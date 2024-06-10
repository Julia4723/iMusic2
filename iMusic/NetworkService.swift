//
//  NetworkService.swift
//  iMusic
//
//  Created by user on 09.06.2024.
//

import UIKit
import Alamofire

class NetworkService {
    
    func fetchTracks(searchText: String, completion: @escaping (SearchResponse?) -> Void) {
        ///для того чтобы получать данные из интернета по запросу реализуем completion
        
        //адрес по которому будем запрашивать данные через поле поиска
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": "\(searchText)",
                          "limit": "10",
                          "media": "music"]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { (dataResponse) in
            if let error = dataResponse.error {
                print("Error received: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            //декодируем данные
            let decoder = JSONDecoder()
            
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                print("objects: ", objects)
                completion(objects)
                
                
            } catch let JSONError {
                print("Failed to decode JSON", JSONError)
                completion(nil)
            }
            
//            let someString = String(data: data, encoding: .utf8)
//            print(someString ?? "")
        }
    }
}
