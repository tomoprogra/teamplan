class EventsController < ApplicationController
  def index
    @group = Group.find(params[:group_id])
    @events = @group.events
  end

  def new
    @group = Group.find(params[:group_id])
    @event = @group.events.build
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    @group = Group.find(params[:event][:group_id])
    @event = @group.events.build(event_parameter)

    if @event.save
      redirect_to group_events_path(@group, @event), notice: 'イベントを作成しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy!
    redirect_to events_path, notice:"削除しました", status: :see_other
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_parameter)
      redirect_to events_path, notice: "編集しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def daily_schedule
    @date = Date.parse(params[:date])
    @group = Group.find(params[:group_id])
    @events = @group.events.where('DATE(start_time) = ?', @date)
  end

  private

  def event_parameter
    params.require(:event).permit(:title, :start_time, :end_time, :description, :group_id)
  end
end
