Gem::Specification.new do |s|
  s.name        = 'valid_file'
  s.version     = '0.0.0'
  s.date        = '2014-05-20'
  s.summary     = "Validate file"
  s.description = "Validate file as per given format"
  s.authors     = ["Arman Ayvazyan"]
  s.email       = 'arman@ayvazyan.com'
        
  s.default_executable = "hola"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  
  s.files = ["Rakefile", "lib/valid_file.rb", "lib/hola/translator.rb", "bin/hola"]
  s.test_files = ["test/test_hola.rb"]
       
  s.homepage = %q{https://github.com/aivoarm/valid_file}
  s.require_paths = ["lib"]


  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end