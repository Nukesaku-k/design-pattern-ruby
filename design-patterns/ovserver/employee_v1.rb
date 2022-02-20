class EmployeeV1
  attr_reader :name
  attr_accessor :title, :salary

  def initialize(name, title, salary, observers = [])
    @name = name
    @title = title
    @salary = salary
    @observers = observers # コレ
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end

  # それぞれのオブザーバーに変更を通知
  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end

  # オブザーバーの追加
  def add_observer(observer)
    @observers << observer
  end

  # オブザーバーの削除
  def delete_observer(observer)
    @observers.delete(observer)
  end
end

# Observerパターンを使うことで、EmployeeクラスとPayrollクラスの結合を取り除いている。
# ※ Employeeクラスを修正せずに変更できるとういこと。
# 他のオブザーバを足すのも簡単。
# employeeを受け取るupdateメソッドを持っていれば、どのオブジェクトもオブザーバになれる。

class TaxMan
  def update(changed_employee)
    puts "#{changed_employee.name}に新しい税金の請求書を送ります"
  end
end

class Payroll
  def update(changed_employee)
    puts "#{changed_employee.name}のために小切手を切ります。"
    puts "彼の給料は月#{changed_employee.salary}円になりました！"
  end
end

yuji = EmployeeV1.new('yuji', 'engineer', 100000)
yuji.add_observer(TaxMan.new)
yuji.add_observer(Payroll.new)
yuji.salary = 99999999
