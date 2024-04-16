<#
.SYNOPSIS
This script creates a number of sprints in Azure DevOps.

.DESCRIPTION
The script authenticates with Azure DevOps using a personal access token and then creates a specified number of sprints with a given start date and duration.

.PARAMETER PAT
The personal access token to authenticate with Azure DevOps.

.PARAMETER Organization
The name of the Azure DevOps organization.

.PARAMETER Project
The name of the Azure DevOps project.

.PARAMETER TeamName
The name of the Azure DevOps team.

.PARAMETER StartDate
The start date of the first sprint. Defaults to '29/4/24'.

.PARAMETER NumberOfSprints
The number of sprints to create. Defaults to 10.

.PARAMETER DaysPerSprint
The number of days each sprint lasts. Defaults to 14.
#>
Param
(
    [string]$PAT,
    [string]$Organization,
    [string]$Project,
    [string]$TeamName,
    [DateTime]$StartDate = [DateTime]::ParseExact('29/4/24', 'd/M/yy', $null),
    [int]$NumberOfSprints = 10,
    [int]$DaysPerSprint = 14
)
 
function Create-Sprint {
    <#
    .SYNOPSIS
    This function creates a sprint in Azure DevOps.

    .DESCRIPTION
    The function authenticates with Azure DevOps using a personal access token and then creates a sprint with a given name, start date, and end date.

    .PARAMETER sprintName
    The name of the sprint to create.

    .PARAMETER startDate
    The start date of the sprint.

    .PARAMETER endDate
    The end date of the sprint.
    #>
    param(
        [string]$sprintName,
        [datetime]$startDate,
        [datetime]$endDate
    )
 
    # Authenticate with Azure DevOps
    Write-Host "Authenticating with Azure DevOps..."
    Set-VSTeamAccount -Account $Organization -PersonalAccessToken $PAT
 
    # Define the sprint object
    Write-Host "Defining the sprint object..."
    $sprint = @{
        Name        = $sprintName
        ProjectName = $Project
        StartDate   = $startDate
        FinishDate  = $endDate
    }
 
    # Add the sprint to Azure DevOps
    Write-Host "Adding the sprint to Azure DevOps..."
    Add-VSTeamIteration @sprint 
}
 
For ($i=1; $i -le $NumberOfSprints; $i++) 
{
    Write-Host "Creating sprint $i..."
    $Sprint = 'Sprint ' + $i
    $StartDateIteration = $StartDate.AddDays(($i - 1) * $DaysPerSprint)
    $FinishDateIteration = $StartDateIteration.AddDays($DaysPerSprint)
    Create-Sprint -sprintName $Sprint -startDate $StartDateIteration -endDate $FinishDateIteration
}
