//
//  MovieManager.swift
//  MoviesLib
//
//  Created by Eric Alves Brito on 29/08/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import CoreData

class MoviesManager {
    
    let context: NSManagedObjectContext
    weak var delegate: NSFetchedResultsControllerDelegate?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Movie> = {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //fetchRequest.fetchLimit = 50
        //let movieName = "Matrix"
        //let predicate = NSPredicate(format: "title contains [c] %@", movieName)
        //fetchRequest.predicate = predicate
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = delegate
        
        return fetchedResultsController
    }()
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    var totalMovies: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func getMovieAt(_ indexPath: IndexPath) -> Movie {
        fetchedResultsController.object(at: indexPath)
    }
}
