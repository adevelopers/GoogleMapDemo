//
//  GeoPointsListViewController.swift
//  GMapDemo
//
//  Created by Kirill Khudiakov on 21.05.2018.
//  Copyright © 2018 Kirill Khudiakov. All rights reserved.
//

import UIKit

class GeoPointsListViewController: UIViewController {
    
    var viewModel: GeoPointsViewModel!
    var tableView: UITableView!
    
    convenience init(viewModel: GeoPointsViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
}

extension GeoPointsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        let point = viewModel.list[indexPath.row]
        cell.textLabel?.text = point.toString() + " " + point.placeDescription.title
        return cell
    }
}
