
# Common transport rules for Exchange mail flow

# Block specific attachment types
New-TransportRule -Name "Block EXE Attachments" -AttachmentExtensionMatchesWords "exe" -RejectMessageReasonText "Executable files are not allowed."

# Add disclaimer to outgoing messages
New-TransportRule -Name "Add Disclaimer" -FromScope "InOrganization" -SentToScope "NotInOrganization" -ApplyHtmlDisclaimerLocation "Append" -ApplyHtmlDisclaimerText "<p><i>This email is confidential...</i></p>" -FallbackAction "Wrap"

# Redirect messages to a manager
New-TransportRule -Name "Redirect Emails to Manager" -From "user@domain.com" -RedirectMessageTo "manager@domain.com"

# Flag emails with sensitive words
New-TransportRule -Name "Flag Sensitive Content" -SubjectOrBodyContainsWords "confidential","secret" -SetSCL 9
