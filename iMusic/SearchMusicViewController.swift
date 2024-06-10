//
//  SearchViewController.swift
//  iMusic
//
//  Created by user on 08.06.2024.
//

import UIKit
import Alamofire

struct TrackModel {
    var trackName: String
    var artistName: String
}

class SearchMusicViewController: UITableViewController {
    ///Шаг 9 Создаем объект класса NetworkService
    var networkServiсe = NetworkService()
    
    ///Шаг 8 создаем таймер для того чтобы дожидаться пока пользователь впишет данные в строку поиска и через установленнное время делать запрос
    private var timer: Timer?
    
    ///Шаг 4 создаем строку поиска
    let searchController = UISearchController(searchResultsController: nil)
    
    ///массив, который хранит все треки
    var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        view.backgroundColor = .white
        
        ///Шаг 3 регистрируем ячейки
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    ///Шаг 5 создаем функцию для строки поиска
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false//строка поиска не будет скрываться
        
        ///Шаг 7 подписываем класс под делегата
        searchController.searchBar.delegate = self
    }
    
    ///вызываем классические методы для реализации таблицы
    ///Шаг 1 задаем количество  ячеек
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count    }
    
    ///Шаг 2 задаем идентификатор для ячеек
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = "(\(String(describing: track.trackName))\n\(track.artistName))"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = #imageLiteral(resourceName: "2")
        return cell
    }
}


extension SearchMusicViewController: UISearchBarDelegate {
    ///Шаг 6
    //метод, который будет срабатывать когда будет вводиться какой-то символ в строку поиска. Реализуем его через делегата
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        ///Шаг 9 Всю реализацию декодирования делаем в таймере
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            ///Шаг 10 Вызываем networkServiсe и его внутреннюю функцию searchText. Пишем [weak self] чтобы не было утечки памяти
            self.networkServiсe.fetchTracks(searchText: searchText) { [weak self] (searchResults) in
                self?.tracks = searchResults?.results ?? []
                self?.tableView.reloadData()
                
                
            }
        })  
        
    }
    
}
