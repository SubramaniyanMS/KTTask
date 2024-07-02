//
//  MapViewController.swift
//  KT
//
//  Created by Subramani MAC on 6/29/24.
//

import UIKit
import GoogleMaps
import RealmSwift

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    var selectedLocation: LocationData?
    
    lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.layer.cornerRadius = .ratioHeightBasedOniPhoneX(20)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var playBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Playback", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = .ratioHeightBasedOniPhoneX(25)
        button.addTarget(self, action: #selector(playbackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpUI()
        mapViewFunctions()
    }
    
    func setUpUI() {
        view.addSubview(mapView)
        view.addSubview(playBackButton)
        view.addSubview(backButton)
        view.bringSubviewToFront(playBackButton)
        view.bringSubviewToFront(backButton)
        
        mapView.top == view.top
        mapView.bottom == view.bottom
        mapView.leading == view.leading
        mapView.trailing == view.trailing
        
        backButton.top == view.top + .ratioHeightBasedOniPhoneX(30)
        backButton.height == .ratioHeightBasedOniPhoneX(40)
        backButton.width == .ratioHeightBasedOniPhoneX(40)
        backButton.leading == view.leading + .ratioHeightBasedOniPhoneX(15)
        
        playBackButton.bottom == view.bottom - .ratioHeightBasedOniPhoneX(25)
        playBackButton.centerX == view.centerX
        playBackButton.height == .ratioHeightBasedOniPhoneX(50)
        playBackButton.width == .ratioHeightBasedOniPhoneX(150)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func playbackButtonTapped() {
        let realm = try! Realm()
        let locationData = realm.objects(LocationData.self).sorted(byKeyPath: "timestamp", ascending: true)
        var coordinates: [CLLocationCoordinate2D] = []
        
        for data in locationData {
            let coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            coordinates.append(coordinate)
        }
        
        animatePath(coordinates)
    }
    
    func mapViewFunctions() {
        guard let location = selectedLocation else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 10.0)
        mapView.camera = camera
        mapView.delegate = self

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        marker.title = "Location"
        marker.snippet = location.locationName
        marker.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = UIView(frame: CGRect(x: 0, y: 0, width: 225, height: 150))
        infoWindow.backgroundColor = .white
        infoWindow.layer.cornerRadius = 10

        let infoLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 205, height: 130))
        infoLabel.text = marker.snippet
        infoLabel.textColor = .black
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoWindow.addSubview(infoLabel)

        return infoWindow
    }
    
    func animatePath(_ coordinates: [CLLocationCoordinate2D]) {
        guard !coordinates.isEmpty else { return }
        
        var currentIndex = 0
        let marker = GMSMarker()
        marker.position = coordinates[currentIndex]
        marker.map = mapView
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if currentIndex < coordinates.count {
                CATransaction.begin()
                CATransaction.setAnimationDuration(1.0)
                marker.position = coordinates[currentIndex]
                self.mapView.animate(toLocation: coordinates[currentIndex])
                CATransaction.commit()
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}
