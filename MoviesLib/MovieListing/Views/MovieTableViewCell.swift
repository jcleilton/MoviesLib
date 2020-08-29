//
//  MovieTableViewCell.swift
//  MoviesLib
//
//  Created by Eric Alves Brito on 29/08/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageViewPoster: UIImageView! {
        didSet {
            imageViewPoster.layer.cornerRadius = 6
            imageViewPoster.clipsToBounds = true
        }
    }
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSummary: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    
    // MARK: - Properties
    /*
    //Técnica utilizando didSet
    var movie: Movie? {
        didSet {
            labelRating.text = movie?.title
        }
    }
    */
    
    // MARK: - Super Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configure(with: nil)
    }
    
    // MARK: - IBActions
    
    // MARK: - Methods
    func configure(with movie: Movie?) {
        imageViewPoster.image = movie?.poster
        labelTitle.text = movie?.title
        labelSummary.text = movie?.summary
        labelRating.text = movie?.ratingFormatted
    }
    
}
