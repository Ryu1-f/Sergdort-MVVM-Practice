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

final class UserSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 83
            tableView.register(UINib(nibName: UserTableViewCell.Const.identifier, bundle: nil), forCellReuseIdentifier: UserTableViewCell.Const.identifier)
        }
    }

    private let disposeBag: DisposeBag = .init()
    private let viewModel: UserSearchViewModel = .init()
    private var usersItem: BehaviorRelay<[Users.Item]> = .init(value: [])

    weak var delegate: UserSearchViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Github Search"
        tableView.dataSource = self
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

        output.reloadData
            .bind(to: Binder(tableView) { [weak self] tableView, _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        output.usersItem
            .filter { !$0.isEmpty }
            .bind(to: usersItem)
            .disposed(by: disposeBag)

        output.isLoading
            .subscribe({ [weak self] in
                guard let self = self else { return }
                $0.element! ? self.view.startSkeletonAnimation(): self.view.stopSkeletonAnimation()
            })
            .disposed(by: disposeBag)

//        output.usersItem
//            .bind(to: tableView.rx.items) { [weak self] _, _, element in
//                let cell: UserTableViewCell = self?.tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.Const.identifier)! as! UserTableViewCell
//                cell.userNameLabel.text = element.login
//                cell.urlLabel.text = element.avatar_url
//                return cell
//        }
//        .disposed(by: disposeBag)

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

        Observable
            .combineLatest(output.isLoading, output.usersItem) {
                !($0 || $1.isEmpty)
            }
            .bind(to: tableView.rx.isScrollEnabled)
            .disposed(by: disposeBag)

        Observable
            .combineLatest(output.isLoading, output.usersItem) {
                !($0 || $1.isEmpty)
            }
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

extension UserSearchViewController: SkeletonTableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usersItem.value.isEmpty ? 8: usersItem.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.Const.identifier)! as! UserTableViewCell
        if !usersItem.value.isEmpty {
            cell.hideSkeletonAnimation()
            cell.userNameLabel.text = usersItem.value[indexPath.row].login
            cell.urlLabel.text = usersItem.value[indexPath.row].avatar_url
        }
        return cell
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        UserTableViewCell.Const.identifier
    }
}
