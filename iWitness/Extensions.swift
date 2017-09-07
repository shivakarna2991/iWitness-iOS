//
//  Extensions.swift
//  iWitness
//
//  Created by Sravani on 23/11/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import Foundation

extension String
{
    var length : Int {
        return self.characters.count
    }
    
    func trim()-> String
    {
        return  self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
    }
    
    var isValidEmail: Bool {
        let emailRegex = "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        
        let PHONE_REGEX = "^(?:(?:\\+?1\\s*(?:[.-]\\s*)?)?(?:\\(\\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\\s*\\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\\s*(?:[.-]\\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\\s*(?:[.-]\\s*)?([0-9]{4})(?:\\s*(?:#|x\\.?|ext\\.?|extension)\\s*(\\d+))?$"
        
        
        return self.matchPattern(PHONE_REGEX, andOption: NSRegularExpression.Options.caseInsensitive)
        
        
        //        return NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX).evaluateWithObject(self)
    }
    
    
    
    func matchPattern(_ pattern : String, andOption option : NSRegularExpression.Options) -> Bool {
        
        if(self.length == 0 || pattern.length == 0) {
            return false
        }
        do {
            let regex : NSRegularExpression = try NSRegularExpression(pattern: pattern,options: option)
            
            let numberMatches = regex.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.length))
            
            if(numberMatches == 1){
                return true
            }
            else{
                return false
            }
        }
            
        catch _ as NSError {
            return false
            
        }
        
    }
    
    
    var isPassword:Bool {
            let passwordRegEx = "^.*(?=.{8,})(?=..*[0-9])(?=.*[a-z])(?=.*[A-Z]).*$"
            return NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: self)

    }
    
    func digitsOnly() -> String{
        let stringArray = self.components(
            separatedBy: CharacterSet.decimalDigits.inverted)
        let newString = stringArray.joined(separator: "")
        
        return newString
    }
    
  }


