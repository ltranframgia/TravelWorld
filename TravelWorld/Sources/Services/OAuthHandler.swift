import Alamofire
import FirebaseAuth
import SwiftyJSON

class OAuthHandler: RequestAdapter, RequestRetrier {

    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void

    private static let keyRefreshToken: String = "OAuth_Refresh_Token"

    private static let keyAccessToken: String = "OAuth_Access_Token"

    private static let keyTokenType: String = "OAuth_Token_Type"

    private static let keyClientId: String = "OAuth_Client_Id"

    private var clientId: String? {
        get {
            let userDefault = UserDefaults.standard
            return userDefault.string(forKey: OAuthHandler.keyClientId)
        }
        set {
            let userDefault = UserDefaults.standard
            userDefault.set(newValue, forKey: OAuthHandler.keyClientId)
        }
    }

    private var accessToken: String? {
        get {
            let userDefault = UserDefaults.standard
            return userDefault.string(forKey: OAuthHandler.keyAccessToken)
        }
        set {
            let userDefault = UserDefaults.standard
            userDefault.set(newValue, forKey: OAuthHandler.keyAccessToken)
        }
    }

    private var refreshToken: String? {
        get {
            let userDefault = UserDefaults.standard
            return userDefault.string(forKey: OAuthHandler.keyRefreshToken)
        }
        set {
            let userDefault = UserDefaults.standard
            userDefault.set(newValue, forKey: OAuthHandler.keyRefreshToken)
        }
    }

    private var tokenType: String? {
        get {
            let userDefault = UserDefaults.standard
            return userDefault.string(forKey: OAuthHandler.keyTokenType)
        }
        set {
            let userDefault = UserDefaults.standard
            userDefault.set(newValue, forKey: OAuthHandler.keyTokenType)
        }
    }

    private let lock = NSLock()

    private var baseUrl: String?

    private var isRefreshing = false

    private var requestsToRetry: [RequestRetryCompletion] = []

    // MARK: - Initialization
    init(accessToken: String?, refreshToken: String? ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    init(baseUrl: String?) {
        self.baseUrl = baseUrl
    }

    //    func parse(jsonObject: AnyObject?) -> Bool {
    //
    //        guard let jsonData = jsonObject else { return false }
    //
    //        // using SwiftyJSON
    //        let json = JSON(jsonData)
    //
    //        // parse
    //        if let accessToken = json[JSONKey.accessToken].string,
    //            let refreshToken = json[JSONKey.refreshToken].string {
    //            self.accessToken = accessToken
    //            self.refreshToken = refreshToken
    //            return true
    //        }
    //
    //        return false
    //    }

    // MARK: - RequestAdapter
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if let _accessToken = self.accessToken,
            let _baseUrl = self.baseUrl,
            let urlString = urlRequest.url?.absoluteString,
            urlString.hasPrefix(_baseUrl) {
            urlRequest.setValue("Bearer " + _accessToken, forHTTPHeaderField: HeaderKey.Authorization)
        }

        return urlRequest
    }

    // MARK: - RequestRetrier
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock()

        defer {
            lock.unlock()
        }

        if let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == HttpStatusCode.unauthorized.rawValue {
            self.requestsToRetry.append(completion)

            if !self.isRefreshing {

                // refresh token
                self.refreshTokens { [weak self] (succeeded, accessToken, refreshToken ) in
                    guard let strongSelf = self else { return }

                    strongSelf.lock.lock()

                    defer {
                        strongSelf.lock.unlock()
                    }

                    if let accessToken = accessToken,
                        let refreshToken = refreshToken {
                        strongSelf.accessToken = accessToken
                        strongSelf.refreshToken = refreshToken
                    }

                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }

    // MARK: - Private - Refresh Tokens
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }

        self.isRefreshing = true

        // refresh token
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { [weak self] (idToken, _) in
            guard let strongSelf = self else { return }
            if let accessToken = idToken,
                let refreshToken = Auth.auth().currentUser?.refreshToken {
                completion(true, accessToken, refreshToken)
            } else {
                completion(false, nil, nil)
            }

            strongSelf.isRefreshing = false
        })
    }
}
