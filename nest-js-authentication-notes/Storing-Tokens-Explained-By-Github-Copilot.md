# **Where Should You Store Your Tokens?**

## **1. Cookies**

## **Access Token:**

- **Can be stored in cookies**, but only if:
  - The cookie is set as `HttpOnly` (not accessible via JavaScript).
  - The cookie is set as `Secure` (only sent via HTTPS).
  - The cookie is set as `SameSite=Strict` (not sent with cross-site requests).

## **Refresh Token:**

- **Best practice:** Store refresh token in an `HttpOnly` cookie.
- **Why?** It’s much less exposed to XSS (cross-site scripting) attacks, because malicious scripts can’t read `HttpOnly` cookies.

## **Pros:**

- Automatic sending with requests (no manual header management).
- Protected from JavaScript-based attacks if `HttpOnly`.

## **Cons:**

- Vulnerable to CSRF (cross-site request forgery) unless you use `SameSite=Strict` or implement CSRF tokens.

## **2. Local Storage / Session Storage**

## **Access Token:**

- **Can be stored in local/session storage** (especially for single-page apps).
- Easy to access via JavaScript to attach as `Authorization` header.

## **Refresh Token:**

- **NOT recommended** to store refresh tokens in local storage.
- If an attacker gets XSS access, they can steal both tokens and take over sessions.

## **Pros:**

- Simple to implement.
- Works well for access tokens with short lifespans.

## **Cons:**

- Vulnerable to XSS attacks.
- Not automatically sent with requests (must be manually set in headers).

## **3. JavaScript Variables (In-Memory)**

## **Access Token:**

- Storing in memory is safest (only accessible while app is open), but lost on refresh/reload.

## **Refresh Token:**

- Same as above, but you’ll lose session continuity if the user refreshes the page.

## **Pros:**

- Least persistent; reduced attack surface.
- Best for temporary tokens.

## **Cons:**

- User must re-login or re-authenticate on page refresh or browser restart.

## **Best Practice Summary**

- **Access Token:**  
  - Short-lived; can be in local storage, session storage, or (preferably) in memory.
  - If you use cookies, be sure to protect against CSRF.

- **Refresh Token:**  
  - Long-lived; should **only** be stored in `HttpOnly` cookies.
  - Never expose to JavaScript if possible.

- **NEVER store tokens in plain local storage if you care about XSS protection.**

## **Recommended Setup for Most Web Apps**

- **Access token:**  
  - Store in memory, or in local/session storage if needed.
  - Attach as `Authorization: Bearer <token>` header.
- **Refresh token:**  
  - Store in `HttpOnly`, `Secure`, `SameSite=Strict` cookie.
  - Use only for the `/refresh` endpoint.

## **Why?**

- **Access tokens** are short-lived and less risky if stolen.
- **Refresh tokens** are high-value targets; keeping them out of JavaScript-accessible storage prevents session hijacking from XSS.
- Cookies can be vulnerable to CSRF, but modern settings (`SameSite`) and proper backend design mitigate this.

## **Summary Table**

| Token         | Recommended Storage          | Why                            |
|---------------|-----------------------------|--------------------------------|
| Access Token  | In-memory or local storage  | Easy API use, short-lived      |
| Refresh Token | `HttpOnly` Secure Cookie    | Protect against XSS attacks    |

**Want more details on implementation for a specific framework (React, Vue, etc.) or mobile apps? Just ask!**
