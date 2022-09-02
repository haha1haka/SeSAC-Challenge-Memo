//
//  MainViewController.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit
import RealmSwift
import SwiftUI



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



enum Header: String, CaseIterable {
    case finnedMemo = "고정된 메모"
    case memo = "메모"
}




class MainViewController: BaseViewController {
    
    let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func configure() {
        configureToolBar()
        configureTableView()
        configureNavigationBar()
        configureSearchController()
    }
    
    
    let repository = MemoRepository()
    
    var totalMemoObjectArray: Results<Memo>!
    
    var fixedMemoObjectArray: Results<Memo>!
    
    var nonFixedMemoObjectArray: Results<Memo>!
    
    
    
    
}





extension MainViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        fixedMemoObjectArray = repository.fetchFilterFixed()
//        nonFixedMemoObjectArray = repository.fetchFilterNonFixed()
    }
}






// MARK: - configure Methods
extension MainViewController {
    
    func configureTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.className)
    }
    
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.title = "1123개 메모"
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    
    
    func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    
    func configureToolBar() {
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



















// MARK: - tableView Methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Header.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.className) as? MainTableViewCell else { return UITableViewCell() }
        
        
        
        

        
        
    }
    
    
    // MARK: - Detail 로 가기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = DetailViewController()
//        
//        
//        switch indexPath.section {
//        case 0:
//            vc.memoObject = fixedMemoObjectArray[indexPath.row]
//        case 1:
//            vc.memoObject = nonFixedMemoObjectArray?[indexPath.row]
//        default:
//            break
//        }
//        
//        transition(vc,transitionStyle: .push)
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        switch indexPath.section {
        case 0:
            let slashPin = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
                self.repository.updatePin(updateObject: self.fixedMemoObjectArray[indexPath.row], isFiexd: false)
            }
            
            
            
            
            tableView.reloadData()
            
            slashPin.image = UIImage(systemName: "pin.slash.fill")
            slashPin.backgroundColor = .systemOrange
            
            return UISwipeActionsConfiguration(actions: [slashPin])
            
            
        case 1:
            let pin = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
                guard let unWrapedNewNonFixedObjectArray = self.nonFixedMemoObjectArray else { return }
                self.repository.updatePin(updateObject: unWrapedNewNonFixedObjectArray[indexPath.row], isFiexd: true)
            }
            
            
            
            pin.image = UIImage(systemName: "pin.fill")
            pin.backgroundColor = .systemOrange
            
            return UISwipeActionsConfiguration(actions: [pin])
            
            
        default:
            break
        }
        
        
        
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        switch section {
        case 0:
            return Header.finnedMemo.rawValue
        case 1:
            return Header.memo.rawValue
        default:
            return ""
        }
        
        
        
    }
    
    
    
    
    // MARK: - 해더뷰
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = .monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        header?.textLabel?.textColor = .white
    }
    
    
}


