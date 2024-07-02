//
//  ListViewController.swift
//  KT
//
//  Created by Subramani MAC on 6/29/24.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {
    
    let locationManager = LocationManager.shared
    let realm = try! Realm()
    var locationData: Results<LocationData>?
    var timer: Timer?
    
    lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 2
        label.text = "Background Location Data to be Saved Every 15 Minutes and Displayed in ListView"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "|"
        label.textColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Stop", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = .ratioHeightBasedOniPhoneX(25)
        button.addTarget(self, action: #selector(stopUpdatingLocationTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Clear Log", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = .ratioHeightBasedOniPhoneX(25)
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray
        setupUI()
        locationManager.startUpdatingLocation()
        fetchLocationData()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(fetchLocationData), userInfo: nil, repeats: true)
    }
    
    func setupUI() {
        
        view.addSubviews(with: [headingLabel, tableView, stopButton, centerLabel, clearButton])
        
        headingLabel.top == view.top + .ratioHeightBasedOniPhoneX(30)
        headingLabel.centerX == view.centerX
        headingLabel.leading == view.leading + .ratioHeightBasedOniPhoneX(20)
        headingLabel.trailing == view.trailing - .ratioHeightBasedOniPhoneX(20)
        headingLabel.height == .ratioHeightBasedOniPhoneX(50)
        
        tableView.top == headingLabel.bottom + .ratioHeightBasedOniPhoneX(15)
        tableView.leading == view.leading + .ratioHeightBasedOniPhoneX(10)
        tableView.trailing == view.trailing - .ratioHeightBasedOniPhoneX(10)
        tableView.bottom == stopButton.top - .ratioHeightBasedOniPhoneX(15)
        
        centerLabel.bottom == view.bottom - .ratioHeightBasedOniPhoneX(10)
        centerLabel.centerX == view.centerX
        centerLabel.width == .ratioHeightBasedOniPhoneX(10)
        centerLabel.height == .ratioHeightBasedOniPhoneX(10)
        
        stopButton.leading == view.leading + .ratioHeightBasedOniPhoneX(15)
        stopButton.trailing == centerLabel.leading - .ratioHeightBasedOniPhoneX(10)
        stopButton.bottom == view.bottom - .ratioHeightBasedOniPhoneX(10)
        stopButton.height == .ratioHeightBasedOniPhoneX(50)
        
        clearButton.leading == centerLabel.trailing + .ratioHeightBasedOniPhoneX(10)
        clearButton.trailing == view.trailing - .ratioHeightBasedOniPhoneX(15)
        clearButton.bottom == view.bottom - .ratioHeightBasedOniPhoneX(10)
        clearButton.height == .ratioHeightBasedOniPhoneX(50)
        
    }
    
    @objc func fetchLocationData() {
        locationData = realm.objects(LocationData.self).sorted(byKeyPath: "timestamp", ascending: false)
        tableView.reloadData()
        print("ListViewController - Fetch location data")
    }
    
    @objc func stopUpdatingLocationTapped() {
        locationManager.stopUpdatingLocation()
    }
    
    @objc func clearButtonTapped() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        fetchLocationData()
    }

}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let data = locationData?[indexPath.row] {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "Location: \(data.locationName)\nTimestamp: \(data.timestamp)"
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = locationData?[indexPath.row] {
            let mapVC = MapViewController()
            mapVC.selectedLocation = data
            navigationController?.pushViewController(mapVC, animated: true)
        }
    }
}
