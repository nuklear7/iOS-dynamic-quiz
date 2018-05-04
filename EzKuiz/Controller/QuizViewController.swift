//
//  ViewController.swift
//  EzKuiz
//
//  Created by Dávid Mohácsi on 2018. 04. 25..
//  Copyright © 2018. Suit Solutions. All rights reserved.
//

import UIKit
import CoreData

class QuizViewController: UIViewController {
    
    let context = AppDelegate.viewContext
    var answerOptions: [AnswerOption]!
    var _quiz: Quiz!
    var qNo = 0
    var correctAnswers = 0
    let finishQuizSegueID = "finishQuizSegue"
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answersStackView: UIStackView!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var questionImage: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupQuiz(quiz: self._quiz, questionNo: 0)
    }
    
    private func setupQuiz(quiz: Quiz, questionNo: Int) {
        
        self.answerOptions = [AnswerOption]()
        
        if qNo >= (_quiz.questions?.count)! {
            return
        }
        
        let questions = (quiz.questions as! Set<NSManagedObject>).sorted(by: {
            Int(($0 as! Question).order) < Int(($1 as! Question).order)
        })
        
        let question = self.getNthQuestion(questions: questions, n: questionNo)!
        
        if question.imageUrl != "" {
            
            self.questionImage.image = UIImage(named: "no-image")
            self.questionImage.isHidden = false
            
            Util.downloadImage(url: URL(string: question.imageUrl!)!, completition: { image in
                DispatchQueue.main.async {
                    self.questionImage.image = image
                }
            })
        } else {
            self.questionImage.isHidden = true
            self.questionImage.image = nil
        }
        
        
        if question.text != "" {
            self.questionLabel.text = question.text
            self.questionLabel.isHidden = false
        } else {
            self.questionLabel.isHidden = true
        }
        
        self.removeSubviews(containerView: answersStackView)
        
        let answers = question.answers as! Set<NSManagedObject>
        
        for (index, answer) in answers.enumerated() {
            
            let answer = answer as! Answer
            let answerBtn = createButton(answer: answer)
            
            UIView.animate(withDuration: 0.5, delay: TimeInterval(CGFloat(0.5) * CGFloat(index)), animations: {
                answerBtn.alpha = 1
            })
            
            answerOptions.append(answerBtn)
            
            answersStackView.addArrangedSubview(answerBtn)
        }
        
        answersStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.disableAnswers(state: false)
        self.disableNextBtn(state: true)
    }
    
    private func createButton(answer: Answer) -> AnswerOption {
    
        let answerBtn = AnswerOption(type: UIButtonType.system)
        
        answerBtn.translatesAutoresizingMaskIntoConstraints = false
        answerBtn.addTarget(self, action: #selector(self.onBtnSelectAnswer), for: .touchUpInside)
        answerBtn.setTitle(answer.text, for: UIControlState.normal)
        answerBtn.titleLabel?.textAlignment = .center
        answerBtn.contentVerticalAlignment = .center
        answerBtn.backgroundColor = ColorUtil.primaryBlue()
        answerBtn.setTitleColor(UIColor.white, for: .normal)
        answerBtn.setTitleColor(UIColor.darkGray, for: .selected)
        
        answerBtn.isCorrect = answer.isRight
        
        return answerBtn
    }
    
    private func removeSubviews(containerView: UIView) {
        for view in containerView.subviews{
            view.removeFromSuperview()
        }
    }
    
    private func getNthQuestion(questions: [NSManagedObject], n: Int) -> Question? {
        
        for (index, question) in questions.enumerated() {
            
            if index == n {
                return question as? Question
            }
        }
        
        return nil
    }
    
    @objc fileprivate func onBtnSelectAnswer(sender: Any) {
        
        let answer = sender as! AnswerOption
        
        processAnswer(answer: answer)
    }
    
    private func processAnswer(answer: AnswerOption) {
        
        self.disableAnswers(state: true)
        self.disableNextBtn(state: false)
        
        var color: UIColor!
        
        if answer.isCorrect {
            color = UIColor.green
            self.correctAnswers = correctAnswers + 1
        } else {
            color = UIColor.red
        }
        
        UIView.transition(
            with: answer,
            duration: 0.6,
            options: [.transitionFlipFromTop],
            animations: {
                answer.backgroundColor = color
                answer.setTitleColor(UIColor.black, for: .normal)
            },
            completion: nil
        )
    }
    
    private func disableNextBtn(state: Bool) {
        
        self.nextBtn.isEnabled = !state
        self.nextBtn.backgroundColor = !state ? ColorUtil.primaryBlue() : UIColor.lightGray
    }
    
    private func disableAnswers(state: Bool) {
        
        answerOptions.enumerated().forEach {
            $0.element.isEnabled = !state
        }
    }
    
    @IBAction func onBtnNext(_ sender: Any) {
        
        qNo = qNo+1
        
        if qNo >= (_quiz.questions?.count)! {
            performSegue(withIdentifier: finishQuizSegueID, sender: self)
        } else {
            setupQuiz(quiz: self._quiz, questionNo: qNo)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == finishQuizSegueID {
            
            if let quizResultView = segue.destination as? QuizResultController {
                quizResultView.resultCurrent = NSDecimalNumber(decimal: Decimal(self.correctAnswers))
                quizResultView.resultMax = NSDecimalNumber(decimal: Decimal(self._quiz.questions!.count))
                quizResultView.scoring = self._quiz.scoring as? Set<NSManagedObject>
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

