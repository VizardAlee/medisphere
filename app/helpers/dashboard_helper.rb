module DashboardHelper
  def no_records_message(resource_name, action = nil)
    message = "No #{resource_name.pluralize} records found."
    message += " #{action} above." if action
    message
  end
end
