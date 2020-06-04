# 📱 Kravers 🍲
Kravers is an iOS Application aimed to help users on their decisions with restaurants when eating out. The application uses Yelp's API for fetching restaurant data and Firebase for handling user authentication as well as for our database usage

## Demo 
![](kravers-demo.gif)

## Installation
Open up terminal 
```bash
cd .../KraversFinal
pod init 
pod install
```
Then go to [Yelp](https://www.yelp.com/developers/v3/manage_app) and sign up for a new api key. 

After that, copy that api key and replace yelp_api_key with your new api key.
```swift 
...
self.apiClient = CDYelpAPIClient(apiKey: yelp_api_key)
```

## License
[MIT](https://choosealicense.com/licenses/mit/)
