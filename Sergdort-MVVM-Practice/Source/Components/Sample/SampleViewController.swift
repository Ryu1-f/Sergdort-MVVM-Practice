//
//  SampleViewController.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/02.
//

import UIKit
import SkeletonView

class SampleViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: "disney")?.rounded(to: 40)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
