# app/controllers/calendars_controller.rb
class CalendarsController < ApplicationController
  # 週間のカレンダーと予定を取得するメソッド
  def get_week(start_date)
    wdays = ['(日)', '(月)', '(火)', '(水)', '(木)', '(金)', '(土)']
    week_days = []

    plans = Plan.where(date: start_date..start_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == start_date + x
      end

      day = start_date + x
      days = {
        month: day.month,
        date: day.day,
        day_of_week: wdays[day.wday], # 曜日を取得して追加
        plans: today_plans
      }
      week_days.push(days)
    end

    week_days
  end

  # １週間のカレンダーと予定が表示されるページ
  def index
    @todays_date = Date.today
    @week_days = get_week(@todays_date)
    @plan = Plan.new
  end

  # 予定の保存
  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      redirect_to action: :index
    else
      # 保存が失敗した場合の処理
      # 例えば、エラーメッセージを表示するなど
      @todays_date = Date.today
      @week_days = get_week(@todays_date)
      render :index
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end
end
