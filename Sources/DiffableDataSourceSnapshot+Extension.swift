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

extension DiffableDataSourceSnapshot {
	
	///  Replace `identifier` with `newIdentifier` in the snapshot.
	mutating func replaceItem( _ identifier: ItemIdentifierType,
							   with newIdentifier: ItemIdentifierType ) {
		
		guard identifier != newIdentifier else { return }

		insertItems( [ newIdentifier ], afterItem: identifier )
		deleteItems( [ identifier ] )
	}
	
	/// Change or replace item in the snapshot with updated version.
	/// - Parameters:
	///   - identifier: Identifier of the item that needs to be changed or replaced.
	///   - update: Closure that takes `inout` item.
	mutating func updateItem( _ identifier: ItemIdentifierType,
							  with update: @escaping ( inout ItemIdentifierType ) -> Void ) {
		
		var newIdentifier = identifier
		update( &newIdentifier )
		
		guard newIdentifier != identifier else { return }
		replaceItem( identifier, with: newIdentifier )
	}
}

@available( iOS 13, tvOS 13, * )
extension NSDiffableDataSourceSnapshot {
	
	///  Replace `identifier` with `newIdentifier` in the snapshot.
	mutating func replaceItem( _ identifier: ItemIdentifierType,
							   with newIdentifier: ItemIdentifierType ) {
		
		guard identifier != newIdentifier else { return }
		
		insertItems( [ newIdentifier ], afterItem: identifier )
		deleteItems( [ identifier ] )
	}

	/// Change or replace item in the snapshot with updated version.
	/// - Parameters:
	///   - identifier: Identifier of the item that needs to be changed or replaced.
	///   - update: Closure that takes `inout` item.
	mutating func updateItem( _ identifier: ItemIdentifierType,
							  with update: @escaping ( inout ItemIdentifierType ) -> Void ) {
		
		var newIdentifier = identifier
		update( &newIdentifier )
		
		guard newIdentifier != identifier else { return }
		replaceItem( identifier, with: newIdentifier )
	}
}
