//
//  ViewController.swift
//  WordGarden
//
//  Created by Kaylee Mei Chao on 7/1/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wordsGuessedLabel: UILabel!
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    @IBOutlet weak var wordsMissedLabel: UILabel!
    @IBOutlet weak var wordsInGameLabel: UILabel!
    @IBOutlet weak var guessLetterLabel: UILabel!
    @IBOutlet weak var guessLetterButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var numberGuessesLabel: UILabel!
    @IBOutlet weak var flowerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
    }
    
}

