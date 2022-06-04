//
//  AppLogo.swift
//  Gordian Seed Tool
//
//  Created by Wolf McNally on 2/6/21.
//

import SwiftUI
import BCApp

struct AppLogo: View {
    var body: some View {
        HStack(spacing: 10) {
            Image.account
                .font(Font.system(size: 48).bold())
                .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
                Text("Gordian")
                Text("Coordinator")
            }
            .font(Font.system(size: 24).bold())
        }
    }
}
