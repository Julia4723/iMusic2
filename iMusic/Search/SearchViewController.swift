//
//  SearchViewController.swift
//  iMusic
//
//  Created by user on 10.06.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {

  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic)?
    
    
    @IBOutlet weak var table: UITableView!
    
    
    ///Шаг 4 создаем строку поиска
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Private Methods
    private var searchViewModel = SearchViewModel(cells: [])
    private var timer: Timer?
    
    // MARK: - Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SearchInteractor()
    let presenter             = SearchPresenter()
    let router                = SearchRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
      setup()
      setupSearchBar()
      setupTableView()
  }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false//строка поиска не будет скрываться
        
        searchController.obscuresBackgroundDuringPresentation = false//экран не будет затемняться при вводе в поле поиска
        
        ///Шаг 7 подписываем класс под делегата
        searchController.searchBar.delegate = self
    }
    
    private func setupTableView() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: TrackCell.reuseID)
    }
  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
      
      switch viewModel {
      case .some:
          print("viewController . some")
      case .displayTracks(let searchViewModel):
          print("viewController . displayTracks")
          self.searchViewModel = searchViewModel
          table.reloadData()
      }

  }
  
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reuseID, for: indexPath) as! TrackCell
        
        
        let cellViewModel = searchViewModel.cells[indexPath.row]
        cell.trackImageView.backgroundColor = .red
        cell.set(viewModel: cellViewModel)
        
//        cell.textLabel?.text = "\(cellViewModel.trackName) \n \(cellViewModel.artistName)"
//        cell.textLabel?.numberOfLines = 2
//        cell.imageView?.image = #imageLiteral(resourceName: "2")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchTerm: searchText))
        })
        
    }
}
