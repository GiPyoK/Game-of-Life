//
//  WebView.swift
//  Game-of-Life
//
//  Created by Gi Pyo Kim on 7/30/20.
//  Copyright © 2020 gipgip. All rights reserved.
//

import SwiftUI

struct WebView: View {
    var body: some View {
        WebviewModel(url: "https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Examples_of_patterns")
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView()
    }
}
