//
//  MapViewController.swift
//  MoviesLib
//
//  Created by Eric Alves Brito on 02/09/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    lazy var locationManager = CLLocationManager()
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requestAuthorization()
    }
    
    // MARK: - IBActions
    
    
    // MARK: - Methods
    private func setupView() {
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
        searchBar.delegate = self
    }
    
    private func requestAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Usuário já autorizou!!")
            case .denied:
                print("Painel explicando pq é importante ele autorizar a localização")
                /*
                if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                */
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Aí ferrou!!!")
            @unknown default:
                print("Cenário não validado!!")
            }
        } else {
            print("Painel explicando pq é importante habilitar os serviços de localização")
        }
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = searchBar.text
        
        let search = MKLocalSearch(request: request)
        search.start { [weak mapView] (response, error) in
            if error == nil {
                guard let response = response else {return}
                mapView?.removeAnnotations(mapView?.annotations ?? [])
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.url?.absoluteString
                    mapView?.addAnnotation(annotation)
                }
                mapView?.showAnnotations(mapView?.annotations ?? [], animated: true)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 7.0
        renderer.strokeColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return renderer
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let camera = MKMapCamera()
        camera.centerCoordinate = view.annotation!.coordinate
        camera.pitch = 80
        camera.altitude = 100
        mapView.setCamera(camera, animated: true)
        
        
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: view.annotation!.coordinate))
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if error == nil {
                guard let response = response,
                      let route = response.routes.first else {return}
                
                print("Nome:", route.name)
                print("Distância:", route.distance)
                print("Duração:", route.expectedTravelTime)
                for step in route.steps {
                    print("Em", step.distance, "metros", step.instructions)
                }
                self.mapView.removeOverlays(self.mapView.overlays)
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            }
        }
    }
}
