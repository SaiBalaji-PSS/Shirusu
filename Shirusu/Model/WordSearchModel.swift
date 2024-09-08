//
//  WordSearchModel.swift
//  Shirusu
//
//  Created by Sai Balaji on 07/09/24.
//

import Foundation

struct WordSearchModel{
    let kanji: String
    let kana: String
    let meaning: String
    let partOfSpeech: String
}


struct SavedFileModel{
    let fileName: String
    let filePath: URL
}
