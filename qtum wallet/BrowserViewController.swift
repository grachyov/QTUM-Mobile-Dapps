//
//  BrowserViewController.swift
//  qtum wallet
//
//  Created by Ivan Grachev on 17/09/2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var demoDappButton: UIButton!
    var webView: WKWebView!
    @IBOutlet weak var webViewPlaceholder: UIView!
    @IBOutlet weak var siteTextField: UITextField! {
        didSet {
            siteTextField.delegate = self
        }
    }
    
    private var observers = [NSKeyValueObservation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupWebView()
    }
    
    private func setupWebView() {
        let webViewConfig = WKWebView.makeQryptoConfiguration(messageHandler: self)
        webView = WKWebView(frame: CGRect.zero, configuration: webViewConfig)
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewPlaceholder.addSubviewConstrainedToFrame(webView)
        observers.append(webView.observe(\WKWebView.url, changeHandler: { [weak self] webView, _ in
            self?.siteTextField.text = webView.url?.absoluteString
        }))
        observers.append(webView.observe(\WKWebView.estimatedProgress, changeHandler: { [weak self] webView, _ in
            if webView.estimatedProgress == 1 {
                self?.addAccount()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            }
        }))
    }
    
    @IBAction func demoDappButtonTapped(_ sender: Any) {
        siteTextField.text = "https://qtum-dapp.herokuapp.com/"
        if let url = URL(string: "https://qtum-dapp.herokuapp.com/") {
            load(url: url)
        }
    }
    
    private var address: String {
        if let current = (UserDefaults(suiteName: "group.qtum.hack")?.object(forKey: "kPublicAddresses") as? [String])?.first {
            return current
        } else {
            return ""
        }
    }
    
    private var balance: String {
        return ServiceLocator.sharedInstance().walletManager.wallet.balance.stringValue() ?? ""
    }
    
    func load(url: URL) {
        webView.load(URLRequest(url: url))
        siteTextField.text = url.absoluteString
        demoDappButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func addAccount() {
        let script =
        """
        window.postMessage({message: {type: "ACCOUNT_CHANGED", payload: {account: {
        address: "\(address)",
        balance: "\(balance)",
        loggedIn: true,
        name: "None",
        network: "TestNet"
        }}}}, "*")
        """
        webView.evaluateJavaScript(script)
    }
    
}

extension BrowserViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard var urlString = siteTextField.text else { return false }
        if !urlString.contains("://") {
            urlString = "http://" + urlString
        }
        
        guard let url = URL(string: urlString) else { return false }
        textField.resignFirstResponder()
        load(url: url)
        return true
    }
}

extension BrowserViewController: WKScriptMessageHandler {
    
    private func executeCallback(id: String, error: String?, value: String?) {
        let script = "executeCallback(\(id), \(JsStringFromOptional(value)), \(JsStringFromOptional(error)))"
        webView.evaluateJavaScript(script, completionHandler: nil)
    }
    
    func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        guard
            let body = message.body as? [String: Any],
            let callbackId = body["id"] as? String,
            let args = body["args"] as? [Any], args.count > 1,
            let receiver = args[0] as? String,
            let amountString = args[1] as? String
            else { return }
        let amount = QTUMBigNumber(string: amountString)
        let fee = QTUMBigNumber(string: "1")
        let arr = [["amount": amount, "address": receiver]]
        
        let alert = UIAlertController(title: "Send \(amountString) QTUM", message: "To address \(receiver)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            ServiceLocator.sharedInstance().transactionManager.sendTransactionWalletKeys(ServiceLocator.sharedInstance().walletManager.wallet.allKeys(), toAddressAndAmount: arr, fee: fee) { (error, response, estFee) in}
            self?.executeCallback(id: callbackId, error: nil, value: "true")
        }
        let canceAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(canceAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func JsStringFromOptional(_ optional: String?) -> String {
        if let value = optional {
            return "\"\(value)\""
        } else {
            return "null"
        }
    }
}

extension UIView {
    
    func addSubviewConstrainedToFrame(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        let firstConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": subview])
        let secondConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": subview])
        addConstraints(firstConstraint)
        addConstraints(secondConstraint)
    }
}

extension WKWebView {
    
    static func makeQryptoConfiguration(messageHandler: WKScriptMessageHandler) -> WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        let userScript = makeUserScriptFor()
        config.userContentController.addUserScript(userScript)
        config.userContentController.add(messageHandler, name: "test")
        return config
    }
    
    static func makeUserScriptFor() -> WKUserScript {
        let js =
        """
        window.qrypto = {
            account: {
                address: "",
                balance: 0,
                loggedIn: true,
                name: "",
                network: ""
            },
            rpcProvider: {
                rawCall: function(method, args) {
                    let provider = this;
                    console.log(provider);
                    return new Promise((resolve, reject) => {
                        const id = provider.trackRequest(resolve, reject);
                        console.log('id', id)
                        webkit.messageHandlers.test.postMessage({"name": "rawCall", "method": method, "args": args, "id": id});
                    });
                },
                handleRpcCallResponse: function(response) {
                    // todo
                    console.log(response);
                    const request = this.requests[response.id];
                    if (!request) {
                    return;
                    }

                    delete this.requests[response.id];

                    if (response.error) {
                    return request.reject(response.error);
                    }

                    request.resolve(response.result);
                },
                trackRequest: function(resolve, reject) {
                    const id = Math.random().toString().slice(-8);
                    this.requests[id] = { resolve, reject };
                    return id;
                },
                requests: {}
            }
        }
        function executeCallback(id, result, error) {
                window.qrypto.rpcProvider.handleRpcCallResponse({id: id, result: result, error: error})
            }
        """
        
        let userScript: WKUserScript = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        return userScript
    }
    
}
