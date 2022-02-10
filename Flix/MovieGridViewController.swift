//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Luis Morfin on 2/9/22.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        //configures the collection view layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //minimumLineSpacing controls the space inbetween the rows
        layout.minimumLineSpacing = 4
         //space between columns
        layout.minimumInteritemSpacing = 4
        
        //this width var changes depending on which phone the app is being
        //runned on
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        //network node snippet start
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
           
              //   print(self.movies)
                 self.collectionView.reloadData()
             }
        }
        task.resume()
        //end network code snippet
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
       return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        cell.posterView.af.setImage(withURL: posterURL!)

        
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
