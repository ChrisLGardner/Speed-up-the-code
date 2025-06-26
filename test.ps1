using namespace System.Management.Automation.Language

$ast = [parser]::ParseFile("pssa.ps1", [ref]$Null, [ref] $null)

$tokens = [management.automation.psparser]::tokenize(([scriptblock]::Create((get-content "pssa.ps1" -raw))),[ref]$null)
$comments = $tokens.where{$_.type -eq "comment"}


function Test-InlineCommentSpacing {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord])]
    param (
        [System.Management.Automation.Language.ScriptBlockAst]$Ast
    )
    
    # Skip if there's no file content to check
    if ($null -eq $Ast.Extent.File -or $null -ne $ast.parent) {
        return
    }
    
    # Read the file content
    $fileContent = Get-Content -Path $Ast.Extent.File -Raw
    $lines = $fileContent -split "`n"
    
    $faultyComment = $false

    # Check each line for inline comments that don't have exactly two spaces before #
    foreach ($line in $lines) {
        if ([regex]::Matches($line, '(?<=(?:^\s*|\w\s{2}))#')) {
            $faultyComment = $true
            break
        }
    }
    # If we found a faulty comment, report a violation
    if ($faultyComment) {
        [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
            Message    = 'Inline-comments should have exactly two spaces before the #-character'
            RuleName   = $myinvocation.MyCommand.Name
            Severity   = 'Information'
            Extent     = $Ast.Extent
        }
    }
}
