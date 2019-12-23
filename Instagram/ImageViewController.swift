//
//  ImageViewController.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 23/12/19.
//  Copyright © 2019 Kostas Poimenidis. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
   
    @IBOutlet weak var titleLabel: UILabel!
    var imageTitle: String = ""
    var imageUrl: String = ""
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = imageTitle
        imageView.sd_setImage(with: URL(string: imageUrl))
        // Do any additional setup after loading the view.
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
