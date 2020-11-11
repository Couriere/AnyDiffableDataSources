// MIT License
//
// Copyright (c) 2020-present Vladimir Kazantsev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import ReactiveSwift
import ReactiveCocoa
import AnyDiffableDataSources
import ReactiveAnyDiffableDataSources


class TableViewController: KeyboardAwareViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = "Posts"

		tableView.tableHeaderView = searchController.searchBar
		tableView.tableFooterView = UIView()
		tableView.register( SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "SectionHeaderView" )
		searchController.dimsBackgroundDuringPresentation = false

		dataSource = AnyTableViewDiffableDataSource( tableView: tableView ) {
			tableView, indexPath, post in

			let cell = tableView.dequeueReusableCell( withIdentifier: "PostTableCell", for: indexPath ) as! PostTableCell
			cell.title = post.post.title
			cell.subtitle = post.post.body
			cell.isExpanded = post.isExpanded

			return cell
		}
		dataSource.defaultRowAnimation = .fade


		// Загружаем посты и обновляем список постов на экране в зависимости от строки поиска.
		dataSource.sectionsAndItems() <~ loadPosts()
			.map { $0.sorted { $0.post.title < $1.post.title }}
			.combineLatest( with: searchQueryProducer() )
			// Showing rows only after view did appear on screen.
			.combineLatest( with: reactive.viewDidAppear ).map { $0.0 }
			.map( filterItems )
			.map { Dictionary( grouping: $0, by: { String( $0.post.title.first?.uppercased() ?? " " ) }) }
			.map { $0.map { ($0, $1) }.sorted { $0.0 < $1.0 } }
	}

	private func loadPosts() -> SignalProducer<[_Post], Never> {
		return URLSession(configuration: .default).reactive
			.data( with: URLRequest( url: URL( string: "https://jsonplaceholder.typicode.com/posts" )! ))
			.attemptMap { data, _ in try JSONDecoder().decode( [Post].self, from: data ) }
			.map { $0.map( _Post.init ) }
			.flatMapError { _ in SignalProducer( value: [] ) }
	}
	
	private func searchQueryProducer() -> SignalProducer<String?, Never> {
		return searchController.searchBar.reactive.continuousTextValues
			.merge( with: searchController.searchBar.reactive.cancelButtonClicked.map { "" } )
			.producer
			.prefix( value: "" )
	}
	
	private func filterItems( _ items: [ _Post ], with searchQuery: String? ) -> [ _Post ] {
		
		guard let searchQuery = searchQuery, !searchQuery.isEmpty else { return items }
		
		let options: String.CompareOptions = [ .caseInsensitive, .diacriticInsensitive ]
		return items
			.filter( {
				$0.post.title.range( of: searchQuery, options: options ) != nil ||
					$0.post.body.range( of: searchQuery, options: options ) != nil
			})
	}


	@IBOutlet private var tableView: UITableView!
	private let searchController = UISearchController( searchResultsController: nil )
	private var dataSource: AnyTableViewDiffableDataSource<String, _Post>!
	
	private struct _Post: Hashable {
		let post: Post
		var isExpanded: Bool
		
		init( post: Post ) {
			self.post = post
			self.isExpanded = false
		}
	}
}

extension TableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow( at: indexPath, animated: true )
		dataSource.replaceItem( at: indexPath ) { $0.isExpanded.toggle() }
	}

	func tableView( _ tableView: UITableView, viewForHeaderInSection section: Int ) -> UIView? {
		let headerView = tableView
			.dequeueReusableHeaderFooterView( withIdentifier: "SectionHeaderView" ) as! SectionHeaderView
		headerView.title = dataSource.snapshot().sectionIdentifiers[ section ]

		return headerView
	}
}

class PostTableCell: UITableViewCell {
	var title: String {
		get { titleLabel.text ?? "" }
		set { titleLabel.text = newValue }
	}

	var subtitle: String {
		get { subtitleLabel.text ?? "" }
		set { subtitleLabel.text = newValue }
	}
	
	var isExpanded: Bool {
		get { !subtitleLabel.isHidden }
		set {
			subtitleLabel.isHidden = !newValue
			arrowImageView.transform = CGAffineTransform( rotationAngle: newValue ? .pi : 0 )
		}
	}

	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var subtitleLabel: UILabel!
	@IBOutlet private var arrowImageView: UIImageView!
}

class SectionHeaderView: UITableViewHeaderFooterView {

	var title: String {
		get { titleLabel.text ?? "" }
		set { titleLabel.text = newValue }
	}

	override init( reuseIdentifier: String? ) {
		super.init( reuseIdentifier: reuseIdentifier )

		contentView.addSubview( titleLabel )
		titleLabel.font = UIFont( name: "GillSans-SemiBold", size: 15 )
		
		if #available(iOS 13, tvOS 13, *) {
			contentView.backgroundColor = .systemGray5
			titleLabel.textColor = .label
		} else {
			contentView.backgroundColor = UIColor( red: 0.933, green: 0.925, blue: 0.91, alpha: 1 )
		}

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		titleLabel.sizeToFit()
		titleLabel.frame.origin = CGPoint( x: 15, y: contentView.bounds.height - titleLabel.bounds.height - 4 )
	}

	let titleLabel = UILabel()
}
