module Error
  module Internal
    class AppSecretNotReceived     < Invalid ; end
    class ExternalAppSecretInvalid < Invalid ; end
    class UnsupportedDataFormat    < Invalid ; end
    class MissingRequiredFields    < Invalid ; end
    class ListOfPersonsLimitExceeded < Invalid; end
  end
end
