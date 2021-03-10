CloudFormation do

  name = external_parameters.fetch(:name, "${EnvironmentName}.${DnsDomain}")
  sso = external_parameters.fetch(:sso, nil)
  short_name = external_parameters.fetch(:short_name, nil)

  DirectoryService_SimpleAD(:Directory) {
    Description FnSub("Simple AD for #{name}")
    EnableSso sso unless sso.nil?
    Name FnSub(name)
    Password "Fn::GetAtt" => ['PasswordSSMSecureParameter', 'Password']
    Size Ref(:Size)
    ShortName short_name unless short_name.nil?
    VpcSettings ({
      SubnetIds: [
        FnSelect(0, FnSplit(",", Ref(:SubnetIds))),
        FnSelect(1, FnSplit(",", Ref(:SubnetIds)))
      ],
      VpcId: Ref(:VPCId)
    })
  }


  export_name = external_parameters.fetch(:export_name, component_name)
  Output(:Directory) {
    Value(Ref(:Directory))
    Export FnSub("${EnvironmentName}-#{export_name}-Directory")
  }

  Output(:DnsServers) {
    Value(FnJoin(',', FnGetAtt(:Directory, :DnsIpAddresses)))
    Export FnSub("${EnvironmentName}-#{export_name}-DnsServers")
  }

end
