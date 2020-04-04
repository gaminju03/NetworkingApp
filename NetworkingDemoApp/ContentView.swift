//
//  ContentView.swift
//  NetworkingDemoApp
//
//  Created by Juan on 04/04/20.
//  Copyright © 2020 usuario. All rights reserved.
//

import SwiftUI


 

struct Response: Codable {

    var results: [Results]

}
struct Results: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String

}

struct ContentView: View {

    @State private var results = [Results]()
    var body: some View {
        NavigationView {
            List {
                ForEach(results, id: \.trackId) { item in
                    VStack(alignment: .leading){
                        Text(item.trackName)
                            .font(.headline)
                        Text(item.collectionName)

                    }

                }

                }.onAppear(perform: loadData)
            .navigationBarTitle("Songs list")
        }

    }
    
    func loadData(){
        //Paso 1 URL
        guard let url = URL (string: "https://itunes.apple.com/search?term=taylor+swift&entity=song")else{
            print("Validar URL")
            return
        }
        //Paso 2
        let request = URLRequest(url: url)
        
        //PASO 3
        URLSession.shared.dataTask(with: request){data, response, error in
        //PASO 4
            if let data2 = data{
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data2){
                  
                    DispatchQueue.main.async {
                        //se sincronizan los thred
                          self.results = decodedResponse.results
                        
                    }
                  return
                }
            }
            
            print ("Fetch failed\(error?.localizedDescription ?? "Unkow error" )")
            
        }.resume()
        
    }

}


 

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {

        ContentView()

    }

}
