//
//  WeatherView.swift
//  MphasisWeatherApp
//
//  Created by PSingh on 8/21/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    init(
        viewModel: WeatherViewModel = WeatherViewModel()
    ) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter Location", text: $viewModel.city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.red)
            Button("Search") {
                viewModel.getWeather(cityName: viewModel.city)
            }.buttonStyle(.bordered)
        }.padding(.bottom, 30)
        
            switch viewModel.weatherState {
            case .loaded:
                Text(viewModel.city).font(.system(size: 40))
                    .font(.headline)
                    .padding(20)
                    .foregroundStyle(Color.red)
                VStack(alignment: .center, spacing: 20) {
                    
                    Text(viewModel.temperation)
                    Text(viewModel.minTemperation)
                    Text(viewModel.maxTemperation)
                }.font(.title2)
                
                Spacer()
            case .error(let error):
                Spacer()
                Text(error)
                Spacer()
            }
    }
}

#Preview {
    WeatherView(viewModel: WeatherViewModel())
}
