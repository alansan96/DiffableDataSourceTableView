//
//  ViewController.swift
//  DiffDataSource
//
//  Created by Alan Santoso on 14/10/20.
//

import UIKit

fileprivate typealias UserDataSource = UITableViewDiffableDataSource<ViewController.Section, User>
fileprivate typealias UsersSnapShot = NSDiffableDataSourceSnapshot<ViewController.Section, User>


fileprivate class DataSource: UserDataSource{
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let identifierToDelete = itemIdentifier(for: indexPath){
                var snapshot = self.snapshot()
                snapshot.deleteItems([identifierToDelete])
                apply(snapshot)
            }
            
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

class ViewController: UIViewController {
    let alertService = AlertService()
    var users = [User]()
    private var dataSource: DataSource!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    func configureDataSource(){
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, user) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = user.name
            return cell
        })
        let snapshot = initSnapShot()
        dataSource.apply(snapshot)
        
    }
    
    fileprivate func initSnapShot() -> UsersSnapShot{
        users = [User(name: "alan"), User(name: "santoso")]
        var snapshot = UsersSnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(users)
        return snapshot
    }

    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        let alert = alertService.createUserAlert { (name) in
            self.addNewUser(with: name)
        }
        present(alert, animated: true)
    }
    
    func addNewUser(with name: String){
        let user = User(name: name)
        users.append(user)
        createSnapshot(from: users)
    }
    
    func createSnapshot(from users:[User]){
        var snapshot = UsersSnapShot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(users)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = dataSource.itemIdentifier(for: indexPath) else {return}
        print(user)
    }
  
}

extension ViewController{
    fileprivate enum Section{
        case main
    }
}
