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
        let folderName = "MySheets"
        let folderPath = documentPath?.appendingPathComponent(folderName)
        
        if var folderPath{
            if fm.fileExists(atPath: folderPath.path) == false{
                do{
                    try fm.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true)
                }
                catch{
                    print(error)
                    onCompletion(error)
                }
            }
            folderPath.appendPathComponent(finalFileName)
            do{
                try content.write(to: folderPath, atomically: true, encoding: .utf8)
                onCompletion(nil)
            }
            catch{
                print(error)
                onCompletion(error)
            }
        }
        
//        if var documentPath{
//            
//            documentPath.appendPathComponent(finalFileName)
//            print(documentPath.absoluteString)
//            do{
//                try fm.createDirectory(at: documentPath, withIntermediateDirectories: true)
//                try content.write(to: documentPath, atomically: true, encoding: .utf8)
//                onCompletion(nil)
//            }
//            catch{
//                onCompletion(error)
//            }
//    
//            
//        }
    }
    func readAllSavedFiles(onCompletion:@escaping([URL]?,Error?)->(Void)){
        let documentPath = fm.urls(for: .documentDirectory, in: .userDomainMask).first
        var finalURL = documentPath?.appendingPathComponent("MySheets")
        if let documentPath, let finalURL{
            if fm.fileExists(atPath: finalURL.path){
                do{
                    let contents = try fm.contentsOfDirectory(at: finalURL.absoluteURL, includingPropertiesForKeys: nil,options: .skipsHiddenFiles)
                    
                    onCompletion(contents,nil)
                    
                }
                catch{
                    onCompletion(nil,error)
                }
            }
          
        }
       
    }
    
}
