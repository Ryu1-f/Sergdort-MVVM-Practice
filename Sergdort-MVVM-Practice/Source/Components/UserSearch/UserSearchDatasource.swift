//
//  UserSearchDatasource.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/29.
//

import RxSwift
import RxCocoa
import SkeletonView
import UIKit

final class UserSearchDatasource: NSObject {

    public var items = BehaviorRelay<[Users.Item]>(value: [])
}

extension UserSearchDatasource: UITableViewDelegate {}

extension UserSearchDatasource: RxTableViewDataSourceType {

    func tableView(_ tableView: UITableView, observedEvent: Event<UserSearchDatasource.Element>) {
        Binder(self) { dataSource, element in
            dataSource.items.accept(element)
            tableView.reloadData()
        }.on(observedEvent)
    }

    typealias Element = [Users.Item]
}

extension UserSearchDatasource: SkeletonTableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.value.isEmpty ? 8: items.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.Const.identifier)! as! UserTableViewCell
        if !items.value.isEmpty {
            cell.hideSkeletonAnimation()
            cell.userNameLabel.text = items.value[indexPath.row].login
            cell.urlLabel.text = items.value[indexPath.row].avatar_url
        }
        return cell
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        UserTableViewCell.Const.identifier
    }
}
