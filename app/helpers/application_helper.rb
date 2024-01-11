module ApplicationHelper
    def flash_background_color(key)
        case key.to_sym
        when :notice then "bg-green-50"
        when :success then "bg-green-50"
        when :alert  then "bg-red-50"
        else "bg-yellow-50"
        end
      end
end
