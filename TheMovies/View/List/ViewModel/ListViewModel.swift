//
//  ListViewModel.swift
//  TheMovies
//
//  Created by Sayali Deopurkar on 20/04/22.
//

import Foundation

struct MoviesViewModelActions {
    let showMovieDetail: (MovieDetail) -> Void
}
protocol ListViewModelInput {
    func loadData()
    func didSelectItem(at index: Int)
}
protocol ListViewModelOutput {
    var didShowError: ((String, String) -> Void)? {get set}
    var didReload: (() -> Void)? {get set}
    var didStartLoading: (() -> Void)? {get set}
    var didStopLoading: (() -> Void)? {get set}
    var imageService: ImageService {get}
    func getListCount() -> Int
    func getMovieData(index: Int) -> Result
}

protocol ListViewModel : ListViewModelInput, ListViewModelOutput {}

final class ListViewModelImpl: ListViewModel {
    
    var didStartLoading: (() -> Void)?
    var didStopLoading: (() -> Void)?
    var didShowError: ((String, String) -> Void)?
    var didReload: (() -> Void)?

    private let actions: MoviesViewModelActions?
    private var service: MoviesService
    var imageService: ImageService

    init(service: MoviesService, actions: MoviesViewModelActions? = nil, imageService: ImageService) {
        self.service = service
        self.actions = actions
        self.imageService = imageService
    }
    
    //private var data: MovieData?
    private var list: [Result] = [] {
        didSet {
            didReload?()
        }
    }
    
    private func fetchData() async {
        do {
            async let movieData: MovieData = try await service.getMovieList(for: 0)
            let movieList = try await movieData.results
            self.list = movieList
            self.didStopLoading?()
        } catch let error as HTTPError {
            //Handle error here
            self.didStopLoading?()
            self.didShowError?(error.errorTitle, error.errorDescription)
        } catch {
            self.didStopLoading?()
            self.didShowError?("Error", error.localizedDescription)
        }
    }
    
    private func fetchDetailData(movieId: Int) async {
        do {
            async let movieDetail: MovieDetail = try await service.getMovieDetail(for: movieId)
            let fetchedMovieDetail = try await movieDetail
            self.didStopLoading?()
            DispatchQueue.main.async {
                self.actions?.showMovieDetail(fetchedMovieDetail)
            }
        } catch let error as HTTPError {
            //Handle error here
            self.didStopLoading?()
            self.didShowError?(error.errorTitle, error.errorDescription)
        } catch {
            self.didStopLoading?()
            self.didShowError?("Error", error.localizedDescription)
        }
    }
}
///ListViewModelInput methods
extension ListViewModelImpl {
    func loadData() {
        self.didStartLoading?()
        Task {
            await self.fetchData()
        }
    }
    
    func didSelectItem(at index: Int) {
        self.didStartLoading?()
        Task {
            await self.fetchDetailData(movieId: list[index].id)
        }
    }
}
///ListViewModelOutput methods
extension ListViewModelImpl {
    
    func getListCount() -> Int {
        return list.count
    }
    
    func getMovieData(index: Int) -> Result {
        return list[index]
    }
}
