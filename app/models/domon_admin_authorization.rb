class DomonAdminAuthorization < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)

    # Super user can do anything
    if user.role == "super"
      true
    else
      if action == :read
        # Give all access to read
        true
      else
        case subject
          when  normalized(AdminRole)
            true
          when normalized(Dougu)
            user.role == "dougu"
          when  normalized(DouguCategory)
            user.role == "dougu"
          when  normalized(DouguType)
            user.role == "dougu"
          when  normalized(DouguSubType)
            user.role == "dougu"
          when  normalized(Member)
            user.role == "membership"
          when  normalized(JapaneseMember)
            user.role == "membership"
          when  normalized(ShikakuKubun)
            user.role == "membership"
          else
            false
        end
      end
    end
  end
end