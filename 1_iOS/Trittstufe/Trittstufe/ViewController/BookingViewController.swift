//
//  BookingViewController.swift
//  Trittstufe
//
//  Created by Ansgar Gerlicher on 12.07.22.
//

import UIKit

class BookingViewController: UIViewController {

    
    var presenter : BookingCoordinatorPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func bookCar(_ sender: Any) {
        
        presenter?.bookCar()
        // send message to Broker to notify car to pick up user
        print("car is booked")
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
