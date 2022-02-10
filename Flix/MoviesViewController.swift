//
//  ViewController.swift
//  Flix
//
//  Created by Luis Morfin on 2/1/22.
//

import UIKit
import AlamofireImage
/* step 1 after linking an outlet tableView,
 modify the ViewController class, adding UITableViewDataSource,UITableViewDelegate
 
 step 2 is adding the two functions table view at the bottom.
 Step 3 is adding in tableview.datasource = self and delegate

*/
class ViewController: UIViewController, UITableViewDataSource,
                      UITableViewDelegate {
    
    
    //created an outlet (click and drag)
    @IBOutlet weak var tableView: UITableView!
    
    //An array of dictionaries
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //step 3
        tableView.dataSource = self
        tableView.delegate = self
        
        //network node snippet start
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                 //access a particular key inside of a dictionary
                 //casted as an array of dictionaries
                 self.movies = dataDictionary["results"] as! [[String:Any]]
                 
                 //reloads the data and keeps on calling the functions below (increments movies.count)
                 self.tableView.reloadData()
                    // TODO: Get the array of movies
                 
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data


             }
        }
        task.resume()
        //end network code snippet

    }
    
    //step 2
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
    Int {
        //return the array size, in this case the array movies (amt of movies)
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        
       // let cell = UITableViewCell()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        
        //acesses first movie, second movie.. etc..
        let movie = movies[indexPath.row]
        
        /*"title" in the array is the value for titles in the API
        going to have to cast "title" casting tells you whats the type.
        */
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        //whatever is inside the paranthesis will replace the section a variable can fit in. \()
        //the question mark/exclamation point is a concept "swift optionals"
        //"row: \(indexPath.row)"
      //  cell.textLabel!.text = title
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        
        cell.posterView.af.setImage(withURL: posterURL!)
        
        return cell
    }
    
    
    //We are passing the movie in this function
    //Details movie screen
    override func prepare(for segue:
    UIStoryboardSegue, sender: Any?) {
        
        //Find the selected movie
        //sender is the cell that was tapped on
        let cell = sender as! UITableViewCell
        //tableView what is the index path for that cell
        let indexPath = tableView.indexPath(for: cell)!
        //accessing the array
        let movie = movies[indexPath.row]
        
        
        //pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}

