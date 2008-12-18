# This file is specifically for you to define your strategies 
#
# You should declare you strategies directly and/or use 
# Merb::Authentication.activate!(:label_of_strategy)
#
# To load and set the order of strategy processing

Merb::Slices::config[:"merb-auth-slice-password"][:no_default_strategies] = true

Merb::Authentication.activate!(:default_password_form)
Merb::Authentication.activate!(:default_openid)
Merb::Authentication.activate!(:default_basic_auth)


class Merb::Authentication::Strategies::Basic::OpenID
  def required_reg_fields
    %w[ fullname email ]
  end

  def find_user_by_identity_url(url)
    user_class.first(:identity_url => url)
  end

  def on_success!(response, sreg_response)
    if user = find_user_by_identity_url(response.identity_url)
      return user
    end

    sreg = sreg_response ? sreg_response.data : {}

    user = Merb::Authentication.user_class.new(
      :login       => sreg['fullname'],
      :email      => sreg['email'],
      :identity_url => response.identity_url
    )

    if user.save
      return user
    end

    request.session.authentication.errors.clear!
    request.session.authentication.errors.add(:openid, 'There was an error while creating your user account')

    nil
  end
end
