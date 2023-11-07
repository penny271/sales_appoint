# app/controllers/appointments_controller.rb
# app/controllers/appointments_controller.rb
class AppointmentsController < Base
  before_action :set_service_category_type, only: [:index]
  before_action :set_search_and_appointments, only: [:index]

  def index
    # Outputs the IDs of the appointments in the log/console
    Rails.logger.info "@appointments.pluck(:id): #{@appointments.pluck(:id)}"
    @appointments = set_search_and_appointments
  end

  def new
    @appointment = SmmAppointment.new # Assuming SmmAppointment is the default
  end

  # 通常サーチ
  def search
    @appointments = Appointment.all

    if params[:company_name_partial].present?
      @appointments = @appointments.where("company_name LIKE ?", "%#{params[:company_name_partial]}%")
    end

    if params[:company_name_exact].present?
      @appointments = @appointments.where(company_name: params[:company_name_exact])
    end

    # Rest of your search logic

    render :index # or wherever you want to render the search results
  end

  private

  def set_service_category_type
    @service_category_type = params[:service_category_type].presence || "smm"
    @service_category_id = case @service_category_type
      when "smm" then 1
      when "cx" then 2
      when "all" then 3
      else 3 # Default to the base model if no valid type is given
      end
  end

  def set_search_and_appointments
    model = case @service_category_type
      when "smm" then SmmAppointment
      when "cx" then CxAppointment
      when "all" then Appointment
      else Appointment # Default to the base model if no valid type is given
      end

    @search = model.ransack(params[:q])
    set_default_sort(@search)
    appointments = @search.result(distinct: true)

    # You might need to adjust the following line if service_category_id is not a valid column
    # for SmmAppointment and CxAppointment, or handle the condition differently.
    appointments = appointments.where(service_category_id: @service_category_id) unless @service_category_type == "all"

    @appointments = paginated_results(appointments)
  end

  def set_default_sort(search)
    search.sorts = "id desc" if search.sorts.empty?
  end

  def paginated_results(appointments)
    appointments.includes(:account, :commodity_category, :service_category)
                .page(params[:page])
                .per(params[:per_page] || Kaminari.config.default_per_page)
  end

  def appointment_params
    params.require(:appointment).permit(
      :account_id, :service_category_id, :commodity_category_id, :duplication,
      :company_name, :company_tel, :company_url, :instagram_url, :content, :call_date,
      :next_call_date, :sent_material_date, :is_next_call, :end_date
    )
  end
end

#  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# # class AppointmentsController < ApplicationController
# class AppointmentsController < Base
#   def index
#     @service_category_type = params[:service_category_type].present? ? params[:service_category_type] : "smm"

#     # ! 下記のように条件分岐すると、@searchがないというエラーが出る 20231106
#     case @service_category_type
#     when "smm"
#       @search, @appointments = smm_appointments_records
#     when "cx"
#       @search, @appointments = cx_appointments_records
#     when "all"
#       @search, @appointments = all_appointments_records
#     else
#       puts("service category is not selected.")
#     end
#     # @search, @smm_appointments = smm_appointments_records
#     # @search, @cx_appointments = cx_appointments_records
#     # @appointments = Appointment.all
#     #! 条件分岐必要 一時的にall
#     # @search = Appointment.ransack(params[:q])
#     # @search, @all_appointments = all_appointments_records

#     # @appointments = @appointments
#     puts("@appointments.pluck(:id): #{@appointments.pluck(:id)}")
#   end

#   # ! 条件分岐必須
#   def new
#     @smm_appointment = SmmAppointment.new
#   end

#   private

#   def smm_appointments_records
#     search = SmmAppointment.ransack(params[:q])

#     # デフォルトのソートをid降順にする
#     search.sorts = "id desc" if search.sorts.empty?

#     # smm_appointments = search.result.page(params[:page]).per(params[:per_page] || Kaminari.config.default_per_page)

#     # - N+1問題解決 - Use .includes to load both :account and :commodity_category associations
#     smm_appointments = search.result.includes(:account, :commodity_category, :service_category).page(params[:page]).per(params[:per_page] || Kaminari.config.default_per_page)

#     return [search, smm_appointments]
#   end

#   def cx_appointments_records
#     search = CxAppointment.ransack(params[:q])

#     # デフォルトのソートをid降順にする
#     search.sorts = "id desc" if search.sorts.empty?

#     cx_appointments = search.result.includes(:account, :commodity_category, :service_category).page(params[:page]).per(params[:per_page] || Kaminari.config.default_per_page)

#     return [search, cx_appointments]
#   end

#   def all_appointments_records
#     # @appointments = Appointment.all
#     # @smm_appointments = SmmAppointment.all
#     # @cx_appointments = CxAppointment.all

#     # `ServiceCategory.ransack`でServiceCategoryに対してransackを使う
#     # params[:q]には検索フォームで指定した検索条件が入る
#     search = Appointment.ransack(params[:q])

#     # デフォルトのソートをid降順にする
#     search.sorts = "id desc" if search.sorts.empty?

#     # `@search.result`で検索結果となる@service_categoriesを取得する
#     # 検索結果に対してはkaminariのpageメソッドをチェーンできる
#     all_appointments = search.result.includes(:account, :commodity_category, :service_category).page(params[:page]).per(params[:per_page] || Kaminari.config.default_per_page)

#     return [search, all_appointments]
#   end

#   def appointment_params
#     params.require(:register_form).permit(
#       :id, :account_id, :service_category_id, :commodity_category_id, :duplication, :company_name,
#       :company_tel, :company_url, :instagram_url, :content, :call_date, :next_call_date,
#       :sent_material_date, :is_next_call, :end_date
#     )
#   end

#   # private
# end
