//
//  SearchService.swift
//  RickAndMorty
//
//  Created by Mikhail on 26.07.2022.
//

import Foundation
import Alamofire

class SearchService {
    static let shared = SearchService()
    
    func getFriendsInfo(url: String, success: @escaping ((_ items: [RaMCharacter]?, _ info: Info) -> Void), failure: @escaping ((_ error: NSError) -> Void)) {
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseDecodable(of: CharacterInfoResult.self) { [weak self] data in
                
                switch data.result {
                    case .success(_):
                        guard let character = data.value else {return}
                        success(character.results, character.info)
                    case .failure(let error):
                        failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription]))
                }
                
            }
    }
}
