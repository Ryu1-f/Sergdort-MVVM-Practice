//
//  SearchViewController.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/03/19.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    let activityIndicator = UIActivityIndicatorView()

    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        let input = SearchViewModel.Input(
            searchText: searchBar.rx.text.orEmpty.asObservable()
        )

        let output = viewModel.transform(input: input)

        //        output.searchDescription
        //          .bind(to: navigationItem.rx.title)
        //          .disposed(by: disposeBag)

        output.wikipediaPages
            .bind(to: tableView.rx.items) {_, _, element in
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
                cell.textLabel?.text = element.title
                cell.detailTextLabel?.text = element.url.absoluteString
                return cell
        }
        .disposed(by: disposeBag)

        output.error
            .subscribe(onNext: { error in
                if let error = error as? URLError,
                    error.code == URLError.notConnectedToInternet {
                    print(error)
                }
            })
            .disposed(by: disposeBag)

        output.isLoading
            .map { !$0 }
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
}
