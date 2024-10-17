import RxSwift
import RxCocoa

class SetDestinationViewModel {
    let destinationInfoList = BehaviorRelay<[DestinationInformation]>(value: [])

    private let disposeBag = DisposeBag()

    init() {
        DestinationManager.shared.destinationInfoListObservable
            .bind(to: destinationInfoList)
            .disposed(by: disposeBag)
    }

    func loadDestinationInformationList(for userType: UserType) {
        if userType == .BUSINESS {
            DestinationManager.shared.loadBusinessDestinationInformationList(businessUserInfo: UserInfoManager.shared.getBussinessUserInfo())
        } else if userType == .PERSONAL {
            DestinationManager.shared.loadPersonalDestinationInformationList(personalUserInfo: UserInfoManager.shared.getPersonalUserInfo())
        }
    }
}
