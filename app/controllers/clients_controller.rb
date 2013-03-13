class ClientsController < ApplicationController
  inherit_resources
  belongs_to :group, :optional => true

  before_filter :authenticate_user!
  before_filter  do
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
  end

  protected
  def collection
    @clients ||= end_of_association_chain.paginate(:page => params[:page])
  end
  
end
