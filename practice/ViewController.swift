//
//  ViewController.swift
//  practice
//
//  Created by Gabriel Castillo Serafim on 9/9/22.
//




//MARK: -   IMPORTANT !!! TO IMPLEMENT THIS FIRST THE CONSTRAINTS FOR THE TEXTFIELD MUST BE RELATIVE TO VIEW BOTTOM AND NOT THE SAFE AREA BOTTOM AND DON'T FORGET TO CHANGE THE TEXTFIELD HIGHT VARIABLE IN THE FUNCTION TO MATCH THE HEIGHT OF THE HEIGHT OF THE TEXT FIELD THAT IS BEING USED.



import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardHiding()
        hideKeyboardWhenTappedAround()
        
    }
    
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField
        else { return }
        
        // check if the top of the keyboard is above the bottom of the currently focused textbox
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        
        // if textField bottom is below keyboard bottom - bump the frame up
        if textFieldBottomY > keyboardTopY {
            let textFieldHeight:Double = 50
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY + textFieldHeight) * -1
            view.frame.origin.y = newFrameY
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
}

//MARK: - Checks textfield is being activated

extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    /// Finds the current first responder
    /// - Returns: the current UIResponder if it exists
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}

//MARK: - Make keyboard go away when touching anywhere

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
