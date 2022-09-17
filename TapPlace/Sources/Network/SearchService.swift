//
//  SearchService.swift
//  TapPlace
//
//  Created by 이상준 on 2022/09/09.
//

import Alamofire
import Foundation

class SearchService {
    private let kakaoSearchUrl = "https://dapi.kakao.com/v2/local/search/keyword.json"

    func getPlace(parameter: Parameters, completion:@escaping(SearchList?) -> ()){
        guard let kakaoApiKey = Constants.kakaoRestApiKey else { return }
        let header: HTTPHeaders = ["Authorization": "KakaoAK " + kakaoApiKey]
        AF.request(kakaoSearchUrl, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: header)
            .validate()
            .responseDecodable(of: SearchList.self) { (response) in
                switch response.result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    completion(nil)
//                    print(error.localizedDescription)
                }
            }
    }
}


