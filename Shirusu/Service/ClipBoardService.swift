//
//  ClipBoardService.swift
//  Shirusu
//
//  Created by Sai Balaji on 01/09/24.
//

import Foundation
import UIKit

class ClipBoardService{
    func cutText(text: String?,onCompletion:@escaping()->(Void)){
        if let text{
            UIPasteboard.general.string = text
            onCompletion()
        }
    }
    func copyText(text: String?){
        if let text{
            UIPasteboard.general.string = text
        }
    }
    func pasteText(onCompletion:@escaping(String?)->(Void)){
        onCompletion(UIPasteboard.general.string)
    }
    func getTextInsideTheSelectedRange(textView: UITextView) -> (String,UITextRange)?{
        if let selectedRange = textView.selectedTextRange{
            if let selectedText = textView.text(in: selectedRange){
                return (selectedText,selectedRange)
            }
        }
        return nil
    }
}
