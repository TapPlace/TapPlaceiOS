//
//  SearchViewModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/11.
//

import Foundation

struct SearchListViewModel {
    let searchLists: [SearchModel]
}

extension SearchListViewModel {
    var numberOfSection: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.searchLists.count
    }
    
    func searchAtIndex(_ index: Int) -> SearchViewModel {
        let place = self.searchLists[index]
        return SearchViewModel(place)
    }
    
}

struct SearchViewModel {
    private let place: SearchModel
}

extension SearchViewModel {
    // 기사를 받는 초기화 메소드
    init(_ store: SearchModel) {
        self.place = store
    }
}

extension SearchViewModel {
    var placeName: String? {
        return self.place.placeName
    }
    
    var distance: String? {
        return self.place.distance
    }
    
    var address: String? {
        return self.place.address
    }
}


