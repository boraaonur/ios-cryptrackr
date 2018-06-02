Cryptotrackr Lite
Cryptrackr is a simple cryptocurrency portfolio tracker application.

- Users can add cryptocurrencies to their Watchlist by clicking + in top right corner.
- If user opening application for the first time, app will download cryptocurrency list. This will happen only once in app life-time. After first download, it will persist downloaded data.
- In Add Coin screen, users are able to search 200+ coins.
- In searchBar, if user click "Done" after selecting his coins, view will dismiss.
- If user click a row in Add Coin screen TableView, that row will be checkmarked and currency at indexPath will be added to - Watchlist.
- There isn't Done button because CoreData is updated on every click to cells. User can go back to Watchlist and see added coins.
- In Add Coin screen, users can show/hide cryptocurrencies that are already in Watchlist. Preference will be persisted with UserDefaults.
- In Watchlist, users can enable Edit Mode by long pressing to any cell for 1 second duration.
- User is able to move and delete cells in Edit Mode. Everything will be persisted including order of cryptocurrencies.
- If user tap to any cryptocurrency in Watchlist, he'll view Market Summary of selected coin.
- User is able to view 1m,5m,30m,1h,1d graphs of selected cryptocurrency.
- User is able to view 24h high, 24h low, 24h volume(currency), 24h volume(BTC) and yesterday's price.
- User is able to view buy and sell order books.
- An alert showing error displayed whenever there is an error.
