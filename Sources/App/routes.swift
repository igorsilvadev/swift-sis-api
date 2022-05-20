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

func routes(_ app: Application) throws {
    
    let sis = app.grouped("sis","api","v2")
    
    sis.get("search","image",":q"){ req -> [ImageObjectResponse]  in
        var result: [ImageObjectResponse] = []
        
        guard var query = req.parameters.get("q") else {
            throw Abort.init(.badRequest, reason: "Invalid search text")
        }
        query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let baseURL = "http://www.bing.com/images/search?q=\(query)"
        
        guard let url = URL(string: baseURL) else {
            throw Abort(.badRequest, reason: "Error creating search URL")
        }
        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html)
            
            for element in try doc.getElementsByTag("a"){
                if let imgJson = try? element.attr("m"), let data = imgJson.data(using: .utf8), let object = try! decodeImageData(data: data) {
                    result.append(ImageObjectResponse(url: object.url,
                                                      website: object.website,
                                                      title: object.title.removeSpecialChars(),
                                                      description: object.description.removeSpecialChars()))
                }
            }
        } catch {
            throw Abort(.internalServerError, reason: "Error when creating image list")
        }
        return result
    }
}

private func decodeImageData(data: Data?) throws -> ImageObject? {
    guard let data = data, let imageObject = try? JSONDecoder().decode(ImageObject.self, from: data), !imageObject.url.containsEspecialCharacter() else { return nil }
    return imageObject
}


