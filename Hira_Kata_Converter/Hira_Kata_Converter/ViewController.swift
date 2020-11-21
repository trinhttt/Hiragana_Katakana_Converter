//
//  ViewController.swift
//  Hira_Kata_Converter
//
//  Created by Trinh Thai on 11/21/20.
//  Copyright © 2020 Trinh Thai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("　佐藤　太郎".hurigana(type: .hiragana))
        print("　佐藤　太郎".hurigana(type: .katakana))
    }


}
enum Kana { case hiragana, katakana }

extension String {
    func hurigana(type: Kana) -> String {
        let transform: CFString = type == Kana.hiragana ? kCFStringTransformLatinHiragana :  kCFStringTransformLatinKatakana
        let inputText = self as NSString
        let outputText = NSMutableString()
        var range = CFRangeMake(0, inputText.length)
        let locale = CFLocaleCopyCurrent()
        let tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, inputText as CFString, range, kCFStringTokenizerUnitWordBoundary, locale)
        var tokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, 0)

        while tokenType.rawValue != 0 {
            if let latin = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, kCFStringTokenizerAttributeLatinTranscription) as? NSString {
                let hurigana = latin.mutableCopy() as! NSMutableString
                CFStringTransform(hurigana, nil, transform, false)
                outputText.append(hurigana as String)
            } else {
                range = CFStringTokenizerGetCurrentTokenRange(tokenizer)

                if let substring = CFStringCreateWithSubstring(kCFAllocatorDefault, inputText as CFString, range) {
                    outputText.append(substring as String)
                }
                // Because if first item is white space, it repeats 2 times
                if range.location == 0 {
                    tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
                }
            }
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        }
        return outputText as String
    }
}
