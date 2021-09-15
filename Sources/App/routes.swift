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

struct resultImage: Codable, Content{
    var murl:String
}

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("search",":q"){ req -> [resultImage] in
        
        let query = req.parameters.get("q")!
        var result:[resultImage] = []
        let baseURL = "https://www.bing.com/images/search?q=\(query)&form=QBLH&sp=-1&pq=camar&sc=6-5&qs=n&cvid=8F95CC537DFB48ACAC383FF851874C28&first=1&tsc=ImageBasicHover"
        if let url = URL(string: baseURL) {
            do {
                let html = try String(contentsOf: url, encoding: .ascii)
                let doc: Document = try SwiftSoup.parse(html)
                
                for element in try doc.getElementsByTag("a"){
                    if let img = try? element.attr("m"){
                        let data = img.data(using: .utf8)
                        if let image = try? JSONDecoder().decode(resultImage.self, from: data!){
                            result.append(image)
                        }
                    }
                }
                
            } catch let error {
                print("Error: \(error)")
            }
            
        }
        return result
    }
    
    
    
}
