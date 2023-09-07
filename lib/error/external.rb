module Error
  module External
    class InternalServerError < ServerError ; end
    class WrongRequestFormat  < BadRequest ; end
    class AccessNotProvided   < AccessError ; end
  end
end