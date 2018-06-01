module Xcover
  class Utils
    URL_REGEX = %r(^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$)

    def self.url?(string)
      URL_REGEX =~ string
    end
  end
end
