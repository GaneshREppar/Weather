//
//  WeatherForcastViewController.swift
//  Weather
//
//  Created by Ganesh Eppar on 03/06/23.
//

import UIKit

class WeatherForcastViewController: UIViewController {

    let viewData: WeatherForcastViewData
    let tableView = UITableView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 40), style: .plain)
    
    init(viewData: WeatherForcastViewData) {
        self.viewData = viewData
        super.init(nibName: nil, bundle: nil)

        // register Cell
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.indentifier)
    }
    
    deinit {
        print("Deinit called")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    func setupView() {
        view.backgroundColor = UIColor.systemBlue
        view.addSubview(tableView)
        tableView.tableHeaderView = createHeaderView()
        tableView.backgroundColor = UIColor.systemBlue
        navigationController?.navigationBar.tintColor = UIColor.black
        tabBarController?.tabBar.barTintColor = UIColor.systemBlue

    }

    func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 150))
        
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 50))
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 50, width: view.frame.width - 20, height: 50))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 100, width: view.frame.width - 20, height: 50))
        
        summaryLabel.text = viewData.forcastDescription
        locationLabel.text = viewData.city
        tempLabel.text = viewData.currentTemp.map { String(format: "%.2f°C", $0-273.15) } ?? "Value not provided"

        summaryLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        
        headerView.addSubview(summaryLabel)
        headerView.addSubview(locationLabel)
        headerView.addSubview(tempLabel)
        
        headerView.backgroundColor = UIColor.systemBlue
        return headerView
    }
}

extension WeatherForcastViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData.dayPredictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.indentifier, for: indexPath) as? WeatherTableViewCell
        cell?.configure(city: viewData.dayPredictions[indexPath.row])
        cell?.selectionStyle = .none
        cell?.backgroundColor = UIColor.systemBlue
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
