//
//  AwesomeMovieViewController.swift
//  AwesomeMovieApp
//
//  Created by sophie on 7/9/16.
//  Copyright © 2016 CorazonCreations. All rights reserved.
//

import UIKit
import AFNetworking


class AwesomeMovieViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var movies = [NSDictionary]()
    var filteredMovies = [NSDictionary]()
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    var endPoint: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        configureSearchController()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        loadDataFromServer()
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
   
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        
        var data: NSDictionary!
        if shouldShowSearchResults {
            data = filteredMovies[indexPath!.row]
        } else {
            data = movies[indexPath!.row]
        }
        let movie = MovieModel.parseData(data)
        let detailsVC = segue.destinationViewController as! DetailsViewController
        detailsVC.movie = movie
        
    }
}


//MARK: - UITableView Methods

extension AwesomeMovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            return filteredMovies.count
        }
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        
        let movie = shouldShowSearchResults ? filteredMovies[indexPath.row] : movies[indexPath.row]
        let movieModel = MovieModel.parseData(movie)
        
        let title = movieModel.title
        let overview = movieModel.overview
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
        }
        
        return cell
        
    }
}


//MARK: - Server Methods

extension AwesomeMovieViewController {
    
    func loadDataFromServer() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
                                                                     completionHandler: { (dataOrNil, response, error) in
                                                                        if let data = dataOrNil {
                                                                            if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                                                                data, options:[]) as? NSDictionary {
                                                                                print("response: \(responseDictionary)")
                                                                                self.movies = responseDictionary["results"] as! [NSDictionary]
                                                                                self.tableView.reloadData()
                                                                                
                                                                            }
                                                                        }
        })
        task.resume()
    }
    
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                                                                      completionHandler: { (data, response, error) in
                                                                        
                                                                        self.tableView.reloadData()
                                                                        refreshControl.endRefreshing()
        });
        task.resume()
    }
    
}

extension AwesomeMovieViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        if searchString?.characters.count > 0 {
            shouldShowSearchResults = true
            filteredMovies = movies.filter({ (dict) -> Bool in
                let title: NSString = dict["title"] as! NSString
                
                return (title.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            })
        }
        else {
            shouldShowSearchResults = false
        }
    
        tableView.reloadData()
    }
    
    
}

extension AwesomeMovieViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
}
