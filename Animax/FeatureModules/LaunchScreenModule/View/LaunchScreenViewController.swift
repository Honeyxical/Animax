//  Created on 21.03.25

import UIKit

final class LaunchScreenViewController: BaseViewController {
	var output: LaunchScreenViewOutput?

    private let test = DSButton()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: Iconography.Main.logo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let activeIndicatorImageView: UIImageView = {
        let image = UIImageView(image: Iconography.Main.activeIndicator)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		output?.viewDidLoad()
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
    }
}

private extension LaunchScreenViewController {
    func setup() {
        view.addSubview(logoImageView)
        view.addSubview(activeIndicatorImageView)
        view.addSubview(test)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 350),
            logoImageView.heightAnchor.constraint(equalToConstant: 160),
            logoImageView.widthAnchor.constraint(equalToConstant: 160),
            
            activeIndicatorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activeIndicatorImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160),
            activeIndicatorImageView.heightAnchor.constraint(equalToConstant: 60),
            activeIndicatorImageView.widthAnchor.constraint(equalToConstant: 60),
            
            test.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            test.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            test.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        test.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
//        test.configure(
//            with: DSButton.ViewModel(
//                title: "Button",
//                leftSide: .image(image: Iconography.Bold.buy!, tintColor: Colors.Others.white),
//                rightSide: .image(image: Iconography.Bold.arrowRight!, tintColor: Colors.Others.white),
//                configuration: DSButton.ViewModel.Configuration(
//                    titleColor: Colors.Others.white,
//                    backgroundColor: Colors.Primary.primary,
//                    roundingCorner: .filled
//                )
//            )
//        )
        
        // act
        test.configure(
            with: DSButton.ViewModel(
                title: "Button when verrrry long value value value value value",
                leftSide: nil,
                rightSide: nil,
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .filled
                )
            )
        )
        
        
        startAnimation()
    }
    
    func startAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1.0
        rotation.speed = 0.5
        rotation.repeatCount = .infinity
        
        activeIndicatorImageView.layer.add(rotation, forKey: "spin")
    }
}
    
extension LaunchScreenViewController: LaunchScreenViewInput {
	func setOutput(_ output: LaunchScreenViewOutput) {
		self.output = output
	}
}
