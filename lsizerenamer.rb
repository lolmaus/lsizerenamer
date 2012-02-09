# coding: utf-8
# Usage: ruby lsizerenamer.rb "/home/user/folder"

require 'find'

SIZEEOF = /\s\[\d{1,3}(\.\d+)?[KMGT]B\]$/

class Numeric
  def to_human
    units = %w{B KB MB GB TB}
    e = (Math.log(self)/Math.log(1024)).floor
    s = "%.3f" % (to_f / 1024**e)
    s.sub(/\.?0*$/, units[e])
  end
end

class String
	def last(n)
		self[-n,n]
	end
end



class Sizerenamer

	attr_reader :mainfolder

	def initialize(mainfolder)
		@mainfolder = mainfolder
	end

	def do_rename
		Dir.chdir(@mainfolder)
		Dir['*/'].each do |f|
			subfolder = Subfolder.new(f)
			puts "Parsing p #{subfolder.folder}..."
			subfolder.do_rename
			puts subfolder.folder
		end
	end

	def undo_rename
		Dir.chdir(@mainfolder)
		Dir['*/'].each do |f|
			subfolder = Subfolder.new(f)
			subfolder.undo_rename
		end
	end
end

class Subfolder

	attr_reader :folder, :size

	def initialize(folder)
		@folder = folder.gsub(/\/$/,'')
		@size = self.get_size if not self.renamed?
	end

	def get_size
		dirsize = 0

		Find.find(@folder) do |f|
			#p f, File.symlink?(f)
			dirsize += File.stat(f).size if not File.symlink?(f)
		end

		return dirsize
	end

	def do_rename
		if not self.renamed?
			new_folder = "#{@folder} [#{@size.to_human}]"
			self.rename(new_folder)
			@renamed = true
		end
	end

	def undo_rename
		if self.renamed?
			new_folder = @folder.gsub(SIZEEOF, '')
			self.rename(new_folder)
			@renamed = false
		end
	end

	def renamed?
		if (@folder =~ SIZEEOF)
			return true
		else
			return false
		end
	end

	protected
	def rename(new_folder)
		File.rename(@folder, new_folder)
		@folder = new_folder
	end
	
end



vasya = Sizerenamer.new(ARGV.first)
vasya.do_rename