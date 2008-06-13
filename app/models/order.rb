# Class Order (db table orders)
# Schema version 3
#
#+------------+--------------+------+-----+---------+----------------+
#| Field      | Type         | Null | Key | Default | Extra          |
#+------------+--------------+------+-----+---------+----------------+
#| id         | int(11)      | NO   | PRI | NULL    | auto_increment | 
#| title      | varchar(255) | NO   |     |         |                | 
#| name       | varchar(255) | NO   |     |         |                | 
#| company    | varchar(255) | YES  |     | NULL    |                | 
#| street1    | varchar(255) | NO   |     |         |                | 
#| street2    | varchar(255) | YES  |     | NULL    |                | 
#| zip        | varchar(255) | NO   |     |         |                | 
#| city       | varchar(255) | NO   |     |         |                | 
#| county     | varchar(255) | YES  |     | NULL    |                | 
#| country    | varchar(255) | NO   |     |         |                | 
#| phone      | varchar(255) | NO   |     |         |                | 
#| email      | varchar(255) | NO   |     |         |                | 
#| amount     | int(11)      | NO   |     |         |                | 
#| reason     | text         | NO   |     |         |                | 
#| deadline   | varchar(255) | NO   |     |         |                | 
#| created_at | datetime     | YES  |     | NULL    |                | 
#| updated_at | datetime     | YES  |     | NULL    |                | 
#+------------+--------------+------+-----+---------+----------------+

class Order < ActiveRecord::Base
  validates_presence_of :title, :name, :street1, :zip, :city, :country,
    :phone, :email, :amount, :reason, :deadline

  validates_numericality_of :amount
end
