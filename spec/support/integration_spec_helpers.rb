module IntegrationSpecHelpers
  def create_lists
    1.upto(5) { |number| create_list("List #{number}") }
  end

  def create_list(name)
    todoable.create_list!(name: name)
  end

  def delete_lists
    1.upto(5) { |number| delete_list("List #{number}") }
  end

  def delete_list(name)
    list = todoable.lists.find_by(name: name)
    todoable.delete_list!(id: list.id)
  end
end
