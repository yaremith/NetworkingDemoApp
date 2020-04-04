//
//  ContentView.swift
//  NetworkingDemoApp
//
//  Created by Laura Yaremith Damian  Padilla on 04/04/20.
//  Copyright © 2020 Laura Yaremith Damian  Padilla. All rights reserved.
//

import SwiftUI

struct Response: Codable{
    var results: [Result]
    
}
struct Result: Codable{
    var trackId: Int
    var trackName: String
    var collectionName: String
}
struct ContentView: View {
    
    @State private var results=[Result]()
    var body: some View {
        NavigationView{
            List{
                ForEach(results, id: \.trackId){item in
                    VStack(alignment: .leading){
                        Text(item.trackName)
                            .font(.headline)
                        Text(item.collectionName)
                    }
                }
                
                
            }.onAppear(perform: loadData)
            .navigationBarTitle("Song List")
            
        }
    }
    
    
    func loadData(){
        guard let url = URL (string:"https://itunes.apple.com/search?term=taylor+swift&entity=song") else{
          print("Invalid URL")
          return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request){data, response,  error in
            
            if let data = data{
                if let decodeResponse = try? JSONDecoder().decode(Response.self, from: data){
                    DispatchQueue.main.async {
                       self.results=decodeResponse.results
                    }
                    return
                    
                }
            }
            print("Fetch Failed: \(error?.localizedDescription ?? "Unknow Error")")
            
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
