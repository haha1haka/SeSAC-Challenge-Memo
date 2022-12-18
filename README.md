# Memo

<br/>

* sesac에서 진행한 2번째 평가 과제 입니다.
* 개발기간: 2022.08.31 ~ 2022.09.04(5일간)

<br/><br/>





![77메모](https://user-images.githubusercontent.com/106936018/208289765-52b639d0-ca63-49e8-ae92-320831aaecb8.gif)



<br/>

* realm database 이용하여, 기본적인 CRUD 진행
* UISearchViewController 이용하여 search
* NSMutableAttributedString 이용하여 textAttribute 변경
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









