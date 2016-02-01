require 'spec_helper'

describe 'smforum::mysql' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:params) do 
          {
            :mysql_user     => 'smforumuser',
            :mysql_db       => 'smforum',
            :mysql_password => 'smforumpass',
          }
        end
        
        let(:facts) do
          facts
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('smforum::mysql') }
        it { is_expected.to contain_class('mysql::server') }
        it do
          is_expected.to contain_mysql__db('smforum').with(
            'password' => 'smforumpass',
            'user'     => 'smforumuser',
          )
        end
      end
    end
  end
end
