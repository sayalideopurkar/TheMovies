//
//  ListViewModel.swift
//  TheMovies
//
//  Created by Sayali Deopurkar on 20/04/22.
//

import Foundation

protocol ListViewModelInput {
    func loadData()
}
protocol ListViewModelOutput {
    var didShowError: ((String, String) -> Void)? {get set}
    var didReload: (() -> Void)? {get set}
    var didStartLoading: (() -> Void)? {get set}
    var didStopLoading: (() -> Void)? {get set}
    func getListCount() -> Int
    func getMovieData(index:Int) -> Result
}

protocol ListViewModel : ListViewModelInput, ListViewModelOutput {}

final class ListViewModelImpl: ListViewModel {
    
    var didStartLoading: (() -> Void)?
    var didStopLoading: (() -> Void)?
    var didShowError: ((String, String) -> Void)?
    var didReload: (() -> Void)?

    //private var data: MovieData?
    private var list: [Result] = []
    private func fetchData() async {

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
}
///ListViewModelOutput methods
extension ListViewModelImpl {
    
    func getListCount() -> Int {
        return 2
        //return list.count
    }
    
    func getMovieData(index: Int) -> Result {
        return list[index]
    }
}
