//
//  ContentView.swift
//  Shared
//
//  Created by solo on 2/21/22.
//

import SwiftUI


struct ContentView: View {
    @Binding var needShowLogin: Bool
    
    var body: some View {
        MainView().sheet(isPresented: $needShowLogin) {
            LoginView()
        }.onAppear {
            ContentViewModel.shared.checkIfUserLogin()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(needShowLogin: Binding.constant(true))
    }
}
