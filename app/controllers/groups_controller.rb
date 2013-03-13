class GroupsController < ApplicationController
  inherit_resources
  respond_to :html

  before_filter :authenticate_user!
  before_filter  do
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
  end
  
end
