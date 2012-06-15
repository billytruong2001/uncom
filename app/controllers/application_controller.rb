class ApplicationController < ActionController::Base
	before_filter :set_locale

	protect_from_forgery
  include SessionsHelper

	def set_locale
	  I18n.locale = params[:locale]
	  # current_user.locale
	  # request.subdomain
	  # request.env["HTTP_ACCEPT_LANGUAGE"]
	  # request.remote_ip
	end

  def default_url_options(options={})
	  logger.debug "default_url_options is passed options: #{options.inspect}\n"
	  { :locale => ((I18n.locale == I18n.default_locale) ? nil : I18n.locale) }
	end
end
