//
//  MoviesFlowCoordinator.swift
//  TheMovies
//
//  Created by Sayali Deopurkar on 20/04/22.
//

import UIKit

protocol MoviesFlowCoordinatorDependencies  {
    func makeMoviesListController() -> ListViewController
}
final class MoviesFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MoviesFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: MoviesFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeMoviesListController()
        navigationController?.pushViewController(vc, animated: false)
    }
}
