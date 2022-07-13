//
//  ScrollViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit
import Elements
class ScrollableView: BaseUIScrollView {
    var content: UIView! {
        didSet {
            _removeView(oldValue)
            _addView(_contentView)
        }
    }

    public private(set) lazy var contentWrapper = BaseUIView()

    public init(content: UIView) {
        self.content = content
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private var _contentView: UIView {
        content
    }

    private func _addView(_ view: UIView) {
        contentWrapper.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentWrapper.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor),
        ])
    }

    private func _removeView(_ view: UIView) {
        view.removeFromSuperview()

        NSLayoutConstraint.deactivate(view.constraints)
    }

    override open func setupView() {
        super.setupView()

        addSubview(contentWrapper)

        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        _addView(_contentView)
    }
}
