# class AppointmentsController < ApplicationController
class AppointmentsController < Base
  def index
    @service_category_type = params[:service_category_type] || 'smm'
    puts("@service_category_type ::: #{@service_category_type}")

    # @search, @smm_appointments = smm_appointments_records
    # @search, @cx_appointments = cx_appointments_records
    # @appointments = Appointment.all
    #! 条件分岐必要 一時的にall
    # @search = Appointment.ransack(params[:q])
    @search, @all_appointments = all_appointments_records


    @appointments = @all_appointments
    puts("@appointments.pluck(:id): #{@appointments.pluck(:id)}")
  end

  # ! 条件分岐必須
  def new
    @smm_appointment = SmmAppointment.new
  end


  private

  def all_appointments_records
    # @appointments = Appointment.all
    # @smm_appointments = SmmAppointment.all
    # @cx_appointments = CxAppointment.all

    # `ServiceCategory.ransack`でServiceCategoryに対してransackを使う
    # params[:q]には検索フォームで指定した検索条件が入る
    search = Appointment.ransack(params[:q])

    # デフォルトのソートをid降順にする
    search.sorts = "id desc" if search.sorts.empty?

    # `@search.result`で検索結果となる@service_categoriesを取得する
    # 検索結果に対してはkaminariのpageメソッドをチェーンできる
    all_appointments = search.result.page(params[:page]).per(params[:per_page] || Kaminari.config.default_per_page)

    return [search, all_appointments]
  end

  def smm_appointments_records
    search = SmmAppointment.ransack(params[:q])

    # デフォルトのソートをid降順にする
    search.sorts = "id desc" if search.sorts.empty?

    smm_appointments = search.result.page(params[:page]).per(params[:per_page] || Kaminari.config.default_per_page)

    return [search, smm_appointments]
  end

  def cx_appointments_records
    search = CxAppointment.ransack(params[:q])

    # デフォルトのソートをid降順にする
    search.sorts = "id desc" if search.sorts.empty?

    cx_appointments = search.result.page(params[:page]).per(params[:per_page] || Kaminari.config.default_per_page)

    return [search, cx_appointments]
  end

  def appointment_params
    params.require(:register_form).permit(
      :id, :account_id, :service_category_id, :commodity_category_id, :duplication, :company_name,
      :company_tel, :company_url, :instagram_url, :content, :call_date, :next_call_date,
      :sent_material_date, :is_next_call, :end_date
    )
  end


  # private
end
