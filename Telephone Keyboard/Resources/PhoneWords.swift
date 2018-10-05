//
//  PhoneWords.swift
//  Telephone Keyboard
//
//  Created by mobility on 10/5/18.
//  Copyright © 2018 TMobil. All rights reserved.
//

import Foundation
import UIKit


class PhoneWords {
    
    private var words = Set<String>()
    
    static let sharedInstance = PhoneWords()

    init() {
        if let path = Bundle.main.path(forResource: "english", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    // do stuff
                    words = Set(jsonResult.keys.map{$0.lowercased()})
                }
            } catch {
                // handle error
            }
        }
    }
    
    /*:
     ## Phone Words
     Generate a collection of words that can be represented by a given phone number. If a phone number contains the digits `1` then split up the phone number and find the words for each of the substrings as long as each substring has more than one digit. Non-keypad characters can be ignored. Optionally, filter out words so that only dictionary words are present in the result.
     ╔═════╦═════╦═════╗
     ║  1  ║  2  ║  3  ║
     ║     ║ abc ║ def ║
     ╠═════╬═════╬═════╣
     ║  4  ║  5  ║  6  ║
     ║ ghi ║ jkl ║ mno ║
     ╠═════╬═════╬═════╣
     ║  7  ║  8  ║  9  ║
     ║ pqrs║ tuv ║wxyz ║
     ╠═════╬═════╬═════╣
     ║  *  ║  0  ║  #  ║
     ║     ║     ║     ║
     ╚═════╩═════╩═════╝
     */
   static let keyMap: [Int: [String]] = [
        0: ["0"],
        1: ["1"],
        2: ["a","b","c"],
        3: ["d","e","f"],
        4: ["g","h","i"],
        5: ["j","k","l"],
        6: ["m","n","o"],
        7: ["p","q","r","s"],
        8: ["t","u","v"],
        9: ["w","x","y","z"]
    ]
    
    public func isWord(s: String) -> Bool {
        return words.contains(s)
    }
    
    /*:
     Generate permutations
     
     1. handle empty string
     2. termination condition
     3. recursively generate permutations on smaller inputs
     4. combine prefixes with each result from recursive permutation
     */
    func permute(parts: [[String]]) -> [String] {
        guard let prefixes = parts.first else { return [] } // 1
        if parts.count == 1 { return prefixes } // 2
        let sx = permute(parts: Array(parts.dropFirst(1))) // 3
        return prefixes.flatMap { p in sx.map { s in p + s } }
    }
    
    /*:
     Some helper functions to make things more readable later
     */
    
    func isPhoneKeyMappable(c: Character) -> Bool {
        return ("2"..."9").contains(String(c))
    }
    
    func hasMoreThanOne<T: Collection>(c: T) -> Bool {
        return c.count > 1
    }
    
    func filter<T: Collection>(pred: @escaping (T.Iterator.Element) -> Bool) -> (T) -> [T.Iterator.Element] {
        return { (c: T) -> [T.Iterator.Element] in
            return c.filter(pred)
        }
    }
    
    func flatMap<T: Collection, V>(transform: @escaping (T.Iterator.Element) -> V?) -> (T) -> [V] {
        return { (c: T) -> [V] in
            return c.compactMap(transform)
        }
    }
    
    func transform<T: Hashable, V>(dict: [T:V]) -> (T) -> V? {
        return { (element: T) -> V? in
            return dict[element]
        }
    }
    
    /*:
     Generate phone words for the phone number
     1. split the phone number at "1"
     2. filter out digits that are not 2-9
     3. filter out single-digit words
     4. convert each collection of `Character` into a `String`
     5. convert each string into a collection of words based on keypad
     6. filter out non-engligh words based on a word dictionary
     */
    
    func getWordfromKeyMap(text :String) -> [String] {
        let mnemonics = text
                .compactMap(Int.init)
                .split(separator: 1)
                .map(PhoneWords.keyMap |> transform |> flatMap)
                .filter(hasMoreThanOne)
                .map(permute)
                .map(isWord |> filter)
        return mnemonics.reduce([], +)
    }
}

precedencegroup ComparisonPrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

infix operator |> : ComparisonPrecedence

public func |> <T,U>(lhs: T, rhs: (T) -> U) -> U {
    return rhs(lhs)
}

extension Int {
    init?(c: Character) {
        guard let i = Int(String(c)) else { return nil }
        self = i
    }
}
