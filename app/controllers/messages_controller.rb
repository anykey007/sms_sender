class MessagesController < ApplicationController
  inherit_resources
  belongs_to :client, :group, :polymorphic => true, :optional => true
  respond_to :js

  before_filter :authenticate_user!
  before_filter  do
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
  end
end
