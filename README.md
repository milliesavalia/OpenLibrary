# OpenLibrary
Created a simple book search by title using the Open Library API

Please discuss your approach to the problem, solution, architecture, testing strategies, challenges:

I took a simple approach to this problem. I created a SearchService that forms the correct search query and requests the data by making a network call. The search service conforms to a protocol, which makes it easier for me to create a Mock search service for testing that also conforms to the same protocol. Once the data comes back from the network, I use the JSON decoder to convert the data into the 'SearchResult' Model.

The SearchResult model uses Codable and coding keys to map the data we want for the purpose of this assignment. The SearchResult holds the list of Books that we should be displaying as the results of the search input.

In the LibraryViewController, I created a UISearchController as the first thing you see when you open the app. The search bar takes in the input from the user and utilizing the UISearchBarDelegate, makes a call to the service to retrieve the search results. Once we set the results of the search to the bookResults variable, the table view reloads on the main thread. The results of the search will be displayed in the table view using the UITableViewDataSource. I created a LibraryTableViewCell to display each of the results in a reusable cell. Using a reusable cell allows for better UI experience as you scroll through the results because the cells get dequeued and setup faster for each index of the results.

The LibraryTableViewCell displays title, author(s), and first publish year. When there are multiple authors, the list gets formatted. The prepareForReuse function allows for the easy breakdown of cells as the are dequeued.

I added in a basic testing structure for the SearchService. I created the MockSearchService which conforms to the same protocol as the SearchService, making it easieer to test the correct data types. The mock service pulls in data from a simple JSON Response file I created with testable data results. The SearchServiceSpec holds a reference to the service and uses XCT to test that we get the expected data results. I created a few simple assert tests to check whether the data is being decoded into the SearchResult model correctly.

One of the challenges I was stumped on was figuring out the correct return types for the Model. At first I incorrectly assumed the 'author' would give a String but then realized it gives a list of authors requiring it to be a list of Strings. Another issue I ran into was that some of the data types were meant to be optional. This mistake caused there to be some missing results, since the decoder wouldn't be able to correctly parse that data. Once I caught it, I was able to see all the results.

Overall this was a fun challenge to be able to work through to showcase my iOS knowledge.
