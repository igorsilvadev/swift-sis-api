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
    
    sis.get("search","image",":q"){ req -> EventLoopFuture<Response> in
        var result: [ImageObjectResponse] = []
        
        guard var query = req.parameters.get("q") else {
            return [ImageObjectResponse]().encodeResponse(status: .badRequest, for: req)
        }
        query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let baseURL = "http://www.bing.com/images/search?q=\(query)"
        
        guard let url = URL(string: baseURL) else {
            return [ImageObjectResponse]().encodeResponse(status: .badRequest, for: req)
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
            return [ImageObjectResponse]().encodeResponse(status: .internalServerError, for: req)
        }
        return result.encodeResponse(status: .ok, for: req)
    }
}

private func decodeImageData(data: Data?) throws -> ImageObject? {
    guard let data = data, let imageObject = try? JSONDecoder().decode(ImageObject.self, from: data), !imageObject.url.containsEspecialCharacter() else { return nil }
    return imageObject
}


