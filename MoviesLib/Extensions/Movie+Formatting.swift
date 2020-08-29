//
//  Movie+Formatting.swift
//  MoviesLib
//
//  Created by Eric Alves Brito on 29/08/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import UIKit

extension Movie {
    var ratingFormatted: String {
        "⭐️ \(rating)/10.0"
    }
    
    var poster: UIImage? {
        guard let data = image else {return nil}
        return UIImage(data: data)
    }
}
