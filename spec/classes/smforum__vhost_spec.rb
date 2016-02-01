require 'spec_helper'

describe 'smforum::vhost' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        let(:default_params) do
          {
            :manage        => true,
            :vhost_fqdn    => 'foo.example.com',
            :ssl           => false,
            :ssl_only      => false,
            :ssl_cert      => nil,
            :ssl_key       => nil,
            :include_php   => false,
            :php_fcgi      => '/tmp/fcgi',
            :document_root => '/opt/smforum',
          }
        end

        context "supported vhosts" do
          ["nginx"].each do |vhost_type|
            let(:params) do 
              default_params.merge({
                :type => vhost_type
              })
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class("smforum::vhost") }
            it { is_expected.to contain_class("smforum::vhost::#{vhost_type}") }
          end
        end
        
        context "unsupported vhost" do
          let(:params) do
            default_params.merge({
              :type => 'invalid_type'
            })
          end
          
          it { should raise_error(Puppet::Error, /vhost type invalid_type not supported/) }
        end
      end
    end
  end
end
