module Pentago
  def self.version(version_file='VERSION')
    version_path = File.dirname(__FILE__) + "/../../#{version_file}"
    return File.read(version_path).chomp.strip if File.file?(version_path)
    '0.0.0'
  end
end

