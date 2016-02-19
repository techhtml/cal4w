class Event < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :members, class_name: 'User', association_foreign_key: 'user_id'

  validates :subject, presence: true
  validates :place, presence: true
  validates :user_id, presence: true

  def editable?(user)
    user.id == user_id ? true : false
  end

  def joined?(user)
    return true if user.id == user_id
    members.exists?(user.id)
  end

  def ing_or_after?
    finish_time > Time.zone.now
  end

  def member_names
    arr = members.map(&:nickname)
    arr.unshift(user.nickname)
  end

  def apply_timezone
    start_time += 9.hours
    finish_time += 9.hours
  end

  def restore_timezone
    start_time -= 9.hours
    finish_time -= 9.hours
  end
end
