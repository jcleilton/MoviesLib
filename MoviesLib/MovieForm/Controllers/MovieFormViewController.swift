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
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    var movie: Movie?
    var selectedCategories: Set<Category> = [] {
        didSet {
            if selectedCategories.count > 0 {
                labelCategories.text = selectedCategories.compactMap({$0.name}).sorted().joined(separator: " | ")
            } else {
                labelCategories.text = "Categorias"
            }
        }
    }
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let categoriesViewController = segue.destination as? CategoriesViewController {
            categoriesViewController.delegate = self
            categoriesViewController.selectedCategories = selectedCategories
        }
    }
    
    // MARK: - IBActions
    @IBAction func selectImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você deseja escolher o pôster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (_) in
                self.selectPictureFrom(.camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (_) in
            self.selectPictureFrom(.savedPhotosAlbum)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (_) in
            self.selectPictureFrom(.photoLibrary)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
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
        movie?.categories = selectedCategories as NSSet?
        
        do {
            try context.save()
            view.endEditing(true)
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Methods
    //https://www.hackingwithswift.com/example-code/uikit/how-to-adjust-a-uiscrollview-to-fit-the-keyboard
    //https://www.youtube.com/watch?v=D3sxanj3vd8
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}

        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let animation = UIView.AnimationOptions(rawValue: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: animation, animations: {
            self.scrollView.contentInset.bottom = keyboardFrame.size.height - self.view.safeAreaInsets.bottom
            self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.size.height - self.view.safeAreaInsets.bottom
        }) { (success) in
            print("Teclado terminou de aparecer")
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    private func setupView() {
        if let movie = movie {
            title = "Edição de filme"
            textFieldTitle.text = movie.title
            textFieldRating.text = "\(movie.rating)"
            textFieldDuration.text = movie.duration
            textViewSummary.text = movie.summary
            buttonSave.setTitle("Alterar", for: .normal)
            
            if let categories = movie.categories as? Set<Category>, categories.count > 0 {
                selectedCategories = categories
            }
            
            if let data = movie.image {
                imageViewPoster.image = UIImage(data: data)
            }
        }
    }
    
    private func selectPictureFrom(_ sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func resizeImage(_ image: UIImage, withScaleFactor scaleFactor: CGFloat) {
        
        let newSize = CGSize(width: image.size.width * scaleFactor, height: image.size.height * scaleFactor)
        
        DispatchQueue.global(qos: .background).async {[weak imageViewPoster] in
            let imageRenderer = UIGraphicsImageRenderer(size: newSize)
            let resizedImage = imageRenderer.image { (_) in
                image.draw(in: CGRect(origin: .zero, size: newSize))
            }
            DispatchQueue.main.async {
                imageViewPoster?.image = resizedImage
            }
        }
        
    }
}

extension MovieFormViewController: CategoriesDelegate {
    func setSelectedCategories(_ categories: Set<Category>) {
        selectedCategories = categories
    }
}

extension MovieFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /*
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            resizeImage(image, withScaleFactor: 0.05)
        }
        dismiss(animated: true, completion: nil)
    }
}
