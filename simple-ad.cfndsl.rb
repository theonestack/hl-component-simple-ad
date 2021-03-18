CloudFormation do

  name = external_parameters.fetch(:name, "${EnvironmentName}.${DnsDomain}")
  short_name = external_parameters.fetch(:short_name, nil)

  DirectoryService_SimpleAD(:Directory) {
    Description FnSub("Simple AD for #{name}")
    EnableSso Ref(:AwsSSO)
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

  if external_parameters[:create_dhcp]
    EC2_DHCPOptions(:SimpleADDHCPOptionSet) {
      DomainName FnSub(name)
      DomainNameServers FnGetAtt(:Directory, :DnsIpAddresses)
      NetbiosNameServers FnGetAtt(:Directory, :DnsIpAddresses)
      NetbiosNodeType 2
    }

    EC2_VPCDHCPOptionsAssociation(:DHCPOptionsAssociation) {
      VpcId Ref(:VPCId)
      DhcpOptionsId Ref(:SimpleADDHCPOptionSet)
    }
  end

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
