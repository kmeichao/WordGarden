//
//  ViewController.swift
//  WordGarden
//
//  Created by Kaylee Mei Chao on 7/1/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var wordsGuessedLabel: UILabel!
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    @IBOutlet weak var wordsMissedLabel: UILabel!
    @IBOutlet weak var wordsInGameLabel: UILabel!
    @IBOutlet weak var guessLetterLabel: UILabel!
    @IBOutlet weak var guessLetterButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var numberGuessesLabel: UILabel!
    @IBOutlet weak var guessLetterTextField: UITextField!
    @IBOutlet weak var flowerImageView: UIImageView!
    
    var wordsToGuess = ["SWIFT", "DOG", "CAT"]
    var currentWordIndex = 0
    var wordToGuess = ""
    var lettersGuessed  = ""
    let maxNumberOfWrongGuesses = 8
    var wrongGuessesRemaining = 8
    var wordsGuessedCount = 0
    var wordsMissedCount = 0
    var guessCount = 0
    var audioPlayer : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let text = guessLetterTextField.text!
        guessLetterButton.isEnabled = !(text.isEmpty)
        wordToGuess = wordsToGuess[currentWordIndex]
        guessLetterLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        updateGameStatusLabels()
        
        
    }
    
    func playSound(name: String) {
        if let sound = NSDataAsset(name: name) {
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print("ERROR: \(error.localizedDescription). Could not initialize")
            }
        } else {
            print ("ERROR: Could not read data from file \(name)")
        }
    }
    
    func updateUIAfterGuess() {
        guessLetterTextField.resignFirstResponder() //dismisses the keyboard
        guessLetterTextField.text! = "" //clear the text field
        guessLetterButton.isEnabled = false //disable guessLetter Button
    }
    
    func updateGuessLetterLabel() {
        var revealedWord = ""
        
        for letter in wordToGuess {
            if lettersGuessed.contains(letter) {
                revealedWord = revealedWord + "\(letter) " //add letter plus space to reveal word
            } else {
                revealedWord = revealedWord + "_ " // add underscore and space to reveal word
            }
        }
        revealedWord.removeLast() //remove space at end of word
        guessLetterLabel.text = revealedWord
    }
    
    func updateNumberGuessesLabel() {
        guessCount += 1
        var guesses = "Guesses"
        if guessCount == 1 {
            guesses = "Guess"
        }
        numberGuessesLabel.text = "You've Made \(guessCount) \(guesses)"
    }
    
    func updateGameStatusLabels() {
        wordsInGameLabel.text = "Words In Game: \(wordsToGuess.count)"
        wordsGuessedLabel.text = "Words Guessed: \(wordsGuessedCount)"
        wordsRemainingLabel.text = "Words Remaining: \(wordsToGuess.count - (wordsGuessedCount + wordsMissedCount))"
        wordsMissedLabel.text = "Words Missed: \(wordsMissedCount)"
    }
    
    func updateAfterWinOrLose() {
        //if game is over ->
        //increment currentWordIndex
        // disable guess a letter textfield
        // set the play again button
        //Update all labels
        
        currentWordIndex += 1
        guessLetterTextField.isEnabled = false
        guessLetterButton.isEnabled = false
        playAgainButton.isHidden = false
        
        //update labels after win
        updateGameStatusLabels()
        
    }
    
    func drawFlowerAndPlaySound(currentLetterGuessed: String) {
        if !wordToGuess.contains(currentLetterGuessed) {
            wrongGuessesRemaining -= 1
 
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                UIView.transition(with: self.flowerImageView,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {self.flowerImageView.image = UIImage(named: "wilt\(self.wrongGuessesRemaining)")})
                { (_) in
                    
                    //change to next flower
                    if self.wrongGuessesRemaining != 0 {
                        self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")
                    } else {
                        self.playSound(name: "word-not-guessed")
                        UIView.transition(with: self.flowerImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")}, completion: nil)
                    }
                }
                self.playSound(name: "incorrect")
            }
           
        } else {
            playSound(name: "correct")
        }
    }
    
    func guessALetter() {
        //get the current letter guessed and add to the letters guessed
        let currentLetterGuessed = guessLetterTextField.text!
        lettersGuessed = lettersGuessed + currentLetterGuessed
        updateGuessLetterLabel()
        
        drawFlowerAndPlaySound(currentLetterGuessed: currentLetterGuessed)
        
        updateNumberGuessesLabel()
        
        //check if user won or lost the game
        if !guessLetterLabel.text!.contains("_") {
            wordsGuessedCount += 1
            numberGuessesLabel.text = "You've guessed the word. It took you \(guessCount) guesses"
            playSound(name: "word-guessed")
            updateAfterWinOrLose()
        } else if wrongGuessesRemaining == 0 {
            numberGuessesLabel.text = "So sorry, you have no more guesses"
            wordsMissedCount += 1
            updateAfterWinOrLose()
        }
        
        if currentWordIndex == wordsToGuess.count {
            numberGuessesLabel.text! += "\n\n You've tried all of the words, restart?"
        }
        
        
    }
    
    

    @IBAction func guessLetterFieldChanged(_ sender: UITextField) {
        sender.text = String(sender.text!.last ?? " ").trimmingCharacters(in: .whitespaces).uppercased()
        guessLetterButton.isEnabled = !(sender.text!.isEmpty)
    }
    
    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
        guessALetter()
        updateUIAfterGuess()
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        if currentWordIndex == wordsToGuess.count {
            currentWordIndex = 0
            wordsGuessedCount = 0
            wordsMissedCount = 0
        }
        
        playAgainButton.isHidden = true
        guessLetterTextField.isEnabled = true
        guessLetterButton.isEnabled = false
        wordToGuess = wordsToGuess[currentWordIndex]
        wrongGuessesRemaining = maxNumberOfWrongGuesses
        guessLetterLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        flowerImageView.image = UIImage(named: "flower\(maxNumberOfWrongGuesses)")
        guessCount = 0
        lettersGuessed = ""
        numberGuessesLabel.text = "You've Made 0 Guesses"
        updateGameStatusLabels()
    }
    
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        guessALetter()
        updateUIAfterGuess()
    }
}

