#!/bin/bash

# Database and user credentials
DB='cube-permission-test'
PASSWORD_PUBLIC='pass_public'
PASSWORD_AUTHENTICATED='pass_authenticated'
PASSWORD_EDITOR='pass_editor'

# Drop existing database
stardog-admin db drop $DB
if [ $? -eq 0 ]; then
    echo "Database $DB dropped successfully."
else
    echo "Database $DB did not exist, continuing..."
fi

# Remove existing roles and users
stardog-admin user remove user_public
stardog-admin user remove user_authenticated
stardog-admin user remove user_editor

stardog-admin role remove public
stardog-admin role remove authenticated
stardog-admin role remove editor

# Create new database
stardog-admin db create -n $DB -o query.all.graphs=true -o security.named.graphs=true --
if [ $? -ne 0 ]; then
    echo "Failed to create database $DB."
    exit 1
fi
echo "Database $DB created successfully."

# Create roles
stardog-admin role add public
stardog-admin role add authenticated
stardog-admin role add editor

# Create users with new passwords
stardog-admin user add user_public --new-password $PASSWORD_PUBLIC
stardog-admin user add user_authenticated --new-password $PASSWORD_AUTHENTICATED
stardog-admin user add user_editor --new-password $PASSWORD_EDITOR

# Grant database-level read permissions to roles
stardog-admin role grant -a read -o "db:$DB" public
stardog-admin role grant -a read -o "db:$DB" authenticated
stardog-admin role grant -a read -o "db:$DB" editor
stardog-admin role grant -a write -o "db:$DB" editor

# Grant permissions to public role
stardog-admin role grant -a read -o "named-graph:$DB\http://example.org/bafu" public
stardog-admin role grant -a read -o "named-graph:$DB\http://example.org/bfe" public

# Grant permissions to authenticated role
stardog-admin role grant -a read -o "named-graph:$DB\http://example.org/bafu" authenticated
stardog-admin role grant -a read -o "named-graph:$DB\http://example.org/bfe" authenticated
stardog-admin role grant -a read -o "named-graph:$DB\http://example.org/bafu/hidden" authenticated
stardog-admin role grant -a read -o "named-graph:$DB\http://example.org/bfe/hidden" authenticated

# Grant permissions to editor role
stardog-admin role grant -a write -o "named-graph:$DB\http://example.org/bafu" editor
stardog-admin role grant -a write -o "named-graph:$DB\http://example.org/bfe" editor
stardog-admin role grant -a write -o "named-graph:$DB\http://example.org/bafu/hidden" editor
stardog-admin role grant -a write -o "named-graph:$DB\http://example.org/bfe/hidden" editor

# Assign roles to users
stardog-admin user addrole --role public user_public
stardog-admin user addrole --role authenticated user_authenticated
stardog-admin user addrole --role editor user_editor

# Add sample data

stardog data add --username user_editor $DB stardog-hidden.trig

echo "Roles and users have been set up successfully."

stardog-admin db list
stardog-admin user list
stardog-admin role list

echo "Permissions..."

stardog-admin role permission public
stardog-admin role permission authenticated
stardog-admin role permission editor
