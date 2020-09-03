//
//  MoviesTableViewController.swift
//  MoviesLib
//
//  Created by Eric Alves Brito on 28/08/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import UIKit
import CoreData

class MoviesTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet var viewNoMovies: UIView!
    
    // MARK: - Properties
    let label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 22))
        label.text = "Sem filmes cadastrados"
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        return label
    }()
    lazy var moviesManager: MoviesManager = {[weak self] in
        let movieManager = MoviesManager(context: context)
        movieManager.delegate = self
        return movieManager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieVisualizationViewController = segue.destination as? MovieVisualizationViewController,
            let indexPath = tableView.indexPathForSelectedRow else {return}
        movieVisualizationViewController.movie = moviesManager.getMovieAt(indexPath)
    }
    
    // MARK: - Methods
    private func loadMovies() {
        moviesManager.performFetch()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = moviesManager.totalMovies == 0 ? label : nil
        return moviesManager.totalMovies
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = moviesManager.getMovieAt(indexPath)
        cell.configure(with: movie)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let movie = moviesManager.getMovieAt(indexPath)
            context.delete(movie)
            try? context.save()
        }
        
    }

}

extension MoviesTableViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            print("Código para excluir o filme da tabela")
        case .move:
            print("Código para atualizar a posição do filme da tabela")
        case .update:
            print("Código para atualizar o filme da tabela")
        case .insert:
            print("Código para inserir o filme da tabela")
        @unknown default:
            print("Cenário desconhecido")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
