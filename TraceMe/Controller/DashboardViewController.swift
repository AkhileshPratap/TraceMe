//
//  DashboardViewController.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 06/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    // This property is a table view used to show all data of a list
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.separatorStyle = .none
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableView.automaticDimension
            tableView.isHidden = true
            registerCell()
        }
    }

    fileprivate var viewModel: DashboardViewModel = DashboardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDefaults()

    }

    private func setupDefaults() {
        self.title = "Dashboard"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshData))

        viewModel.getDataFromRealm()
        viewModel.reloadData = { [weak self] () in
            self?.prepareDataSource()
        }
    }

    @objc private func refreshData() {
        self.prepareDataSource()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.prepareDataSource()
    }

    private func prepareDataSource() {
        viewModel.getDataFromDataBase()
        if viewModel.ifDataAvailableToPrepareDataSource() {
            tableView.isHidden = false
            tableView.reloadData()
        } else {
            tableView.isHidden = true
        }
    }

    private func registerCell() {
        viewModel.allCellTypes().forEach { tableView.registerNib(cell: $0) }
    }

}

extension DashboardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return if data model nil
        guard let dataModel = viewModel.itemForRow(indexPath: indexPath) else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(cell: dataModel.cellType.self) else { return UITableViewCell() }
        cell.representedObject = dataModel
        return cell
    }
}



