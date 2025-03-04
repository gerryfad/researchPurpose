//
//  Helper.swift
//  researchPurpose
//
//  Created by Suitmedia on 04/03/25.
//

import UIKit

extension NSLayoutConstraint {
    static func pinToSafeArea(_ view: UIView, toView: UIView, insets: UIEdgeInsets = .zero, edges: UIRectEdge = .all) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        if edges.contains(.left) {
            constraints += [view.leftAnchor.constraint(equalTo: toView.safeAreaLayoutGuide.leftAnchor, constant: insets.left)]
        }
        if edges.contains(.top) {
            constraints += [view.topAnchor.constraint(equalTo: toView.safeAreaLayoutGuide.topAnchor, constant: insets.top)]
        }
        if edges.contains(.right) {
            constraints += [view.rightAnchor.constraint(equalTo: toView.safeAreaLayoutGuide.rightAnchor, constant: insets.right)]
        }
        if edges.contains(.bottom) {
            constraints += [view.bottomAnchor.constraint(equalTo: toView.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom)]
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}

class Navbar: UIView {
    
    weak var controller: UIViewController?
    var onTapBack: (() -> Void)?
    var useMargin: Bool = true
    
    var navViewHeight: CGFloat = 56
    lazy var navView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 0
        view.insetsLayoutMarginsFromSafeArea = false
        if useMargin {
            view.isLayoutMarginsRelativeArrangement = true
            view.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 24)
        }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return view
    }()
    
    lazy var buttonBack: UIButton = {
        let buttonX = UIButton()
        buttonX.setImage(UIImage(systemName: "chevron.left")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)).withRenderingMode(.alwaysTemplate), for: .normal)
        buttonX.tintColor = .gray
        buttonX.widthAnchor.constraint(equalToConstant: 44).isActive = true
        buttonX.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonX.addTarget(self, action: #selector(_onTapBack), for: .touchUpInside)
        buttonX.setContentHuggingPriority(.required, for: .horizontal)
        buttonX.setContentCompressionResistancePriority(.required, for: .horizontal)
        return buttonX
    }()
    
    lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkText
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.text = "Judul Buku"
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    // MARK: - VARIABEL DECLARATION
    
    var title: String? {
        get { labelTitle.text }
        set { labelTitle.text = newValue }
    }
    
    // MARK: - INIT
    
    init(controller: UIViewController, useMargin: Bool = true) {
        self.controller = controller
        super.init(frame: .zero)
        
        self.useMargin = useMargin
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    // MARK: - SETUP
    
    func setupView() {
        backgroundColor = .white
        addSubview(navView)
        navView.addArrangedSubview(buttonBack)
        navView.addArrangedSubview(labelTitle)
    }
    
    override var intrinsicContentSize: CGSize {
        var size = frame.size
        size.height = navViewHeight
        return size
    }
    
    // MARK: - ACTION
    
    @objc func _onTapBack(_ sender: Any) {
        if let onTapBack = onTapBack {
            onTapBack()
        } else {
            controller?.popOrDismiss()
        }
    }
    
}

extension UIViewController {
    
    func isModal() -> Bool {
        // Source: https://stackoverflow.com/a/43020070/2537616
        //
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
    
    func popOrDismiss(animated: Bool = true) {
        if isModal() {
            dismiss(animated: animated, completion: nil)
        } else {
            let _ = navigationController?.popViewController(animated: animated)
        }
    }
    
}
