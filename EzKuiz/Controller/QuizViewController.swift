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
    var answerOptions = [AnswerOption]()
    var _quiz: Quiz!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answersStackView: UIStackView!
    @IBOutlet var nextBtn: UIButton!
    var qNo = 0
    var correctAnswers = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupQuiz(quiz: self._quiz, questionNo: 0)
    }
    
    fileprivate func setupQuiz(quiz: Quiz, questionNo: Int) {
        
        if qNo >= (_quiz.questions?.count)! {
            return
        }
        
        let questions = (quiz.questions as! Set<NSManagedObject>).sorted(by: {
            Int(($0 as! Question).order) < Int(($1 as! Question).order)
        })
        let answers = self.getNthQuestion(questions: questions, n: questionNo)?.answers as! Set<NSManagedObject>
        
        self.questionLabel.text = self.getNthQuestion(questions: questions, n: questionNo)?.text
        
        self.removeSubviews(containerView: answersStackView)
        
        // Adding answer buttons.
        for (index, answer) in answers.enumerated() {
            
            let answer = answer as! Answer
            let answerBtn = AnswerOption(type: UIButtonType.system)
            let deviceSize = UIScreen.main.bounds.size
            let btnHeight = 70
            let btnWidth = Int(deviceSize.width-2*16)
            
            answerBtn.frame = CGRect(
                x: (Int(deviceSize.width)/2 - btnWidth/2 - 16),
                y: btnHeight*index + 16*index,
                width: btnWidth,
                height: btnHeight
            )
            answerBtn.addTarget(self, action: #selector(self.onBtnSelectAnswer), for: .touchUpInside)
            answerBtn.setTitle(answer.text, for: UIControlState.normal)
            answerBtn.titleLabel?.textAlignment = .center
            answerBtn.contentVerticalAlignment = .center
            answerBtn.backgroundColor = ColorUtil.primaryBlue()
            answerBtn.setTitleColor(UIColor.white, for: .normal)
            answerBtn.setTitleColor(UIColor.darkGray, for: .selected)
            
            answerBtn.isCorrect = answer.isRight
            
            answerOptions.append(answerBtn)
            
            answersStackView.addSubview(answerBtn)
        }
        
        self.disableAnswers(state: false)
        self.disableNextBtn(state: true)
    }
    
    fileprivate func removeSubviews(containerView: UIView) {
        for view in containerView.subviews{
            view.removeFromSuperview()
        }
    }
    
    fileprivate func getNthQuestion(questions: [NSManagedObject], n: Int) -> Question? {
        
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
    
    fileprivate func processAnswer(answer: AnswerOption) {
        
        self.disableAnswers(state: true)
        self.disableNextBtn(state: false)
        
        var color: UIColor!
        
        if answer.isCorrect {
            color = UIColor.green
            self.correctAnswers = correctAnswers + 1
        } else {
            color = UIColor.red
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            answer.backgroundColor = color
            
        }, completion: nil)
    }
    
    fileprivate func disableNextBtn(state: Bool) {
        
        self.nextBtn.isEnabled = !state
        self.nextBtn.backgroundColor = !state ? ColorUtil.primaryBlue() : UIColor.lightGray
    }
    
    fileprivate func disableAnswers(state: Bool) {
        
        answerOptions.enumerated().forEach {
            $0.element.isEnabled = !state
        }
    }
    
    @IBAction func onBtnNext(_ sender: Any) {
        
        qNo = qNo+1
        
        if qNo >= (_quiz.questions?.count)! {
            performSegue(withIdentifier: "finishQuizSegue", sender: self)
        } else {
            setupQuiz(quiz: self._quiz, questionNo: qNo)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finishQuizSegue" {
            
            let quizResultView = segue.destination as! QuizResultController
            quizResultView.result = "\(self.correctAnswers)/\(self._quiz.questions!.count ?? 0)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

