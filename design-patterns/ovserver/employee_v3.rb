require 'observer'
class Employee
  include Observable

  attr_reader :name, :salary

  def initialize(name, salary)
    @name = name
    @salary = salary
  end

  # changedメソッドで、オブジェクトに変更があったかどうかを示すフラグを設定する必要がある。
  # フラグがfalseのままだったら下のnotify_observersは如何なる通知も行わない。
  def salary=(new_salary)
    @salary = new_salary
    changed
    notify_observers(self) # オブザーバのupdateメソッドを呼ぶ実装がされている
  end
end

class TaxMan
  def update(changed_employee)
    puts "#{changed_employee.name}に新しい税金の請求書を送ります"
  end
end

yuji = Employee.new('yuji', 200)

yuji.add_observer(TaxMan.new)

yuji.salary = 100
