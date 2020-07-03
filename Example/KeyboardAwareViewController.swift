//
//  KeyboardAwareViewController.swift
//
//  Created by Vladimir Kazantsev on 21.05.2020.
//  Copyright © 2020 MC2 Software. All rights reserved.
//

import UIKit

open class KeyboardAwareViewController: UIViewController {

	public override func viewDidLoad() {
		super.viewDidLoad()

		NotificationCenter.default.addObserver( self,
												selector: #selector( onKeyboardEvent ),
												name: UIResponder.keyboardWillShowNotification,
												object: nil )
		NotificationCenter.default.addObserver( self,
												selector: #selector( onKeyboardEvent ),
												name: UIResponder.keyboardWillHideNotification,
												object: nil )
	}

	deinit {
		NotificationCenter.default.removeObserver( self, name: UIResponder.keyboardWillHideNotification, object: nil )
		NotificationCenter.default.removeObserver( self, name: UIResponder.keyboardWillShowNotification, object: nil )
	}

	@objc private func onKeyboardEvent( _ notification: Foundation.Notification ) {
		guard
			let isLocalKeyboard = notification.userInfo?[ UIResponder.keyboardIsLocalUserInfoKey ] as? Bool, isLocalKeyboard,
			let targetFrame = ( notification.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue )?.cgRectValue else {
				return
		}

		let adjustedInset = UIScreen.main.bounds.height - targetFrame.minY - ( view.safeAreaInsets.bottom - additionalSafeAreaInsets.bottom )
		self.additionalSafeAreaInsets.bottom = max( adjustedInset, 0 )
	}
}
