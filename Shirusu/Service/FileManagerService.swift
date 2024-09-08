//
//  FileManagerService.swift
//  Shirusu
//
//  Created by Sai Balaji on 08/09/24.
//

import Foundation


class FileManagerService{
    static var shared = FileManagerService()
    private var fm = FileManager.default
    
    func saveFile(fileName: String,content: String,onCompletion:@escaping(Error?)->(Void)){
        let documentPath = fm.urls(for: .documentDirectory, in: .userDomainMask).first
        let finalFileName = fileName + ".txt"
        if var documentPath{
            documentPath.appendPathComponent(finalFileName)
            print(documentPath.absoluteString)
            do{
                try content.write(to: documentPath, atomically: true, encoding: .utf8)
                onCompletion(nil)
            }
            catch{
                onCompletion(error)
            }
    
            
        }
    }
    func readAllSavedFiles(onCompletion:@escaping([URL]?,Error?)->(Void)){
        let documentPath = fm.urls(for: .documentDirectory, in: .userDomainMask).first
        if let documentPath{
            do{
                let contents = try fm.contentsOfDirectory(at: documentPath.absoluteURL, includingPropertiesForKeys: nil,options: .skipsHiddenFiles)
                
                onCompletion(contents,nil)
                
            }
            catch{
                onCompletion(nil,error)
            }
        }
       
    }
    
}
