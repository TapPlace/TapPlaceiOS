//
//  CommonUtils.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/08.
//

import UIKit

struct CommonUtils {
    /**
     * @ 디바이스 고유 UUID 가져오기
     * coder : sanghyeon
     */
    static func getDeviceUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    /**
     * @ 해상도 비율에 따라 폰트사이즈 동기화
     * 13Pro 해상도 기준 390
     * coder : sanghyeon
     */
    static func resizeFontSize(size: CGFloat) -> CGFloat {
        let standatdScreenSize: CGRect = CGRect(x: 0, y: 0, width: 375, height: 812)
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let sizeFormatter = size/375
        return screenWidth < standatdScreenSize.width ? screenWidth * sizeFormatter : size
    }
    
    /**
     * @ 결제수단 선택창 셀 크기 지정을 위해 글자수 기반 사이즈 반환
     * coder : sanghyeon
     */
    static func getTextSizeWidth(text: String) -> LabelSize {
        let label: UILabel = {
            let label = UILabel()
            label.text = text
            label.font = .systemFont(ofSize: CommonUtils.resizeFontSize(size: 13), weight: .regular)
            label.sizeToFit()
            return label
        }()
        return LabelSize(width: label.frame.width, height: label.frame.height)
    }
    
    /**
     * @날짜를 지정한 형식으로 반환
     * @creater : sanghyeon
     * @param date : 기준 날짜
     * @param type : 가져올 형식(1 : 년, 2 : 년.월, 3 : 년.월.일
     * @Return : String
     */
    public static func getDate(_ date: Date, type: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        switch type {
        case 1:
            dateFormatter.dateFormat = "yyyy"
        case 2:
            dateFormatter.dateFormat = "yyyy.MM"
        default:
            dateFormatter.dateFormat = "yyyy.MM.dd"
        }
        
        return dateFormatter.string(from: date)
    }

}

extension String {
    /**
     * @String의 날짜를 Date로 변환
     * @creater : sanghyeon
     * @Return : Date?
     */
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    /**
     * @ 일반 문자를 데이트스트링으로 변환 (yyyy-MM-dd)
     * coder : sanghyeon
     */
    func toDateString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        if self == "" { return nil }
        
        let dateObj = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateObj = dateObj {
            return dateFormatter.string(from: dateObj)
        } else {
            return nil
        }
    }
}

extension Date {
    /**
     * @Date의 날짜를 String으로 변환
     * @creater : sanghyeon
     * @Return : String
     */
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        return dateFormatter.string(from: self)
    }
    /**
     * @날짜를 지정한 형식으로 반환
     * @creater : sanghyeon
     * @param date : 기준 날짜
     * @param type : 가져올 형식(1 : 년, 2 : 년/월, 3 : 년.월.일, 4 : 년-월-일
     * @Return : String
     */
    func getDate(_ type: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        switch type {
        case 1:
            dateFormatter.dateFormat = "yyyy"
        case 2:
            dateFormatter.dateFormat = "yyyy.MM"
        case 3:
            dateFormatter.dateFormat = "yyyy.MM.dd"
        default:
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
        
        return dateFormatter.string(from: self)
    }
}


struct LabelSize {
    let width: CGFloat
    let height: CGFloat
}
