//
//  MoviesDIContainer.swift
//  TheMovies
//
//  Created by Sayali Deopurkar on 20/04/22.
//

import UIKit

final class MoviesDIContainer {
   
    // MARK: - List
    func makeMoviesListController() -> ListViewController {
        return ListViewController(viewModel: makeListViewModel())
    }
    func makeListViewModel() -> ListViewModel {
        return ListViewModelImpl()
    }
    // MARK: - Flow Coordinators
    func makeMoviesFlowCoordinator(navigationController: UINavigationController) -> MoviesFlowCoordinator {
        return MoviesFlowCoordinator(navigationController: navigationController,
                                           dependencies: self)
    }
}
extension MoviesDIContainer: MoviesFlowCoordinatorDependencies {}
