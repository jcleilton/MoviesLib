//
//  FlowManager.swift
//  MoviesLib
//
//  Created by Cleilton Feitosa on 30/08/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import UIKit


struct FlowManager {
    
    static func getRootViewController() -> UIViewController {
        getDetailMovieViewController()
    }
    
    static func getDetailMovieViewController() -> DetailMovieViewController {
        DetailMovieViewController()
    }
}
