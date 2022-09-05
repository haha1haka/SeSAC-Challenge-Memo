//
//  MainViewController.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit
import RealmSwift


class MainViewController: BaseViewController {
    
    var searchController = UISearchController(searchResultsController: nil)
    let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func configure() {
        configureUITableView() // 테이블뷰 설정
        configureUISearchController() // UISearchController 설정
        configureUIToolBar() // 툴바 설장
        checkIntroScene() // Userdefaults 이용 첫번째 화면 컨트롤
        configureUINavigationBar()
    }
    
    let repository = MemoRepository()
    
    // totalMemoObjectArray 기준으로 모든 배열 최신화, totalMemoObjectArray은 willAppear에서 패치
    var totalMemoObjectArray: Results<Memo>! {
        didSet {
            configureTitle(totalMemoObjectArray.count)
            fixedMemoObjectArray = repository.fetchFilter(in: totalMemoObjectArray, isFixed: true)
            nonFixedMemoObjectArray = repository.fetchFilter(in: totalMemoObjectArray, isFixed: false)
            searchedMemoObjectArray = repository.fetchFilterSearchedText(in: totalMemoObjectArray, text: searchController.searchBar.text!)
        }
    }
    
    var fixedMemoObjectArray: Results<Memo>! // 고정된 객체들
    var nonFixedMemoObjectArray: Results<Memo>! // 비고정된 객체들
    var searchedMemoObjectArray: Results<Memo>! //검색된 객체들
    
    // 검색중이면 true
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
}










// MARK: - viewWillAppear
extension MainViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalMemoObjectArray = repository.fetch() // 패치
        mainView.tableView.reloadData()
    }
}









// MARK: - configure Methods
extension MainViewController {
    
    
    func configureUITableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.className)
    }
    
    
    
    func configureUINavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.delegate = self
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = COLOR_BRANDI_PRIMARY
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    
    
    func configureUISearchController() {
        searchController.searchBar.placeholder = "검색"
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    
    func configureUIToolBar() {
        self.navigationController?.isToolbarHidden = false
        let writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonClicked))
        writeButton.tintColor = Color.memoYellow
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        self.toolbarItems = [flexibleSpace, writeButton]
    }
    @objc func writeButtonClicked() {
        let vc = DetailViewController()
        transition(vc, transitionStyle: .push)
    }
    
    
    
    
    func checkIntroScene() {
        if !UserDefaults.standard.bool(forKey: "isIntro") {
            UserDefaults.standard.set(true, forKey: "isIntro")
            let vc = IntroViewController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            transition(vc, transitionStyle: .present)
        }
    }
    
    
    // 천자리 넘어가면, 소숫점 찍기
    func configureTitle(_ memoCount: Int) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.navigationItem.title = "\(numberFormatter.string(from: memoCount as NSNumber) ?? "1")개의 메모"
    }
    
    
    
    // 셀을 구성했을시 Date()와, 내가 등록한 registeredDate 비교해서! 분기따라 포메터 적용 하도록!
    func dateSeparator(registeredDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        let currentDateComponent = Calendar.current.dateComponents([.day, .weekOfYear], from: Date())
        let registeredeDateComponent = Calendar.current.dateComponents([.day, .weekOfYear], from: registeredDate)
        if currentDateComponent.day == registeredeDateComponent.day {
            formatter.dateFormat = "a hh:mm"
        } else if currentDateComponent.weekOfYear == registeredeDateComponent.weekOfYear {
            formatter.dateFormat = "EEEE"
        } else {
            formatter.dateFormat = "yyyy.MM.dd a HH:mm"
        }
        return formatter.string(from: registeredDate)
    }
    
    
    // title String Attribute 변경
    func applyNSMutableAttributedTitleString(object:  Results<Memo>,index: Int) ->  NSMutableAttributedString {
        let totalString: String = object[index].title
        let targetTitleString = NSMutableAttributedString(string: totalString)
        var titleFirstIndex: Int = 0
        if let titleFirstRange = totalString.range(of: "\(searchController.searchBar.text!)", options: .caseInsensitive) {
            titleFirstIndex = totalString.distance(from: totalString.startIndex, to: titleFirstRange.lowerBound)
            targetTitleString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: NSRange(location: titleFirstIndex, length: searchController.searchBar.text?.count ?? 0))
        }
        return targetTitleString
    }
    
    
    // content String Attribute 색상 변경
    func applyNSMutableAttributedContentString(object:  Results<Memo>,index: Int) ->  NSMutableAttributedString {
        
        let totalContent: String = object[index].content
        let targetContentString = NSMutableAttributedString(string: totalContent)
        var contentFirstIndex: Int = 0
        if let contentFirstRange = totalContent.range(of: "\(searchController.searchBar.text!)", options: .caseInsensitive) {
            contentFirstIndex = totalContent.distance(from: totalContent.startIndex, to: contentFirstRange.lowerBound)
            targetContentString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: NSRange(location: contentFirstIndex, length: searchController.searchBar.text?.count ?? 0))
        }
        return targetContentString
    }
}












// MARK: - UISearchBarController
extension MainViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.searchedMemoObjectArray = repository.fetchFilterSearchedText(in: totalMemoObjectArray, text: text)
        //        searchingText = text
        //글자마다 리로드
        self.mainView.tableView.reloadData()
    }
    func didDismissSearchController(_ searchController: UISearchController) {
        mainView.tableView.reloadData()
    }
}












// MARK: - tableView Methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering { // 검색중
            return 1
        } else {
            return Header.allCases.count
        }
    }
    

    
    
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let cellStatus = CellStatus.allCases[section]
        
        if isFiltering {
            return searchedMemoObjectArray?.count ?? 0
        } else {
            //if fixedMemoObjectArray.count <= 0 {
            //return nonFixedMemoObjectArray.count
            //} else {
            switch cellStatus {
            case .fixed:
                return fixedMemoObjectArray.count
            case .nonFixed:
                return nonFixedMemoObjectArray.count
            }
        }
        //}
    }
    
    
    
    
    
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.className) as? MainTableViewCell else { return UITableViewCell() }
        
        let cellStatus = CellStatus.allCases[indexPath.section]
        
        if isFiltering {
            cell.contentLabel.attributedText = applyNSMutableAttributedContentString(object:  searchedMemoObjectArray, index: indexPath.row)
            cell.mainLabel.attributedText = applyNSMutableAttributedTitleString(object:  searchedMemoObjectArray, index: indexPath.row)
            cell.dateLabel.text = dateSeparator(registeredDate: searchedMemoObjectArray?[indexPath.row].date ?? Date())
            cell.selectionStyle = .none
        } else {
            //if fixedMemoObjectArray.count == 0 {
            //cell.mainLabel.text = nonFixedMemoObjectArray[indexPath.row].title
            //cell.dateLabel.text = dateSeparator(registeredDate: nonFixedMemoObjectArray?[indexPath.row].date ?? Date())
            //cell.contentLabel.text = nonFixedMemoObjectArray[indexPath.row].content
            //} else {
            switch cellStatus {
            case .fixed:
                cell.contentLabel.attributedText = applyNSMutableAttributedContentString(object:  fixedMemoObjectArray, index: indexPath.row)
                cell.mainLabel.attributedText = applyNSMutableAttributedTitleString(object:  fixedMemoObjectArray, index: indexPath.row)
                cell.dateLabel.text = dateSeparator(registeredDate: fixedMemoObjectArray[indexPath.row].date)
                cell.selectionStyle = .none
                
            case .nonFixed:
                cell.contentLabel.attributedText = applyNSMutableAttributedContentString(object:  nonFixedMemoObjectArray, index: indexPath.row)
                cell.mainLabel.attributedText = applyNSMutableAttributedTitleString(object:  nonFixedMemoObjectArray, index: indexPath.row)
                cell.dateLabel.text = dateSeparator(registeredDate: nonFixedMemoObjectArray?[indexPath.row].date ?? Date())
                cell.selectionStyle = .none
                
                
            }
        }
        //}
        return cell
    }
    
    
    
    
    
    
    // MARK: - Detail 로 가기 + 객체 넘겨주기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        let cellStatus = CellStatus.allCases[indexPath.section]
        
        if isFiltering {
            vc.memoObject = searchedMemoObjectArray?[indexPath.row]
        } else {
            //if fixedMemoObjectArray.count == 0 {
            //    vc.memoObject = nonFixedMemoObjectArray[indexPath.row]
            //} else {
                switch cellStatus {
                case .fixed:
                    vc.memoObject = fixedMemoObjectArray[indexPath.row]
                case .nonFixed:
                    vc.memoObject = nonFixedMemoObjectArray[indexPath.row]
                }
            }
        //}
        transition(vc,transitionStyle: .push)
    }
    
    
    
    
    
    
    
    
    // MARK: - 리딩 (핀고정, 비고정 코드)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cellStatus = CellStatus.allCases[indexPath.section]
        
        // 검색중일떄
        if isFiltering {
            if searchedMemoObjectArray?[indexPath.row].isFixed == true {
                
                let pin = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
                    
                    // 업데이트후 리로드
                    self.repository.updatePin(updateObject: (self.searchedMemoObjectArray?[indexPath.row])!, isFiexd: false)
                    self.mainView.tableView.reloadData()
                    
                }
                pin.image = UIImage(systemName: "pin.slash.fill")
                pin.backgroundColor = .systemOrange
                return UISwipeActionsConfiguration(actions: [pin])
                
            } else {
                
                let pin = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
                    
                    if self.fixedMemoObjectArray.count >= 5 {
                        self.showAlertMessage(title: "5개 최대")
                    } else {
                        // 업데이트후 리로드
                        self.repository.updatePin(updateObject: (self.searchedMemoObjectArray?[indexPath.row])!, isFiexd: true)
                        self.mainView.tableView.reloadData()
                    }
                }
                pin.image = UIImage(systemName: "pin.fill")
                pin.backgroundColor = .systemOrange
                return UISwipeActionsConfiguration(actions: [pin])
            }
            
            
        } else { // 검색 안하고 있을때
            
            
            switch cellStatus {
            case .fixed:
                let pin = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
                    // 업데이트후 리로드
                    self.repository.updatePin(updateObject: self.fixedMemoObjectArray[indexPath.row], isFiexd: false)
                    self.mainView.tableView.reloadData()
                }
                pin.image = UIImage(systemName: "pin.slash.fill")
                pin.backgroundColor = .systemOrange
                return UISwipeActionsConfiguration(actions: [pin])
                
                
            case .nonFixed:
                
                let pin = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
                    if self.fixedMemoObjectArray.count >= 5 {
                        self.showAlertMessage(title: "5개 최대")
                    } else {
                        // 업데이트후 리로드
                        self.repository.updatePin(updateObject: self.nonFixedMemoObjectArray[indexPath.row], isFiexd: true)
                        self.mainView.tableView.reloadData()
                    }
                }
                pin.image = UIImage(systemName: "pin.fill")
                pin.backgroundColor = .systemOrange
                return UISwipeActionsConfiguration(actions: [pin])
            }
        }
        
    }
    
    
    
    
    
    
    
    // MARK: - 트레일링(메모 삭제)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            
            let cellStatus = CellStatus.allCases[indexPath.section]
            
            if self.fixedMemoObjectArray.count <= 0 {
                self.repository.deletePost(deletedObject: self.nonFixedMemoObjectArray[indexPath.row])
                
            } else {
                switch cellStatus {
                case .fixed:
                    self.repository.deletePost(deletedObject: self.fixedMemoObjectArray[indexPath.row])
                    
                case .nonFixed:
                    self.repository.deletePost(deletedObject: self.nonFixedMemoObjectArray[indexPath.row])
                }
            }
            
            //업데이트 후 패치 -> 리로드
            self.totalMemoObjectArray = self.repository.fetch()
            self.mainView.tableView.reloadData()
            
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    
    
    
    
    

    // MARK: - 헤더 타이틀
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let cellStatus = CellStatus.allCases[section]
        
        if isFiltering {
            return "\(searchedMemoObjectArray?.count ?? 0)개의 메모가 검색되었네요"
        } else {
            switch cellStatus {
            case .fixed:
                return Header.fixedMemo.rawValue
            case .nonFixed:
                return Header.nonFixedMemo.rawValue
            }
        }
        
    }
    
    
    
    
    
    
    
    // MARK: - 헤더안에 뷰 넣어서 구성하기
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = .monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        header?.textLabel?.textColor = .label
    }
}
