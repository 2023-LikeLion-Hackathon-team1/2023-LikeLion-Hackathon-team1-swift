//
//  MyWidgetBundle.swift
//  MyWidget
//
//  Created by 최혜림 on 8/15/23.
//

import WidgetKit
import SwiftUI

@main
struct MyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyWidget()
        MyWidgetLiveActivity()
    }
}
