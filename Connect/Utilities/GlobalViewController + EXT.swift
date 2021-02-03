//
//  GlobalViewController + EXT.swift
//  Content
//
//  Created by Leandro Diaz on 1/20/21.
//

//MARK:- GLOBAL VIEW CONTROLLER EXTENSIONS
//MARK:- GLOBAL VIEW CONTROLLER EXTENSIONS
//MARK:- GLOBAL VIEW CONTROLLER EXTENSIONS
import UIKit
import SafariServices
fileprivate var containerView: UIView!

extension UIViewController {

    
    //TitleAttributes
    func preferedTitleAppearance() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 26)]
    }
    
    //Present Login View Controller
    func showLoginViewController(){
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .custom
//        loginVC.transitioningDelegate = self
        present(loginVC, animated: true)
    }
    
    //Present Alert View Controller
    func showAlert(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = AlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle   = .overFullScreen
            alertVC.modalTransitionStyle     = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    //Present Success View Controller
    func showSuccess(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = AlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle   = .overFullScreen
            alertVC.modalTransitionStyle     = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    //Present Comments View Controller
//    needs the image
    func showComments(message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let commentsVC = CommentsViewController(message: message, buttonTitle: "Post")
            commentsVC.modalPresentationStyle   = .overFullScreen
            commentsVC.modalTransitionStyle     = .crossDissolve
            self.present(commentsVC, animated: true)
        }
    }
    
    //present delete coments
    func deleteComments(_ sender: UIButton?){
        DispatchQueue.main.async {
            let commentsVC = UIAlertController(title: "Remove Coment", message: "Do you want to remove your comment?", preferredStyle: .alert)
            commentsVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancel) in
                self.dismiss(animated: true, completion: nil)
                sender?.tag = 1
                sender?.tintColor = .systemRed
            }))
            commentsVC.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (remove) in
                sender?.tag = 0
                self.dismiss(animated: true, completion: nil)
                
            }))
            self.present(commentsVC, animated: true, completion: nil)
        }
    }
    

    //present safari inside windows
    func presentSafariVC(with url: URL){
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemTeal
        present(safariVC, animated: true, completion: nil)
    }
    
    //EmptyState
    func showEmptyState(with message: String, in view: UIView){
        let emptyStateView = EmptyState(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    //Loading View for screens
    func showLoadingView(){
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0
        
        UIView.animate(withDuration: 0.5) {
            containerView.alpha = 0.9
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = CustomColors.CustomGreenLightBright
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    //dismissLoading View
    func dismissLoadingView() {
        DispatchQueue.main.async{
            containerView.removeFromSuperview()
        }
    }
    
    //RandomColors
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 0.7)
    }
    
    //CustomNavigationBar
    
    
}


extension UINavigationController {
    func removeThisViewController(_ controller: UIViewController.Type) {
        if let vc = viewControllers.first(where: {$0.isKind(of: controller.self) }) {
            vc.removeFromParent()
            print("removed")
        }
    }
}
