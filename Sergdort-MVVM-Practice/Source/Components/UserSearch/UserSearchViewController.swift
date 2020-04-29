//
//  SearchViewController2.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/05.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView
//import RxDataSources

final class UserSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 83
            tableView.register(UINib(nibName: UserTableViewCell.Const.identifier, bundle: nil), forCellReuseIdentifier: UserTableViewCell.Const.identifier)
            tableView.separatorStyle = .none
            tableView.delegate = dataSource
            tableView.isScrollEnabled = false
            tableView.isUserInteractionEnabled = false
        }
    }

    private let disposeBag: DisposeBag = .init()
    private let viewModel: UserSearchViewModel = .init()
    private let dataSource: UserSearchDatasource = .init()

    weak var delegate: UserSearchViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Github Search"
        bind()

        let input = UserSearchViewModel.Input(
            searchText: searchBar.rx.text.orEmpty.asObservable(),
            itemSelected: tableView.rx.itemSelected.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.searchDescription
            .filter { !$0.isEmpty }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        output.isLoading
            .subscribe({ [weak self] in
                guard let self = self else { return }
                $0.element! ? self.view.startSkeletonAnimation(): self.view.stopSkeletonAnimation()
            })
            .disposed(by: disposeBag)

        output.usersItem
            .bind(to: dataSource.items)
            .disposed(by: disposeBag)

        output.usersItem
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        output.error
            .subscribe(onNext: { error in
                if let error = error as? URLError,
                    error.code == URLError.notConnectedToInternet {
                    print(error)
                }
            })
            .disposed(by: disposeBag)

        output.selectedItem
            .map { $0.login }
            .subscribe { [weak self] name in
                self?.delegate?.pushUserDetail(with: name.element ?? "Unknown")
            }
            .disposed(by: disposeBag)

        output.usersItem
            .map { !$0.isEmpty }
            .bind(to: tableView.rx.isScrollEnabled)
            .disposed(by: disposeBag)

        output.usersItem
            .map { !$0.isEmpty }
            .bind(to: tableView.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

protocol UserSearchViewControllerDelegate: AnyObject {
    func pushUserDetail(with title: String)
}
