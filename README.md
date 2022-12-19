# SeSAC-Challenge_Memo



> *개발기간: 2022.08.31 ~ 2022.09.04(5일)*

* sesac에서 진행한 2번째 평가 과제 입니다.

* iPhone 기본 메모앱을 바탕으로 만들었습니다.

    

<br/><br/>
<br/>

# Table of Contents

* Tech Stack
* Simmulation 및 개발 고려사항

<br/><br/>

## Tech Stack

* MVC
* Swift
* UIKit
* RealmDatabaes

<br/><br/>

## Simulation

![77메모](https://user-images.githubusercontent.com/106936018/208289765-52b639d0-ca63-49e8-ae92-320831aaecb8.gif)

### CoreWork

* Code Base UI(with Snapkit)
* 메모 갯수 1000개 넘어갈 경우 3자리마다 콤마 
* 최신순 정렬
* 메모고정기능(최대 5개 이상 넘어갈시 알럿)
* trailing Swipe 이용한 메모삭제기능
* dateFormatter를 이용한 날짜 포맷 대응
* realm database 이용하여, CRUD 
* DarkMode, LightMode 대응
* NSMutableAttributedString 이용하여 text 컬러 변경
* UIViewController + Extension에 transition func 를 만들어서 화면전화 코드 줄이기



```swift
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present) {
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
        case .presentNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            self.present(navi, animated: true)
        case .presentFullNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
```









