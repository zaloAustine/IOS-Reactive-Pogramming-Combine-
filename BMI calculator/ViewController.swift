//
//  ViewController.swift
//  BMI calculator
//
//  Created by ZALO on 09/04/2021.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    private let notificationCenter = NotificationCenter.default
    private var subscribers = Set<AnyCancellable>()
    
    @Published private var height:Double?
    @Published private var weight:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        observeTextField()
        
    }
    
    private func observeTextField(){
        
        notificationCenter.publisher(for: UITextField.textDidChangeNotification,object: heightTextField).sink(receiveValue: {
            
            guard let textField = $0.object as? UITextField,let text = textField.text,let height = Double(text) else {
                self.height = nil
                
                return
                
                
            }
            
            self.height = height
            
        }).store(in: &subscribers)
        
        
        notificationCenter.publisher(for: UITextField.textDidChangeNotification,object: weightTextField).sink(receiveValue: {
            
            guard let textField = $0.object as? UITextField,let text = textField.text,let weight = Double(text) ,!text.isEmpty else {
                self.weight = nil
                return
                
            }
            
            self.weight = weight
        }).store(in: &subscribers)
        
        
        Publishers.CombineLatest($height,$weight).sink{[weak self](height,weight) in
            guard let this = self else {return}
        
            
            guard let height = height, let weight = weight else {
                this.resultLabel.text = ""
                return}
            
            let result = this.calculateBMI(height: height, weight: weight)
            this.resultLabel.text = String(result)
            
        }.store(in: &subscribers)
    }
    
    private func calculateBMI(height:Double,weight:Double)->Double{
        
        return weight/(height*height)
    }
}

