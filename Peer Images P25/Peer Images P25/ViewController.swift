//
//  ViewController.swift
//  Peer Images P25
//
//  Created by Rev on 14/03/2022.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var images = [UIImage]()
    
    var mcPeerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession : MCSession?
    var mcAdvertiserAssistant : MCAdvertiserAssistant?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(selectImage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptSessionOption))
        
        mcSession = MCSession(peer: mcPeerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath)
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        return cell
    }
    
    
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        images.append(image)
        collectionView.reloadData()
        dismiss(animated: true)
       
        guard let mcSession = mcSession else { return }
        
        if !mcSession.connectedPeers.isEmpty {
            if let dataImg = image.pngData() {
                do {
                    try mcSession.send(dataImg, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    alertAc(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    
    @objc func promptSessionOption() {
        let ac = UIAlertController(title: "Choose Action...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Host Session", style: .default, handler: hostSession))
        ac.addAction(UIAlertAction(title: "Join Session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Send a message to connected devices", style: .default, handler: promptSendingMessage))
        ac.addAction(UIAlertAction(title: "Show Connected Devices", style: .default, handler: showConnectedDevices))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        
        present(ac, animated: true)
    }
    
    
    func hostSession(action : UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "rev-p25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(action : UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowse = MCBrowserViewController(serviceType: "rev-p25", session: mcSession)
        mcBrowse.delegate = self
        
        present(mcBrowse, animated: true)
    }
    
    
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected \(peerID)... If we wanna share intial array we can't do here, we gotta show a button that says Share that send the images as data. Then the rest of code is same since we share each image separately")
        case .connecting:
            print("Connecting \(peerID)")
        case .notConnected:
            print("Disconnected \(peerID)")
            alertAc(title:"Alert", message: "\(peerID) has disconnected")
        default:
            print("Unknown thing. PeerId: \(peerID)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            [weak self] in
            if let image = UIImage(data: data) {
                self?.images.append(image)
                self?.collectionView.reloadData()
                return
            }
            
            if let str = String(data: data, encoding: .utf8) {
                self?.alertAc(title: "\(peerID) sends:", message: str)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func alertAc(title : String?, message : String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
    }
    
    func promptSendingMessage(action : UIAlertAction) {
        let ac = UIAlertController(title: "Type a message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Send", style: .default, handler: {
            [weak self, weak ac] _ in
            guard let mcSession = self?.mcSession else { return }
            guard !mcSession.connectedPeers.isEmpty else { return }
            
            if let msg = ac?.textFields?[0].text {
                let dataStr = Data(msg.utf8)
                do {
                    try mcSession.send(dataStr, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    self?.alertAc(title: "Error", message: error.localizedDescription)
                }
            }
        }))
    }
    
    func showConnectedDevices(action : UIAlertAction) {
        guard let mcSession = mcSession else { return }
        var connectedDevices = ""
        for peer in mcSession.connectedPeers {
            connectedDevices += peer.displayName + "\n"
        }
        
        if connectedDevices.isEmpty {
            connectedDevices = "No connected devices!"
        }
        
        alertAc(title: "Connected devices", message: connectedDevices)
        
    }

}

