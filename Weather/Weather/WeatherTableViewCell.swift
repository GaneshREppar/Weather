//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Ganesh Eppar on 04/06/23.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    static let indentifier = "WeatherTableViewCell"
    
    let dayLabel = UILabel()
    let highTempLabel = UILabel()
    let lowTempLabel = UILabel()
    let containerView = UIStackView()
    let tempContainer = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        highTempLabel.translatesAutoresizingMaskIntoConstraints = false
        lowTempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dayLabel.textAlignment = .center
        highTempLabel.textAlignment = .right
        lowTempLabel.textAlignment = .right
        
        
        contentView.addSubview(containerView)
        containerView.axis = .horizontal
        containerView.distribution = .fillEqually
        containerView.alignment = .center
        containerView.spacing = 10
        
        
        
        tempContainer.axis = .horizontal
        tempContainer.distribution = .fillEqually
        tempContainer.alignment = .center
        tempContainer.spacing = 10
        
        containerView.addArrangedSubview(dayLabel)
        containerView.addArrangedSubview(tempContainer)
        tempContainer.addArrangedSubview(highTempLabel)
        tempContainer.addArrangedSubview(lowTempLabel)
        containerView.frame = contentView.frame
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func configure(city: List) {
        var token = city.dt_txt.components(separatedBy: " ")
        print (token[0])
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:token[0])!
        dayLabel.text = dayOfWeek(date: date)
        highTempLabel.text = String(format: "%.2f°C", city.main.temp_max-273.15)
        lowTempLabel.text = String(format: "%.2f°C", city.main.temp_min-273.15)
    }
    
    func dayOfWeek(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date).capitalized
        // or use capitalized(with: locale) if you want
    }
}
