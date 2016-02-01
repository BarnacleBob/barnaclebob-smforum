require 'spec_helper'

describe 'smforum::install' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:params) do 
          {
            :version       => '2.0.11',
            :document_root => '/opt/smforum',
            :user          => 'webuser',
          }
        end
        
        let(:facts) do
          facts
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('smforum::install') }
        it do
          is_expected.to contain_archive('smf_2-0-11_install').with(
            'target' => '/opt/smforum',
            'user'   => 'webuser',
            'url'    => 'http://download.simplemachines.org/index.php/smf_2-0-11_install.tar.gz',
          )
        end
      end
    end
  end
end
