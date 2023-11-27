# Hidden-Data-POC

This proof of concept (PoC) automatically sets up a Stardog database named `cube-permission-test` with the correct roles and users. It is designed to demonstrate access control mechanisms over RDF data stored in Stardog.

## Setup

1. **Add User Passwords to `.sdpass` File:**
   Before running the setup script, add the following lines to `$HOME/.sdpass`. This file stores the connection credentials for Stardog.

```
localhost:5820:cube-permission-test:user_public:pass_public
localhost:5820:cube-permission-test:user_authenticated:pass_authenticated
localhost:5820:cube-permission-test:user_editor:pass_editor
```

Replace `pass_public`, `pass_authenticated`, and `pass_editor` with the actual passwords for the users.

2. **Run the Setup Script:**
Execute `create.sh` to create the database, roles, users, and assign the necessary permissions. Ensure that Stardog is running and you have administrative access.

`./create.sh`

## Testing

After running the script, you can test the access controls:

- **Public User (`user_public`):** Can read the default non-hidden graphs.
- **Authenticated User (`user_authenticated`):** Has read access to all graphs, including hidden graphs.
- **Editor User (`user_editor`):** Can read from and write to all graphs.

Use appropriate SPARQL queries to validate the access controls for each user. Ensure you are authenticated as the correct user when running these queries.

## Note

This PoC is intended for demonstration purposes and should be adapted for production environments with proper security considerations, especially concerning password management and user permissions.
