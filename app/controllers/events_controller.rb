class EventsController < ApplicationController
  include MembershipCheck
  before_action :authenticate_user!
  before_action :set_group

  def index
    @events = @group.events
    @event = @group.events.build
  end

  def new
  @event = @group.events.build

    # params[:date]が存在する場合のみDateTime.parseを使用
    if params[:date].present?
      @event.start_time = DateTime.parse(params[:date])
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    @event = @group.events.build(event_params)

    if @event.save
      redirect_to group_events_path(@group, @event), success: t('defaults.flash_message.created', item: Event.model_name.human)
    else
      flash[:danger] = @event.errors.full_messages.join(', ')
      redirect_to request.referer and return
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
    
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to request.referer }
        format.turbo_stream { flash.now[:success] = "イベントを更新しました。" }
      else
        format.html { redirect_to request.referer }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@event, partial: "form", locals: { event: @event }) }
      end
    end
  end

  def daily_schedule
    @event = @group.events.build
    @date = params[:date].to_date
    @group = Group.find(params[:group_id])
  
    # この日付がイベントの開始日または終了日の範囲内にあるイベントを取得
    @events = Event.where('start_time <= ? AND end_time >= ?', @date.end_of_day, @date.beginning_of_day)
                   .where(group_id: @group.id)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def event_params
    params.require(:event).permit(:title, :start_time, :end_time, :description, :group_id)
  end
end
