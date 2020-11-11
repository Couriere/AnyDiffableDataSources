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
import DiffableDataSources

@available( iOS, deprecated: 13, message: "Use UIKit's UICollectionViewDiffableDataSource" )
@available( tvOS, deprecated: 13, message: "Use UIKit's UICollectionViewDiffableDataSource" )
open class AnyCollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> : NSObject, UICollectionViewDataSource where SectionIdentifierType : Hashable, ItemIdentifierType : Hashable {

	public init(collectionView: UICollectionView, cellProvider:  @escaping (UICollectionView, IndexPath, ItemIdentifierType) -> UICollectionViewCell? ) {

		if #available( iOS 13, tvOS 13, * ) {
			let base = UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>( collectionView: collectionView, cellProvider: cellProvider)
			_indexPathForItemIdentifier = base.indexPath(for:)
			_itemIdentifierForIndexPath = base.itemIdentifier(for:)
			_numberOfSections = base.numberOfSections
			_numberOfItemsInSection = base.collectionView(_:numberOfItemsInSection:)
			_cellForItemAtIndexPath = base.collectionView(_:cellForItemAt:)
			_viewForSupplementaryElementOfKindAt = base.collectionView(_:viewForSupplementaryElementOfKind:at:)
			_canMoveItemAt = base.collectionView(_:canMoveItemAt:)
			_moveItemAt = base.collectionView(_:moveItemAt:to:)
			_indexTitles = base.indexTitles(for:)
			_indexPathForIndexTitleAt = base.collectionView(_:indexPathForIndexTitle:at:)
			_description = base.description

			self.base = base
		}
		else {
			let base = CollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>( collectionView: collectionView, cellProvider: cellProvider)
			_indexPathForItemIdentifier = base.indexPath(for:)
			_itemIdentifierForIndexPath = base.itemIdentifier(for:)
			_numberOfSections = base.numberOfSections
			_numberOfItemsInSection = base.collectionView(_:numberOfItemsInSection:)
			_cellForItemAtIndexPath = base.collectionView(_:cellForItemAt:)
			_viewForSupplementaryElementOfKindAt = base.collectionView(_:viewForSupplementaryElementOfKind:at:)
			_canMoveItemAt = base.collectionView(_:canMoveItemAt:)
			_moveItemAt = base.collectionView(_:moveItemAt:to:)
			_indexTitles = { _ in nil }
			_indexPathForIndexTitleAt = { _, _, _ in fatalError("Not implemented") }
			_description = { "CollectionViewDiffableDataSource" }

			self.base = base
		}
	}

	open var supplementaryViewProvider: ((UICollectionView, String, IndexPath) -> UICollectionReusableView? )? {
		get {
			if #available( iOS 13, tvOS 13, * ) {
				let ds = base as! UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
				return ds.supplementaryViewProvider
			}
			else {
				let ds = base as! CollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
				return ds.supplementaryViewProvider
			}
		}
		set {
			if #available( iOS 13, tvOS 13, * ) {
				let ds = base as! UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
				ds.supplementaryViewProvider = newValue
			}
			else {
				let ds = base as! CollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
				ds.supplementaryViewProvider = newValue
			}
		}
	}

	/// Applies given snapshot to perform automatic diffing update.
	///
	/// - Parameters:
	///   - snapshot: A snapshot object to be applied to data model.
	///   - animatingDifferences: A Boolean value indicating whether to update with
	///                           diffing animation.
	///   - completion: An optional completion block which is called when the complete
	///                 performing updates.
	open func apply(_ snapshot: DiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {

		if #available( iOS 13, tvOS 13, * ) {
			let ds = base as! UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
			ds.apply( snapshot, animatingDifferences: animatingDifferences, completion: completion )
		}
		else {
			let ds = base as! CollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
			ds.apply( snapshot, animatingDifferences: animatingDifferences, completion: completion )
		}
	}
	@available( iOS 13, tvOS 13, * )
	open func apply(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {

		let ds = base as! UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
		ds.apply( snapshot, animatingDifferences: animatingDifferences, completion: completion )
	}

	/// Returns a new snapshot object of current state.
	///
	/// - Returns: A new snapshot object of current state.
	open func snapshot() -> DiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
		if #available( iOS 13, tvOS 13, * ) {
			let ds = base as! UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
			let snapshot = ds.snapshot()
			var converted = DiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
			converted.appendSections( snapshot.sectionIdentifiers )
			snapshot.sectionIdentifiers
				.forEach { converted.appendItems( snapshot.itemIdentifiers( inSection: $0 ), toSection: $0 ) }
			return converted
		}
		else {
			let ds = base as! CollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
			return ds.snapshot()
		}
	}


	open func itemIdentifier(for indexPath: IndexPath) -> ItemIdentifierType? {
		_itemIdentifierForIndexPath( indexPath )
	}

	open func indexPath(for itemIdentifier: ItemIdentifierType) -> IndexPath? {
		_indexPathForItemIdentifier( itemIdentifier )
	}

	// Proxy datasource methods

	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		return _numberOfSections( collectionView )
	}

	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return _numberOfItemsInSection( collectionView, section )
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return _cellForItemAtIndexPath( collectionView, indexPath )
	}

	public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		return _viewForSupplementaryElementOfKindAt( collectionView, kind, indexPath )
	}

	public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		return _canMoveItemAt( collectionView, indexPath )
	}

	public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		_moveItemAt( collectionView, sourceIndexPath, destinationIndexPath )
	}

	public func indexTitles(for collectionView: UICollectionView) -> [String]? {
		return _indexTitles( collectionView )
	}

	public func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
		return _indexPathForIndexTitleAt( collectionView, title, index )
	}

	open func description() -> String {
		return _description()
	}

	private let base: UICollectionViewDataSource

	private let _numberOfSections: (UICollectionView) -> Int
	private let _numberOfItemsInSection: (UICollectionView, Int) -> Int
	private let _cellForItemAtIndexPath: (UICollectionView, IndexPath) -> UICollectionViewCell
	private let _canMoveItemAt: (UICollectionView, IndexPath) -> Bool
	private let _moveItemAt: (UICollectionView, IndexPath, IndexPath) -> Void
	private let _viewForSupplementaryElementOfKindAt: (UICollectionView, String, IndexPath) -> UICollectionReusableView
	private let _indexTitles: (UICollectionView) -> [String]?
	private let _indexPathForIndexTitleAt: (UICollectionView, String, Int) -> IndexPath
	private let _description: () -> String
	private let _itemIdentifierForIndexPath: (IndexPath) -> ItemIdentifierType?
	private let _indexPathForItemIdentifier: (ItemIdentifierType) -> IndexPath?
}

@available(iOS 13, tvOS 13, *)
extension UICollectionViewDiffableDataSource {

	open func apply( _ snapshot: DiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
					 animatingDifferences: Bool = true,
					 completion: (() -> Void )? = nil) {

		var newSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
		newSnapshot.appendSections( snapshot.sectionIdentifiers )
		for section in snapshot.sectionIdentifiers {
			newSnapshot.appendItems( snapshot.itemIdentifiers( inSection: section ), toSection: section )
		}
		apply( newSnapshot,
			   animatingDifferences: animatingDifferences,
			   completion: completion )
	}
}

extension AnyCollectionViewDiffableDataSource {

	/// Change or replace item in the datasource with updated version.
	/// - Parameters:
	///   - indexPath: Index path of an item to change or replace.
	///   - animatingDifferences: Animate change to item. Default is `true`.
	///   - update: A closure that can change or replace provided item.
	open func replaceItem( at indexPath: IndexPath,
						   animatingDifferences: Bool = true,
						   with update: @escaping ( inout ItemIdentifierType ) -> Void ) {

		guard let identifier = itemIdentifier( for: indexPath ) else { return }
		var newSnapshot = snapshot()
		newSnapshot.updateItem( identifier, with: update )
		apply( newSnapshot, animatingDifferences: animatingDifferences )
	}
}
