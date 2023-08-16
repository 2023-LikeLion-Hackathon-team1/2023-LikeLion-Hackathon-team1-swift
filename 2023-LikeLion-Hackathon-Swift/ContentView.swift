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
        MyWebView(urlToLoad: "https://likelion-hackathon-2023.netlify.app/")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
