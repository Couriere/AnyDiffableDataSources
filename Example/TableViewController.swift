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
import AnyDiffabeDataSources
import ReactiveAnyDiffableDataSources


class TableViewController: UIViewController {

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
			cell.title = post.title

			return cell
		}


		// Загружаем посты.
		posts <~ loadPosts().map { $0.sorted { $0.title < $1.title }}

		// Обновляем список постов на экране в зависимости от строки поиска.
		dataSource.sectionsAndItems <~ posts.producer
			.combineLatest( with: self.searchController.searchBar.reactive.continuousTextValues.producer.prefix( value: "" ) )
			.combineLatest( with: reactive.viewDidAppear ).map { $0.0 } // Выводим информацию только после появления на экране.
			.map( { posts, searchText -> [ Post ] in
				guard let query = searchText, !query.isEmpty else { return posts }
				return posts.filter { $0.title.range( of: query, options: .caseInsensitive ) != nil }
			})
			.map { Dictionary( grouping: $0, by: { String( $0.title.first?.uppercased() ?? " " ) }) }
			.map { $0.map { ($0, $1) }.sorted { $0.0 < $1.0 } }

		// При появлении экрана прячем строку поиска под Navigation bar.
		reactive.viewDidLayoutSubviews
			.take( first: 1 )
			.observeValues { [unowned self] in
				self.tableView.contentOffset =
					CGPoint( x: 0,
							 y: self.searchController.searchBar.frame.height - self.tableView.adjustedContentInset.top )
		}
	}

	private func loadPosts() -> SignalProducer<[Post], Never> {
		return URLSession(configuration: .default).reactive
			.data( with: URLRequest( url: URL( string: "https://jsonplaceholder.typicode.com/posts" )! ))
			.attemptMap { data, _ in try JSONDecoder().decode( [Post].self, from: data ) }
			.flatMapError { _ in SignalProducer( value: [] ) }
	}


	@IBOutlet private var tableView: UITableView!
	private let searchController = UISearchController( searchResultsController: nil )
	private var dataSource: AnyTableViewDiffableDataSource<String, Post>!


	private let posts = MutableProperty<[ Post ]>( [] )
}

extension TableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow( at: indexPath, animated: true )
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

	@IBOutlet private var titleLabel: UILabel!
}

class SectionHeaderView: UITableViewHeaderFooterView {

	var title: String {
		get { titleLabel.text ?? "" }
		set { titleLabel.text = newValue }
	}

	override init( reuseIdentifier: String? ) {
		super.init( reuseIdentifier: reuseIdentifier )

		contentView.backgroundColor = UIColor( red: 0.933, green: 0.925, blue: 0.91, alpha: 1 )
		contentView.addSubview( titleLabel )
		titleLabel.font = UIFont( name: "GillSans-SemiBold", size: 15 )
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
