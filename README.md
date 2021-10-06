
# SIS-API (Search In Swift) é um API desenvolvida totalmente em Swift que utiliza a técnica de Web Scrapping para buscar imagens e retornar um JSON com as URLs dos resultados. 
Ela utiliza: 

- [SwiftSoup](https://github.com/scinfu/SwiftSoup) (Pure Swift HTML Parser, with best of DOM, CSS, and jquery (Supports Linux, iOS, Mac, tvOS, watchOS) para trazer esses resultados. 
- [Vapor 4](https://github.com/vapor/) ( Backend)

Os resultados são extraídos de um request do Bing Image Search.
Esta é uma versão inicial e posteriormente haverão melhorias de arquitetura, perfomance e novos filtros. 

Para utilizar essa API de imagens é só fazer o request para https://sis-api.herokuapp.com/sis/api/v1/search/image/.
Depois do /image/{nome da imagem que deseja buscar}
 

