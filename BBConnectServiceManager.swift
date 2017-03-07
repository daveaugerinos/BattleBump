//
//  BBConnectServiceManager.swift
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-06.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import MultipeerConnectivity

@objc class BBConnectServiceManager: NSObject {
    
    private let ConnectServiceManagerType = "BattleBumpRPS"
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    
    override init() {
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: ConnectServiceManagerType)
        super.init()
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
    }
    
    deinit {
        
        self.serviceAdvertiser.startAdvertisingPeer()
    }
}

extension BBConnectServiceManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer: \(peerID)")
    }
}

