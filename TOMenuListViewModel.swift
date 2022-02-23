//
//  TOMenuListViewModel.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Foundation
import Combine
import SwiftUI

class TOMenuListViewModel: ObservableObject, TOAPIService {
    var apiSession: APIService
    @Published var foodList = [TOFoodsResposneItem]()
    
    var cancellables = Set<AnyCancellable>()
    
    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
    }
    
    func getPokemonList() {
        let cancellable = self.getFoodsList()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                case .finished:
                    break
                }
                
            }) { (pokemon) in
                self.foodList = pokemon.data
        }
        cancellables.insert(cancellable)
    }
}
