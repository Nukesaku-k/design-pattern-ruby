class Employee
  attr_reader :name, :salary
  attr_accessor :title

  def initialize(name, title, salary, payroll)
    @name = name
    @title = title
    @salary = salary
    @payroll = payroll
  end

  def salary=(new_salary)
    @salary = new_salary
    @payroll.update(self) # 情報を送信
  end
end

class Payroll
  def update(changed_employee)
    puts "#{changed_employee.name}のために小切手を切ります。"
    puts "彼の給料は月#{changed_employee.salary}円になりました！"
  end
end

yuji = Employee.new('yuji', 'engineer', 100000, Payroll.new)
yuji.salary = 99999999
