//
//  FlashCardWordModel.swift
//  Shirusu
//
//  Created by Sai Balaji on 09/09/24.
//

import Foundation
import RealmSwift


class FlashCardWordModel: Object{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var kanji: String
    @Persisted var kana: String
    @Persisted var defination: String
    @Persisted var partsOfSpeech: String
    convenience init( kanji: String, kana: String, defination: String, partsOfSpeech: String) {
        self.init()
        self.kanji = kanji
        self.kana = kana
        self.defination = defination
        self.partsOfSpeech = partsOfSpeech
    }
}
