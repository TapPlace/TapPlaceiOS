//
//  SearchViewModel.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/11.
//

import Foundation

struct SearchListViewModel {
    let documents: [SearchModel]
}

extension SearchListViewModel {
    var numberOfSection: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.documents.count
    }
    
    func searchAtIndex(_ index: Int) -> SearchViewModel {
        let place = self.documents[index]
        return SearchViewModel(place)
    }
    
}

struct SearchViewModel {
    private let searchModel: SearchModel
}

extension SearchViewModel {
    init(_ searchModel: SearchModel) {
        self.searchModel = searchModel
    }
}

extension SearchViewModel {
    var placeName: String? {
        return self.searchModel.placeName
    }
    
    var distance: String? {
        return self.searchModel.distance
    }
    
    var addressName: String? {
        return self.searchModel.addressName
    }
}


