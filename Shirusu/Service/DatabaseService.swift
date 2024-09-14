//
//  DatabaseService.swift
//  Shirusu
//
//  Created by Sai Balaji on 01/09/24.
//

import Foundation
import SQLite3
import SQLite

enum DBError: Error{
    case unableToLoadDB
    
}
extension DBError: LocalizedError{
    var errorDescription: String?{
        switch self {
        case .unableToLoadDB:
            return "Unable to load the DB"
        
        }
    }
}

class DatabaseService{
    static var shared = DatabaseService()
    private var db: Connection?
    let dispatchQueue = DispatchQueue(label: "QueueIdentification2", qos: .userInitiated)
    
    private let kanaQuery = """
        SELECT entry.id AS entry_id,
               kana.value AS kana_value,
               GROUP_CONCAT(DISTINCT definition.value) AS definitions,
               GROUP_CONCAT(DISTINCT part_of_speech.value) AS parts_of_speech
        FROM entry
        JOIN kana ON entry.id = kana.entry_id
        JOIN sense ON entry.id = sense.entry_id
        JOIN definition ON sense.id = definition.sense_id
        JOIN part_of_speech ON sense.id = part_of_speech.sense_id
        WHERE kana.value = ?
        GROUP BY entry.id, kana.value LIMIT 1;
        """
    private let kanjiQuery = """
        SELECT
            entry.id AS entry_id,
            kanji.value AS kanji_value,
            GROUP_CONCAT(DISTINCT kana.value) AS hiragana_readings,
            GROUP_CONCAT(DISTINCT definition.value) AS definitions,
            GROUP_CONCAT(DISTINCT part_of_speech.value) AS parts_of_speech
        FROM
            entry
        JOIN
            kanji ON entry.id = kanji.entry_id
        JOIN
            sense ON entry.id = sense.entry_id
        JOIN
            definition ON sense.id = definition.sense_id
        JOIN
            part_of_speech ON sense.id = part_of_speech.sense_id
        JOIN
            kana ON entry.id = kana.entry_id
        WHERE
            kanji.value = ?
            AND kana.no_kanji = 0
        GROUP BY
            entry.id, kanji.value LIMIT 1;
        """
    private let wordSearchQuery = """
SELECT
    k.value AS kanji,
    ka.value AS kana,
    d.value AS english_meaning,
    pos.value AS part_of_speech
FROM entry e
JOIN kanji k ON e.id = k.entry_id
JOIN kana ka ON e.id = ka.entry_id
JOIN sense s ON e.id = s.entry_id
JOIN definition d ON s.id = d.sense_id
LEFT JOIN part_of_speech pos ON s.id = pos.sense_id
WHERE d.value = ?;
"""
    
    private let wordSearchWithPartsOfSpeech = """
SELECT DISTINCT
    k.value AS kanji,
    ka.value AS kana,
    d.value AS english_meaning,
    pos.value AS part_of_speech
FROM entry e
JOIN kanji k ON e.id = k.entry_id
JOIN kana ka ON e.id = ka.entry_id
JOIN sense s ON e.id = s.entry_id
JOIN definition d ON s.id = d.sense_id
LEFT JOIN part_of_speech pos ON s.id = pos.sense_id
WHERE (d.value LIKE ? OR k.value LIKE ? OR ka.value LIKE ?)
AND pos.value LIKE ?;
"""
    
    func loadDB(){
        if let path = Bundle.main.path(forResource: "JMdict_e", ofType: "db"){
            do{
                let db = try Connection(path, readonly: true)
                print(db)
                self.db = db
            }
            catch{
                print(error)
            }
        }
        
    }
    
    
    func getKanjiWordMeaning(word: String,onCompletion:@escaping(String?,Error?,FlashCardWordModel?)->(Void)){
        var flashCardWord: FlashCardWordModel?
        dispatchQueue.async {
            do{
                if let db = self.db{
                    var results = [String]()
                    let statement = try db.prepare(self.kanjiQuery)
                    for row in try statement.run(word){
                        let kanji = row[1] as? String ?? ""
                                       let hiraganaReadings = row[2] as? String ?? ""
                                       let definitions = row[3] as? String ?? ""
                                       let partOfSpeech = row[4] as? String ?? ""
                                       
                                       results += [
                                           "Kanji: \(kanji)\n" +
                                           "Hiragana Readings: \(hiraganaReadings)\n" +
                                           "Definitions: \(definitions)\n" +
                                           "Parts of Speech: \(partOfSpeech)"
                                       ]
                                    flashCardWord = FlashCardWordModel(kanji: kanji, kana: hiraganaReadings, defination: definitions, partsOfSpeech: partOfSpeech)
                        
                    }
                    onCompletion(results.first,nil,flashCardWord)
                }
            }
            catch{
                onCompletion(nil,error,nil)
            }
        }
        
    }
   
    func getKanaWordMeaning(word: String,onCompletion:@escaping(String?,Error?,FlashCardWordModel?)->(Void)){
        var flashCardWord: FlashCardWordModel?
        dispatchQueue.async {
            do{
                
                if let db = self.db{
                    var results = [String]()
                    let statement = try db.prepare(self.kanaQuery)
                    for row in try statement.run(word){
                        
                        let kanaValue = row[1] as? String ?? ""
                       
                        let definitions = row[2] as? String ?? ""
                        let partsOfSpeech = row[3] as? String ?? ""
                        flashCardWord = FlashCardWordModel(kanji: "", kana: kanaValue, defination: definitions, partsOfSpeech: partsOfSpeech)
                        let result = "Kana: \(kanaValue)\n Definitions: \(definitions)\n Parts of Speech: \(partsOfSpeech)"
                        print(result)
                        results += [result]
                        

                    }
                    onCompletion(results.first,nil,flashCardWord)
                    
                }
            }
            catch{
                onCompletion(nil,error,nil)
            }
        }
      
    }
    
    func getWordList(searchTerm: String,onCompletion:@escaping([WordSearchModel]?,Error?)->(Void)){
        do{
            
            if let db{
                var result = [WordSearchModel]()
                let statement = try db.prepare(wordSearchQuery)
                for row in try statement.run(searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)){
                    let kanji = row[0] as? String ?? ""
                    let kana = row[1] as? String ?? ""
                    let englishMeaning = row[2] as? String ?? ""
                    let partOfSpeech = row[3] as? String ?? ""
                    result.append(WordSearchModel(kanji: kanji, kana: kana, meaning: englishMeaning, partOfSpeech: partOfSpeech))
                }
                onCompletion(result,nil)
                
            }
        }
        catch{
            print(error)
            onCompletion(nil,error)
        }
    }
    func getWordWithPartsOfSpeech(searchTerm: String,partsOfSpeech: String,onCompletion:@escaping([WordSearchModel]?,Error?)->(Void)){
        dispatchQueue.async {
            do{
                if let db = self.db{
                    var result = [WordSearchModel]()
                    let statement = try db.prepare(self.wordSearchWithPartsOfSpeech)
                    for row in try statement.run( "%" + searchTerm + "%",searchTerm.trimmingCharacters(in: .whitespacesAndNewlines) ,searchTerm.trimmingCharacters(in: .whitespacesAndNewlines),partsOfSpeech + "%"){
                        let kanji = row[0] as? String ?? ""
                        let kana = row[1] as? String ?? ""
                        let englishMeaning = row[2] as? String ?? ""
                        let partOfSpeech = row[3] as? String ?? ""
                        result.append(WordSearchModel(kanji: kanji, kana: kana, meaning: englishMeaning, partOfSpeech: partOfSpeech))
                    }
                    onCompletion(result,nil)
                    
                }
            }
            catch{
                print(error)
                onCompletion(nil,error)
            }
        }
        
    }
}


extension String{
    func containsHiragana() -> Bool {
        let hiraganaPattern = "[\\u3040-\\u309F]"
        let regex = try? NSRegularExpression(pattern: hiraganaPattern)
        let range = NSRange(location: 0, length: self.utf16.count)
        if let regex = regex {
            return regex.firstMatch(in: self, options: [], range: range) != nil
        }
        return false
    }

    
    func containsKanji() -> Bool {
        let kanjiPattern = "[\\u4E00-\\u9FAF]"
        let regex = try? NSRegularExpression(pattern: kanjiPattern)
        let range = NSRange(location: 0, length: self.utf16.count)
        if let regex = regex {
            return regex.firstMatch(in: self, options: [], range: range) != nil
        }
        return false
    }
    func containsKatakana() -> Bool {
        // Regular expression for Katakana characters
        let katakanaRegex = "[\\p{Katakana}]"
        let regex = try? NSRegularExpression(pattern: katakanaRegex)
        let range = NSRange(location: 0, length: self.utf16.count)
        if let regex = regex {
            return regex.firstMatch(in: self, options: [], range: range) != nil
        }
        return false 
    }
}
