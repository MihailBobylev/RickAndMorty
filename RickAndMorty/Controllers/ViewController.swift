//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Mikhail on 26.07.2022.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var searchResultTableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchedCharacters = [RaMCharacter]()
    private var pageInfo = Info()
    private let baseURL = "https://rickandmortyapi.com/api/character/?"
    private let searchParam = "name="
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var searchMode = SearchMode.unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
    }

    func setupElements() {
        title = "Search character"
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: "CharacterInfoCell")
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search character"
        navigationItem.searchController = searchController
    }
    
   @IBAction func searchCharacterByName(url: String) {
        SearchService.shared.getFriendsInfo(url: url) { [weak self] items, info in
            guard let _items = items else {return}
            self?.pageInfo = info
            self?.searchedCharacters += _items
            self?.searchResultTableView.reloadData()
        } failure: { [weak self] error in
            self?.clearCharactersStorages()
            self?.searchResultTableView.reloadData()
            print(error.localizedDescription)
        }
    }
    
    func makeDelayAndRequest() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(nameSearch), object: nil)
        perform(#selector(nameSearch), with: nil, afterDelay: 0.5)
    }
    
    @IBAction func nameSearch() {
        if !searchBarIsEmpty {
            switch searchMode {
            case .nextPage:
                if let _nextPage = pageInfo.next {
                    searchCharacterByName(url: _nextPage)
                }
            case .newSearch:
                guard let _name = searchController.searchBar.text?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else { return }
                clearCharactersStorages()
                searchCharacterByName(url: baseURL + searchParam + _name)
            case .unknown:
                return
            }
        } else {
            clearCharactersStorages()
            searchResultTableView.reloadData()
        }
    }
    
    func clearCharactersStorages() {
        searchedCharacters.removeAll()
        pageInfo.next = nil
    }
}


extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchMode = .newSearch
        SDWebImageManager.shared.imageCache.clear(with: .all)
        makeDelayAndRequest()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterInfoCell", for: indexPath) as? CharacterTableViewCell {
            let item = searchedCharacters[indexPath.row]
            cell.refresh(characterRaM: item)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = searchedCharacters.count - 1

        if indexPath.row == lastElement && pageInfo.next != nil {
            searchMode = .nextPage
            nameSearch()
        }
    }
}
