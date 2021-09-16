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


//Custum key: https://www.swiftbysundell.com/articles/customizing-codable-types-in-swift/
struct resultImage: Codable, Content{
    var murl:String
}

func routes(_ app: Application) throws {
    
    
    app.get("hello"){ _ in
        return "Working"
    }

    let sis = app.grouped("sis","api","v1")

    sis.get("search","image",":q"){ req -> [resultImage] in
        
        var query = req.parameters.get("q")!
        //https://www.codegrepper.com/code-examples/swift/urlencode+string+swift
        query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        var result:[resultImage] = []
        let baseURL = "https://www.bing.com/images/search?q=\(query)&form=QBLH&sp=-1&pq=camar&sc=6-5&qs=n&cvid=8F95CC537DFB48ACAC383FF851874C28&first=1&tsc=ImageBasicHover"
        if let url = URL(string: baseURL) {
            do {
                let html = try String(contentsOf: url, encoding: .ascii)
                let doc: Document = try SwiftSoup.parse(html)
                
                for element in try doc.getElementsByTag("a"){
                    if let img = try? element.attr("m"){
                        print(img)
                        let data = img.data(using: .utf8)
                        if let image = try? JSONDecoder().decode(resultImage.self, from: data!){
                            if !containsEspecial(string: image.murl){
                                result.append(image)
                            }
                        }
                    }
                }
                
            } catch let error {
                print("Error: \(error)")
            }
            
        }else{
            print("URL não construida")
        }
        return result
    }
    
    
    
}


func containsEspecial(string: String) -> Bool{
    //https://stackoverflow.com/questions/27703039/check-if-string-contains-special-characters-in-swift
    let regex = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:/-_~")
    if string.rangeOfCharacter(from: regex.inverted) != nil {
        return true
    }
    return false
}
