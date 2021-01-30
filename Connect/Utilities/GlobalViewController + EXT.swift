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
