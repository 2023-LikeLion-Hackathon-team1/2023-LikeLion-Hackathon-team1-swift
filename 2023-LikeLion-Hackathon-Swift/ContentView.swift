//
//  ContentView.swift
//  2023-LikeLion-Hackathon-Swift
//
//  Created by 최혜림 on 8/11/23.
//

import SwiftUI
import WebKit

struct ContentView: View {
    var body: some View {
        MyWebView(urlToLoad: "https://main--serene-frangipane-9ca84b.netlify.app/")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
