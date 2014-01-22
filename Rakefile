# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'URLTrapper'
  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleURLName' => 'http URL',
      'CFBundleURLSchemes' => ['http'] },
    { 'CFBundleURLName' => 'https URL',
      'CFBundleURLSchemes' => ['https'] },
    { 'CFBundleURLName' => 'ftp URL',
      'CFBundleURLSchemes' => ['ftp'] },
  ]
end
