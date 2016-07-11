//
//  DetailsViewController.swift
//  AwesomeMovieApp
//
//  Created by sophie on 7/9/16.
//  Copyright © 2016 CorazonCreations. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    var movie: MovieModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        titleLabel.text = movie.title
        
        
        overviewLabel.text = movie.overview
        overviewLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        
        if let posterPath = movie.posterPath {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            posterImageView.setImageWithURL(imageUrl!)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
  }
