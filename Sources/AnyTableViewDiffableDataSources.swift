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

@available( iOS, deprecated: 13, message: "Use UIKit's UITableViewDiffableDataSource" )
@available( tvOS, deprecated: 13, message: "Use UIKit's UITableViewDiffableDataSource" )
open class AnyTableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> : NSObject, UITableViewDataSource where SectionIdentifierType : Hashable, ItemIdentifierType : Hashable {

	public init(tableView: UITableView, cellProvider:  @escaping (UITableView, IndexPath, ItemIdentifierType) -> UITableViewCell? ) {

		if #available( iOS 13, tvOS 13, * ) {
			let base = UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>( tableView: tableView, cellProvider: cellProvider)
			_indexPathForItemIdentifier = base.indexPath(for:)
			_itemIdentifierForIndexPath = base.itemIdentifier(for:)
			_numberOfSections = base.numberOfSections
			_numberOfRowsInSection = base.tableView(_:numberOfRowsInSection:)
			_cellForRowAtIndexPath = base.tableView(_:cellForRowAt:)
			_titleForHeaderInSection = base.tableView(_:titleForHeaderInSection:)
			_titleForFooterInSection = base.tableView(_:titleForFooterInSection:)
			_canEditRowAt = base.tableView(_:canEditRowAt:)
			_commit = base.tableView(_:commit:forRowAt:)
			_canMoveRowAt = base.tableView(_:canMoveRowAt:)
			_moveRowAt = base.tableView(_:moveRowAt:to:)
			_sectionIndexTitles = base.sectionIndexTitles(for:)
			_sectionForSectionIndexTitle = base.tableView(_:sectionForSectionIndexTitle:at:)
			_description = base.description

			self.base = base
		}
		else {
			let base = TableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>( tableView: tableView, cellProvider: cellProvider)
			_indexPathForItemIdentifier = base.indexPath(for:)
			_itemIdentifierForIndexPath = base.itemIdentifier(for:)
			_numberOfSections = base.numberOfSections
			_numberOfRowsInSection = base.tableView(_:numberOfRowsInSection:)
			_cellForRowAtIndexPath = base.tableView(_:cellForRowAt:)
			_titleForHeaderInSection = base.tableView(_:titleForHeaderInSection:)
			_titleForFooterInSection = base.tableView(_:titleForFooterInSection:)
			_canEditRowAt = base.tableView(_:canEditRowAt:)
			_commit = base.tableView(_:commit:forRowAt:)
			_canMoveRowAt = base.tableView(_:canMoveRowAt:)
			_moveRowAt = base.tableView(_:moveRowAt:to:)
			_sectionIndexTitles = { _ in nil }
			_sectionForSectionIndexTitle = base.tableView(_:sectionForSectionIndexTitle:at:)
			_description = { base.description }

			self.base = base
		}
	}

	/// The default animation to updating the views.
	open var defaultRowAnimation: UITableView.RowAnimation {
		get {
			if #available( iOS 13, tvOS 13, * ) {
				let ds = base as! UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
				return ds.defaultRowAnimation
			}
			else {
				let ds = base as! TableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
				return ds.defaultRowAnimation
			}
		}
		set {
			if #available( iOS 13, tvOS 13, * ) {
				let ds = base as! UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
				ds.defaultRowAnimation = newValue
			}
			else {
				let ds = base as! TableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
				ds.defaultRowAnimation = newValue
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
			let ds = base as! UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
			ds.apply( snapshot, animatingDifferences: animatingDifferences, completion: completion )
		}
		else {
			let ds = base as! TableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
			ds.apply( snapshot, animatingDifferences: animatingDifferences, completion: completion )
		}
	}
	@available( iOS 13, tvOS 13, * )
	open func apply(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {

		let ds = base as! UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
		ds.apply( snapshot, animatingDifferences: animatingDifferences, completion: completion )
	}

	/// Returns a new snapshot object of current state.
	///
	/// - Returns: A new snapshot object of current state.
	open func snapshot() -> DiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
		if #available( iOS 13, tvOS 13, * ) {
			let ds = base as! UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
			let snapshot = ds.snapshot()
			var converted = DiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
			converted.appendSections( snapshot.sectionIdentifiers )
			snapshot.sectionIdentifiers
				.forEach { converted.appendItems( snapshot.itemIdentifiers( inSection: $0 ), toSection: $0 ) }
			return converted
		}
		else {
			let ds = base as! TableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
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
	public func numberOfSections(in tableView: UITableView) -> Int {
		return _numberOfSections( tableView )
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return _numberOfRowsInSection( tableView, section )
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return _cellForRowAtIndexPath( tableView, indexPath )
	}

	public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return _titleForHeaderInSection( tableView, section )
	}

	public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return _titleForFooterInSection( tableView, section )
	}

	public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return _canEditRowAt( tableView, indexPath )
	}

	public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		_commit( tableView, editingStyle, indexPath )
	}

	public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return _canMoveRowAt( tableView, indexPath )
	}

	public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		_moveRowAt( tableView, sourceIndexPath, destinationIndexPath )
	}

	public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return _sectionIndexTitles( tableView )
	}

	public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		return _sectionForSectionIndexTitle( tableView, title, index )
	}

	open func description() -> String {
		return _description()
	}

	private let base: UITableViewDataSource

	private let _numberOfSections: (UITableView) -> Int
	private let _numberOfRowsInSection: (UITableView, Int) -> Int
	private let _cellForRowAtIndexPath: (UITableView, IndexPath) -> UITableViewCell
	private let _titleForHeaderInSection: (UITableView, Int) -> String?
	private let _titleForFooterInSection: (UITableView, Int) -> String?
	private let _canEditRowAt: (UITableView, IndexPath) -> Bool
	private let _commit: (UITableView, UITableViewCell.EditingStyle, IndexPath) -> Void
	private let _canMoveRowAt: (UITableView, IndexPath) -> Bool
	private let _moveRowAt: (UITableView, IndexPath, IndexPath) -> Void
	private let _sectionIndexTitles: (UITableView) -> [String]?
	private let _sectionForSectionIndexTitle: (UITableView, String, Int) -> Int
	private let _description: () -> String
	private let _itemIdentifierForIndexPath: (IndexPath) -> ItemIdentifierType?
	private let _indexPathForItemIdentifier: (ItemIdentifierType) -> IndexPath?
}

@available(iOS 13.0, *)
extension UITableViewDiffableDataSource {

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

/// Change or replace item in the datasource with updated version.
/// - Parameters:
///   - indexPath: Index path of an item to change or replace.
///   - animatingDifferences: Animate change to item. Default is `true`.
///   - update: A closure that can change or replace provided item.
extension AnyTableViewDiffableDataSource {
	open func replaceItem( at indexPath: IndexPath,
						   animatingDifferences: Bool = true,
						   with update: @escaping ( inout ItemIdentifierType ) -> Void ) {
		
		guard let identifier = itemIdentifier( for: indexPath ) else { return }
		var newSnapshot = snapshot()
		newSnapshot.updateItem( identifier, with: update )
		apply( newSnapshot, animatingDifferences: animatingDifferences )
	}
}
