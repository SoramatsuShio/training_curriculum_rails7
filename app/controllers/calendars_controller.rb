class CalendarsController < ApplicationController
  # １週間のカレンダーと予定が表示されるページ

  def index
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    @todays_date = Date.today

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      day = @todays_date + x
      days = {
        month: day.month,
        date: day.day,
        day_of_week: wdays[day.wday], # 曜日を取得して追加
        plans: today_plans
      }
      @week_days.push(days)
    end

    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end
end
