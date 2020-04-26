//
//  UserTableViewCell.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/23.
//

import UIKit
import SkeletonView

class UserTableViewCell: UITableViewCell {

    enum Const {
        static let identifier: String = "UserTableViewCell"
    }

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        isSkeletonable = true
        contentView.isSkeletonable = true
        userNameLabel.isSkeletonable = true
        urlLabel.isSkeletonable = true

        [userNameLabel, urlLabel].forEach {
            $0?.showAnimatedGradientSkeleton()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = ""
        urlLabel.text = ""
    }

    override func layoutSubviews() {
        superview?.layoutSubviews()
        layoutSkeletonIfNeeded()
    }

    public func hideSkeletonAnimation() {
        [userNameLabel, urlLabel].forEach {
            $0?.hideSkeleton()
        }
    }
}
