module ApplicationHelper
  def is_current_provider?
    (@authentications.map{|a|a.provider}).include?('twitter')
  end
end
