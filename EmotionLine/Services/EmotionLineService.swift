//
//  EmotionLineService.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import RxSwift

protocol EmotionLineServiceProtocol {
    // MARK: - Auth
    
    func login(_ id: String, _ password: String) -> Observable<Void>
    func changeUsername(_ username: String) -> Single<Void>
    func changeMyDiaryAccess(_ isPublic: Bool) -> Single<Void>
    
    /// 내가 조회한 프로필
    func myProfileList() -> Single<[User]>
    
    // MARK: - Diary
    
    func createDiary(_ content: String) -> Single<Void>
    func editDiary(_ diaryId: Int, _ content: String) -> Single<Void>
    func deleteDiary(_ diaryId: Int) -> Single<Void>
    func getDiaryList(_ userId: String, _ year: Int, _ month: Int) -> Single<[Diary]>
    
    
    // MARK: - Profile
    
    /// 내 프로필을 조회한 사람
    func anotherProfileList() -> Single<[User]>
    
    // MARK: - UserDefaultsService
    
    func checkIsLogin() -> Bool
    func logout()
    func getCurrentUserId() -> String
}

final class EmotionLineService: EmotionLineServiceProtocol {
    fileprivate let network: Network<EmotionLineAPI>
    private let userDefaultsService: UserDefaultsServiceProtocol
    
    init() {
        self.network = Network<EmotionLineAPI>(plugins: [RequestLoggingPlugin()])
        self.userDefaultsService = UserDefaultsService()
    }
    
    
    func login(_ id: String, _ password: String) -> Observable<Void> {
        return network.requestObject(.login(id, password), type: LoginResponse.self)
            .asObservable()
            .flatMap { [weak self] response -> Observable<Void> in
                let user = User(accountId: 0, isPublic: true, userId: response.userId, profileImageUrl: nil, username: "")
                self?.userDefaultsService.setUser(user: user)
                self?.userDefaultsService.setToken(token: response.token)
                return Observable.just(Void())
            }
    }
    
    func changeUsername(_ username: String) -> Single<Void> {
        return network.requestWithoutMapping(.changeUsername(username))
    }
    
    func changeMyDiaryAccess(_ isPublic: Bool) -> Single<Void> {
        return network.requestWithoutMapping(.changeMyDiaryAccess(isPublic))
    }
    
    func myProfileList() -> Single<[User]> {
        return network.requestArray(.myProfileList, type: User.self)
    }
    
    func createDiary(_ content: String) -> Single<Void> {
        return network.requestWithoutMapping(.createDiary(content))
    }
    
    func editDiary(_ diaryId: Int, _ content: String) -> Single<Void> {
        return network.requestWithoutMapping(.editDiary(diaryId, content))
    }
    
    func deleteDiary(_ diaryId: Int) -> Single<Void> {
        return network.requestWithoutMapping(.deleteDiary(diaryId))
    }
    
    func getDiaryList(_ userId: String, _ year: Int, _ month: Int) -> Single<[Diary]> {
        return network.requestObject(.getDiaryList(userId, year, month), type: List<Diary>.self)
            .map { $0.list }
    }
    
    func anotherProfileList() -> Single<[User]> {
        return network.requestArray(.anotherProfileList, type: User.self)
    }
    
    
    func checkIsLogin() -> Bool {
        if userDefaultsService.getToken() == nil {
            return false
        } else {
            return true
        }
    }
    
    func logout() {
        userDefaultsService.deleteUser()
        userDefaultsService.deleteToken()
    }
    
    func getCurrentUserId() -> String {
        let user = userDefaultsService.getUser()
        return user?.userId ?? ""
    }
}
