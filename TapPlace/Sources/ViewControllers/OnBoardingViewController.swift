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
    
    // 버튼 생성
    let skipButton = BottomButton()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
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
        let vc = PickPaymentsViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setLayout() {
        
        let titleLabel: UILabel = {
            let titleLabel = UILabel()
            
            titleLabel.text = "빠르게 찾는 내 주변\n간편결제 가맹점"
            titleLabel.numberOfLines = 2
            titleLabel.textAlignment = .center
            titleLabel.textColor = .black
            titleLabel.font = .boldSystemFont(ofSize: 27)
            titleLabel.sizeToFit()
            
            return titleLabel
        }()
        
        let subTitleLabel: UILabel = {
            let subTitleLabel = UILabel()
            
            subTitleLabel.text = "간편결제가 필요한 순간,\n흩어져 있던 내 주변 가맹점들을\n간편하게 확인해보세요"
            subTitleLabel.numberOfLines = 3
            subTitleLabel.textAlignment = .center
            subTitleLabel.textColor = .lightGray
            subTitleLabel.font = .systemFont(ofSize: 14)
            subTitleLabel.sizeToFit()
            
            return subTitleLabel
        }()
        
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        
        
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
//        pageControl.addTarget(self, action: #selector(pageControlChange(_:)), for: .valueChanged)
        
        
        // 건너뛰기 버튼
        skipButton.delegate = self
        
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.left.equalToSuperview().offset(83)
            $0.right.equalToSuperview().offset(-83)
        }
        
        view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(101)
            $0.right.equalToSuperview().offset(-101)
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
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        skipButton.backgroundColor = .deactiveGray
        skipButton.setTitle("건너뛰기", for: .normal)
        skipButton.setTitleColor(UIColor.init(hex: 0xAFB4C3), for: .normal)
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

    
    private func setPageControlSelectedPage(currentPage:Int) {
        pageControl.currentPage = currentPage
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
        
        if pageControl.currentPage == 2 {
            skipButton.backgroundColor = UIColor.pointBlue
            skipButton.setTitle("가맹점 찾으러 가기", for: .normal)
            skipButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
//    @objc func pageControlChange(_ sender: UIPageControl) {
//        if sender.currentPage == sender.numberOfPages - 1 {
//            skipButton.backgroundColor = UIColor.pointBlue
//            skipButton.setTitle("가맹점 찾으러 가기", for: .normal)
//            skipButton.setTitleColor(UIColor.white, for: .normal)
//        }
//    }
}


