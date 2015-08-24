class DomonAdminAuthorization < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)

    # Super user can do anything
    if user.role == "super"
      true

    elsif user.role == "" || user.role.nil?
      # user with no rule can only view Dougu
      if action == :read
        case subject
        when normalized(Dougu)
          # ippan can only read dougu, nothing more
          true
        else
          false
        end
      else
        false
      end
    else
      # ppl with some sort of roles
      if action == :read
        true
      else
        case subject
          when normalized(Dougu)
            if action == :read
              true
            else
              user.role == "dougu"
            end
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
          when normalized(AdminUser)
            true
          else
            false
        end
      end
    end
  end
end