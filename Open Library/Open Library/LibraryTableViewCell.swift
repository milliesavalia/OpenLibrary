import UIKit

class LibraryTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    private lazy var publishYearLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        authorLabel.text = ""
        publishYearLabel.text = ""
    }
    
    public func setup(with book: Book) {
        titleLabel.text = "\(book.title)"
        authorLabel.text = formatAuthors(authors: book.author)
        if let publishYear = book.publishYear {
            publishYearLabel.text = "Published: \(publishYear)"
        }
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(publishYearLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            publishYearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            publishYearLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            publishYearLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            publishYearLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func formatAuthors(authors: [String]?) -> String {
        var result = "By: "
        guard let authors = authors,
              !authors.isEmpty else { return "" }
        result.append(authors[0])
        if authors.count > 1 {
            for i in 1...authors.count-1 {
                result.append(", \(authors[i])")
            }
        }
        return result
    }
}
