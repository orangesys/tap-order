//
//  TOMenuListCell.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import SwiftUI

struct TOMenuListCell: View {
    private var colors: [Color] = [.yellow, .purple, .green]
    var imgName = "keyboard"
    var catName = "keyboardwoedf"
    var priceName = "20"

    var body: some View {
        
        VStack {
            Image(systemName: imgName)
                .font(.system(size: 30))
                .frame(width: 130, height: 90)
                .scaledToFit()
                .background(Color.themeColor)
                .cornerRadius(20)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            Text(catName)
                .font(.system(size: 20))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            HStack {
                Text(priceName)
                    .font(.system(size: 18,weight: .bold))
                .foregroundColor(Color(uiColor: UIColor(rgb: 0xCAAA38)))
                Spacer()
//                button
            }
        }
        .frame(width: 150, height: 210, alignment: .top)
        .background(LinearGradient(gradient: Gradient(colors: [Color(uiColor: UIColor(rgb: 0xe8e8e8)), Color(uiColor:UIColor(rgb: 0xe4e4e4).withAlphaComponent(0.85))]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
    }
}

struct TOMenuListCell_Previews: PreviewProvider {
    static var previews: some View {
        TOMenuListCell()
    }
}
