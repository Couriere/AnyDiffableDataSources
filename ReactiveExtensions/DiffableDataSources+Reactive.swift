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
import ReactiveSwift
import ReactiveCocoa

extension TableViewDiffableDataSource where SectionIdentifierType == Int {

	open var items: BindingTarget<[ItemIdentifierType]> {
		return BindingTarget( lifetime: Lifetime.of( self )) { [weak self] value in

			guard let self = self else { return }

			var snapshot = DiffableDataSourceSnapshot<Int, ItemIdentifierType>()
			snapshot.appendSections( [ 0 ] )
			snapshot.appendItems( value, toSection: 0 )

			UIScheduler().schedule { self.apply( snapshot ) }
		}
	}

	open var sectionsAndItems: BindingTarget<[[ItemIdentifierType]]> {
		return BindingTarget( lifetime: Lifetime.of( self )) { [weak self] value in

			guard let self = self else { return }

			var snapshot = DiffableDataSourceSnapshot<Int, ItemIdentifierType>()
			snapshot.appendSections( Array( 0..<value.count ))

			for ( index, items ) in value.enumerated() {
				snapshot.appendItems( items, toSection: index )
			}

			UIScheduler().schedule { self.apply( snapshot ) }
		}
	}
}

@available(iOS 13.0, *)
extension UITableViewDiffableDataSource where SectionIdentifierType == Int {

	open var items: BindingTarget<[ItemIdentifierType]> {
		return BindingTarget( lifetime: Lifetime.of( self )) { [weak self] value in

			guard let self = self else { return }

			var snapshot = DiffableDataSourceSnapshot<Int, ItemIdentifierType>()
			snapshot.appendSections( [ 0 ] )
			snapshot.appendItems( value, toSection: 0 )

			UIScheduler().schedule { self.apply( snapshot ) }
		}
	}

	open var sectionsAndItems: BindingTarget<[[ItemIdentifierType]]> {
		return BindingTarget( lifetime: Lifetime.of( self )) { [weak self] value in

			guard let self = self else { return }

			var snapshot = DiffableDataSourceSnapshot<Int, ItemIdentifierType>()
			snapshot.appendSections( Array( 0..<value.count ))

			for ( index, items ) in value.enumerated() {
				snapshot.appendItems( items, toSection: index )
			}

			UIScheduler().schedule { self.apply( snapshot ) }
		}
	}
}

@available(iOS 13.0, *)
extension UITableViewDiffableDataSource {

	open var sectionsAndItems: BindingTarget<[( SectionIdentifierType, [ ItemIdentifierType ] )]> {
		return BindingTarget( lifetime: Lifetime.of( self )) { [weak self] value in

			guard let self = self else { return }

			var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
			snapshot.appendSections( value.map { $0.0 } )
			value.forEach { snapshot.appendItems( $1, toSection: $0 ) }

			UIScheduler().schedule { self.apply( snapshot ) }
		}
	}
}



extension CollectionViewDiffableDataSource where SectionIdentifierType == Int {

	open var items: BindingTarget<[ItemIdentifierType]> {
		return BindingTarget( lifetime: Lifetime.of( self )) { [weak self] value in

			guard let self = self else { return }

			var snapshot = DiffableDataSourceSnapshot<Int, ItemIdentifierType>()
			snapshot.appendSections( [ 0 ] )
			snapshot.appendItems( value, toSection: 0 )

			UIScheduler().schedule { self.apply( snapshot ) }
		}
	}

	open var sectionsAndItems: BindingTarget<[[ItemIdentifierType]]> {
		return BindingTarget( lifetime: Lifetime.of( self )) { [weak self] value in

			guard let self = self else { return }

			var snapshot = DiffableDataSourceSnapshot<Int, ItemIdentifierType>()
			snapshot.appendSections( Array( 0..<value.count ))

			for ( index, items ) in value.enumerated() {
				snapshot.appendItems( items, toSection: index )
			}

			UIScheduler().schedule { self.apply( snapshot ) }
		}
	}
}

@available(iOS 13.0, *)
extension UICollectionViewDiffableDataSource where SectionIdentifierType == Int {

	open var items: BindingTarget<[ItemIdentifierType]> {
		return BindingTarget( lifetime: Lifetime.of( self )) { [weak self] value in

			guard let self = self else { return }

			var snapshot = NSDiffableDataSourceSnapshot<Int, ItemIdentifierType>()
			snapshot.appendSections( [ 0 ] )
			snapshot.appendItems( value, toSection: 0 )

			UIScheduler().schedule { self.apply( snapshot ) }
		}
	}

	open var sectionsAndItems: BindingTarget<[[ItemIdentifierType]]> {
		return BindingTarget( lifetime: Lifetime.of( self )) { [weak self] value in

			guard let self = self else { return }

			var snapshot = NSDiffableDataSourceSnapshot<Int, ItemIdentifierType>()
			snapshot.appendSections( Array( 0..<value.count ))

			for ( index, items ) in value.enumerated() {
				snapshot.appendItems( items, toSection: index )
			}

			UIScheduler().schedule { self.apply( snapshot ) }
		}
	}
}

@available(iOS 13.0, *)
extension UICollectionViewDiffableDataSource {

	open var sectionsAndItems: BindingTarget<[( SectionIdentifierType, [ ItemIdentifierType ] )]> {
		return BindingTarget( lifetime: Lifetime.of( self )) { [weak self] value in

			guard let self = self else { return }

			var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
			snapshot.appendSections( value.map { $0.0 } )
			value.forEach { snapshot.appendItems( $1, toSection: $0 ) }

			UIScheduler().schedule { self.apply( snapshot ) }
		}
	}
}
