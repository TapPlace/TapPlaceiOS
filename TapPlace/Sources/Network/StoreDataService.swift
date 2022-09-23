//
//  StoreDataService.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/08.
//

import Alamofire

struct StoreDataService {
    static let shared = StoreDataService()
    private let aroundSearchUrl = "\(Constants.tapplaceApiUrl)/store/around"
    private let kakaoGeoUrl = "https://dapi.kakao.com/v2/local/geo/coord2address.json"
    private let payListUrl = "\(Constants.tapplaceApiUrl)/pay/list"
    private let payListCheckUrl = "\(Constants.tapplaceApiUrl)/pay/list/check"
    
    
    /**
     * @ 주변 스토어 검색
     * coder : sanghyeon
     */
    func requestFetchAroundStore(parameter: Parameters, completion: @escaping (AroundStoreModel?, Error?) -> ()) {
        let url = "\(aroundSearchUrl)"
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: AroundStoreModel.self) { (response) in
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    /**
     * @ 스토어 아이디로 가맹점 정보 요청
     * coder : sanghyeon
     */
    func requestFetchStoreInfo(parameter: Parameters, completion: @escaping (StoreInfo?, Error?) -> ()) {
        let url = "\(payListUrl)"
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: StoreInfo.self) { (response) in
                switch response.result {
                case .success(let response):
                    print("*** storeDataService requestFetchStoreInfo: \(response)")
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    /**
     * @ 스토어 등록 여부 확인
     * coder : sanghyeon
     */
    func requestFetchStoreInfoCheck(parameter: Parameters, completion: @escaping ([Feedback]?, Error?) -> ()) {
        let url = "\(payListCheckUrl)"
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: SearchFeedbackCheckModel.self) { (response) in
                switch response.result {
                case .success(let response):
                    completion(response.feedback, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    /**
     * @ 카카오 로컬 API로 현재 주소 요청
     * coder : sanghyeon
     */
    func requestFetchKakaoGeoAddress(parameter: Parameters, completion: @escaping (KakaoGeoAddresModel?, Error?) -> ()) {
        let url = kakaoGeoUrl
        guard let kakaoApiKey = Constants.kakaoRestApiKey else { return }
        let header: HTTPHeaders = ["Authorization": "KakaoAK " + kakaoApiKey]
        AF.request(url, method: .get, parameters: parameter, headers: header)
            .validate()
            .responseDecodable(of: KakaoGeoAddresModel.self) { (response) in
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
}
