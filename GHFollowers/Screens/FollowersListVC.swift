//
//  FollowersListVC.swift
//  GHFollowers
//
//  Created by Umut Barış Çoşkun on 14.11.2022.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}



class FollowersListVC: UIViewController {
    
    enum Section {case main}
    var userName: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var page = 1
    var hasMoreFollowers = true
    var isSearching     = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
        
        getFollowers(username: userName, page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self , action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem  = addButton
    }
    
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        
    }
    
    func configureSearchController(){
        let searchController     = UISearchController()
        searchController.searchResultsUpdater  = self
        searchController.searchBar.delegate   = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController           = searchController
        //searchController.obscuresBackgroundDuringPresentation  = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
  
    
    func getFollowers(username: String, page: Int){
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else {return}
            self.dismissloadingView()
            switch result {
            case .success(let followers):
                if followers.count < 100 {self.hasMoreFollowers = false}
                self.followers.append(contentsOf: followers)
             
                if self.followers.isEmpty{
                    let message = "This is user doesnt have any followers. Go follow them 🙂"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                    
                    
                }
                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            
            cell.set(follower: follower)
            return cell
        })
        
    }
    
    func updateData(on followers:[Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot,animatingDifferences: true)
        }
    }
    
    @objc func addButtonTapped(){
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
            guard let self = self else {return}
            self.dismissloadingView()
            
            switch result {
            case.success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) {[weak self] error in
                    guard let self = self else {return}
                    
                    guard let error = error else{
                        self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully favorited this user 🎉", buttonTitle: "Hooray!")
                        return
                    }
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
                }
            case.failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }

}

extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY   = scrollView.contentOffset.y
        let contentHeight  = scrollView.contentSize.height
        let height      = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else {return}
            page += 1
            getFollowers(username: userName, page: page)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension FollowersListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {return}
        isSearching = true
        filteredFollowers  = followers.filter {
            $0.login.lowercased().contains(filter.lowercased())
        }
        updateData(on: filteredFollowers)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
}

extension FollowersListVC: FollowerListVCDelegate {
    func didRequestFollowers(for username: String) {
        self.userName = username
        title       = username
        page        = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        
      //   collectionView.setContentOffset(.zero, animated: true)  -> failed
    //     collectionView.scrollsToTop = true  -> alternative
         collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
         if isSearching {
         navigationItem.searchController?.searchBar.text = ""
         navigationItem.searchController?.isActive = false
         navigationItem.searchController?.dismiss(animated: false)
         isSearching = false
         }
        
        getFollowers(username: username, page: page)
        
      
    }
    
    
}
