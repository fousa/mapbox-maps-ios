@_exported import MapboxCommon
@_implementationOnly import MapboxCommon_Private

extension HttpRequestError: LocalizedError {
    /// Standardized error message
    public var errorDescription: String? {
        return message
    }
}

extension HttpResponse {
    /// Initialize a response given the initial request and `HttpResponseData` or
    /// `HttpRequestError`
    ///
    /// - Parameters:
    ///   - request: Original request
    ///   - result: Result type encapsulating response or error
    public convenience init(request: HttpRequest, result: Result<HttpResponseData, HttpRequestError>) {
        let expected: MBXExpected<AnyObject, AnyObject>
        switch result {
        case let .success(response):
            expected = MBXExpected(value: response)
        case let .failure(error):
            expected = MBXExpected(error: error)
        }

        self.init(request: request, result: expected)
    }

    /// Result of HTTP request call.
    public var result: Result<HttpResponseData, HttpRequestError> {

        guard let expected = __result as? MBXExpected<HttpResponseData, HttpRequestError>  else {
            fatalError("Invalid MBXExpected types or none.")
        }

        if expected.isValue() {
            return .success(expected.value!)
        } else {
            return .failure(expected.error!)
        }
    }
}
