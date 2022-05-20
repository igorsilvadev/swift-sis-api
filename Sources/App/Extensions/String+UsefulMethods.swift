//
//  String+UsefulMethods.swift
//  
//
//  Created by Igor Samoel da Silva on 20/05/22.
//

import Foundation

extension String {
    
    func containsEspecialCharacter() -> Bool {
        let regex = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:/-_~")
        return self.rangeOfCharacter(from: regex.inverted) != nil ? true : false
    }

    func removeSpecialChars() -> String {
        let validChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_'*;,@º%&|\\/:~")
        return self.filter {validChars.contains($0) }
    }

}
