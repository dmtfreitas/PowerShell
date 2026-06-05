
# Send_mail_via_Script_Windows_PowerShell.ps1

$smtp_server = 'smtp.office365.com'
$smtp_port   = 587
$mail        = ''
$password    = ''

$to      = ''
$subject = 'E-mail automático | Send mail via Script Windows PowerShell'
$body    = 'Send mail via Script Windows PowerShell!'

$Message = New-Object System.Net.Mail.MailMessage
$Message.From = New-Object System.Net.Mail.MailAddress($mail)
$Message.To.Add($to)
$Message.Subject = $subject
$Message.Body = $body
$Message.SubjectEncoding = [System.Text.Encoding]::UTF8
$Message.BodyEncoding    = [System.Text.Encoding]::UTF8

$smtp = New-Object System.Net.Mail.SmtpClient($smtp_server, $smtp_port)
$smtp.EnableSsl = $true
$smtp.DeliveryMethod = [System.Net.Mail.SmtpDeliveryMethod]::Network
$smtp.UseDefaultCredentials = $false
$smtp.Credentials = New-Object System.Net.NetworkCredential($mail, $password)

try {

    $smtp.Send($Message)
    Write-Host 'Send mail is successful!' -ForegroundColor Green

}

catch {

    Write-Host 'Error mail send!' -ForegroundColor Red

}

finally {

    $Message.Dispose()
    $smtp.Dispose()

}
