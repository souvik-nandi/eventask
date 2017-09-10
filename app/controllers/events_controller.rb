class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :show, :destroy]
  before_action :require_user
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @events = Event.paginate(page: params[:page], per_page: 5)
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      flash[:success] = "Event is succesfully created"
      redirect_to event_path(@event)
    else
      render 'new'
    end
  end

  def update
    if @event.update(event_params)
      flash[:success] = "Event was sucessfully updated"
      redirect_to event_path(@event)
    else
      render 'edit'
    end
  end

  def show
  end

  def destroy
    @event.destroy
    flash[:danger] = "Event was successfully deleted"
    redirect_to events_path
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :description)
    end

    def require_same_user
      if current_user != @event.user and !current_user.admin?
        flash[:danger] = "You can only edit or delete your own event"
        redirect_to root_path
      end 
    end
end