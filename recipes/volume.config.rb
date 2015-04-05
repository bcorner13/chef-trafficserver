#
# Cookbook Name:: trafficserver
# Recipe:: volume.config
#
# Copyright 2014, Virender Khatri
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node['trafficserver']['config']['volume'].each do |id, options|
  fail 'volume id must be numeric' unless id.is_a?(Integer)
  fail 'missing volume attribute scheme' unless options.key?('scheme') || options['scheme']
  fail 'missing volume attribute size' unless options.key?('size') || options['size']
end

template ::File.join(node['trafficserver']['conf_dir'], 'volume.config') do
  cookbook node['trafficserver']['cookbook']
  source 'volume.config.erb'
  owner node['trafficserver']['user']
  group node['trafficserver']['group']
  mode 0644
  variables(:volume => node['trafficserver']['config']['volume'])
  notifies :reload, 'service[trafficserver]', :delayed if node['trafficserver']['notify_restart']
  only_if { node['trafficserver']['manage_config'] }
end
