//
//  MoviesViewController.swift
//  Flicker
//
//  Created by Umut Yerli on 1/5/16.
//  Copyright © 2016 Umut Yerli. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	
	var movies: [NSDictionary]?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		
		
		let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
		let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
		let request = NSURLRequest(URL: url!)
		let session = NSURLSession(
			configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
			delegate:nil,
			delegateQueue:NSOperationQueue.mainQueue()
		)
		
		let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
			completionHandler: { (dataOrNil, response, error) in
				if let data = dataOrNil {
					if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
						data, options:[]) as? NSDictionary {
							NSLog("response: \(responseDictionary)")
							
							self.movies = responseDictionary["results"] as? [NSDictionary]
							self.tableView.reloadData()
					}
				}
		});
		task.resume()
		
		// Initialize a UIRefreshControl
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
		tableView.insertSubview(refreshControl, atIndex: 0)
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func loadDataFromNetwork() {
	
		let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
		let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
		let request = NSURLRequest(URL: url!)
		let session = NSURLSession(
			configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
			delegate:nil,
			delegateQueue:NSOperationQueue.mainQueue()
		)
		MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		
		let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
			completionHandler: { (data, response, error) in
				
				// Hide HUD once the network request comes back (must be done on main UI thread)
				MBProgressHUD.hideHUDForView(self.view, animated: true)
				
				// ... Remainder of response handling code ...
				
		});
		task.resume()
	}
	
	// Makes a network request to get updated data
	// Updates the tableView with the new data
	// Hides the RefreshControl
	func refreshControlAction(refreshControl: UIRefreshControl) {
		
		// ... Create the NSURLRequest (myRequest) ...
		
		let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
		let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
		let request = NSURLRequest(URL: url!)
		let session = NSURLSession(
			configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
			delegate:nil,
			delegateQueue:NSOperationQueue.mainQueue()
		)

		let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
			completionHandler: { (data, response, error) in
				
				// ... Use the new data to update the data source ...
				
				// Reload the tableView now that there is new data
				self.tableView.reloadData()
				
				// Tell the refreshControl to stop spinning
				refreshControl.endRefreshing()
		});
		task.resume()
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if let movies = movies {
			return movies.count
		} else {
			return 0
		}
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
		
		let movie = movies![indexPath.row]
		let title = movie["title"] as! String
		let overview = movie["overview"] as! String
		cell.titleLabel.text = title
		cell.overviewLabel.text = overview
		
		let baseUrl = "https://image.tmdb.org/t/p/w500"
		
		if let posterPath = movie["poster_path"] as? String {
			let imageUrl = NSURL(string: baseUrl + posterPath)
			cell.posterView.setImageWithURL(imageUrl!)
		}
		
		
		return cell
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let cell = sender as! UITableViewCell
		let indexPath = tableView.indexPathForCell(cell)
		let movie = movies![indexPath!.row]
		
		let detailViewController = segue.destinationViewController as! DetailViewController
		detailViewController.movie = movie
		
		print("prepare for segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
	

}
