//
//  MapViewController.swift
//  IPTracker
//
//  Created by Jordan Christensen on 10/19/20.
//

import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Variables
    
    let ipController = IPAddressController()
    
    var ipContainer: IPResponseContainer? = nil {
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
        
        textFieldStack.layer.cornerRadius = 8
        ipView.layer.cornerRadius = 8
        
        updateViews()
    }
    
    private func updateViews() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let container = self.ipContainer {
                self.ipAddressLabel.text = "\(container.ip)"
                self.locationLabel.text = "\(container.location)"
                self.ispLabel.text = container.isp
                
                self.mapView.setCenter(CLLocationCoordinate2D(latitude: container.location.latitude, longitude: container.location.longitude), animated: true)
            } else {
                self.ipAddressLabel.text = ""
                self.locationLabel.text = ""
                self.ispLabel.text = ""
            }
        }
    }
    
    @IBAction func submitTapped(_ sender: Any) {
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
}

extension MapViewController: UITextFieldDelegate {
    
}
