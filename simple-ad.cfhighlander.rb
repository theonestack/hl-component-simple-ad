CfhighlanderTemplate do
  Name 'simple-ad'
  Description "simple-ad - #{component_version}"

  Parameters do
    ComponentParam 'EnvironmentName', 'dev', isGlobal: true
    ComponentParam 'EnvironmentType', 'development', allowedValues: ['development','production'], isGlobal: true
    ComponentParam 'Size', 'Small', allowedValues: ['Small','Large']
    ComponentParam 'VPCId', type: 'AWS::EC2::VPC::Id'
    ComponentParam 'SubnetIds', ''
    ComponentParam 'DnsDomain'
    ComponentParam 'Identifier', component_name
    ComponentParam 'PathSuffix', 'admin-password'
    ComponentParam 'AwsSSO', 'false', allowedValues: ['true', 'false']
  end

  Component name: 'securepassword', template: 'password-generator@0.2.1', render: Inline do
    parameter name: 'Identifier', value: Ref(:Identifier)
    parameter name: 'PathSuffix', value: Ref(:PathSuffix)
  end

end
