//
//  ViewController.swift
//  benchmark
//
//  Created by Eliot Andres on 9/20/19.
//  Copyright © 2019 Eliot Andres. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    var inputData: CVPixelBuffer?
    let myModel = yolov5()
    
    let numRuns = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(startBenchmark), for: .touchUpInside)
        label.text = ""
        let inputFeatureDescription = myModel.model.modelDescription.inputDescriptionsByName["image"]
        let imageConstraints = inputFeatureDescription?.imageConstraint
        let width = imageConstraints?.pixelsWide
        let height = imageConstraints?.pixelsHigh
        let image = #imageLiteral(resourceName: "cat.jpg")
        self.inputData = image.pixelBuffer(width: width ?? 0, height: height ?? 0)
    }

    @objc func startBenchmark() {
        label.text = "Loading..."
        DispatchQueue.global(qos: .userInitiated).async {
            self.benchmark()
        }

    }

    func benchmark() {
        let start = Date()

        for i in 1...numRuns {
            do {
                print(i)
                let result = try myModel.prediction(image: self.inputData!)
            } catch let error {
                print(error.localizedDescription)
            }

        }

        let end = Date()
        let executionTime = end.timeIntervalSince(start)
        let imagesPerSecond = Double(numRuns) / executionTime

        DispatchQueue.main.async {
            self.label.text = String(format: "%.2f images/second", imagesPerSecond)
        }
    }

}

