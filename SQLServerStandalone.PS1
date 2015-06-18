configuration SQLServerStandalone
{
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PackagePath,
 
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $WinSources
    )

    Import-DSCResource -modulename xSQLServer
    Import-DSCResource -modulename xActiveDirectory

    Node localhost
    {
         WindowsFeature NetFramework35Core
        {
            Name = "NET-Framework-Core"
            Ensure = "Present"
            Source = $WinSources
        }

        WindowsFeature NetFramework45Core
        {
            Name = "NET-Framework-45-Core"
            Ensure = "Present"
            Source = $WinSources
        }

        xSqlServerSetup SQLServerSetup
        {
            DependsOn = "[WindowsFeature]NET-Framework-Core"
            SourcePath = $SourcePath
            SetupCredential = $SQLSetupCredential
            InstanceName = $SQLInstanceName
            Features = $SQLFeatures
            SQLSysAdminAccounts = $SQLSysAdminAccounts
        }

        xSqlServerFirewall SQLServerFirewall
        {
            DependsOn = ("[xSqlServerSetup]SQLServerSetup")
            SourcePath = $SourcePath
            InstanceName = $SQLInstanceName
            Features = $Features
        }
    }
}
