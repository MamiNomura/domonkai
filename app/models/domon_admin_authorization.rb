class DomonAdminAuthorization < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)

    # Super user can do anything
    if user.role == "super"
      true
    elsif user.role == "" || user.role.nil?
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
      # some sort of roles
      case subject
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