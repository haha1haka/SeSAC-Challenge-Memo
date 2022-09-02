//
//  MainViewController.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit
import RealmSwift
import SwiftUI
import Network



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
enum CellStatus: Int, CaseIterable {
    case fixed
    case nonFixed
}


enum Header: String, CaseIterable {
    case fixedMemo = "고정된 메모"
    case nonFixedMemo = "메모"
}




class MainViewController: BaseViewController {
    
    let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func configure() {
        configureUITableView()
        configureUINavigationBar()
        configureUISearchController()
        configureUIToolBar()
    }
    
    let repository = MemoRepository()
    
    var totalMemoObjectArray: Results<Memo>! {
        didSet {
            fixedMemoObjectArray = repository.fetchFilter(in: totalMemoObjectArray, isFixed: true)
            nonFixedMemoObjectArray = repository.fetchFilter(in: totalMemoObjectArray, isFixed: false)
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





extension MainViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalMemoObjectArray = repository.fetch()
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
        appearance.backgroundColor = .black
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.title = "1123개 메모"
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    
    
    func configureUISearchController() {
        let searchController = UISearchController(searchResultsController: nil)
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
    
    // MARK: - Write 로 가기
    @objc func writeButtonClicked() {
        let detailViewController = DetailViewController()
        transition(detailViewController, transitionStyle: .push)
    }
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
            if fixedMemoObjectArray.count < 0 {
                return 0
            } else {
                return 1
            }
            
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
            if fixedMemoObjectArray.count < 0 {
                return nonFixedMemoObjectArray.count
            } else {
                switch cellStatus {
                case .fixed:
                    return fixedMemoObjectArray.count
                case .nonFixed:
                    return nonFixedMemoObjectArray.count
                }
            }
        }
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.className) as? MainTableViewCell else { return UITableViewCell() }
        
        let cellStatus = CellStatus.allCases[indexPath.section]
        
        if isFiltering {
            cell.mainLabel.text = searchedMemoObjectArray?[indexPath.row].title
        } else {
            if fixedMemoObjectArray.count < 0 {
                cell.mainLabel.text = nonFixedMemoObjectArray[indexPath.row].title
            } else {
                switch cellStatus {
                case .fixed:
                    cell.mainLabel.text = fixedMemoObjectArray[indexPath.row].title
                    
                case .nonFixed:
                    cell.mainLabel.text = nonFixedMemoObjectArray[indexPath.row].title
                }
            }
        }
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
        
        
        let pin = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            if self.fixedMemoObjectArray.count >= 5 && self.totalMemoObjectArray[indexPath.row].isFixed == false {
                self.showAlertMessage(title: "메모 5개 초과")
            }
            
            if self.fixedMemoObjectArray.count == 0 {
                self.repository.updatePin(updateObject: self.nonFixedMemoObjectArray[indexPath.row], isFiexd: true)
            } else {
                switch cellStatus {
                case .fixed:
                    self.repository.updatePin(updateObject: self.fixedMemoObjectArray[indexPath.row], isFiexd: false)
                case .nonFixed:
                    self.repository.updatePin(updateObject: self.nonFixedMemoObjectArray[indexPath.row], isFiexd: true)
                }
            }
            //업데이트 후 패치 -> 리로드
            self.totalMemoObjectArray = self.repository.fetch()
            self.mainView.tableView.reloadData()
        }
        
        
        
        
        
        
        
        if fixedMemoObjectArray.count == 0 {
            pin.image = UIImage(systemName: "pin.fill")
        } else {
            switch cellStatus {
            case .fixed:
                pin.image = UIImage(systemName: "pin.slash.fill")
            case .nonFixed:
                pin.image = UIImage(systemName: "pin.fill")
            }
        }
        

        
        
        pin.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [pin])
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 헤더
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let cellStatus = CellStatus.allCases[section]
        
        switch cellStatus {
        case .fixed:
            return Header.fixedMemo.rawValue
        case .nonFixed:
            return Header.nonFixedMemo.rawValue
        }
        
    }
    
    // MARK: - 해더뷰
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = .monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        header?.textLabel?.textColor = .white
    }
    
    
}


