# == Schema Information
   #
   # Table name: projects
   #
   #  id         :integer         not null, primary key
   #  name       :string(255)
   #  created_at :datetime        not null
   #  updated_at :datetime        not null
   #

class Project < ActiveRecord::Base
  has_many :team_memberships
  has_many :users, through: :team_memberships

  attr_accessible :name

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  def owner
    @owner ||= team_memberships.find_by_owner(true).user
  end
end