//
//  StringUtil.swift
//  EzKuiz
//
//  Created by Dávid Mohácsi on 2018. 04. 27..
//  Copyright © 2018. Suit Solutions. All rights reserved.
//

import UIKit

class StringUtil {

}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
