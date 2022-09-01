//
//  OnBoardingViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/05.
//

import UIKit
import SnapKit

class OnBoardingViewController: UIViewController {
    /**
     * 이 주석은 작업 후 삭제 예정
     * 온보딩뷰 에서 관심 설정뷰로 이동시 User Defaults 초기실행 값 지정
     * coder : sanghyeon
     */
    var userSettingViewModel = UserSettingViewModel()
    
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let skipButton = BottomButton()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    
    let titleArray = ["빠르게 찾는 내 주변\n간편결제 가맹점", "어디서든 쉽게\n새로운 가맹점 등록", "피드백으로 확인하는\n결제 수단 사용 여부"] // 메인 타이틀
    let subTitleArray = ["간편결제가 필요한 순간,\n흩어져 있던 내 주변 가맹점들을\n간편하게 확인해보세요", "언제 어디서든\n새로운 가맹점을 발견하면\n손쉽게 등록할 수 있어요", "직접 이용했던 사용자들의 피드백으로\n원하는 결제 수단의 사용 여부를\n더 정확히 알 수 있어요"]
    let images = [UIImage(named: "dog.jpeg"), UIImage(named: "dog2.jpeg"), UIImage(named: "dog3.jpeg")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLayout()
    }
}

//MARK: - Layout
extension OnBoardingViewController: UIScrollViewDelegate, BottomButtonProtocol{
    
    
    func didTapBottomButton() {
        guard let buttonText = skipButton.titleLabel?.text else { return }
        if buttonText == "건너뛰기" {
            UIView.animate(withDuration: 0.1, animations: {
                self.scrollView.contentOffset = CGPoint(x: 255 * (self.images.count - 1), y: 0)
                self.pageControl.currentPage = 2
                self.checkLastPage(self.pageControl.currentPage)
            })
        } else {
            let setUser = UserModel(uuid: Constants.userDeviceID, isFirstLaunch: false, agreeTerm: "", agreePrivacy: "", agreeMarketing: "", birth: "", sex: "")
            userSettingViewModel.updateUser(setUser)
            let vc = TermsViewController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // 레이아웃
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        // 메인타이틀
        titleLabel.text = "빠르게 찾는 내 주변\n간편결제 가맹점"
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 27)
        titleLabel.sizeToFit()
        
        // 서브타이틀
        subTitleLabel.text = "간편결제가 필요한 순간,\n흩어져 있던 내 주변 가맹점들을\n간편하게 확인해보세요"
        subTitleLabel.numberOfLines = 3
        subTitleLabel.textAlignment = .center
        subTitleLabel.textColor = .lightGray
        subTitleLabel.font = .systemFont(ofSize: 14)
        subTitleLabel.sizeToFit()
        
        // 스크롤 뷰
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        
        // 이미지뷰 셋팅
        for i in 0 ..< images.count {
            let imageView = UIImageView()
            let xPos = 255 * CGFloat(i) // 이미지의 가로가 255이기 때문에 이미지 갯수에 그 길이를 곱함
            imageView.frame = CGRect(x: xPos, y: 0, width: 255, height: 255)
            imageView.image = images[i]
            imageView.contentMode = .scaleToFill
            scrollView.addSubview(imageView)
            scrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
        }
        
        // 페이지 컨트롤
        pageControl.backgroundColor = .white
        pageControl.currentPage = 0
        pageControl.numberOfPages = images.count
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.8859946132, green: 0.8967292905, blue: 0.9279116988, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.3751349747, green: 0.5605497956, blue: 0.9886955619, alpha: 1)
        
        // 건너뛰기 버튼
        skipButton.delegate = self
        
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(80)
            $0.leading.trailing.equalTo(safeArea).inset(20)
        }
        
        view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(safeArea).inset(20)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(48)
            $0.size.equalTo(CGSize(width: 255, height: 255))
            scrollView.layer.cornerRadius = 20
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.bottom).offset(30)
        }
        
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        
        skipButton.setButtonStyle(title: "건너뛰기", type: .disabled, fill: true)
    }
    
    /**
     * @ 초기 레이아웃 설정
     * coder : sanghyeon
     */
    private func setupView() {
        /// 기본 내비게이션 컨트롤러 숨기기
        self.navigationController?.navigationBar.isHidden = true
        /// 네비게이션 컨트롤러 스와이프 뒤로가기 제거
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        /// 뷰컨트롤러 배경색 지정
        view.backgroundColor = .white
    }
    
    // 레이아웃 변화(라벨, 페이지 컨트롤)
    private func changeLayout(currentPage:Int) {
        DispatchQueue.main.async {
            self.pageControl.currentPage = currentPage
            self.titleLabel.text = self.titleArray[currentPage]
            self.subTitleLabel.text = self.subTitleArray[currentPage]
        }
    }
    
    
    // 마지막 페이지인지 체킹하는 함수
    func checkLastPage(_ currentPage: Int) {
        if pageControl.currentPage == 2 {
            skipButton.setButtonStyle(title: "가맹점 찾으러 가기", type: .activate, fill: true)
        }
    }
    
    
    // scrollView를 스크롤했을 때 이벤트 메소드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        changeLayout(currentPage: Int(round(value)))
        checkLastPage(self.pageControl.currentPage)
    }
}
