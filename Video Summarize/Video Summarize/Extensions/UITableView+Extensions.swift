//
//  UITableView+Extensions.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 26.11.2024.
//


import UIKit.UITableView

extension UITableView {
    func applyDefaultSettings(separatorStyle: UITableViewCell.SeparatorStyle = .none,
                              backgroundColor: UIColor = .clear,
                              rowHeight: CGFloat = UITableView.automaticDimension,
                              contentTopInset: CGFloat = 16,
                              contentLeftInset: CGFloat = 0,
                              contentBottomInset: CGFloat = 0,
                              contentRightInset: CGFloat = 0) {

        self.backgroundColor = backgroundColor
        self.separatorStyle = separatorStyle
        self.rowHeight = rowHeight
        contentInset = UIEdgeInsets(top: contentTopInset,
                                    left: contentLeftInset,
                                    bottom: contentBottomInset,
                                    right: contentRightInset)
        configureTableView()
    }

    func registerCell<T: UITableViewCell>(type: T.Type) where T: UITableViewCell {
        self.register(T.nibName, forCellReuseIdentifier: T.identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func configureTableView() {
        self.isPrefetchingEnabled = false
        self.sectionHeaderTopPadding = 0
    }
}


extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }

    static var nibName: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

