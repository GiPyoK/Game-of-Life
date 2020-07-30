//
//  Webview.swift
//  Game-of-Life
//
//  Created by Gi Pyo Kim on 7/30/20.
//  Copyright © 2020 gipgip. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit

struct WebviewModel: UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }
        
        let request = URLRequest(url: url)
        let wkWebview = WKWebView()
        wkWebview.load(request)
        return wkWebview
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    
    
}
