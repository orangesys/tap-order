//
//  TOOrderCell.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI

struct TOOrderListCell: View {
    var body: some View {
        HStack {
            Image("chicken")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 130, alignment: .center)
                .background(Color.normalGray)
                .padding(3)
                .cornerRadius(20)
            VStack(alignment:.leading,spacing: 15){
                HStack {
                    Text("Noodles")
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                }
                Text("20")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.normalYellow)
                HStack {
                    Text("1")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.themeColor)
                }
            }
        }
    }
}

struct TOOrderListCell_Previews: PreviewProvider {
    static var previews: some View {
        TOOrderListCell()
    }
}
