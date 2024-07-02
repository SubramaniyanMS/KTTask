//
//  LocationManager.swift
//  KT
//
//  Created by Subramani MAC on 6/29/24.
//

import Foundation
import CoreLocation
import RealmSwift

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private var timer: Timer?

    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(saveLocation), userInfo: nil, repeats: true)
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
    }

    @objc private func saveLocation() {
        guard let location = locationManager.location else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            guard let placemark = placemarks?.first, error == nil else { return }
            let locationName = [placemark.name, placemark.locality, placemark.administrativeArea].compactMap { $0 }.joined(separator: ", ")

            let realm = try! Realm()
            let locationData = LocationData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, timestamp: Date(), locationName: locationName)
            try! realm.write {
                realm.add(locationData)
            }
            DispatchQueue.main.async {
                ListViewController().tableView.reloadData()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
}

class LocationData: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var timestamp: Date = Date()
    @objc dynamic var locationName: String = ""

    convenience init(latitude: Double, longitude: Double, timestamp: Date, locationName: String) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.locationName = locationName
    }
}
