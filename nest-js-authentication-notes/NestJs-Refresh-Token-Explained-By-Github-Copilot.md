
# **1. How do you know if an access token has expired?**

- **Access tokens** have an expiration time (e.g., 15 minutes).
- The token itself (a JWT) contains an `exp` (expiry) field.
- When your client makes an API request, the backend will check this field:
  - If the token is still valid, the request proceeds.
  - If the token is expired, the backend returns an error (typically 401 Unauthorized, or a custom message indicating "token expired").

## **On the client side:**

- Many clients decode the JWT locally and check the `exp` field before making a request.
- If expired, they **do not** send the API request with the old token—instead, they use the refresh token to get a new pair.

## **2. When are you supposed to call the `/refresh` route? Who does it?**

- **The client (user’s app/web browser)** is responsible for calling `/refresh`.
- This happens when:
  - The app detects the access token is expired (by checking the JWT or after getting a 401 from the server).
  - The user tries to perform an action and the backend rejects the request due to token expiry.

## **Best practice:**

- Your app should automatically call `/refresh` either:
  - Just before the access token expires (using a timer).
  - Immediately after receiving a token expiry error from the API.

## **3. Does this go against the purpose of the two-token system?**

**No, it’s exactly the point!**

- The **access token** is short-lived and used for regular API calls.
- The **refresh token** is long-lived and only used to obtain new access tokens when the old one expires.
- The refresh token is sent less often, reducing its exposure to attackers.

## **Why two tokens?**

- If an access token is stolen, it expires quickly, limiting damage.
- The refresh token is only sent to the backend for re-authentication, and only when necessary.
- The backend can invalidate refresh tokens (on logout, password change, etc.), cutting off the session.

## **Summary Table**

| Token Type    | Used For             | Lifetime      | Who Sends It?        | When Is It Used?              |
|---------------|---------------------|---------------|----------------------|-------------------------------|
| Access Token  | API requests        | Short (minutes)| Client (app/browser) | Every API call                |
| Refresh Token | Getting new tokens  | Long (days)   | Client (app/browser) | When access token expires     |

## **Final Notes**

- **User/client** handles token expiry and refreshing.
- This system increases security and user experience.
- You only call `/refresh` when you need a new token—**not on every request**.

Let me know if you want code samples or flow diagrams for how this works!
