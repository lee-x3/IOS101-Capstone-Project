//
//  MoodUserProfileViewController.swift
//  TheMoodJournal
//
//  Created by Xia Mey Lee on 4/7/25.
//

import UIKit

class MoodUserProfileViewController: UIViewController {

    @IBOutlet weak var selfImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        selfImageView.layer.cornerRadius = selfImageView.frame.width/2
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
