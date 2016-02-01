require 'spec_helper'

describe 'smforum' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:default_params) do 
          {
            :manage_mysql => false,
            :manage_vhost => false,
          }
        end
        let(:facts) do
          facts
        end

        context "smforum class without any management" do
          let(:params) do
            default_params
          end
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('smforum::install').that_comes_before('smforum::vhost') }
          it { is_expected.to contain_class('smforum::vhost').that_comes_before('smforum') }
          it { is_expected.to contain_class('smforum') }
          it { is_expected.to contain_class('smforum::params') }

          it { is_expected.to_not contain_class('smforum::vhost::nginx') }
          it { is_expected.to_not contain_class('smforum::vhost::apache') }
          it { is_expected.to_not contain_class('smforum::mysql') }
        end
        context "smforum class with mysql management" do
          let(:params) do
            default_params.merge({ :manage_mysql => true })
          end
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('smforum::mysql').that_comes_before('smforum') }
        end
        context "smforum class with vhost management" do
          ['nginx'].each do |supported_vhost|
            let(:vhost_params) do
              default_params.merge(
                {
                  :manage_vhost => true,
                  :vhost_type   => supported_vhost,
                }
              )
            end  
            
            let(:params) do
              vhost_params
            end
            
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class("smforum::vhost::#{supported_vhost}").that_comes_before('smforum::vhost') }

            context "with php included" do
              let(:params){ vhost_params.merge({ :include_php => true }) }
              it { is_expected.to compile.with_all_deps }
              it { is_expected.to contain_class('php') }
              it { is_expected.to contain_class('php::fpm') }
              it { is_expected.to contain_class('php::extension::apc') }
            end    
          end
        end
        context "smforum parameter verification" do
          context "ssl only without ssl" do
            let(:params) do
              default_params.merge({
                :manage_vhost   => true,
                :vhost_ssl      => false,
                :vhost_ssl_only => true,
              })
            end
            
            it { should raise_error(Puppet::Error, /you cannot set a ssl only vhost with enabling ssl vhost/) }
          end
          
          context "invalid smforum version parameter" do
            let(:params) do
              default_params.merge({
                :version => "invalid_version",
              })
            end
            
            #it { is_expected.to compile.with_all_deps }
            it { should raise_error(Puppet::Error, /"invalid_version" does not match /) }
          end
            
          context "ssl included without ssl_key" do
            let(:params) do
              default_params.merge({
                :manage_vhost   => true,
                :vhost_ssl      => true,
                :vhost_ssl_cert => 'asdf',
              })
            end
            
            it { should raise_error(Puppet::Error, /you must set both a ssl key and cert file to enable ssl in vhost/) }
          end
          context "ssl included without ssl_cert" do
            let(:params) do
              default_params.merge({
                :manage_vhost   => true,
                :vhost_ssl      => true,
                :vhost_ssl_key  => 'asdf',
              })
            end
            
            it { should raise_error(Puppet::Error, /you must set both a ssl key and cert file to enable ssl in vhost/) }
          end
        end     
      end
    end
  end

  context 'unsupported operating system' do
    describe 'smforum class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('smforum') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
