/*
 RESOURCES:
 
 https://stackoverflow.com/questions/60051224/how-to-get-imageurl-out-of-html-tag
 https://stackoverflow.com/questions/42462202/deleting-specific-substrings-in-strings-swift
 https://medium.com/geekculture/scraping-google-image-search-result-dfe01bcbc610
 https://stackoverflow.com/questions/61170959/python-image-scraper-not-working-properly-on-bing
 https://stackoverflow.com/questions/47281375/convert-json-string-to-json-object-in-swift-4/47281832
 
 */
import Vapor
import SwiftSoup
import Foundation


//Custum key: https://www.swiftbysundell.com/articles/customizing-codable-types-in-swift/
struct ImageObject: Codable {
    var url: String
    var website: String
    var title: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case url = "murl"
        case website = "purl"
        case title = "t"
        case description = "desc"
    }
}

struct ImageObjectResponse: Codable, Content {
    var url: String
    var website: String
    var title: String
    var description: String
}

func routes(_ app: Application) throws {
    
    let sis = app.grouped("sis","api","v2")
    
    sis.get("search","image",":q"){ req throws -> [ImageObjectResponse]  in
        var result :[ImageObjectResponse] = []
        
        guard var query = req.parameters.get("q") else { throw Abort.init(.badRequest, reason: "Invalid query") }
        query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let baseURL = "http://www.bing.com/images/search?q=\(query)"
        
        guard let url = URL(string: baseURL) else { throw Abort(.badRequest, reason: "Error creating search URL")}
        do {
            let html = try String(contentsOf: url, encoding: .ascii)
            let doc: Document = try SwiftSoup.parse(html)
            
            for element in try doc.getElementsByTag("a"){
                if let imgJson = try? element.attr("m"), let data = imgJson.data(using: .utf8), let object = try! decodeImageData(data: data) {
                    result.append(ImageObjectResponse(url: object.url,
                                                      website: object.website,
                                                      title: object.title,
                                                      description: object.description))
                }
            }
        } catch {
            throw Abort(.internalServerError, reason: "Error when creating image list")
        }
        return result
    }
}


private func decodeImageData(data: Data?) throws -> ImageObject? {
    guard let data = data, let imageObject = try? JSONDecoder().decode(ImageObject.self, from: data), !containsEspecial(url: imageObject.url) else { return nil }
    return imageObject
}

private func containsEspecial(url: String) -> Bool {
    let regex = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:/-_~")
    return url.rangeOfCharacter(from: regex.inverted) != nil ? true : false
}


/*
 
 /// Check if the parameter contains any special characters.
 /// - Parameter specialCharacters: The userInput that may or not contains special characters
 /// - Returns true if the input contains one or more special characters
 static func passwordContains(specialCharacters: String) -> Bool {
     let initCharset = {(charsets: CharacterSet...) -> CharacterSet in
         var sets = CharacterSet()
         charsets.forEach { sets.formUnion($0) }
         return sets
     }, charset = initCharset(.symbols, .whitespaces, .nonBaseCharacters, .punctuationCharacters)
     return specialCharacters.rangeOfCharacter(from: charset) != nil ? true : false
 }
 
 
 */
