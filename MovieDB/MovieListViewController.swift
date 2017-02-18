//
//  MovieListViewController.swift
//  MovieDB
//
//  Created by Linh Le on 2/15/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit
import AFNetworking
import KRProgressHUD
class MovieListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkWarningView: UIView!
    @IBAction func reloadButton(_ sender: UIButton) {
        checkNetwork()
        loadMovieDataBase()
    }
    
    var movie = [NSDictionary]()
    let tmdbUrl = "https://image.tmdb.org/t/p/w500"
    // Initialize a UIRefreshControl
    let refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNetwork()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        loadMovieDataBase()
        //Add refresh database
        refreshController.addTarget(self, action: #selector(refreshControlAction(refreshController:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshController, at: 0)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
    }
    override func viewDidAppear(_ animated: Bool) {
        checkNetwork()
        
        // Un-select the selected row
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListTableViewCell") as! MovieListTableViewCell
        
        let movieDictionary = movie[indexPath.row]
        let overview = movieDictionary["overview"] as? String
        let title = movieDictionary["title"] as? String
        let imageUrl = tmdbUrl + (movieDictionary["poster_path"] as! String)
        
        cell.overviewLabel.text = overview
        cell.titleLabel.text = title
        cell.posterImage.setImageWith(URL(string: imageUrl)!)
        print(imageUrl)
        return cell
    }
    
    
    func loadMovieDataBase() {
        KRProgressHUD.show()
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                             completionHandler: { (dataOrNil, response, error) in
                                if let data = dataOrNil {
                                    if let responseDictionary = try! JSONSerialization.jsonObject(
                                        with: data, options:[]) as? NSDictionary {
                                        self.movie = (responseDictionary["results"] as! [NSDictionary])
                                        //print(self.movie)
                                        self.tableView.reloadData()
                                        KRProgressHUD.dismiss()
                                        //end refresh database
                                        self.refreshController.endRefreshing()
                                    }
                                }
            })
        task.resume()
    }
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshController: UIRefreshControl) {
        loadMovieDataBase()
    }
    // Check network
    func checkNetwork() {
        if !isInternetAvailable() {
            KRProgressHUD.dismiss()
            tableView.isHidden = true
            networkWarningView.isHidden = false            
        }else{
            networkWarningView.isHidden = true
            tableView.isHidden = false
        }
    }
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let MovieDetail = segue.destination as! MovieDetailViewController
        // Get sellected row
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)?.row
        // Send selected movie data to detail view controller
        MovieDetail.movieDB = movie[indexPath!]
    }
 

}
