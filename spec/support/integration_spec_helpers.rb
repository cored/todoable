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
    todoable.delete_list!(id: find_list(name).id)
  end

  def delete_list_item(list_name:, name:)
    list = find_list(list_name)
    item = list.items.find { |item| item.name == name }
    todoable.delete_item!(
      list_id: list.id,
      id: item.id,
    )
  end

  private

  def find_list(name)
    todoable.lists.find_by(name: name)
  end
end
