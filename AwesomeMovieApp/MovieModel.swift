//
//  MovieModel.swift
//  AwesomeMovieApp
//
//  Created by sophie on 7/9/16.
//  Copyright © 2016 CorazonCreations. All rights reserved.
//

import UIKit

class MovieModel: NSObject {
    var title: String! = ""
    var overview: String! = ""
    var posterPath: String! = ""
    
    class func parseData(data: NSDictionary) -> MovieModel {
        let movieModel = MovieModel()
        movieModel.title = data["title"] as? String
        movieModel.overview = data["overview"] as? String
        movieModel.posterPath = data["poster_path"] as! String
        return movieModel
    }
}
