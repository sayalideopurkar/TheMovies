//
//  MovieDetailViewModel.swift
//  TheMovies
//
//  Created by Sayali Deopurkar on 23/04/22.
//

import Foundation

protocol MovieDetailViewModel : MovieDetailViewModelOutput {}

protocol MovieDetailViewModelOutput {
    var didShowError: ((String, String) -> Void)? {get set}
    var imageService: ImageService {get}
    
    var title: String {get}
    var description: String {get}
    var posterPath: String? {get}
}

final class MovieDetailViewModelImpl: MovieDetailViewModel {
    var didShowError: ((String, String) -> Void)?
    var title: String {
        return movieDetail.title
    }
    var description: String {
        return movieDetail.overview ?? "No overview available"
    }
    var posterPath: String? {
        return movieDetail.posterPath
    }
    private let movieDetail: MovieDetail
    internal let imageService: ImageService
    
    init(movieDetail: MovieDetail, imageService: ImageService) {
        self.movieDetail = movieDetail
        self.imageService = imageService
    }
}

extension MovieDetailViewModelImpl {
    
}
