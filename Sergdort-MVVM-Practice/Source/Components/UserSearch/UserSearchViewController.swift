//
//  SearchViewController2.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/05.
//

import UIKit
import RxSwift
import RxCocoa

class UserSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    let activityIndicator = UIActivityIndicatorView()

    private let disposeBag = DisposeBag()
    private let viewModel = UserSearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Github Search"
        setupViews()
        bind()

        let input = UserSearchViewModel.Input(
            searchText: searchBar.rx.text.orEmpty.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.searchDescription
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        output.usersItem
            .bind(to: tableView.rx.items) {_, _, element in
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
                cell.textLabel?.text = element.login
                cell.detailTextLabel?.text = element.avatar_url
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

    private func bind() {
        tableView.rx.itemSelected
            .subscribe({ [weak self] indexPath in
                guard let indexPath = indexPath.element else { return }
                self?.tableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
    }
}
