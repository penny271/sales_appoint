# class AppointmentsController < ApplicationController
class AppointmentsController < Base
  def index
    # @appointments = Appointment.all
    @smm_appointments = SmmAppointment.all
    @cx_appointments = CxAppointment.all
  end

end
