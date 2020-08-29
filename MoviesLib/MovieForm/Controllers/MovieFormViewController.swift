//
//  MovieFormViewController.swift
//  MoviesLib
//
//  Created by Eric Alves Brito on 29/08/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import UIKit

class MovieFormViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldRating: UITextField!
    @IBOutlet weak var textFieldDuration: UITextField!
    @IBOutlet weak var labelCategories: UILabel!
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var textViewSummary: UITextView!
    
    // MARK: - Properties
    var movie: Movie?
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - IBActions
    @IBAction func selectImage(_ sender: UIButton) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func save(_ sender: UIButton) {
        if movie == nil {
            movie = Movie(context: context)
        }
        movie?.title = textFieldTitle.text
        movie?.summary = textViewSummary.text
        movie?.duration = textFieldDuration.text
        let rating = Double(textFieldRating.text!) ?? 0
        movie?.rating = max(min(rating, 10), 0)
        movie?.image = imageViewPoster.image?.jpegData(compressionQuality: 0.85)
        
        do {
            try context.save()
            view.endEditing(true)
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Methods
    private func setupView() {
        if let movie = movie {
            title = "Edição de filme"
            textFieldTitle.text = movie.title
            textFieldRating.text = "\(movie.rating)"
            textFieldDuration.text = movie.duration
            textViewSummary.text = movie.summary
            if let data = movie.image {
                imageViewPoster.image = UIImage(data: data)
            }
        }
    }
}
