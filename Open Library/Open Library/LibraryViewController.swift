import UIKit

class LibraryViewController: UIViewController {
    var bookResults: [Book] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
        
    let searchService: SearchServiceProtocol = SearchService()
    
    private lazy var searchBar: UISearchController = {
        let view = UISearchController()
        view.searchBar.searchBarStyle = .prominent
        view.searchBar.placeholder = NSLocalizedString("Search...", comment: "placeholder")
        view.searchBar.sizeToFit()
        view.searchBar.isTranslucent = false
        view.searchBar.delegate = self
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.separatorStyle = .singleLine
        view.register(LibraryTableViewCell.self, forCellReuseIdentifier: "LibraryTableViewCell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.searchController = searchBar
        navigationItem.title = NSLocalizedString("Book Search", comment: "title")
        setup()
    }

    private func setup() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension LibraryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.bookResults = []
            return
        }
        Task.init {
            do {
                let search = try await searchService.requestSearch(input: searchText)
                self.bookResults = search.books
            } catch {
                print(error)
            }
        }
    }
}

extension LibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryTableViewCell", for: indexPath) as! LibraryTableViewCell
        if let book = bookResults.at(indexPath.row) {
            cell.setup(with: book)
        }
        cell.selectionStyle = .none
        return cell
    }
}

public extension Array {
    func at(_ index: Int) -> Element? {
        guard index < count && index >= 0 else { return nil }
        return self[index]
    }
}
