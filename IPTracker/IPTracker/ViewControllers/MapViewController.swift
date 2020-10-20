//
//  MapViewController.swift
//  IPTracker
//
//  Created by Jordan Christensen on 10/19/20.
//

import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Variables
    
    private let cornerRadius: CGFloat = 20
    
    private var annotation: MKPointAnnotation?
    
    private let ipController = IPAddressController()
    private var ipContainer: IPResponseContainer? = nil {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var textFieldStack: UIStackView!
    @IBOutlet private weak var spacerView: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var ipView: UIView!
    
    @IBOutlet private weak var ipAddressLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var ispLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        updateViews()
    }
    
    override func viewDidLayoutSubviews() {
        submitButton.round(corners: [.topRight, .bottomRight], with: cornerRadius)
        spacerView.round(corners: [.topLeft, .bottomLeft], with: cornerRadius)
        
        ipView.layer.cornerRadius = cornerRadius
    }
    
    private func updateViews() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let container = self.ipContainer {
                self.ipAddressLabel.text = "\(container.ip)"
                self.locationLabel.text = "\(container.location)"
                self.ispLabel.text = container.isp
                
                
                let location = CLLocationCoordinate2D(latitude: container.location.latitude, longitude: container.location.longitude)
                let viewRegion = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
                
                if let annotation = self.annotation {
                    self.mapView.removeAnnotation(annotation)
                }
                
                self.annotation = MKPointAnnotation()
                self.annotation?.coordinate = location
                self.annotation?.title = self.ipAddressLabel.text
                
                self.mapView.addAnnotation(self.annotation!)
                self.mapView.setRegion(viewRegion, animated: true)
                
            } else {
                self.ipAddressLabel.text = ""
                self.locationLabel.text = ""
                self.ispLabel.text = ""
            }
        }
    }
    
    private func findIP() {
        guard let ip = textField.text, !ip.isEmpty,
              ip.rangeOfCharacter(from: NSCharacterSet.letters) == nil else { return }
        
        ipController.findLocationFromIP(ip: ip) { result in
            switch result {
            case .success(let container):
                self.ipContainer = container
            case .failure(let error):
                NSLog("There was an issue while trying to fetch location from ip address: \(error)")
            }
        }
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        view.endEditing(true)
        findIP()
    }
}

extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        findIP()
        return true
    }
}
