require 'spec_helper'

provider_class = Puppet::Type.type(:ec2_instance).provider(:v2)

describe provider_class do
  let(:resource) {
    Puppet::Type.type(:ec2_instance).new(
      name: 'test-instance',
      image_id: AWS_IMAGE,
      instance_type: 't2.micro',
      availability_zone: AWS_REGION+'a',
      region: AWS_REGION,
    )
  }

  let(:provider) { resource.provider }
  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the ProviderV2' do
    expect(provider).to be_an_instance_of Puppet::Type::Ec2_instance::ProviderV2
  end

  describe 'self.prefetch' do
    it 'should exist' do
      provider.class.instances
      provider.class.prefetch({})
    end
  end

  describe 'running create' do
    it 'should send a request to the EC2 API to create the instance' do
      expect(provider.exists?).to be_falsy
      expect(provider.create).to be_truthy
      expect(instance.exists?).to be_truthy
      expect(provider.stop).to be_truthy
      expect(provider.destroy).to be_truthy
    end
  end
end
