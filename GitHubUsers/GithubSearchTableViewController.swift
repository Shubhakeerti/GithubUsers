//
//  GithubSearchTableViewController.swift
//  GitHubUsers
//
//  Created by Shubhakeerti on 17/04/18.
//  Copyright © 2018 Shubhakeerti. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class GithubSearchTableViewController: UITableViewController {
    var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
    
    lazy var activityIndicator: NVActivityIndicatorView = {
        return NVActivityIndicatorView(frame: CGRect(x: (self.view.frame.width/2) - 30, y: (self.view.frame.height / 2) - 30, width: 60, height: 60), type: .ballSpinFadeLoader, color: UIColor.black , padding: 0)
    }()
    
    let requestManager: HTTPRequestManager = HTTPRequestManager()

    var searchOperation: DataRequest? = nil {
        willSet {
            if let searchOp = self.searchOperation { //there was a non-nil search operation, so cancel the old search
                if !searchOp.progress.isFinished {
                    searchOp.cancel()
                }
            }
        }
    }
    var githubuser = [UserStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityIndicator)
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = NSLocalizedString("Github Users", comment: "")
        self.tableView.contentInset = UIEdgeInsets.zero
        self.searchBar.isHidden = false
    }
    
    func setupTable() {
        self.tableView.register(UINib(nibName: "UserCell", bundle: Bundle.main), forCellReuseIdentifier: "UserCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 92
        tableView.tableHeaderView = searchBar
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        searchBar.placeholder = NSLocalizedString("Search by UserName", comment: "")
        tableView.backgroundView = UIView()
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func retryAction() {
        self.searchBar.isHidden = false
        self.searchBar.becomeFirstResponder()
        self.searchBar(searchBar, textDidChange: searchBar.text ?? "")
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.githubuser.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        if let user: UserStruct = datasouce(indexPath) {
            cell.configureCell(user)
        }
        return cell
    }
}

extension GithubSearchTableViewController:UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count <= 2) {
            footerHeight = -1
        }
        self.searchOperation = searchOp(searchText)
        
        if self.searchOperation != nil {
            activityIndicator.startAnimating()
        } else {
            endOperation()
        }
        
        self.searchOperation?.responseData(completionHandler: {[weak self] (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                self?.endOperation(json["items"])
            case .failure(_):
                print(response.error.debugDescription)
                if response.request == self?.searchOperation?.request {
                    self?.endOperation()
                }
            }
        })
    }
    
    func endOperation(_ json: JSON? = nil) {
        self.populateData(json)
        self.tableView.reloadData()
        searchOperation?.cancel()
        activityIndicator.stopAnimating()
    }
    
    func searchOp(_ searchText: String) -> DataRequest? {
        if searchText.count < 3 {
            return nil
        }
        let dataRequest = requestManager.getUserRequest("https://api.github.com/search/users?sort=followers&q=" + searchText)
        return dataRequest
    }
    
    func populateData(_ json: JSON?) {
        if json == nil {
            //Api failed or text is less than 3
            //Api failed:
            if let searchBarText: String = self.searchBar.text, searchBarText.count > 2 {
                self.searchBar.isHidden = true
                self.searchBar.resignFirstResponder()
            } else {             //less than 3
                self.githubuser = []
                self.searchBar.isHidden = false
            }
            return
        }
        self.footerHeight = 49
        if let userArray = json?.array, userArray.count > 0 {
            self.githubuser.removeAll()
            for user in userArray {
                self.githubuser.append(UserStruct(json: user))
            }
        }
    }
    
    func datasouce(_ indexPath: IndexPath) -> UserStruct? {
        guard indexPath.row >= 0 && indexPath.row < self.githubuser.count else {
            return nil
        }
        return self.githubuser[indexPath.row]
    }
}

