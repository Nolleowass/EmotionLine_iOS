//
//  EmotionLineAPI.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import RxSwift
import Moya

enum EmotionLineAPI {
    case login(_ id: String, _ password: String)
    case changeUsername(_ username: String)
    case changeMyDiaryAccess(_ isPublic: Bool)
    
    /// 내가 조회한 프로필
    case myProfileList
    
    case createDiary(_ content: String)
    case editDiary(_ diaryId: Int, _ content: String)
    case deleteDiary(_ diaryId: Int)
    case getDiaryList(_ userId: String, _ year: Int, _ month: Int)
    
    /// 내 프로필을 조회한 사람
    case anotherProfileList
}

extension EmotionLineAPI: BaseAPI {
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .changeUsername:
            return "/auth/name"
        case .changeMyDiaryAccess:
            return "/auth/is_public"
        case .myProfileList:
            return "/auth/profile/list"
        case .createDiary:
            return "/diary"
        case .editDiary(let diaryId, _):
            return "/diary/\(diaryId)"
        case .deleteDiary(let diaryId):
            return "/diary/\(diaryId)"
        case .getDiaryList(let userId, _, _):
            return "/diary/list/\(userId)"
        case .anotherProfileList:
            return "/profile/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .createDiary:
            return .post
        case .changeUsername, .changeMyDiaryAccess, .editDiary:
            return .put
        case .myProfileList, .anotherProfileList, .getDiaryList:
            return .get
        case .deleteDiary:
            return .delete
        }
    }
    
    var headers: [String: String]? {
        var header = [String: String]()
        header = ["Content-Type": "application/json"]
        
        if let token = UserDefaultsService().getToken() {
            header = ["token": token]
        }
        
        return header
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(let id, let password):
            return [
                "user_id": id,
                "password": password
            ]
        case .changeUsername(let username):
            return [
                "user_name": username
            ]
        case .changeMyDiaryAccess(let isPublic):
            return [
                "is_public": isPublic
            ]
        case .createDiary(let content):
            return [
                "content": content
            ]
        case .editDiary(_, let content):
            return [
                "content": content
            ]
        case .getDiaryList(_, let year, let month):
            return [
                "year": year,
                "month": month
            ]
        default:
            return nil
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .getDiaryList:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var task: Task {
        switch self {
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
            }
            return .requestPlain
        }
    }
}
