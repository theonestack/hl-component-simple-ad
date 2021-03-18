# simple-ad CfHighlander component

creates a AWS Simple-AD directory with a randomly generated administrator password and an option DNCP option set with the directory DNS and NetBIOS name servers


## Parameters

| Name | Use | Default | Global | Type | Allowed Values |
| ---- | --- | ------- | ------ | ---- | -------------- |
| EnvironmentName | Tagging | dev | true | string
| EnvironmentType | Tagging | development | true | string | ['development','production']
| DnsDomain | domain name used in the directory name | | false | string
| Size | Directory size | | false | string | Big, Small
| SubnetIds | comma delimited list of 2 subnets to place the directory in | | false | comma delimited list
| Identifier | SSM parameter prefix for the generated password | the component name | false | string
| PathSuffix | SSM parameter suffix for the generated password | administrator-password | false | string
| AwsSSO | Enable AWS SSO for the Directory | false | false | boolean | true, false

## Configuration

### Directory Name

the default directory name structure is `${EnvironmentName}.${DnsDomain}` which uses the EnvironmentName and DnsDomain parameters to construct the directory name.
the `name:` config can be used to alter this structure for example if you only wanted to use the DnsDomain parameter as the directory name

```yaml
name: ${DnsDomain}
```

or if you wanted to ignore the DnsDomain parameter and set the directory name in config you can use the name key to set it

```yaml
name: test.local
```

### NetBIOS Short Name

by default the first name in you directory name is used. for example if the directory name is `test.local` the NetBIOS name becomes `test`.
this can be overridden by proving with the following config:

```yaml
short_name: test
```

or using a parameter

```yaml
short_name:
    Ref: ShortName
```

### DHCP

dhcp option is disabled by default but can be enabled by adding the following to your config.
the directory DNS and NetBIOS name servers are added to the dhcp options as well as the directory name

```yaml
create_dhcp: true
```