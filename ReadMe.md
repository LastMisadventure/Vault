# Vault

## Abstract

Provides a PowerShell command-line interface to the "Web Credentials" section of the [Windows Password Vault](https://docs.microsoft.com/en-us/uwp/api/Windows.Security.Credentials.PasswordVault) (called "Credential Manager" in the Windows GUI). This allows for a decent measure of protection for credentials at rest. As always, the best defense for secrets is to make sure only authorized entities can access them, and that authentication of authorized parties is as strong as possible.

## Quick Start

### Example 1: Get a Credential from the Windows Credential Manager

You need to get a stored credential from the Windows Credential Manager. You may need to view the password in clear-text.

```PowerShell
# get the credential without the password by the username
Get-VaultEntry -UserName test


UserName Resource         Password Properties
-------- --------         -------- ----------
test     http://test.com/          {[hidden, False], [applicationid, 00000000-0000-0000-0000-000000000000], [application, ]}

# get the same credential, this time returning the clear-text password

Get-VaultEntry -UserName test -IncludePassword


UserName Resource         Password Properties
-------- --------         -------- ----------
test     http://test.com/ test     {[hidden, False], [applicationid, 00000000-0000-0000-0000-000000000000], [application, ]}

```

### Example 2: Store a Credential in the Windows Credential Manager

You need to use an API key in clear-text with an API, but you do not want to store the key in clear-text.
You want the key to be decrypted by the same user on the same computer it was encrypted on.

```PowerShell
# get the credential
$credToAdd = Get-Credential

# add it to the Password Vault
Add-VaultEntry -Credential $credToAdd -Resource http://test.com

```

### Example 3: Remove a Credential from the Windows Credential Manager

You need to remove a credential from the Windows Credential Manager.

```PowerShell
# remove the credential by resource
Remove-VaultEntry -Resource http://test.com/ -Verbose
```
