require 'spec_helper'

describe 'smforum::vhost::nginx' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        let(:default_params) do
          {
            :vhost_fqdn    => 'foo.example.com',
            :ssl           => false,
            :ssl_only      => false,
            :ssl_cert      => nil,
            :ssl_key       => nil,
            :include_php   => false,
            :php_fcgi      => '/tmp/fcgi',
            :document_root => '/opt/smforum',
            :type          => 'nginx',
          }
        end

        context "vhost with http only" do
          let(:params) do 
            default_params
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('smforum::vhost::nginx') }
          it do
            is_expected.to contain_nginx__resource__vhost('foo.example.com http').with(
              'location_cfg_append' => nil
            )
          end
          
          it { is_expected.to contain_nginx__resource__location('foo.example.com_root').with('ssl_only' => false) }
          
          it { is_expected.to_not contain_class('php') }
          it { is_expected.to_not contain_nginx__resource__vhost('foo.example.com ssl') }
          
          
        end
        context "vhost with php" do
          let(:params) do 
            default_params.merge({
              :include_php => true,
            })
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('smforum::vhost::nginx') }
          it { is_expected.to contain_class('php') }
          it { is_expected.to contain_class('php::fpm') }
          it { is_expected.to contain_class('php::extension::apc') }
        end
        context "vhost with ssl" do
          let(:params) do 
            default_params.merge({
              :ssl      => true,
              :ssl_cert => '/tmp/cert',
              :ssl_key  => '/tmp/key',
            })
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('smforum::vhost::nginx') }
          it { is_expected.to contain_nginx__resource__vhost('foo.example.com http') }
          it { is_expected.to contain_nginx__resource__vhost('foo.example.com ssl') }
        end
        context "vhost with ssl" do
          let(:params) do 
            default_params.merge({
              :ssl      => true,
              :ssl_cert => '/tmp/cert',
              :ssl_key  => '/tmp/key',
              :ssl_only => true,
            })
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('smforum::vhost::nginx') }
          it { is_expected.to contain_nginx__resource__vhost('foo.example.com ssl') }
          it do
            is_expected.to contain_nginx__resource__vhost('foo.example.com http').with(
              'location_cfg_append' => { 'rewrite' => '^ https://$servername$request_uri? permanent' }
            )
          end
          it { is_expected.to contain_nginx__resource__location('foo.example.com_root').with('ssl_only' => true) }
        end
      end
    end
  end
end
