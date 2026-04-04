//  Created on 21.03.25

import Dispatch

final class LaunchScreenInteractor {
	weak var output: LaunchScreenInteractorOutput?
}

extension LaunchScreenInteractor: LaunchScreenInteractorInput {
    func start() {
        output?.presentLoadingAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.output?.presentOnboarding()
        }
    }
    
// TODO: Сделать проверку на первый запуск и на авторизацию
}
