class IndexUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    user.__elasticsearch__.index_document
  end
end
