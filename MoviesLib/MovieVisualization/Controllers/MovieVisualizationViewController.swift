//
//  ViewController.swift
//  MoviesLib
//
//  Created by Eric Alves Brito on 26/08/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import UIKit

class MovieVisualizationViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCategories: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var textViewSummary: UITextView!
    
    // MARK: - Properties
    var movie: Movie?
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    func setupView() {
        guard let movie = movie else {return}
        imageViewPoster.image = movie.poster
        labelTitle.text = movie.title
        labelRating.text = movie.ratingFormatted
        labelCategories.text = (movie.categories as? Set<Category>)?.compactMap({$0.name}).sorted().joined(separator: " | ")
        labelDuration.text = movie.duration
        textViewSummary.text = movie.summary
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieFormViewController = segue.destination as? MovieFormViewController
        movieFormViewController?.movie = movie
    }
}

