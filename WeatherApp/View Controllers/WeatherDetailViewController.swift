//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Shilpa Mulpuri on 12/20/20.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    var viewModel: WeatherDetailViewModel!

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var sunLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
        iconImageView.layer.borderWidth = 1.0
        iconImageView.layer.borderColor = view.tintColor.cgColor
        
//        title = "\(viewModel.zipcode)"
        
        loadCurrentWeather()
    }
    
    private func loadCurrentWeather() {
        let loadingView = UIView()
        loadingView.backgroundColor = view.tintColor
        loadingView.alpha = 0.5
        loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let progressView = UIActivityIndicatorView(style: .large)
        progressView.center = loadingView.center
        progressView.color = .white
        loadingView.addSubview(progressView)
        progressView.startAnimating()
        view.addSubview(loadingView)
        viewModel.getCurrentWeather { [weak self] currentWeather, error in
            DispatchQueue.main.async {
                guard error == nil, let currentWeather = currentWeather else {
                    // show error alert
                    return
                }
                print(currentWeather)
                
                if let iconURL = currentWeather.mainWeatherInfo?.iconURL {
                    self?.loadIconImage(from: iconURL)
                }
                
                self?.title = currentWeather.name
                self?.mainLabel.text = currentWeather.mainWeatherInfo?.main
                self?.descriptionLabel.text = currentWeather.mainWeatherInfo?.description
                self?.visibilityLabel.text = "Visibility: \(currentWeather.visibility)"
                self?.temperatureLabel.text = "Temperature: \(currentWeather.main.temperature)\u{00B0}\nFeels Like: \(currentWeather.main.feelsLike)\u{00B0}\nHumidity: \(currentWeather.main.humidity)%"
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short
                dateFormatter.locale = Locale(identifier: "en_US")
                let sunriseDate = Date(timeIntervalSince1970: TimeInterval(currentWeather.sun.rise))
                let sunsetDate = Date(timeIntervalSince1970: TimeInterval(currentWeather.sun.set))
                self?.sunLabel.text = "Sunrise: \(dateFormatter.string(from: sunriseDate))\nSunset: \(dateFormatter.string(from: sunsetDate))"
                
                loadingView.removeFromSuperview()
            }
        }
    }
    
    private func loadIconImage(from url: URL) {
        let progressView = UIActivityIndicatorView(style: .large)
        progressView.center = iconImageView.center
        progressView.color = view.tintColor
        iconImageView.addSubview(progressView)
        progressView.startAnimating()
        viewModel.getIconImage(imageURL: url) { [weak self] image, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    // show image loading error alert
                    return
                }
                
                self?.iconImageView.image = image
            }
        }
    }
}
