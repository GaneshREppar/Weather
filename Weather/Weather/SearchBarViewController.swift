//
//  SearchBarViewController.swift
//  Weather
//
//  Created by Ganesh Eppar on 02/06/23.
//

import UIKit
import CoreLocation

class SearchBarViewController: UIViewController, CLLocationManagerDelegate {
    
    var searching = false
    var textField = UITextField(frame: CGRect(x: 20, y: 60, width: UIScreen.main.bounds.width - 40, height: 40))
    var tableView = UITableView(frame: CGRect(x: 20, y: 100, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height - 40), style: .plain)
    let cityData = ["Mumbai", "Bangalore", "Chennai",  "Hyderabad", "Delhi", "Ahmedabad", "Kolkata", "Pune", "Surat", "Indore"]
    var filterData: [String] = []
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var forcast: Forcast? = nil
    var weatherForcastViewData: WeatherForcastViewData? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        textField.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        filterData = cityData
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.white
        self.navigationItem.titleView = textField
        view.addSubview(tableView)
        textField.placeholder = "Search city name here"
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10.0
        
        view.backgroundColor = UIColor.systemBlue
        navigationController?.navigationBar.tintColor = UIColor.black
        tableView.backgroundColor = UIColor.systemBlue

        // Create a UIView to use as padding: You can create a new UIView to use as padding at the beginning of the text field. The width of this view will determine the amount of space you want to create.
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        
        // Set the leftView property of the text field: You can set the leftView property of the text field to the padding view you created in step 2. This will ensure that the padding view is displayed at the beginning of the text field.
        textField.leftView = paddingView
        
        // Set the leftViewMode property of the text field: You also need to set the leftViewMode property of the text field to .always. This will ensure that the padding view is always visible, even when there is no text in the text field.
        textField.leftViewMode = .always
        setupCurrentLocationButton()
        setupLocation()
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }

    func setupCurrentLocationButton() {
        let leftNavBarButton = UIBarButtonItem(title: "Current location", style: .plain, target: self, action: #selector(actionTapped))
        self.navigationItem.rightBarButtonItem = leftNavBarButton
    }

    @objc
    func actionTapped() {
        guard let currentLocation = currentLocation else { return  }
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(currentLocation.coordinate.latitude)&lon=\(currentLocation.coordinate.longitude)&appid=b47727437835c094fdff60c4ced2a98c"
        fetchData(urlString: urlString)
        guard let weatherForcastViewData = weatherForcastViewData else { return }
        self.navigationController?.pushViewController(WeatherForcastViewController(viewData: weatherForcastViewData), animated: true)
        self.weatherForcastViewData = nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty && currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestForWeatherOnLocation()
        }
    }

    func requestForWeatherOnLocation() {
        guard let currentLocation = currentLocation else { return  }
        
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        print("==\(long), \(lat)==")
    }

    
    private func fetchData(urlString: String) {
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.sync{
            guard let url = URL(string: urlString),
                  let data = try? Data(contentsOf: url) else {
                return
            }
            self.parse(data: data)
        }
    }
    
    private func parse(data: Data) {
        let decoder = JSONDecoder()
        guard let jsonPetition = try? decoder.decode(Forcast.self, from: data) else { return }
        forcast = jsonPetition

        var count = 0
        var list: [List] = []
        for weather in jsonPetition.list {
            if count%8 == 0 {
                list.append(weather)
                count+=1
                continue
            }
            count+=1
        }
        
        weatherForcastViewData = WeatherForcastViewData(city: jsonPetition.city, dayPredictions: list)
    }

}

extension SearchBarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching
        ? filterData.count
        : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        cell.textLabel?.text = searching
        ? filterData[indexPath.row]
        : nil
        cell.backgroundColor = UIColor.systemBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = filterData[indexPath.row]
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city),in&APPID=b47727437835c094fdff60c4ced2a98c"
        fetchData(urlString: urlString)
        guard let weatherForcastViewData = weatherForcastViewData else { return }
        self.navigationController?.pushViewController(WeatherForcastViewController(viewData: weatherForcastViewData), animated: true)
        self.weatherForcastViewData = nil
    }
}

extension SearchBarViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                guard let filterText = textField.text?.dropLast(),
                      filterText.count != 0 else {
                    filterData = cityData
                    tableView.reloadData()
                    return true
                }
                filterData = self.cityData.filter({ $0.localizedCaseInsensitiveContains(filterText) })
                
                tableView.reloadData()
                return true
            }
        }
        
        //input text
        let searchText  = textField.text! + string
        searching = searchText.count == 0 ? false : true
        //add matching text to arrya
        filterData = self.cityData.filter({ $0.localizedCaseInsensitiveContains(searchText) })
        
        tableView.reloadData()
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searching = true
        filterData = cityData
        tableView.reloadData()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searching = false
        filterData = []
        tableView.reloadData()
    }
    
}
