defmodule Employee do
  defstruct [:first_name, :last_name, id_number: 0, salary: 0, job: :none]

  def employee(first_name, last_name) do
    %Employee{
      first_name: first_name,
      last_name: last_name,
    }
  end

  def promote1(%Employee{job: current_job} = employee) when current_job in [:none, :coder] do
    %Employee{employee | job: :coder, salary: 2000, id_number: 1}
  end

  def promote2(%Employee{job: current_job} = employee) when current_job in [:none, :coder, :designer] do
    %Employee{employee | job: :designer, salary: 4000, id_number: 2}
  end

  def promote3(%Employee{job: current_job} = employee) when current_job in [:none, :coder, :designer, :manager] do
    %Employee{employee | job: :manager, salary: 6000, id_number: 3}
  end

  def promote4(%Employee{job: current_job} = employee) when current_job in [:none, :coder, :designer, :manager, :ceo] do
    %Employee{employee | job: :ceo, salary: 8000, id_number: 4}
  end

  def demote(%Employee{job: current_job} = employee) when current_job in [:none, :coder, :designer, :manager, :ceo] do
    %Employee{employee | job: :none, salary: 0, id_number: 0}
  end
end


employee_1_add = Employee.employee("John","Doe")
IO.inspect(employee_1_add)

employee_1_promote = Employee.promote1(employee_1_add)
IO.inspect(employee_1_promote)

employee_1_promote_again = Employee.promote2(employee_1_promote)
IO.inspect(employee_1_promote_again)

employee_1_demote = Employee.demote(employee_1_promote_again)
IO.inspect(employee_1_demote)


# Output

"""
%Employee{
  first_name: "John",
  last_name: "Doe",
  id_number: 0,
  salary: 0,
  job: :none
}
%Employee{
  first_name: "John",
  last_name: "Doe",
  id_number: 1,
  salary: 2000,
  job: :coder
}
%Employee{
  first_name: "John",
  last_name: "Doe",
  id_number: 2,
  salary: 4000,
  job: :designer
}
%Employee{
  first_name: "John",
  last_name: "Doe",
  id_number: 0,
  salary: 0,
  job: :none
}
"""
