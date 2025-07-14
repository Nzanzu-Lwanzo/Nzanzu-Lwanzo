# About

These notes are a guideline that shows how to implement a secure authentication system in NestJs using 2FA or email verification.

It's structured in an intuitive way so the flow is easy to understand and follow. These notes are based on this repo : <https://github.com/nullpwntrops/simple-auth-backend>

## SIGN UP

On sign up, do whatever processing, verification and validation you need to do.

Then generate and hash a verification token along with a verification token expiration date. Save these data on the user. Then send an email to the user.

The email must prompt the user to click on a link so they confirm their account. That url should look something like :

```txt
https://site.api.org/verify-email?token=wjfbwoeifbwoeifbnwoei
```

The token should be included as a query string value in the URL they're going to go to.

## VERIFY EMAIL

Once the user clicks on the link, we fetch their **Ip Adress** and the **token**. We then check if there's any user with that verification token. Remember that the token we received in the query string and the one saved in the database are hashed strings. So they can perfectly be compared.

If a user is found, we check if the verification token has reached it's expiration date. If so, the user should probably be sent another email and repeat the process until now.

If the verification token has not expired yet and is still valid, we update the user by setting the following fields:

```javascript
    foundUser.isVerified = true;
    foundUser.verifiedAt = currentTimeStamp();
    foundUser.verifiedFromIp = ip;
    foundUser.verificationToken = null;
    foundUser.verificationTokenExpiresAt = null;
```

Once this process is successfully completed, we take them to a the success page.

## LOGIN

When the user wants to log in, as always we check if their credentials are valid.

1. If successful, we register the last successful login details. It might look something like this :

```javascript
    user.lastLogin = currentTimeStamp();
    user.lastLoginIp = ip;
    user.failedLoginAttempts = 0;
    user.isLocked = false;
    user.isLockedExpiresAt = null;
    user.isLockedReason = null;
```

We then generate the **access** and **refresh** tokens, save the refresh token on the user and handle the rest as we want (like, returning some data to the user, putting the refresh token in a cookie, sending the access token to be stored on the browser, ... ).

And also, if the **2FA** is enabled, we should log in the user (like normal) but send them a verification code. This code should be hashed and kept in the database, then sent to the user (by email or OTP message). Once the user give this code back, we should validate it and if it's valid (has not expired yet, for example), we should grant them full access to any route.

So in this case, we should have 3 authentication states :

- The first one is where the user is simply logged in (with credentials)
- The second one is where the user has got the 2FA enabled but they haven't yet given back the code. An so, it's not verified. How do you check this ? Normally, when a user verifies with the code, we delete it from database. So if they still have it, that means they haven't verified (caveat, they might not have any code and still not verified, like if they don't have 2FA enabled)
- The third one is where the user has got 2FA enabled and have already given back the code for verification. How do you check ? Well, if they have no code saved on the database.

Based on these 3 steps, we can decide what routes they can access and what they can do. Using guards. For more details, see the explanation made by Github Copilot.

2. If fails, we register the last login failed detais :

```javascript
    // Increase the counter of failed attempts
    user.failedLoginAttempts += 1;
    // When did it last fail
    user.failedLoginAttemptsAt = currentTimeStamp();
    // The ip the attempt failed from
    user.failedLoginAttemptsFromIp = ip;
    // A string representing the reason
    user.failedLoginAttemptsReason = reason;
```

Then if the **failedLoginAttempts** value is greater than a limit fixed by us (let's say maximum 5 attempts), we can choose to lock the user account, revoke all their tokens and also maybe tell them to wait a while before retrying. The locking might look something like this :

```javascript
    user.isLocked = true;
    user.isLockedExpiresAt = currentTimeStamp()
    user.isLockedReason = 'TOO_MANY_ATTEMPTS';
```

## LOGOUT

Remove all the tokens from database and cookies and maybe store information about the last logout time and ip adress.

## CHANGE PASSWORD

The user will provide the new and the old password. We'll then validate them (like, they should not be the same, the new password should follow the same validation requirements as the last one, ...). Also verify that the old password belongs to them.

If these validations are successfull, we update the user by giving them their new password and generate new tokens.

## TWO FACTORS
