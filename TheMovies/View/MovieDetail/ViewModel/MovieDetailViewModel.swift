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
    var releaseYear: String {get}
    var rating: String {get}
    var runTime: String {get}
    func getGenreListCount() -> Int
    func getGenre(for index: Int) -> String
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
    var releaseYear: String {
        if let date = movieDetail.releaseDate.getDate() {
            let year = Calendar.current.component(.year, from: date)
            return String(year)
        }
        return ""
    }
    
    var runTime: String {
        if let runtime = movieDetail.runtime {
            let (hour, min) = (runtime/60, runtime%60)
            return "- \(hour)h \(min)m"
        }
        return ""
    }
    var rating: String {
        return String(movieDetail.voteAverage)
    }
    private let movieDetail: MovieDetail
    internal let imageService: ImageService
    
    init(movieDetail: MovieDetail, imageService: ImageService) {
        self.movieDetail = movieDetail
        self.imageService = imageService
    }
}

extension MovieDetailViewModelImpl {
    func getGenreListCount() -> Int {
        return movieDetail.genres.count
    }
    func getGenre(for index: Int) -> String {
        return movieDetail.genres[index].name
    }
}
