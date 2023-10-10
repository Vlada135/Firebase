//
//  ListViewController.swift
//  FirebaseDB
//
//  Created by Владислава on 10.10.23.
//

import UIKit
import SnapKit
import FirebaseAuth

class ListViewController: UIViewController {
    
    private var list: [List] = []
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .white
        table.register(ListCell.self, forCellReuseIdentifier: ListCell.id)
        return table
    }()
    
    private lazy var actionButton: UIButton = {
        let button = GradientButton(type: .system)
        button.tintColor = .white
        button.startColor = UIColor.purple
        button.endColor = UIColor.systemPink
        button.setTitle("Добавить", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.addTarget(
            self,
            action: #selector(action),
            for: .touchUpInside
        )
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cобытие"
        makeLayout()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readList()
    }
    private func makeLayout() {
        view.addSubview(table)
        view.addSubview(actionButton)
        
    }
    
    private func makeConstraints() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(250)
            make.trailing.equalToSuperview().offset(-40)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
    }
    
    @objc func action() {
        let secondController = SettingsViewController(mode: .create)
        self.navigationController?.pushViewController(secondController, animated: true)
    }
    
    private func parseData(_ dict: [String : Any]) {
        list.removeAll()
        for (key, value) in dict {
            guard let answer = value as? [String: Any] else { continue }
            guard let new = try? List(
                key: key,
                dict: answer
            ) else { continue }
            
            self.list.append(new)
        }
        self.table.reloadData()
    }
    
    private func readList() {
        guard let user = Auth.auth().currentUser else { return }
        Environment.ref.child("users/\(user.uid)/list").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let contactsDict = (snapshot.value as? [String: Any]) else { return }
            self?.parseData(contactsDict)
        }
        
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.id, for: indexPath)
        guard let listCell = cell as? ListCell else { return UITableViewCell() }
        listCell.setList(list: list[indexPath.row])
        return listCell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let settingListVC = SettingsViewController(mode: .edit(list[indexPath.row]))
        self.navigationController?.pushViewController(settingListVC, animated: true)
    }
}

