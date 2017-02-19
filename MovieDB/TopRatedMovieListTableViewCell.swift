//
//  TopRatedMovieListTableViewCell.swift
//  MovieDB
//
//  Created by Linh Le on 2/19/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit

class TopRatedMovieListTableViewCell: UITableViewCell {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
