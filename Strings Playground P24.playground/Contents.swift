import UIKit
import Foundation

extension String {
    subscript(i : Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

// u can drop self.index and self.startIndex bcz they exist in the scope of the String thing
// not that this is good for this functionality, but if someone loops on i and access each letter and do stuff it's like a loop inside a loop, could be very slow

let name = "revy"
let firstletterofname = name[1]


// dropFirst dropLast

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return "" }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return "" }
        return String(self.dropLast(suffix.count))
    }
}

let mutatedName = name.deletingSuffix("y")
let mutatedName2 = name.deletingPrefix("r")


let someSentence = "rev is the best"
someSentence.capitalized // capitalize the first letter of all words
someSentence.uppercased() // capitalize all the letters

extension String {
    func capitalizeFirstLetter() -> String {
        guard let firstLetter = self.first else { return ""}
        return firstLetter.uppercased() + self.dropFirst(1)
    }
}

// uppercased() return a String not a Character so the result will be a String all good
someSentence.capitalizeFirstLetter()

// we can make the same thing a prop with a getter instead
extension String {
    var firstLetterCapitalized : String {
        guard let firstLetter = self.first else { return ""}
        return firstLetter.uppercased() + self.dropFirst(1)
    }
}




// COOL STUFF, could be confusing, if a func or method expect a closure that takes a String and return a Bool, u can pass that closure directly and it will run
let someSent = "Wow Swift is a fast language"
let langArr = ["Python", "Swift", "JS", "Arabic"]

// didnt work bcz first expect (Character) and second is String
// someSent.contains(where: langArr.contains)

// this works cz first expect String, and second expect a StringProtocol
// to explain further, the where will be ran on each element of the array, so if the where closure takes a String and return a bool, that array will feed its String element to it which is the contain method of the Sentence and return the Bool, for each element
// it really makes sense, it calls the Closure on each element of the arr, so it feeds each element to the function, but it's made when it hits true it stops
langArr.contains(where: someSent.contains)



let decorateMeString = "Make me look like a smexy string"
let attributes: [NSAttributedString.Key : Any] = [
    .foregroundColor: UIColor.gray,
    .backgroundColor: UIColor.blue,
    .font: UIFont.boldSystemFont(ofSize: 32),
]

let attributedString = NSAttributedString(string: decorateMeString, attributes: attributes) // use below better


let attributedStringMutable = NSMutableAttributedString(string: decorateMeString) // it can also accepts attributes
attributedStringMutable.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: attributedStringMutable.length)) // default is 12
attributedStringMutable.addAttribute(.font, value: UIFont.systemFont(ofSize: 6), range: NSRange(location: 0, length: 7))
attributedStringMutable.addAttribute(.font, value: UIFont.systemFont(ofSize: 10), range: NSRange(location: 8, length: 4))
attributedStringMutable.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 20, length: 5))
attributedStringMutable.addAttribute(.underlineStyle, value: NSNumber(integerLiteral: NSUnderlineStyle.thick.hashValue), range: NSRange(location: 0, length: attributedStringMutable.length))
attributedStringMutable.addAttribute(.underlineColor, value: UIColor.red, range: NSRange(location: 0, length: attributedStringMutable.length))

// we read about the .underlineStyle on Documentation, its value should be NSNumber that takes an Int described by NSUnderlineStyle, well there's rawValue and hashValue, only the latter worked



extension String {
    func withPrefix(_ str : String) -> String {
        guard !hasPrefix(str) else { return "" }
        return str + self
    }
}

let s1 = "pet"
let s2 = s1.withPrefix("car")

extension String {
    func isNumberic() -> Bool {
        guard !self.isEmpty else { return false }
        for char in self {
            if Int(String(char)) != nil {
                return true
            }
        }
        
        return false
    }
}

let sok = "Does this have any number? maybe 1 or two"
let sok1 = "Does this have any number? maybe yes maybe not"
sok.isNumberic()
sok1.isNumberic()

let axz = "adada\nadadada"

extension String {
    func lines() -> [String] {
        guard !isEmpty else { return [""] }
        return self.components(separatedBy: "\n")
    }
}

axz.lines()
sok.lines()
