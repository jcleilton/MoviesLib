//
//  ViewController.swift
//  MoviesLib
//
//  Created by Eric Alves Brito on 26/08/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import UIKit
import AVKit

class MovieVisualizationViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCategories: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var textViewSummary: UITextView!
    @IBOutlet weak var viewMovie: UIView!
    
    // MARK: - Properties
    var movie: Movie?
    var moviePlayer: AVPlayer?
    var moviePlayerController: AVPlayerViewController?
    var trailer: String = ""
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = movie?.title {
            loadTrailer(with: title)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieFormViewController = segue.destination as? MovieFormViewController
        movieFormViewController?.movie = movie
    }
    
    // MARK: - Methods
    private func loadTrailer(with title: String) {
        let itunesPath = "https://itunes.apple.com/search?media=movie&entity=movie&term="
        guard let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              !encodedTitle.isEmpty,
              let url = URL(string: "\(itunesPath)\(encodedTitle)") else {return}
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            let apiResult = try! JSONDecoder().decode(ItunesResult.self, from: data!)
            self?.trailer = apiResult.results.first?.previewUrl ?? ""
            DispatchQueue.main.async {
                self?.prepareVideo()
                if UserDefaults.standard.bool(forKey: Key.autoplay) {
                    self?.play()
                }
            }
        }.resume()
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
    
    func prepareVideo() {
        guard let url = URL(string: trailer) else {return}
        moviePlayer = AVPlayer(url: url)
        moviePlayerController = AVPlayerViewController()
        moviePlayerController?.player = moviePlayer
        moviePlayerController?.showsPlaybackControls = false
        
        guard let movieView = moviePlayerController?.view else {return}
        movieView.frame = viewMovie.bounds
        viewMovie.addSubview(movieView)
    }
    
    func play() {
        viewMovie.isHidden = false
        moviePlayer?.play()
        
        
        /*
        guard let moviePlayerController = moviePlayerController else {return}
        present(moviePlayerController, animated: true) {[weak moviePlayer] in
            moviePlayer?.play()
        }
        */
    }
    
    // MARK: - IBActions
    @IBAction func playMovie(_ sender: UIButton) {
        play()
    }
    
}

