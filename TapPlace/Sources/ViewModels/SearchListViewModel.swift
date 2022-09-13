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
    var searchModelEach: SearchModel?
}

extension SearchViewModel {
    init(_ searchModel: SearchModel) {
        self.searchModel = searchModel
        self.searchModelEach = searchModel
    }
}

extension SearchViewModel {
    var categoryGroupCode: String? {
        return self.searchModel.categoryGroupCode
    }
    
    var placeName: String? {
        return self.searchModel.placeName
    }
    
    var distance: String? {
        return self.searchModel.distance
    }
    
    // 도로명 주소
    var roadAddressName: String? {
        return self.searchModel.roadAddressName
    }
    
    // 지번 주소
    var addressName: String? {
        return self.searchModel.addressName
    }
    
    var storeID: String? {
        return self.searchModel.id
    }
}


