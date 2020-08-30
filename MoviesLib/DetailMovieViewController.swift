//
//  DetailMovieViewController.swift
//  MoviesLib
//
//  Created by Ricardo Espirito Santo Bailoni on 29/08/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import UIKit

fileprivate struct Consts {
    static let multiplier40: CGFloat = 0.40
    static let multiplier50: CGFloat = 0.50
    static let multiplier65: CGFloat = 0.65
    static let constant06: CGFloat = 06
    static let constant10: CGFloat = 10
    static let constant16: CGFloat = 16
    static let constant25: CGFloat = 25
    static let constant50: CGFloat = 50
    static let constant60: CGFloat = 60
    static let mainColor = UIColor(named: "Main")
    static let imageToyStory = UIImage(named: "toystory3")
    static let imagePlay = UIImage(named: "play")
    static let imageGradient = UIImage(named: "gradient")
    static let textToyStory = "Toy Story"
    static let textGenres = "Ação | Comédia | Animação"
    static let priority252: Float = 252
    static let priority749: Float = 749
    static let textTime = "02:00h"
    static let textRating = "⭐️ 9.0/10"
    static let textTitleSynopsis = "Sinopse"
    static let fontSize14: CGFloat = 14.0
    static let textSynopsis = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    static let textLinkMovie = "http://www.toystory3.com.br"
}

class DetailMovieViewController: UIViewController {
    lazy var mainImage: UIImageView = {
        return UIImageView(frame: .zero)
    }()
    
    lazy var playButton: UIButton = {
        return UIButton(type: .custom)
    }()
    
    lazy var gradient: UIImageView = {
        return UIImageView(frame: .zero)
    }()
    
    lazy var movieName: UILabel = {
        return UILabel()
    }()
    
    lazy var movieGenres: UILabel = {
        return UILabel()
    }()
    
    lazy var movieTime: UILabel = {
        return UILabel()
    }()
    
    lazy var movieRating: UILabel = {
        return UILabel()
    }()
    
    lazy var synopsisContainer: UIView = {
        return UIView()
    }()
    
    lazy var synopsisTitle: UILabel = {
        return UILabel()
    }()
    
    lazy var synopsis: UITextView = {
        return UITextView()
    }()
    
    lazy var linkMovie: UILabel = {
        return UILabel()
    }()
    
    lazy var verticalCompactLandscapeConstraints: [NSLayoutConstraint] = {
        return [
            mainImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Consts.multiplier50),
            mainImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Consts.multiplier65),
            synopsisContainer.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor),
            synopsisContainer.topAnchor.constraint(equalTo: view.topAnchor),
            linkMovie.leadingAnchor.constraint(equalTo: synopsis.leadingAnchor),
            linkMovie.trailingAnchor.constraint(equalTo: synopsis.trailingAnchor),
            linkMovie.bottomAnchor.constraint(equalTo: synopsisContainer.bottomAnchor, constant: -Consts.constant25)
        ]
    }()
    
    lazy var regularConstraints: [NSLayoutConstraint] = {
        return [
            
            mainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Consts.multiplier40),
            synopsisContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            synopsisContainer.topAnchor.constraint(equalTo: movieRating.bottomAnchor, constant: Consts.constant16),
            linkMovie.bottomAnchor.constraint(equalTo: synopsis.bottomAnchor, constant: Consts.constant50)

        ]
    }()
    
    var isLandscapeOrientation: Bool {
        get {
            let orientation = UIDevice.current.orientation
            return orientation == .landscapeRight || orientation == .landscapeLeft
        }
    }
    
    var isVerticalCompact: Bool {
        get {
            return UIScreen.main.traitCollection.verticalSizeClass == .compact
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCodeSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setConstraints()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setConstraints()
    }
    
    private func setConstraints() {
        if isLandscapeOrientation && isVerticalCompact {
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(verticalCompactLandscapeConstraints)
            highlightFontSynopsisTitle(true)
        } else {
            NSLayoutConstraint.deactivate(verticalCompactLandscapeConstraints)
            NSLayoutConstraint.activate(regularConstraints)
            highlightFontSynopsisTitle(false)
        }
    }
    
    private func highlightFontSynopsisTitle(_ isTrue: Bool) {
        if isTrue {
            synopsisTitle.textColor = Consts.mainColor
            synopsisTitle.font = .preferredFont(forTextStyle: .title2)
        } else {
            synopsisTitle.textColor = .black
            synopsisTitle.font = .preferredFont(forTextStyle: .footnote)
        }
    }
}

extension DetailMovieViewController: ViewCodePrococol {
    func viewCodeHierarchySetup() {
        view.addSubview(mainImage)
        view.addSubview(playButton)
        view.addSubview(gradient)
        view.addSubview(movieName)
        view.addSubview(movieGenres)
        view.addSubview(movieTime)
        view.addSubview(movieRating)
        view.addSubview(synopsisContainer)
        synopsisContainer.addSubview(synopsisTitle)
        synopsisContainer.addSubview(synopsis)
        synopsisContainer.addSubview(linkMovie)
    }
    
    func viewCodeConstraintSetup() {
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.centerYAnchor.constraint(equalTo: mainImage.centerYAnchor).isActive = true
        playButton.centerXAnchor.constraint(equalTo: mainImage.centerXAnchor).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: Consts.constant50).isActive = true
        playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor).isActive = true
        
        gradient.translatesAutoresizingMaskIntoConstraints = false
        gradient.leadingAnchor.constraint(equalTo: mainImage.leadingAnchor).isActive = true
        gradient.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor).isActive = true
        gradient.bottomAnchor.constraint(equalTo: mainImage.bottomAnchor).isActive = true
        gradient.heightAnchor.constraint(equalToConstant: Consts.constant60).isActive = true
        
        movieName.translatesAutoresizingMaskIntoConstraints = false
        movieName.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Consts.constant16).isActive = true
        movieName.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: -Consts.constant16).isActive = true
        movieName.topAnchor.constraint(equalTo: mainImage.bottomAnchor).isActive = true
        
        movieGenres.translatesAutoresizingMaskIntoConstraints = false
        movieGenres.leadingAnchor.constraint(equalTo: movieName.leadingAnchor).isActive = true
        movieGenres.topAnchor.constraint(equalTo: movieName.bottomAnchor, constant: Consts.constant06).isActive = true
        
        movieTime.translatesAutoresizingMaskIntoConstraints = false
        movieTime.leadingAnchor.constraint(equalTo: movieGenres.trailingAnchor, constant: Consts.constant10).isActive = true
        movieTime.trailingAnchor.constraint(equalTo: movieName.trailingAnchor).isActive = true
        movieTime.topAnchor.constraint(equalTo: movieGenres.topAnchor).isActive = true
        
        movieRating.translatesAutoresizingMaskIntoConstraints = false
        movieRating.leadingAnchor.constraint(equalTo: movieGenres.leadingAnchor).isActive = true
        movieRating.trailingAnchor.constraint(equalTo: movieTime.trailingAnchor).isActive = true
        movieRating.topAnchor.constraint(equalTo: movieGenres.bottomAnchor, constant: Consts.constant06).isActive = true
        
        synopsisContainer.translatesAutoresizingMaskIntoConstraints = false
        synopsisContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        synopsisContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        synopsisTitle.translatesAutoresizingMaskIntoConstraints = false
        synopsisTitle.leadingAnchor.constraint(equalTo: synopsisContainer.leadingAnchor, constant: Consts.constant16).isActive = true
        synopsisTitle.trailingAnchor.constraint(equalTo: synopsisContainer.trailingAnchor, constant: -Consts.constant16).isActive = true
        synopsisTitle.topAnchor.constraint(equalTo: synopsisContainer.topAnchor, constant: Consts.constant16).isActive = true
        
        synopsis.translatesAutoresizingMaskIntoConstraints = false
        synopsis.leadingAnchor.constraint(equalTo: synopsisTitle.leadingAnchor).isActive = true
        synopsis.trailingAnchor.constraint(equalTo: synopsisTitle.trailingAnchor).isActive = true
        synopsis.topAnchor.constraint(equalTo: synopsisTitle.bottomAnchor, constant: Consts.constant06).isActive = true
        synopsis.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Consts.constant50).isActive = true
        
        linkMovie.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func viewCodeThemeSetup() {
        view.backgroundColor = .black
        mainImage.contentMode = .scaleAspectFill
        mainImage.image = Consts.imageToyStory
        mainImage.clipsToBounds = true
        
        playButton.setBackgroundImage(Consts.imagePlay, for: .normal)
        playButton.tintColor = .white
        
        gradient.image = Consts.imageGradient
        gradient.contentMode = .scaleToFill
        gradient.clipsToBounds = true
        
        movieName.textColor = .white
        movieName.font = .preferredFont(forTextStyle: .title1)
        movieName.text = Consts.textToyStory
        
        movieGenres.textColor = .lightGray
        movieGenres.font = .preferredFont(forTextStyle: .footnote)
        movieGenres.text = Consts.textGenres
        movieGenres.setContentCompressionResistancePriority(UILayoutPriority(rawValue: Consts.priority749), for: .horizontal)
        
        movieTime.textColor = .lightGray
        movieTime.font = .preferredFont(forTextStyle: .footnote)
        movieTime.text = Consts.textTime
        movieTime.setContentHuggingPriority(UILayoutPriority(rawValue: Consts.priority252), for: .horizontal)
        
        movieRating.textColor = Consts.mainColor
        movieRating.font = .preferredFont(forTextStyle: .footnote)
        movieRating.text = Consts.textRating
        
        synopsisContainer.backgroundColor = .white
        
        synopsisTitle.text = Consts.textTitleSynopsis
        
        synopsis.tintColor = .black
        synopsis.font = .systemFont(ofSize: Consts.fontSize14)
        synopsis.text = Consts.textSynopsis
        
        linkMovie.text = Consts.textLinkMovie
        linkMovie.textColor = Consts.mainColor
        linkMovie.font = .preferredFont(forTextStyle: .footnote)
    }
}
