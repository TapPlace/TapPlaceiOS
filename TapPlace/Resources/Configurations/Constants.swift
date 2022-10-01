//
//  Constants.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/14.
//

import Foundation
import Alamofire

struct Constants {
    static let userDeviceUUID = UUID().uuidString
    static let keyChainDeviceID = KeyChain.readUserDeviceUUID() ?? userDeviceUUID
    static let naverClientId = Bundle.main.infoDictionary?["NAVER_CLIENT_ID"] as? String
    static let kakaoRestApiKey = Bundle.main.infoDictionary?["KAKAO_REST_API_KEY"] as? String
    static let tapplaceBaseUrl = "https://www.tapplace.co.kr"
    static let tapplaceApiUrl = "https://\(Bundle.main.infoDictionary?["TAPPLACE_API_URL"] as? String ?? "")"
    static let tapplaceApiKey = Bundle.main.infoDictionary?["TAPPLACE_API_KEY"] as? String ?? ""
    static let tapplaceSecretKey = Bundle.main.infoDictionary?["TAPPLACE_SECRET_KEY"] as? String ?? ""
    static let tapplaceConsentUrl = tapplaceBaseUrl + "/consent"
    static let tapplacePolicyUrl = tapplaceBaseUrl + "/policy"
    static let tapplaceFAQUrl = tapplaceBaseUrl + "/questions"
    static let latestTerm = "2022-09-01"
    static let latestPrivacy = "2022-09-01"
    let header: HTTPHeaders = ["Authorization": "\(APIToken.generateToken())"]
}
