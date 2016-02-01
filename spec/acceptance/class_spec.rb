require 'spec_helper_acceptance'

describe 'smforum class' do
  context 'simple parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'smforum': 
        include_php  => false,
        manage_mysql => false,
        manage_vhost => false,
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file("#{$document_root}") do
      it { is_expected.to be_directory }
    end

    describe file("#{$document_root}/install.php") do
      it { is_expected.to be_file }
    end
  end
end
