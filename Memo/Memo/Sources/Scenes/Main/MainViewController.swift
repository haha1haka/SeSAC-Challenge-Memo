//
//  MainViewController.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit

enum Header: String {
    case finnedMemo = "고정된 메모"
    case memo = "메모"
}

class MainViewController: BaseViewController {
    
    
    
    
    
    let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func configure() {
        configureSearchController()
        
        configureNavigationBar()
        configureTableView()
        configureToolBar()
        
    }
    
    var tasks: [String] = [] {
        didSet {
            mainView.tableView.reloadData()
        }
    }
}






extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        print("\(tasks)")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        searchController.isActive = false
        //        searchController.searchBar.becomeFirstResponder()
        
        
        
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
    
    
    
    
    
    
    func configureNavigationBarButtonItem() {
        
        
    }
    func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        
        //searchController.searchBar.delegate = self
        //searchController.searchResultsUpdater = self
        //        searchController.hidesNavigationBarDuringPresentation = false
        //searchController.searchBar.scopeButtonTitles = [SearchBarScope.first.result,SearchBarScope.second.result,SearchBarScope.third.result]
//        searchController.hidesNavigationBarDuringPresentation = true
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
        let writeViewController = WriteViewController()
        writeViewController.writeView.textView.becomeFirstResponder()
        writeViewController.delegate = self
        transition(writeViewController, transitionStyle: .push)
    }
    
    
}







extension MainViewController: WriteTextDelegate {
    func sentText(_ text: String) {
        tasks.append(text)
    }
    
}





// MARK: - SearchBar Methods
//extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text?.lowercased() else {return}
//
//        filterList = diaryTitleList?.filter({
//            $0.lowercased().contains(text)
//        })
//
//        tableView.reloadData()
//    }
//
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        switch selectedScope {
//        case SearchBarScope.first.rawValue: searchBar.text = SearchBarScope.first.result
//        case SearchBarScope.second.rawValue: searchBar.text = SearchBarScope.second.result
//        case SearchBarScope.third.rawValue: searchBar.text = SearchBarScope.third.result
//        default: searchBar.text = ""
//        }
//    }
//}

















// MARK: - tableView Methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return tasks.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.className) as? MainTableViewCell else { return UITableViewCell() }
        
        //        cell.textLabel?.text =
        //        cell.backgroundColor = .brown
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "안녕하세요"
        } else {
            cell.textLabel?.text = tasks[indexPath.row]
        }
        
        
        return cell
    }
    // MARK: - Detail 로 가기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
//        vc.navigationController?.navigationBar.prefersLargeTitles = false
        vc.detailView.textView.text = tasks[indexPath.row]
        transition(vc,transitionStyle: .push)
    }
    
    
    
    
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //
    //        switch editingStyle {
    //        case .delete:
    ////            try! localRealm.write {
    ////                localRealm.delete(objectArray[indexPath.row])
    ////                objectArray = fetchRealm()
    ////            }
    //        default: break
    //        }
    //    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pin = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            
        }
        
        pin.image = UIImage(systemName: "pin.fill")
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


