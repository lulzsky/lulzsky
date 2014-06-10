class User < ActiveRecord::Base
	validates_presence_of :oasid, :oaspw 
	validates_uniqueness_of :oasid
	  has_many :ratings
	def self.create_with_pass(oasid,oaspw,maindump)
		self.create(
			oasid: oasid,
			oaspw: oaspw,
			fbuid: "",
			maindump: maindump,
			schedule: ""
			)
	end
end