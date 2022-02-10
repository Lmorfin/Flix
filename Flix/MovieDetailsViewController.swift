//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Luis Morfin on 2/7/22.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    //dictionary. a property called movie
    var movie: [String:Any]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        movieTitle.text = movie["title"] as? String
        //automatically fits text without breaks
        movieTitle.sizeToFit()
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        
        poster.af.setImage(withURL: posterURL!)

        let backdropPath = movie["backdrop_path"] as! String
        let backdropURL = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        
        backdrop.af.setImage(withURL: backdropURL!)
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
