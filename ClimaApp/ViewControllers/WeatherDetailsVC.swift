//
//  WeatherDetailsVC.swift
//  ClimaApp
//
//  Created by Yassine DAOUDI on 26/5/2022.
//

import UIKit

class WeatherDetailsVC: UIViewController {
    
    var weather: WeatherModel?
    
    let backgroundImageView = UIImageView()
    let stateImageView = UIImageView()
    let cityTemperature = TitleLabel(textAlignment: .left, fontSize: 20)
    let cityHumidity = TitleLabel(textAlignment: .left, fontSize: 20)
    let cityWindSpeed = TitleLabel(textAlignment: .left, fontSize: 20)
    let cityPressure = TitleLabel(textAlignment: .left, fontSize: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = weather?.cityName
        configure()
    }
    
    func configure() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        stateImageView.translatesAutoresizingMaskIntoConstraints = false

        backgroundImageView.image = UIImage(named: "background")
       
        stateImageView.image = UIImage(systemName: weather?.conditionName ?? "questionmark")
        stateImageView.tintColor = UIColor(named: "weatherColour")
        
        cityTemperature.text = "Temperature 🌡 : " + (weather?.temperatureString ?? "NA") + " °C"
        
        cityHumidity.text = "Humidity: " + "\(weather?.humidity ?? -0) "

        cityWindSpeed.text = "Wind speed 💨 : " + "\(weather?.windSpeed ?? -0)"

        cityPressure.text = "Pressure: " + "\(weather?.pressure ?? -0)"

        view.addSubviews(backgroundImageView, stateImageView, cityTemperature, cityHumidity, cityWindSpeed, cityPressure)
        
        backgroundImageView.pinToEdges(to: view)
        
        stateImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stateImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stateImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        stateImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        cityTemperature.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        cityTemperature.leadingAnchor.constraint(equalTo: stateImageView.trailingAnchor, constant: 10).isActive = true
        cityTemperature.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cityTemperature.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cityWindSpeed.topAnchor.constraint(equalTo: cityTemperature.bottomAnchor, constant: 5).isActive = true
        cityWindSpeed.leadingAnchor.constraint(equalTo: stateImageView.trailingAnchor, constant: 10).isActive = true
        cityWindSpeed.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cityWindSpeed.heightAnchor.constraint(equalToConstant: 22).isActive = true

        cityPressure.topAnchor.constraint(equalTo: cityWindSpeed.bottomAnchor, constant: 5).isActive = true
        cityPressure.leadingAnchor.constraint(equalTo: stateImageView.trailingAnchor, constant: 10).isActive = true
        cityPressure.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cityPressure.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cityHumidity.topAnchor.constraint(equalTo: cityPressure.bottomAnchor, constant: 5).isActive = true
        cityHumidity.leadingAnchor.constraint(equalTo: stateImageView.trailingAnchor, constant: 10).isActive = true
        cityHumidity.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cityHumidity.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
}
