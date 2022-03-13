//
//  CTHomeViewController.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

@available(iOS 13.0, *)
class CTHomeViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var refreshControl : UIRefreshControl?
    var viewModel: CTHomeViewModel!
    var data: [CTWorkout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
        //print(WorkoutMO.getAll())
        
        
        
    }
    
    func setup() {
        self.configureTableView()
        DispatchQueue.main.async {
            self.bindRx()
        }
    }
    
    func configureTableView() {
        self.tableView.rowHeight = 113.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: CTTrainingTableViewCell.nameOfClass, bundle: nil), forCellReuseIdentifier: "cell")
    
    }
    
    
    func bindRx() {
        self.viewModel = CTHomeViewModel()
        self.viewModel.inputs.refresh()
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CTWorkout>>(
            configureCell: { dataSource, tableView, indexPath, workout in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CTTrainingTableViewCell
                cell.configure(workout: workout)
                return cell
        })
        
        self.refreshControl?.rx.controlEvent(.valueChanged)
            .bind(to: self.viewModel.inputs.loadPageTrigger)
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.elements.asDriver()
            .map { [SectionModel(model: "CTWorkout", items: $0)] }
            .drive(self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}
