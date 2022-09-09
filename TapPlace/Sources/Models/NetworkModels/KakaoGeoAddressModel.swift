//
//  KakaoGeoAddressModel.swift
//  TapPlace
//
//  Created by 박상현 on 2022/09/09.
//
import Foundation

// MARK: - KakaoGeoAddresModel
struct KakaoGeoAddresModel: Codable {
    let documents: [KakaoGeoDocument]
}

// MARK: - Document
struct KakaoGeoDocument: Codable {
    let roadAddress: KakaoGeoRoadAddress?
    let address: KakaoGeoAddress

    enum CodingKeys: String, CodingKey {
        case roadAddress = "road_address"
        case address
    }
}

// MARK: - Address
struct KakaoGeoAddress: Codable {
    let addressName, region1DepthName, region2DepthName, region3DepthName: String
    let mountainYn, mainAddressNo, subAddressNo, zipCode: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case mountainYn = "mountain_yn"
        case mainAddressNo = "main_address_no"
        case subAddressNo = "sub_address_no"
        case zipCode = "zip_code"
    }
}

// MARK: - RoadAddress
struct KakaoGeoRoadAddress: Codable {
    let addressName, region1DepthName, region2DepthName, region3DepthName: String
    let roadName, undergroundYn, mainBuildingNo, subBuildingNo: String
    let buildingName, zoneNo: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case roadName = "road_name"
        case undergroundYn = "underground_yn"
        case mainBuildingNo = "main_building_no"
        case subBuildingNo = "sub_building_no"
        case buildingName = "building_name"
        case zoneNo = "zone_no"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}
