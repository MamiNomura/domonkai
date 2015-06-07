module ActiveAdmin
  module Views
    class Footer < Component

      def build
        super :id => "footer"
        super :style => "display: none"

        div do
          small "Domonkai #{Date.today.year}"
        end
      end

    end
  end
end