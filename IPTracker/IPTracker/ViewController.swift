//
//  MapViewController.swift
//  IPTracker
//
//  Created by Jordan Christensen on 10/19/20.
//

import MapKit

class MapViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        if segue.identifier == "", let destVC = destination as? MapViewController {
            print(destVC)
        }
    }
}

