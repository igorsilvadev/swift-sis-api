
# Swift Image Search

SIS API is an API developed entirely in Swift that uses the Web Scrapping technique to fetch images and return a JSON with the results.


## API Reference

#### Get a list of images

```
  GET /sis/api/v2/search/image/${q}
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `q` | `string` | **Required**. A text that represents the images that will be fetched |


## Request Example

```
  GET /sis/api/v2/search/image/ronaldinho
```
## Response

````
[ 
  {
    "website": "https://everythingbarca.com/2018/01/17/barcelona-legend-ronaldinho-retires-football/",
    "description": "barcelona ronaldinho fc football legends legend everythingbarca manchester united",
    "title": "FC Barcelona legend Ronaldinho retires from football",
    "url": "https://everythingbarca.com/wp-content/uploads/getty-images/2018/01/804675276-2017-football-friendly-fc-barcelona-v-manchester-united-legends-jun-30th.jpg.jpg"
  },
  {
    "website": "http://famusfootballerandallrecord.blogspot.com/2018/02/ronaldinho-life-story-and-career.html",
    "description": "ronaldinho ballon story",
    "title": "Ronaldinho life story and career",
    "url": "https://4.bp.blogspot.com/-8g7TWeLqpZQ/WpQpT1HUOuI/AAAAAAAACCU/dyXfdtvFRYkADtKgd4zYOwmazqd9yrmQgCLcBGAs/s1600/2609760.main_image.jpg"
  }
]
````
#### The amount of results returned can vary, but usually 10 or more objects are returned.






## Installing Vapor

Documentation Reference Vapor 4: 
https://docs.vapor.codes/install/macos/

```bash
  swift --version
```
Vapor 4 requires Swift 5.2 or greater.

If you don't have **HomeBrew**, install it: 

HomeBrew Reference: https://brew.sh/

```bash 
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installing Home Brew run: 
```bash 
brew install vapor
```

Then clone this repository into the directory of your choice

```bash 
git clone https://github.com/igorsilvadev/swift-sis-api.git
```

## Using:

Inside the ***swift-sis-api*** folder run: 
```bash 
vapor xcode
```
Xcode will open, in which you can run the project. After the compilation go to your browser: 

```
http://127.0.0.1:8080/sis/api/v2/search/image/ronaldinho

```

## Deployment on heroku

The official Vapor Documentation has a tutorial on how to perform a deployment on Heroku:

https://docs.vapor.codes/deploy/heroku/


## Demo 

You can use the API demo version for educational purposes:

https://sis-api.herokuapp.com/sis/api/v2/search/image/ronaldinho



## Author

- [@igorsilvadev](https://www.github.com/igorsilvadev)
- [Linkedin](https://www.linkedin.com/in/igorsilvadev/)

## Vapor 

https://github.com/vapor/vapor

##  SwiftSoup
https://github.com/scinfu/SwiftSoup


