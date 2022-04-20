//
//  ListViewController.swift
//  TheMovies
//
//  Created by Sayali Deopurkar on 19/04/22.
//

import UIKit

class ListViewController: UIViewController {

    private var viewModel: ListViewModel
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Movies"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
   
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.cellID)
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        
        return tableView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.addArrangedSubview(self.titleLabel)
        return stackView
    }()
    
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        bindViewModel()
        viewModel.loadData()
    }
    
    private func bindViewModel() {
        viewModel.didStartLoading = {
            ///Show Activity indicator
        }
        viewModel.didStopLoading = {
            ///Hide Activity indicator
        }
        viewModel.didReload = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Tableview Delegate & Datasource
extension ListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:ListTableViewCell.cellID, for: indexPath) as? ListTableViewCell ?? ListTableViewCell(style: .default, reuseIdentifier: ListTableViewCell.cellID)
        cell.textLabel?.text = "Test"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}

extension ListViewController {
    private func setupViews() {
        view.backgroundColor = .lightGray
        view.addSubview(headerStackView)
        view.addSubview(tableView)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.darkText]
        tableView.backgroundColor = .clear
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            headerStackView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -8.0),
            headerStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20.0),
            headerStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20.0),
            tableView.leftAnchor.constraint(equalTo: headerStackView.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: headerStackView.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8.0)
        ])
    }
}

