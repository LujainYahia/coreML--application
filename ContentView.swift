//
//  ContentView.swift
//  Artector
//
//  Created by Lujain Yhia on 11/06/1445 AH.
//

import SwiftUI
import CoreML
import CoreImage

struct ContentView: View {
    @State private var error: Bool = false
    @State private var predictedImage: UIImage?
    let labels = ["Blind Light", "Builders", "Composition","Dark sea","Fosa","Our generous land","Still life with fish ","The land of solidities","Thursday Market","Untitled (Desert series)", "Untitled 1987", "Untitled 1988"]
    @State private var classificationLabel = ""
    @State private var selectedPainting: Painting?
    @State private var navigateToResultPage = false
    
    var capturedImage: UIImage

    let model: MyImageClassifier = {
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .cpuOnly
            return try MyImageClassifier(configuration: config)
        } catch {
            print(error)
            fatalError("Failed to load model")
        }
    }()

    var body: some View {
        VStack {
            Image(uiImage: capturedImage)
                .resizable()


            Spacer()

            Button("Scan") {
                classifyImage(capturedImage: capturedImage)
            }
            .foregroundColor(Color.white)
            .fontWeight(.medium)
            .font(.title3)
            .frame(width: 342,height: 50)
            .background(Color("PrimaryColor"))
            .cornerRadius(10)

            NavigationLink(destination: ResultPage(painting: selectedPainting, image: predictedImage), isActive: $navigateToResultPage) {
//                Text("Show Painting Info")
//                    .padding()
//                    .frame(width: 250)
//                    .foregroundColor(Color.black)
//                    .background(Color.white)
//                    .cornerRadius(10)
//                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
            }
            .padding()

            Text(classificationLabel)
                .padding()
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .navigationTitle("Captured Image").navigationBarTitleDisplayMode(.inline)
    }

    private func classifyImage(capturedImage: UIImage) {
        do {
            guard let pixelBuffer = capturedImage.pixelBuffer() else {
                return
            }

            let input = MyImageClassifierInput(image: pixelBuffer)
            let prediction = try model.prediction(input: input)

            let confidence = prediction.targetProbability[prediction.target] ?? 0
            self.classificationLabel = "Match: \(Int(confidence * 100))%"

            if confidence >= 0.85 {
                if let matchedPainting = paintings[prediction.target] {
                    self.selectedPainting = matchedPainting
                    self.predictedImage = capturedImage
                    self.navigateToResultPage = true
                } else {
                    // If there's no matched painting found within the high confidence level
                    self.selectedPainting = nil
                    self.predictedImage = nil
                    // You might want to handle this case differently or leave it as is
                }
            } else {
                // For confidence less than 85%, show the captured image with a message
                self.selectedPainting = nil
                self.predictedImage = capturedImage // Show the captured image
                self.classificationLabel = "There is no painting, try again"
            }

            // Catch block remains unchanged
            } catch {
                self.error = true
                self.classificationLabel = "Image Identification Unsuccessful"
            }

    }
}

extension UIImage {
    func pixelBuffer() -> CVPixelBuffer? {
        guard let ciImage = CIImage(image: self) else {
            return nil
        }

        var pixelBuffer: CVPixelBuffer?
        let options: [CIImageOption: Any] = [
            .applyOrientationProperty: true,
            .colorSpace: CGColorSpaceCreateDeviceRGB()
        ]

        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(ciImage.extent.width),
                                         Int(ciImage.extent.height),
                                         kCVPixelFormatType_32ARGB,
                                         options as CFDictionary,
                                         &pixelBuffer)

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        let context = CIContext()
        context.render(ciImage, to: buffer)

        return buffer
    }
}
