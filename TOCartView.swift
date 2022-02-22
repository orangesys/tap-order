//
//  TOCartView.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI

struct TOCartView: View {
    let dataList = [1,2,3]
    var body: some View {
        //NavigationView {
        
        VStack {
            List {
                ForEach(dataList, id:\.self) { _ in
                    TOCartCell()
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            
            ZStack(alignment: .bottom) {
                VStack(spacing:40) {
                    HStack {
                        Text("Total:")
                            .font(.system(size: 22, weight: .semibold))
                        Spacer()
                        Text("22")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.normalYellow)
                    }
                    //Color.clear.padding(.bottom, 20)
                    Button(action: doSomething) {
                        RoundedRectangle(cornerSize: CGSize(width: 25, height: 25))
                            .foregroundColor(.themeColor)
                            .overlay(alignment: .center) {
                                Text("Send order")
                                    .font(.system(size: 24,weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(width:.SCREENWIDTH - 80,height: 64)
                    }
                }
                .background(.white)
            }
        }
        .padding(EdgeInsets(top: 0, leading: .menuListPadding, bottom: 0, trailing: .menuListPadding))
        
    }
    
    private func doSomething() {
        
    }
}

struct TOCartView_Previews: PreviewProvider {
    static var previews: some View {
        TOCartView()
    }
}
