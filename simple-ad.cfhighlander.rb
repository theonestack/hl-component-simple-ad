CfhighlanderTemplate do
  Name 'simple-ad'
  Description "simple-ad - #{component_version}"

  Parameters do
    ComponentParam 'EnvironmentName', 'dev', isGlobal: true
    ComponentParam 'EnvironmentType', 'development', allowedValues: ['development','production'], isGlobal: true
    ComponentParam 'Size', 'Small', allowedValues: ['Small','Large']
    ComponentParam 'VPCId', type: 'AWS::EC2::VPC::Id'
    ComponentParam 'SubnetIds', type: 'CommaDelimitedList'
    ComponentParam 'DnsDomain'
  end

  Component name: 'securepassword', template: 'github:theonestack/hl-component-password-generator#master.snapshot', render: Inline do
    parameter name: 'securepasswordSSMParameterPath', value: '/simple-ad/${EnvironmentName}/master_password'
    parameter name: 'securepasswordIdentifier', value: component_name
  end

end
