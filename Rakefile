task :default => :rps

desc "Ejecutar rps en el servidor"
task :rps do
  sh "rackup"
end

desc "Ejecutar los tests unitarios"
task :test do
  sh "ruby test/test_rps.rb"
end

desc "Ejecutar los test de TDD con rspec"
task :spec do
  sh "rspec spec/rsack/server_spec.rb"
end
