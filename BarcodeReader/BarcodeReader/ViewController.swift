//
//  ViewController.swift
//  BarcodeReader
//
//  Created by 岩井 宏晃 on 2018/04/24.
//  Copyright © 2018年 kiizan-kiizan. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: Bundle.main.url(forResource: "test", withExtension: "html")!)
        webView.load(request)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BarcodeReaderViewController {
            vc.delegate = self
        }
    }
}

extension ViewController: BarcodeReaderViewControllerDelegate {
    func barcodeReaderViewController(_ vc: BarcodeReaderViewController, DidReadBarcode number: String) {
        let script = "document.getElementById('barcode').value = \"\(number)\";"
        webView.evaluateJavaScript(script, completionHandler: nil)
    }
}

