//
//  SOSMSUserDefaultsExt.swift
//  SOSMS
//
//  Created by ELLI SCHARLIN on 2/18/20.
//  Copyright © 2020 ELLI SCHARLIN. All rights reserved.
//

import Foundation

extension UserDefaults {

    func hasValue(forKey key: String) -> Bool {
        return nil != object(forKey: key)
    }
}
