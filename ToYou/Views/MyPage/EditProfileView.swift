//
//  EditProfileView.swift
//  ToYou
//
//  Created by 이승준 on 2/23/25.
//

import UIKit

class EditProfileView: UIView {
    
    private let navigationBarHeight = 55
    private let tabBarHeight = 68
    
    public var isNicknameChecked: Bool = false
    public var newNickname: String?
    public var originalUserType: UserType?
    public var newUserType: UserType?
    
    public lazy var navigationBar = CustomNavigationBar()
        
    private lazy var profileImage = UIImageView().then {
        $0.image = .defaultProfile
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 61
    }
    
    // MARK: Nickname Editing
    private lazy var nicknameEditFrame = UIView()
    
    private lazy var nicknameEditLabel = UILabel().then {
        $0.text = "수정할 닉네임을 알려주세요."
        $0.textColor = .black04
        $0.font = UIFont(name: K.Font.s_core_regular, size: 16)
    }
    
    public lazy var nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력해주세요."
        $0.textColor = .black04
        $0.tintColor = .black01
        $0.font = UIFont(name: K.Font.s_core_light, size: 15)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 7
        
        $0.enablesReturnKeyAutomatically = false
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
    }
    
    private lazy var warningLabel = UILabel().then {
        $0.text = "중복된 닉네임인지 확인해주세요."
        $0.font = UIFont(name: K.Font.s_core_light, size: 13)
        $0.textColor = .black04
    }
    
    public lazy var maxTextLength = UILabel().then {
        $0.text = "(0/15)"
        $0.font = UIFont(name: K.Font.s_core_light, size: 13)
        $0.textColor = .gray00
    }
    
    public lazy var overlappedCheck = CheckButton()
    
    // MARK: User Type
    private lazy var userTypeMainFrame = UIView()
    
    private lazy var userTypeMainLabel = UILabel().then {
        $0.text = "현재 상태를 알려주세요."
        $0.font = UIFont(name: K.Font.s_core_regular , size: 16)
        $0.textColor = .black04
    }
    
    public lazy var studentButton = UserTypeButton()
    public lazy var collegeButton = UserTypeButton()
    public lazy var workerButton = UserTypeButton()
    public lazy var etcButton = UserTypeButton()
    
    // MARK: Confirm Button
    public lazy var completeButton = ConfirmButton()
    
    public lazy var scrollView = UIScrollView().then {
        $0.bounces = false
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        self.signUpTopTitleComponents()
        self.addLeftViewInTextField(self.nicknameTextField)
        self.overlappedCheck.unavailable()
    }
    
//    public func checkAnyInfoChanged() {
//        if isNicknameChecked || (newUserType != originalUserType && newUserType != nil ){
//            print("available \(isNicknameChecked) \(newUserType != originalUserType)")
//            completeButton.available()
//        } else {
//            completeButton.unavailable()
//        }
//    }
    
    public func resetNickname() {
        isNicknameChecked = false
        newNickname = nil
    }
    
    public func resetUserType() {
        originalUserType = newUserType
        newUserType = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: 사용자 정보를 불러온 후, 뷰를 구성
extension EditProfileView {
    
    public func configure( result: MyPageResult) {
        nicknameTextField.text = result.nickname
        originalUserType = result.status
        switch result.status {
        case .SCHOOL:
            studentButton.selectedView()
        case .COLLEGE:
            collegeButton.selectedView()
        case .OFFICE:
            workerButton.selectedView()
        case .ETC:
            etcButton.selectedView()
        default :
            break
        }
    }
    
    public func updateNewUserType() {
        let buttons = [studentButton, collegeButton, workerButton, etcButton]
        for btn in buttons {
            if btn.returnUserType() == originalUserType {
                print("유저 타입은 \(btn.returnUserType())입니다.")
                btn.selectedView()
            } else {
                btn.notSelectedView()
            }
        }
    }
    
    public func returnUserType() -> UserType? {
        return originalUserType
    }
}

// MARK: 닉네임 수정 관련 동작
extension EditProfileView {
    
    public func defaultState() { // 기본 상태 or 텍스트가 없는 상태
        warningLabel.text = "중복된 닉네임인지 확인해주세요."
        warningLabel.textColor = .black04
        overlappedCheck.unavailable()
    }
    
    public func properTextLength() { // 입력중, 텍스트 길이가 정상적인 경우
        warningLabel.text = "중복된 닉네임인지 확인해주세요."
        warningLabel.textColor = .black04
        overlappedCheck.available()
    }
    
    public func textLengthWarning() { // 입력중, 텍스트 길이가 15자를 넘는 경우
        warningLabel.text = "15자 이내로 입력해주세요."
        warningLabel.textColor = .black04
        overlappedCheck.unavailable()
    }
    
    public func satisfiedNickname() { // 확인 결과, 사용 가능한 닉네임
        warningLabel.text = "사용 가능한 닉네임입니다."
        warningLabel.textColor = .red02
    }
    
    public func unsatisfiedNickname() { // 확인 결과, 중복된 닉네임
        warningLabel.text = "이미 사용 중인 닉네임입니다."
        warningLabel.textColor = .red02
        overlappedCheck.unavailable()
    }
    
    public func updatedNickname() { // 성공적으로 바뀐다면, 닉네임이 업데이트 되었습니다.
        warningLabel.text = "성공적으로 닉네임이 반영되었습니다."
        warningLabel.textColor = .black04
        overlappedCheck.unavailable()
    }
    
}

// MARK: 제약사항 관리
extension EditProfileView {
    
    public func setConstraints() {
        let screenWidth = UIScreen.main.bounds.width
        // let screenHeight = UIScreen.main.bounds.height
        
        scrollView.contentSize = CGSize(width: screenWidth , height: 700)
        
        self.setScrollViewComponents()
        self.setProfileImageComponents()
        self.setNicknameEditComponents()
        self.setUserTypeEditComponents()
        self.setCompleteButtonComponents()
    }
    
    private func setScrollViewComponents() {
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview() // 추가
            make.width.equalTo(self.safeAreaLayoutGuide.snp.width)
            make.top.equalTo(navigationBar.dividerLine.snp.bottom)
        }
    }
    
    private func setProfileImageComponents() {
        scrollView.addSubview(profileImage)
        
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(122)
            make.top.equalTo(scrollView.snp.top).offset(40)
        }
    }
        
    private func setNicknameEditComponents() {
        scrollView.addSubview(nicknameEditFrame)
        
        nicknameEditFrame.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(30)
            make.width.equalToSuperview().offset(-60)
            make.height.equalTo(90)
        }
        
        nicknameEditFrame.addSubview(nicknameEditLabel)
        nicknameEditFrame.addSubview(overlappedCheck)
        nicknameEditFrame.addSubview(nicknameTextField)
        nicknameEditFrame.addSubview(warningLabel)
        
        nicknameEditLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        overlappedCheck.snp.makeConstraints { make in
            make.top.equalTo(nicknameEditLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(40)
            make.trailing.equalTo(overlappedCheck.snp.leading).offset(-10)
            make.top.equalTo(nicknameEditLabel.snp.bottom).offset(10)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(9)
            make.leading.equalToSuperview()
        }
        
    }
    
    private func setUserTypeEditComponents() {
        scrollView.addSubview(userTypeMainFrame)
        
        userTypeMainFrame.snp.makeConstraints { make in
            make.top.equalTo(nicknameEditFrame.snp.bottom).offset(62)
            make.leading.equalToSuperview().offset(30)
            make.width.equalToSuperview().offset(-60)
            make.height.equalTo(220)
        }
        
        userTypeMainFrame.addSubview(userTypeMainLabel)
        userTypeMainFrame.addSubview(studentButton)
        userTypeMainFrame.addSubview(collegeButton)
        userTypeMainFrame.addSubview(workerButton)
        userTypeMainFrame.addSubview(etcButton)
        
        studentButton.configure(userType: .SCHOOL)
        collegeButton.configure(userType: .COLLEGE)
        workerButton.configure(userType: .OFFICE)
        etcButton.configure(userType: .ETC)
        
        userTypeMainLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        studentButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(userTypeMainLabel.snp.bottom).offset(10)
        }
        
        collegeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(studentButton.snp.bottom).offset(10)
        }
        
        workerButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(collegeButton.snp.bottom).offset(10)
        }
        
        etcButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(workerButton.snp.bottom).offset(10)
        }
        
    }
    
    private func setCompleteButtonComponents() {
        scrollView.addSubview(completeButton)
        
        completeButton.configure(labelText: "완료")
        
        completeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.width.equalToSuperview().offset(-60)
            make.height.equalTo(43)
            make.top.equalTo(userTypeMainFrame.snp.bottom).offset(30)
        }
    }
    
    private func signUpTopTitleComponents() {
        self.addSubview(navigationBar)
        
        navigationBar.configure(with: "프로필 수정")
        navigationBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
