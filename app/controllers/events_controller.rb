class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group

  def index
    @events = @group.events
  end

  def new
    @event = @group.events.build
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    @event = @group.events.build(event_params)

    if @event.save
      redirect_to group_events_path(@group, @event), success: t('defaults.flash_message.created', item: Event.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Event.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy!
    redirect_to group_events_path(@group), success: t('defaults.flash_message.delete', item: Event.model_name.human), status: :see_other
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to group_events_path(@group), success: t('defaults.flash_message.updated', item: Event.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: Event.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def daily_schedule
    @date = Date.parse(params[:date])
    @events = @group.events.where('DATE(start_time) = ?', @date)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def event_params
    params.require(:event).permit(:title, :start_time, :end_time, :description, :group_id)
  end
end
