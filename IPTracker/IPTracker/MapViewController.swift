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
            // TODO: - Set labels to represent ipContainer and update mapView
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var textFieldStack: UIStackView!
    @IBOutlet private weak var spacerView: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var ipView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldStack.layer.cornerRadius = 8
        ipView.layer.cornerRadius = 8
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
