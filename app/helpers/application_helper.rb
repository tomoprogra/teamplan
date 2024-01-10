module ApplicationHelper
    def flash_background_color(key)
        case key.to_sym
        when :notice then "bg-green-500"
        when :alert  then "bg-red-500"
        else "bg-gray-500"
        end
      end
end
