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
    ComponentParam 'SSMParameterPath', '/simple-ad/${EnvironmentName}/master_password'
    ComponentParam 'Identifier', component_name
  end

  Component name: 'securepassword', template: 'github:theonestack/hl-component-password-generator#master.snapshot', render: Inline do
    parameter name: 'SSMParameterPath', value: Ref(:SSMParameterPath)
    parameter name: 'Identifier', value: Ref(:Identifier)
  end

end
