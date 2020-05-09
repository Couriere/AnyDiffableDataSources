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


struct Post: Decodable, Hashable {
	let userId: Int
	let id: Int
	let title: String
	let body: String
}

class CollectionViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = "Posts"

		dataSource = AnyCollectionViewDiffableDataSource( collectionView: collectionView ) {
			collectionView, indexPath, post in

			let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "PostCollectionCell", for: indexPath ) as! PostCollectionCell
			cell.title = post.title

			return cell
		}


		// Загружаем посты.
		posts <~ loadPosts()

		// Обновляем список постов на экране в зависимости от строки поиска.
		dataSource.items( animatingDifferences: true ) <~ posts.producer
			.combineLatest( with: self.searchBar.reactive.continuousTextValues.producer.prefix( value: "" ) )
			.combineLatest( with: reactive.viewDidAppear ).map { $0.0 } // Выводим информацию только после появления на экране.
			.map( { posts, searchText -> [ Post ] in
				guard let query = searchText, !query.isEmpty else { return posts }
				return posts.filter { $0.title.range( of: query, options: .caseInsensitive ) != nil }
			})
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		layout.itemSize = CGSize( width: collectionView.bounds.width / 2 - 10, height: 31 )
		layout.estimatedItemSize = .zero
		layout.invalidateLayout()
	}

	private func loadPosts() -> SignalProducer<[Post], Never> {
		return URLSession(configuration: .default).reactive
			.data( with: URLRequest( url: URL( string: "https://jsonplaceholder.typicode.com/posts" )! ))
			.attemptMap { data, _ in try JSONDecoder().decode( [Post].self, from: data ) }
			.flatMapError { _ in SignalProducer( value: [] ) }
	}


	@IBOutlet private var collectionView: UICollectionView!
	@IBOutlet private var searchBar: UISearchBar!
	private var dataSource: AnyCollectionViewDiffableDataSource<Int, Post>!


	private let posts = MutableProperty<[ Post ]>( [] )
}

class PostCollectionCell: UICollectionViewCell {
	var title: String {
		get { titleLabel.text ?? "" }
		set { titleLabel.text = newValue }
	}

	override var isHighlighted: Bool {
		didSet {
			backgroundColor = isHighlighted ? UIColor( white: 0, alpha: 0.2 ) : .clear
		}
	}

	@IBOutlet private var titleLabel: UILabel!
}
