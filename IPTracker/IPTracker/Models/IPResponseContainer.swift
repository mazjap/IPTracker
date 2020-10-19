//
//  IPResponseContainer.swift
//  IPTracker
//
//  Created by Jordan Christensen on 10/19/20.
//

import Foundation

struct IPResponseContainer: Decodable {
    enum CodingKeys: String, CodingKey {
        case ip
        case location
        case isp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        ip = try IP(container.decode(String.self, forKey: .ip))
        location = try container.decode(Location.self, forKey: .location)
        isp = try container.decode(String.self, forKey: .isp)
    }
    
    let ip: IP
    let location: Location
    let isp: String
}

struct IP: CustomStringConvertible {
    enum IPErrors: Error {
        case incompleteValues
    }
    
    var description: String {
        "\(val1).\(val2).\(val3).\(val4)"
    }
    
    init(_ ip: String) throws {
        let intArr = ip.split(separator: ".").compactMap { UInt8($0) }
        guard intArr.count == 4 else { throw IPErrors.incompleteValues }
        
        self.val1 = intArr[0]
        self.val2 = intArr[1]
        self.val3 = intArr[2]
        self.val4 = intArr[3]
    }
    
    let val1: UInt8
    let val2: UInt8
    let val3: UInt8
    let val4: UInt8
}

struct Location: Decodable, CustomStringConvertible {
    enum CodingKeys: String, CodingKey {
        case country
        case region
        case city
        case latitude = "lat"
        case longitude = "lng"
        case postalCode
    }
    
    var description: String {
        "\(city), \(region)\n" +
        "\(country), \(postalCode)"
    }
    
    var country: String
    var region: String
    var city: String
    var latitude: Double
    var longitude: Double
    var postalCode: String
}
