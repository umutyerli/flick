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
	var refreshControl: UIRefreshControl!
	var endpoint: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		
		
		refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: "didRequest", forControlEvents: UIControlEvents.ValueChanged)
		tableView.insertSubview(refreshControl, atIndex: 0)
		
		loadDataFromNetwork()
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func loadDataFromNetwork() {
	
		let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
		let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
		let request = NSURLRequest(URL: url!)
		let session = NSURLSession(
			configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
			delegate:nil,
			delegateQueue:NSOperationQueue.mainQueue()
		)
		
		MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		
		let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
			completionHandler: { (dataOrNil, response, error) in
				
				if let data = dataOrNil {
					
					if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
						data, options:[]) as? NSDictionary {
							//
							// NSLog("response: \(responseDictionary)")
							//
							
							self.movies = responseDictionary["results"] as? [NSDictionary]
							
							// Reload the tableView now that there is new data
							self.tableView.reloadData()
							
							self.refreshControl.endRefreshing()
							MBProgressHUD.hideHUDForView(self.view, animated: true)
					}
				}
				
				
		});
		task.resume()

	}
	
	func didRequest() {
		loadDataFromNetwork()
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
		
		cell.selectionStyle = .Gray
		
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor.yellowColor()
		cell.selectedBackgroundView = backgroundView
		
		
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
