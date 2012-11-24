guard 'rspec', all_after_pass: false do

  watch( 'cases/spec_helper.rb' )       { |m| "spec" }
  watch( %r{^lib/(.+)\.rb$} )           { |m| "spec/cases/#{m[1]}_spec.rb" }
  watch( %r{^spec/cases/.+_spec\.rb$} )

end
