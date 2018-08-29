class User < ApplicationRecord

  include BaseModelConcern

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def self.sign_in(options)
    object_key = nil
    response   = Response.rescue do |res|
      account, password = options.values_at(:phone, :password)

      res.raise_error('登录信息不完整') if account.blank? || password.blank?

      user = self.where('users.email = :keyword', keyword: account).first

      res.raise_error("账号:#{account}的用户不存在") if user.blank?

      res.raise_error('请输入正确的登录密码') if user.valid_password?(password) == false

      object_key = Aes.object_encrypt(user.id, 'User').chomp!.delete('+')

      session_key = SessionKey.new(session_key: object_key, user_id: user.id)

      session_key.save!

    end
    return [response, object_key]
  end

end

