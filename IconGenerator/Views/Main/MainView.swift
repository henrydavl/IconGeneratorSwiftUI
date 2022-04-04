//
//  ContentView.swift
//  IconGenerator
//
//  Created by Henry David Lie on 04/04/22.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var vm = MainViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.self) private var env
    
    var body: some View {
        switch horizontalSizeClass {
        case .regular:
            mainView.frame(width: 360, height: 600, alignment: .center)
        default:
            mainView
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension MainView {
    @ViewBuilder
    private var mainView: some View {
            VStack(spacing: 20) {
                addButton
                exportOptions
                    .padding()
            }
            .overlay {
                loadingView
            }
            .animation(.default, value: vm.selectedImage)
            .animation(.easeInOut, value: vm.exportingPhase)
            .fullScreenCover(isPresented: $vm.isPresentingImagePicker) {
                ImagePickerView(image: $vm.selectedImage)
        }
    }
    
    private var addButton: some View {
        Button {
            self.vm.importImage()
        } label: {
            RoundedRectangle(cornerRadius: 24, style: .circular)
                .overlay {
                    if let image = vm.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .cornerRadius(24)
                            .clipped()
                    } else {
                        VStack {
                            Text("Click or Drag n drop")
                                .font(.callout)
                                .foregroundColor(.black)
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(env.colorScheme == .dark ? .black : .white)
                                .padding()
                                .background(.primary, in: RoundedRectangle(cornerRadius: 24))
                            recomendedSize
                        }
                    }
                }
        }
        .frame(width: 200, height: 200, alignment: .center)
        .buttonStyle(.plain)
        .onDrop(of: ["public.image"], isTargeted: nil, perform: vm.handleOnDropProviders)
    }
    
    private var recomendedSize: some View {
        Text("1024 x 1024")
            .foregroundColor(.black)
            .font(.caption)
            .padding(.bottom, 10)
    }
    
    private var loadingView: some View {
        ZStack {
            if vm.isExportingInProgress {
                Color.black
                    .opacity(0.25)
                ProgressView()
                    .padding()
                    .background(.white, in: RoundedRectangle(cornerRadius: 10))
                    .environment(\.colorScheme, .light)
            }
        }
    }
    
    @ViewBuilder
    private var exportOptions: some View {
        Divider()
        VStack {
            Toggle("iPhone", isOn: $vm.isExportingToiPhone)
            Toggle("iPad", isOn: $vm.isExportingToiPad)
            Toggle("Mac", isOn: $vm.isExportingToMac)
            Toggle("Apple Watch", isOn: $vm.isExportingToWatch)
        }
        .disabled(vm.isToggleOptionsDisabled)
        Divider ()
        Button {
            vm.export()
        } label: {
            Text("Generate Icon Set")
                .foregroundColor(env.colorScheme == .dark ? .black : .white)
                .padding(.vertical, 8)
                .padding(.horizontal, 18)
                .background(.primary, in: RoundedRectangle(cornerRadius: 10))
        }
        .padding(.top, 10)
        .disabled(vm.isExportButtonDisabled)
        
        if case let .failure(error) = vm.exportingPhase {
            Text(error.localizedDescription)
                .foregroundColor(.red)
        }
    }
}
