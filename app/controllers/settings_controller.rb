class SettingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter  do
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
  end

  def index
    @sync = Synchronization.where(:table_name => Client.to_s).last
  end

  def sync
    result = SynchronizeClients.sync
    redirect_to settings_path, :notice => result
  end
end
