import Foundation

import FirebaseAuth
import FirebaseFirestore

class SignUpViewModel {
    var email: String = ""
    var password: String = ""
    var errorMessage: String?
    var isSignUpSuccessful: ((Bool) -> Void)?
    
    func signUP() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.isSignUpSuccessful?(false)
            } else if let result = result {
                self?.isSignUpSuccessful?(true)
                
                // Firestore에 사용자 정보 저장
                   let db = Firestore.firestore()
                   db.collection("users").document(result.user.uid).setData([
                       "email": self?.email ?? "",
                       "createdAt": Timestamp()
                   ]) { error in
                       if let error = error {
                           print("Error saving user data: \(error)")
                       } else {
                           print("User data saved successfully.")
                       }
                   }
               }
           }
       }
   }
