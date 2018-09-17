//
//  ActionViewController.swift
//  QTUM Signer
//
//  Created by Ivan Grachev on 16/09/2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    private var providedAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let address = (UserDefaults(suiteName: "group.qtum.hack")?.object(forKey: "kPublicAddresses") as? [String])?.first {
            providedAddress = address
            infoLabel.text = address
        }
    }

    @IBAction func allowButtonTapped(_ sender: Any) {
        var items: [Any]?
        if let providedAddress = providedAddress {
            let item = NSExtensionItem()
            let attachment = NSItemProvider(item: providedAddress + " " + "qtumwallet" as NSSecureCoding, typeIdentifier: "qtum.provider.response")
            item.attachments = [attachment]
            items = [item]
        }                
        self.extensionContext!.completeRequest(returningItems: items, completionHandler: nil)
    }

    @IBAction func cancelButtonTapped() {
        cancel()
    }

    private func cancel() {
        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
}
