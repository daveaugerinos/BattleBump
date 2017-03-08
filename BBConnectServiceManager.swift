//
//  BBConnectServiceManager.swift
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-06.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import MultipeerConnectivity

@objc protocol BBConnectServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: BBConnectServiceManager, connectedDevices: [String])
    func receivedInvitee(manager: BBConnectServiceManager, invitee: Invitee)
}


@objc class BBConnectServiceManager: NSObject {
    
    private let ConnectServiceManagerType = "BBRPS-Game"
    private var peerID: MCPeerID?
    private var serviceAdvertiser: MCNearbyServiceAdvertiser?
    private var serviceBrowser: MCNearbyServiceBrowser?
    fileprivate var mySession: MCSession?
    var delegate: BBConnectServiceManagerDelegate?
    
    override init() {
        
        self.peerID = nil
        self.serviceAdvertiser = nil
        self.serviceBrowser = nil
        super.init()
    }
    
    deinit {
        
        serviceAdvertiser?.startAdvertisingPeer()
        serviceBrowser?.stopBrowsingForPeers()
    }
    
    
//    lazy var session: MCSession = {
//        
//        //if let peerID = self.peerID {
//        
//            let session = MCSession(peer: self.peerID!, securityIdentity: nil, encryptionPreference: .required)
//            session.delegate = self
//            return session
//        //}
//        
//        //return nil
//    }()
    
    
    @objc public func join(invitee: Invitee) {
        
        peerID = MCPeerID(displayName: invitee.player.name);
        
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID!, discoveryInfo: nil, serviceType: ConnectServiceManagerType)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID!, serviceType: ConnectServiceManagerType)
        
        serviceAdvertiser?.delegate = self
        serviceAdvertiser?.startAdvertisingPeer()
        
        serviceBrowser?.delegate = self
        serviceBrowser?.startBrowsingForPeers()
        
        mySession = MCSession(peer: self.peerID!, securityIdentity: nil, encryptionPreference: .required)
        mySession?.delegate = self
    }
    
    
    @objc public func send(invitee: Invitee) {
        
        print("sendInvitee: \(invitee.player.name) and \(invitee.game.name) to \(mySession?.connectedPeers.count) peers")
        
        if mySession!.connectedPeers.count > 0 {
            
            do {
                
                let dictionary = ["playerName" : invitee.player.name, "playerEmoji" : invitee.player.emoji, "gameName" : invitee.game.name, "gameStakes" : invitee.game.stakes]
                
                let myData: Data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
                
                try mySession?.send(myData, toPeers: mySession!.connectedPeers, with: .reliable)
            }
                
            catch let error {
                
                print("Error for sending: \(error)")
            }
        }
    }
}


extension BBConnectServiceManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        
        print("didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        print("didReceiveInvitationFromPeer: \(peerID)")
        invitationHandler(true, mySession)
    }
}


extension BBConnectServiceManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        print("foundPeer: \(peerID)")
        print("invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: mySession!, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        print("lostPeer: \(peerID)")
    }
}


extension BBConnectServiceManager : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        print("peer \(peerID) didChangeState: \(state)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{$0.displayName})
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        print("%@", "didReceiveData: \(data)")
        
        let dictionary: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : String]
        
        if let dictionary = dictionary, let playerName = dictionary["playerName"], let playerEmoji = dictionary["playerEmoji"], let gameName = dictionary["gameName"], let gameStakes = dictionary["gameStakes"] {
            
            let player = Player(name: playerName, emoji: playerEmoji)
            let game = Game(name: gameName, stakes: gameStakes)
            let invitee = Invitee(player: player, game: game)
            
            print("didReceive Invitee + \(invitee)")
            
            self.delegate?.receivedInvitee(manager: self, invitee: invitee)
        }
        
        else {
            
            print("Error in didReceiveData")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
        print("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
        print("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
        print("didFinishReceivingResourceWithName")
    }
}
