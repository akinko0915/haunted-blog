# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  scope :published, -> { where('secret = FALSE') }

  scope :search, lambda { |term|
    search_term = "%#{sanitize_sql_like(term)}%"
    where('title LIKE ? OR content LIKE ?', search_term, search_term)
  }

  scope :default_order, -> { order(id: :desc) }

  scope :viewable_by, lambda { |user|
    where('secret = FALSE OR user_id = ?', user&.id)
  }

  def owned_by?(target_user)
    user == target_user
  end
end
