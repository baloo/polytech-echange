module Exceptions
  class UserAccessDeniedError < StandardError
    def initialize(msg = "Access Denied")
      super(msg)
    end
  end
  class UserCreateDeniedError < UserAccessDeniedError
    def initialize(msg = "Object Creation Denied")
      super msg
    end
  end
  class UserDeleteDeniedError < UserAccessDeniedError
    def initialize(msg = "Object Deletion Denied")
      super msg
    end
  end
  class UserEditDeniedError < UserAccessDeniedError
    def initialize(msg = "Object Update Denied")
      super msg
    end
  end
end
