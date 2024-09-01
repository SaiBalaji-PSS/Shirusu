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
    
    
    func getKanjiWordMeaning(word: String,onCompletion:@escaping(String?,Error?)->(Void)){
        do{
            if let db{
                var results = [String]()
                let statement = try db.prepare(kanjiQuery)
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
                    
                }
                onCompletion(results.first,nil)
            }
        }
        catch{
            onCompletion(nil,error)
        }
    }
   
    func getKanaWordMeaning(word: String,onCompletion:@escaping(String?,Error?)->(Void)){
        do{
            if let db{
                var results = [String]()
                 let statement = try db.prepare(kanaQuery)
                for row in try statement.run(word){
                    
                    let kanaValue = row[1] as? String ?? ""
                   
                    let definitions = row[2] as? String ?? ""
                    let partsOfSpeech = row[3] as? String ?? ""
                    
                    let result = "Kana: \(kanaValue)\n Definitions: \(definitions)\n Parts of Speech: \(partsOfSpeech)"
                    print(result)
                    results += [result]
                   

                }
                onCompletion(results.first,nil)
                
            }
        }
        catch{
            onCompletion(nil,error)
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

    // Function to check if a string contains Kanji characters
    func containsKanji() -> Bool {
        let kanjiPattern = "[\\u4E00-\\u9FAF]"
        let regex = try? NSRegularExpression(pattern: kanjiPattern)
        let range = NSRange(location: 0, length: self.utf16.count)
        if let regex = regex {
            return regex.firstMatch(in: self, options: [], range: range) != nil
        }
        return false
    }
}
