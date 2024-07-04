<!DOCTYPE html>
<html>
    <head>
        <title>Verification Code</title>
    </head>
    <h1>Welcome: {{$user->nom}}</h1>

    <body>
        <p>This Email is sent for verification</p>
        <p>Your verification code is: {{ $verificationCode }}</p>
    </body>
</html>