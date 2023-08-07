module ApplicationHelper
    def full_title(title)
        if !title.blank?
            "Sample App Second || #{title}"
        else
            "Sample App Second"
        end
    end
end
