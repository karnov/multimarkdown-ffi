require 'rake/clean'
require 'rake/testtask'
require 'bundler/gem_tasks'
require 'rdoc/task'
require 'bundler'
require 'ffi-compiler/compile_task'

Bundler::GemHelper.install_tasks

task default: [:compile, :test]

desc 'Run tests'
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
end

desc "Compile"
namespace "ffi-compiler" do
  FFI::Compiler::CompileTask.new('ext/multimarkdown') do |t|
  end
end
task compile: [:clean, "ffi-compiler:default"]

Rake::RDocTask.new do |rd|
  rd.main = "README.md"
  rd.rdoc_files.include("README.md", "ext/**/*.c", "lib/**/*.rb")
end

CLEAN.include('ext/**/*{.o,.log,.so,.bundle}')
CLEAN.include('lib/**/*{.o,.log,.so,.bundle}')
