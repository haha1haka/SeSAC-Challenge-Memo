//
//  MainViewController.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit
import RealmSwift

enum CellStatus: Int, CaseIterable {
    case fixed
    case nonFixed
}

enum Header: String, CaseIterable {
    //    case searchingMemo = "찾으시는 메모"
    case fixedMemo = "고정된 메모"
    case nonFixedMemo = "메모"
}

class MainViewController: BaseViewController {
    
    let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func configure() {
        print("🟩파일위치 -> \(String(describing: repository.localRealm.configuration.fileURL))")
        configureUITableView()
        configureUISearchController()
        configureUIToolBar()
        checkIntroScene()
    }
    
    let repository = MemoRepository()
    
    var totalMemoObjectArray: Results<Memo>! {
        didSet {
            configureTitle(totalMemoObjectArray.count)
            fixedMemoObjectArray = repository.fetchFilter(in: totalMemoObjectArray, isFixed: true)
            nonFixedMemoObjectArray = repository.fetchFilter(in: totalMemoObjectArray, isFixed: false)
            print("현재 object 갯수👉🏻 \(repository.localRealm.objects(Memo.self))")
        }
    }
    
    var fixedMemoObjectArray: Results<Memo>!
    var nonFixedMemoObjectArray: Results<Memo>!
    var searchedMemoObjectArray: Results<Memo>?
    
    
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
        totalMemoObjectArray = repository.fetch()
        mainView.tableView.reloadData()

        //왔다 갔다 하면 라지 타이틀 살아져서 걍 여기다 둠 생각해보기
        configureUINavigationBar()

        self.navigationController?.navigationBar.shadowImage = nil
        
        

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
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = COLOR_BRANDI_PRIMARY
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance

    }
    
    
    func configureUISearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
//        searchController.searchBar.tintColor = .clear
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
        //        if !UserDefaults.standard.bool(forKey: "isIntro") {
        //            UserDefaults.standard.set(true, forKey: "isIntro")
        //
        //        }
        
        //⭐️이거 위에 심어주기 마지막 제출 전에 하기
        let vc = IntroViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        transition(vc, transitionStyle: .present)
    }
    
    
    func configureTitle(_ memoCount: Int) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.navigationItem.title = "\(numberFormatter.string(from: memoCount as NSNumber) ?? "1")개의 메모"
    }
    
    
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
    
    //    func cellColorSeparator(cell: UITableViewCell) {
    //        cell.
    //    }
}









// MARK: - UISearchBarController
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.searchedMemoObjectArray = repository.fetchFilterSearchedText(in: totalMemoObjectArray, text: text)
        
        //글자마다 리로드
        self.mainView.tableView.reloadData()
    }
}












// MARK: - tableView Methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        } else {
            return Header.allCases.count
        }
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let cellStatus = CellStatus.allCases[section]
        
        //⭐️여기 생각 다시해보기
        if isFiltering {
            return searchedMemoObjectArray?.count ?? 0
        } else {
//            if fixedMemoObjectArray.count <= 0 {
//                return nonFixedMemoObjectArray.count
//            } else {
                switch cellStatus {
                case .fixed:
                    return fixedMemoObjectArray.count
                case .nonFixed:
                    return nonFixedMemoObjectArray.count
                }
            }
//        }
    }
    
    
    //    func parsingText() {
    //        searchedColor
    //        if
    //    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.className) as? MainTableViewCell else { return UITableViewCell() }
        
        let cellStatus = CellStatus.allCases[indexPath.section]
        
        if isFiltering {
            cell.mainLabel.text = searchedMemoObjectArray?[indexPath.row].title
            cell.dateLabel.text = dateSeparator(registeredDate: searchedMemoObjectArray?[indexPath.row].date ?? Date())
            cell.contentLabel.text = "  \(searchedMemoObjectArray?[indexPath.row].content ?? "")"
            
            
        } else {
//            if fixedMemoObjectArray.count == 0 {
//                cell.mainLabel.text = nonFixedMemoObjectArray[indexPath.row].title
//                cell.dateLabel.text = dateSeparator(registeredDate: nonFixedMemoObjectArray?[indexPath.row].date ?? Date())
//                cell.contentLabel.text = nonFixedMemoObjectArray[indexPath.row].content
//            } else {
                switch cellStatus {
                case .fixed:
                    cell.mainLabel.text = fixedMemoObjectArray[indexPath.row].title
                    cell.dateLabel.text = dateSeparator(registeredDate: fixedMemoObjectArray[indexPath.row].date)
                    cell.contentLabel.text = "  \(fixedMemoObjectArray[indexPath.row].content)"
                case .nonFixed:
                    cell.mainLabel.text = nonFixedMemoObjectArray[indexPath.row].title
                    cell.dateLabel.text = dateSeparator(registeredDate: nonFixedMemoObjectArray?[indexPath.row].date ?? Date())
                    cell.contentLabel.text = "  \(nonFixedMemoObjectArray[indexPath.row].content)"
                    
                }
            }
//        }
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Detail 로 가기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        let cellStatus = CellStatus.allCases[indexPath.section]
        
        if isFiltering {
            vc.memoObject = searchedMemoObjectArray?[indexPath.row]
        } else {
            if fixedMemoObjectArray.count == 0 {
                vc.memoObject = nonFixedMemoObjectArray[indexPath.row]
            } else {
                switch cellStatus {
                case .fixed:
                    vc.memoObject = fixedMemoObjectArray[indexPath.row]
                case .nonFixed:
                    vc.memoObject = nonFixedMemoObjectArray[indexPath.row]
                }
            }
        }
        transition(vc,transitionStyle: .push)
    }
    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cellStatus = CellStatus.allCases[indexPath.section]
        
        if isFiltering {
            if searchedMemoObjectArray?[indexPath.row].isFixed == true {
                
                let pin = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
                    
                    //⭐️ 강제해제 다시보기
                    self.repository.updatePin(updateObject: (self.searchedMemoObjectArray?[indexPath.row])!, isFiexd: false)
                    //♻️
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
                        self.repository.updatePin(updateObject: (self.searchedMemoObjectArray?[indexPath.row])!, isFiexd: true)
                        //♻️
                        self.mainView.tableView.reloadData()
                    }
                }
                pin.image = UIImage(systemName: "pin.fill")
                pin.backgroundColor = .systemOrange
                return UISwipeActionsConfiguration(actions: [pin])
            }
            
            
            
            
            
        } else {
            switch cellStatus {
                
                
                
            case .fixed:
                
                let pin = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
                    self.repository.updatePin(updateObject: self.fixedMemoObjectArray[indexPath.row], isFiexd: false)
                    //♻️
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
                        self.repository.updatePin(updateObject: self.nonFixedMemoObjectArray[indexPath.row], isFiexd: true)
                        //♻️
                        self.mainView.tableView.reloadData()
                    }
                    
                }
                
                
                
                pin.image = UIImage(systemName: "pin.fill")
                pin.backgroundColor = .systemOrange
                return UISwipeActionsConfiguration(actions: [pin])
            }
        }

}









//        let cellStatus = CellStatus.allCases[indexPath.section]
//
//        let pin = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
//
//            //            var currentMemo = Memo()
//
//
//            if self.fixedMemoObjectArray.count > 5 {
//                if self.totalMemoObjectArray[indexPath.row].isFixed == true {
//                    self.showAlertMessage(title: "메모 5개 초과")
//                    //                    return
//                }
//
//
//            }
//
//
//            if self.fixedMemoObjectArray.count <= 0 {
//                self.repository.updatePin(updateObject: self.nonFixedMemoObjectArray[indexPath.row], isFiexd: true)
//
//            } else {
//                switch cellStatus {
//                case .fixed:
//                    self.repository.updatePin(updateObject: self.fixedMemoObjectArray[indexPath.row], isFiexd: false)
//
//                case .nonFixed:
//                    self.repository.updatePin(updateObject: self.nonFixedMemoObjectArray[indexPath.row], isFiexd: true)
//                }
//            }
//
//
//
//
//
//
//
//            //업데이트 후 패치 -> 리로드
//            self.totalMemoObjectArray = self.repository.fetch()
//            self.mainView.tableView.reloadData()
//        }
//
//
//
//
//
//
//
//        if fixedMemoObjectArray.count == 0 {
//            pin.image = UIImage(systemName: "pin.fill")
//        } else {
//            switch cellStatus {
//            case .fixed:
//                pin.image = UIImage(systemName: "pin.slash.fill")
//            case .nonFixed:
//                pin.image = UIImage(systemName: "pin.fill")
//            }
//        }
//
//
//
//
//        pin.backgroundColor = .systemOrange
//
//        return UISwipeActionsConfiguration(actions: [pin])

//    }













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












// MARK: - 헤더
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

// MARK: - 해더뷰
func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as? UITableViewHeaderFooterView
    header?.textLabel?.font = .monospacedDigitSystemFont(ofSize: 20, weight: .bold)
    header?.textLabel?.textColor = .label
}


}






//print("현재 object 갯수👉🏻 \(repository.localRealm.objects(Memo.self))")
//print("🟩파일위치 -> \(String(describing: repository.localRealm.configuration.fileURL))")

//switch section {
//case 0:
//    return fixedMemoObjectArray.count
//case 1:
//    return nonFixedMemoObjectArray?.count ?? 0
//default:
//    return 0
//}


//if !(totalMemoObjectArray?[indexPath.row].isFixed ?? true) {
//    //true
//    cell.mainLabel.text = fixedMemoObjectArray[indexPath.row].title
//    cell.dateLabel.text = fixedMemoObjectArray[indexPath.row].content
//    return cell
//} else {
//    //false
//    cell.mainLabel.text = nonFixedMemoObjectArray?[indexPath.row].title
//    cell.dateLabel.text = nonFixedMemoObjectArray?[indexPath.row].content
//    return cell
//    //
//    //        }
//
//
//
//
//    //        switch indexPath.section {
//    //        case 0:
//    //            cell.mainLabel.text = fixedMemoObjectArray[indexPath.row].title
//    //            cell.dateLabel.text = fixedMemoObjectArray[indexPath.row].content
//    //        case 1:
//    //            cell.mainLabel.text = nonFixedMemoObjectArray?[indexPath.row].title
//    //            cell.dateLabel.text = nonFixedMemoObjectArray?[indexPath.row].content
//    //        default:
//    //            break
//    //        }
//    //
//
//}



//        switch indexPath.section {
//        case 0:
//            let fixedObject = fixedMemoObjectArray[indexPath.row]
//            vc.memoObject = fixedObject
//            vc.detailView.textView.text = fixedObject.content
//
//        case 1:
//            let nonFixedbject = nonFixedMemoObjectArray?[indexPath.row]
//            vc.memoObject = nonFixedbject
//            vc.detailView.textView.text = nonFixedbject?.content
//        default:
//            break
//        }
//
//        transition(vc,transitionStyle: .push)

//// ⭐️  하 열거형으로 해보기
///enum WriteDate {
//case today(date: Date)
//case thisWeek(date: Date)
//case etc(date: Date)
//}

//extension WriteDate {
//
//    //    var formatter: DateFormatter {
//    //        let formatter = DateFormatter()
//    //        formatter.locale = Locale(identifier: "ko_KR")
//    //        return formatter
//    //    }
//
//    //    var realDate
//
//
//    var formatter: String {
//        switch self {
//        case .today(let date):
//            let formatter = DateFormatter()
//            formatter.dateFormat = "a hh:mm"
//            return formatter.string(from: date)
//        case .thisWeek(let date):
//            let formatter = DateFormatter()
//            formatter.dateFormat = "EEEE"
//            return formatter.string(from: date)
//        case .etc(let date):
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy.MM.dd a HH:mm"
//            return formatter.string(from: date)
//        }
//    }
//}

