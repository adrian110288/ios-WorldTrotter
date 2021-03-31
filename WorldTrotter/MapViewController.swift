//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Adrian Lesniak on 15/02/2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    private var map: MKMapView!
    
    private var locationManager = CLLocationManager()
    
    override func loadView() {
        map = MKMapView()
        view = map
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        
        let poiSwitch = UISwitch()
        
        view.addSubview(poiSwitch)
        
        poiSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        poiSwitch.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8).isActive = true
        
        poiSwitch.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        
        poiSwitch.addTarget(self, action: #selector(poiToggled(_:)), for: .valueChanged)
    }
    
    @objc func poiToggled(_ target: UISwitch) {
        
        if (target.isOn) {
            map.pointOfInterestFilter = .includingAll
            return
        }
        
        map.pointOfInterestFilter = .excludingAll
    }
    
    @objc func mapTypeChanged(_ target: UISegmentedControl) {
        
        switch target.selectedSegmentIndex {
        case 0:
            map.mapType = .standard
        case 1:
            map.mapType = .hybrid
        case 2:
            map.mapType = .satellite
        default:
            break
        }
        
    }
    
    override func viewDidLoad() {
        map.delegate = self
        map.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan()), animated: true)
    }

}
