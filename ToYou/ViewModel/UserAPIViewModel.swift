//
//  UserViewModel.swift
//  ToYou
//
//  Created by 이승준 on 6/30/25.
//

import Combine
import Alamofire
import Foundation

let UserViewModel = UserAPIViewModel.shared

final class UserAPIViewModel: ObservableObject {
    
    // 책임
    // 사용자 정보를 가져온다.
    // 닉네임을 검사하고 사용 불가능하다면 그 이유도 알려준다.
    // 사용자 타입을 설정한다.
    // 현재 선택된 사용자 타입으로 바꿀 수 있는지 알려준다.
    // 수정 가능
    // userInfo와 viewController에서 선택한 내용에 따라 수정 완료 버튼 활성화를 결정한다.
    // userInfo 수정이 된다면 버튼을 누를 수 있는 여부도 확인해야 한다.
    @Published var userInfo: MyPageResult?
    @Published var isLoading: Bool = false
    
    @Published var selectedUserType: UserType?
    
    @Published var newNickName: String?
    @Published var isNickNameValid: Bool = false
    
    @Published var isChangeable: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    func defaultMode() {
        selectedUserType = nil
        newNickName = nil
        isNickNameValid = false
        isChangeable = false
    }
    
    init() {
        
        self.$selectedUserType
            .receive(on: DispatchQueue.main)
            .sink{ selectedUserType in
                if (selectedUserType != self.userInfo?.status && selectedUserType != nil)
                    || self.isNickNameValid {
                    print("\(selectedUserType != self.userInfo?.status && selectedUserType != nil) || \(self.isNickNameValid)")
                    self.isChangeable = true
                } else {
                    self.isChangeable = false
                }
            }
            .store(in: &cancellables)
        
        self.$isNickNameValid
            .receive(on: DispatchQueue.main)
            .sink{ isNickNameValid in
                if (self.selectedUserType != self.userInfo?.status && self.selectedUserType != nil)
                    || isNickNameValid {
                    self.isChangeable = true
                } else {
                    self.isChangeable = false
                }
            }
            .store(in: &cancellables)
        
    }
    
    static let shared = UserAPIViewModel()
    
    func fetchUser( retry: Bool = false, completion: @escaping(UserCode) -> Void) {
        let url = K.URLString.baseURL + "/users/mypage"
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [
            "accept" : " ",
            "Authorization": "Bearer " + accessToken,
        ]
        AF.request(
            url,
            method: .get,
            headers: headers
        ).responseDecodable(of: ToYouResponse<MyPageResult>.self) { [weak self] response in
            switch response.result {
            case .success(let apiResponse):
                let code = apiResponse.code
                switch code {
                case UserCode.success.rawValue :
                    self?.userInfo = apiResponse.result
                    completion(.success)
                case UserCode.expired.rawValue: // access token이 만료된 경우
                    if !retry { // refresh token을 통해 재발급 시도
                        AuthAPIService.reissueRefreshToken { [weak self] code in
                            switch code {
                            case .success:
                                self?.fetchUser(retry: true) { [weak self] code in
                                    switch code {
                                    case .success:
                                        self?.userInfo = apiResponse.result
                                    case .expired:
                                        completion(.expired)
                                    case .error:
                                        print("fetch user info error")
                                        completion(.error)
                                    }
                                }
                            case .expired:
                                completion(.expired)
                            case .error:
                                print("reissue token error")
                                completion(.error)
                            }
                        }
                    }
                    completion(.expired)
                default:
                    print("fetch user info error")
                    completion(.error)
                }
            case .failure(let error):
                completion(.error)
                print(error)
            }
        }
    }
    
    func changeUserType(to type: UserType?) {
        self.selectedUserType = type
    }
    
    func checkNickNameAvailability(_ nickName: String, completion: @escaping(NicknameCheckMode) -> Void) {
        UserAPINetworkService.checkNickNameAvailability(nickName: nickName) { response in
            switch response.result {
            case .success(let result):
                if result.result!.exists {
                    self.newNickName = nil
                    self.isNickNameValid = false
                    completion(.unavailable)
                } else {
                    self.newNickName = nickName
                    self.isNickNameValid = true
                    completion(.available)
                }
            case .failure(let failure):
                print("#checkNickNameAvailability failure: \(failure)")
            }
        }
    }
    
    private func updateNickName(completion: @escaping(Bool) -> Void) {
        UserAPINetworkService.patchNickName(self.newNickName!) { response in
            switch response.result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    private func updateUserType(completion: @escaping(Bool) -> Void) {
        UserAPINetworkService.patchUserType(selectedUserType!) { response in
            switch response.result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func updateUserInfo() {
        if isNickNameValid {
            self.updateNickName() { isSucceed in
            }
        }
        if  selectedUserType != self.userInfo?.status && self.selectedUserType != nil {
            self.updateUserType() { isSucceed in
            }
        }
    }
    
}

enum NicknameCheckMode: String, Decodable {
    case available, unavailable
}

enum UserAPINetworkService {
    static func checkNickNameAvailability(nickName: String, completion: @escaping ((DataResponse<ToYouResponse<NicknameCheckResult>, AFError>) -> Void)) {
        let tail = "/users/nickname/check"
        let url = K.URLString.baseURL + tail + "?nickname=\(nickName)"
        let headers: HTTPHeaders = [
            "accept": "*/*",
        ]
        AF.request( url, method: .get, headers: headers
        ).responseDecodable(of: ToYouResponse<NicknameCheckResult>.self) { response in
            completion(response)
        }
    }
    
    static func patchNickName(_ nickName: String, completion: @escaping ((DataResponse<ToYouResponseWithoutResult, AFError>) -> Void)) {
        let tail = "/users/nickname"
        let url = K.URLString.baseURL + tail
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer " + accessToken,
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "nickname": nickName
        ]
        URLSession.generateCurlCommand(url: url, method: .patch, headers: headers, parameters: parameters)
        AF.request(
            url,
            method: .patch,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .responseDecodable(of: ToYouResponseWithoutResult.self) { response in
            completion(response)
        }
    }
    
    static func patchUserType(_ type: UserType, completion: @escaping ((DataResponse<ToYouResponse<EmptyResult>, AFError>) -> Void)) {
        let tail = "/users/status"
        let url = K.URLString.baseURL + tail
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer " + accessToken,
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "status": type.rawValue
        ]
        AF.request(
            url,
            method: .patch,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .responseDecodable(of: ToYouResponse<EmptyResult>.self) { response in
            completion(response)
        }
    }
    
    
}
