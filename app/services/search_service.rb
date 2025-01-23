class SearchService
  def initialize(query_params, page: 1, per_page: 5, upcoming: false)
    @query_params = query_params
    @page = page
    @per_page = per_page
    @upcoming = upcoming
  end
  
  def call
    patients = Patient.ransack(@query_params).result
  
    if @upcoming
      patients = patients.where("next_appointment_date BETWEEN ? AND ?", Time.current, 72.hours.from_now)
    end
    patients.paginate(page: @page, per_page: @per_page)
  end
end
  