//
//  SOSMSStringEXT.swift
//  SOSMS
//
//  Created by ELLI SCHARLIN on 2/17/20.
//  Copyright © 2020 ELLI SCHARLIN. All rights reserved.
//

import Foundation

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
    
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
}

