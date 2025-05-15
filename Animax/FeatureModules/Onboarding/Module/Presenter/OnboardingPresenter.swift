//  Created on 09.05.25

import UIKit

final class OnboardingPresenter: BasePresenter
<
OnboardingModuleOutput, 
OnboardingInteractorInput, 
OnboardingRouterInputProtocol,
OnboardingViewInput
> {}

// MARK: Module Input
extension OnboardingPresenter: OnboardingModuleInput {}

// MARK: View Output
extension OnboardingPresenter: OnboardingViewOutput {
	func viewDidLoad() {
        interactor.start()
    }
}

// MARK: Interactor Output
extension OnboardingPresenter: OnboardingInteractorOutput {
    func presentStaticData() {
        view?.showBackgorundImage(UIImage(named: "onboarding_background") ?? UIImage())
        view?.showTitleLabel("Welcome to Animax")
        view?.showDescriptionLabel("The best streaming anime app of the century to entertain you every day")
        view?.showStartButton(
            DSButton.ViewModel(
                title: "Get started",
                leftSide: nil,
                rightSide: nil,
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .rounded
                )
            )
        )
    }
}
