#!/usr/bin/env ruby

require 'sinatra'
require 'rugged'
require 'mime/types'

repo_path = ENV['HOME'] + '/projects/libgit2'
ref_name = 'refs/remotes/upstream/gh-pages'

repo = Rugged::Repository.new(repo_path)

get '*' do |path|
  commit = repo.ref(ref_name).target
  path.slice!(0)
  path = 'index.html' if path.empty?

  entry = commit.tree.path path
  puts path
  blob = repo.lookup entry[:oid]
  content = blob.content
  halt 404, "404 Not Found" unless content

  content_type MIME::Types.type_for(path).first.content_type
  content
end
