//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Linh Le on 2/18/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieDetailScrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDayLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    
    @IBOutlet weak var detailView: UIView!
    
    var movieDB = NSDictionary()
    let tmdbUrl = "https://image.tmdb.org/t/p/w500"

    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailScrollView.contentSize = CGSize(width: movieDetailScrollView.frame.width, height: detailView.frame.size.height + detailView.frame.origin.y + 50)
        
        // Do any additional setup after loading the view.
        titleLabel.text! = movieDB["title"] as! String
        overviewLabel.text! = movieDB["overview"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let releaseDay = dateFormatter.date(from: (movieDB["release_date"] as! String))
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        releaseDayLabel.text! = dateFormatter.string(from:releaseDay! as Date)
        ratingLabel.text! = String(describing: movieDB["vote_average"] as! CFNumber)
        posterImage.setImageWith(URL(string: tmdbUrl + (movieDB["poster_path"] as! String))!)
        runtimeLabel.text! = "1h 30m"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
