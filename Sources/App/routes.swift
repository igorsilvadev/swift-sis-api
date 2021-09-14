/*
RESOURCES:
 
 https://stackoverflow.com/questions/60051224/how-to-get-imageurl-out-of-html-tag
 https://stackoverflow.com/questions/42462202/deleting-specific-substrings-in-strings-swift
 https://medium.com/geekculture/scraping-google-image-search-result-dfe01bcbc610
*/
import Vapor
import SwiftSoup

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("search",":q"){ req -> [String] in
        let query = req.parameters.get("q")!
        
        var imgSrc:[String] = []
        var result:[String] = []
        let baseURL = "https://www.google.com/search?q=\(query)&rlz=1C5CHFA_enGB937GB937&sxsrf=ALeKk02twWeFWJCESdRh27hZxC0iZwBS6w:1617724623722&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiu0ans_envAhUkT98KHZ7CDiMQ_AUoAXoECAEQAw&biw=714&bih=732"
        print("Debug 1\(query)")
        if let url = URL(string: baseURL) {
            do {
                let html = try String(contentsOf: url, encoding: .ascii)
                let doc: Document = try SwiftSoup.parse(html)
                for element in try doc.getElementsByTag("a").array(){
                    if var img = try? element.attr("href"){
                        if img.starts(with: "/url?q="){
                            img = img.replacingOccurrences(of: "/url?q=", with: "")
                            print(img)
                            imgSrc.append(img)
                            print(element)
                        }
                    }
                }
                for source in imgSrc{
                    if let url = URL(string: source){
                        do{
                            let html = try String(contentsOf: url, encoding: .ascii)
                            let doc = try SwiftSoup.parse(html)
                            
                            for element in try doc.getElementsByTag("img").array(){
                                if let img = try? element.attr("src"){
                                    if img.contains(query) && (img.hasSuffix(".jpg") || img.hasSuffix(".png") || img.hasSuffix(".jpeg")) {
                                        print(img)
                                        result.append(img)
                                    }
                                }
                            }
                        }catch let erro{
                            return ["\(erro.localizedDescription)"]
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
