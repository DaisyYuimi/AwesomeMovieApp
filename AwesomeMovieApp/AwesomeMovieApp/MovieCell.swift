//
//  MovieCell.swift
//  AwesomeMovieApp
//
//  Created by sophie on 7/9/16.
//  Copyright © 2016 CorazonCreations. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterView.alpha = 0.5
        UIView.animateWithDuration(1.5, animations: {
            self.posterView.alpha = 1
        })
        
        }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        }

}
