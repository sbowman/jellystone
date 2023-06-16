# Jellystone

Jellystone is a prototype app and API for managing databases on a PostgreSQL deployment.  It's 
designed to support humans manually creating databases, or Terraform-type processes creating them
remotely via an API.

## Running the service

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Lab Week June 2023

The following notes describe the major steps I've taken to create this application.

### Goals

Here's the basic functionality I'd like to have at the end of the week:

* Create user accounts
* Create teams and invite users to them
* Create a database for a team
* Create a PostgreSQL user for the team's database
* Be able to see the databases and accounts configured for a team
* Change database user account password
* Support for this functionality in the API

Some stretch goals:

* Prometheus metrics (how does Phoenix do with Prom)
* Database Stats:
    * See the last time the database was updated (any SQL query, not just in this UI)
    * See the number of connections to the database
    * See the size of the database
    * Slow query logging, dashboard
    * Too many connections?  Too much memory?

### User Accounts & Authentication

I leveraged the `phx.gen.auth` command to generate the basic user account and authentication 
workflow in Jellystone.  

    $ mix phx.gen.auth Accounts User users

This generates a modules, `Accounts`, and creates a `User` struct in it, along with a `users` table
in the database to store user account information.  It also generates a migration to create the
database table.  The `User` changeset includes validations for things like email address and 
passwords.  And, to top it all off, generates test cases.

I then changed the generated code to use Argon2 instead of Bcrypt for the password hashes.  There's
a CLI option for `phx.gen.auth` to do this at creation time, but I forgot.  But changing out the
hash is relatively simple:

1. Add the Argon2 dependency to `mix.exs` and remove Bcrypt.
2. Replace `Bcrypt` in the `jellystone_web/live/user*` files with `Argon2`; the function calls in both libraries are the same.

I also changed the minimum password length from 12 to 6.  It's a minor gripe, and probably not 
something I'd do in production code, but when I'm developing it's a pain.  I updated the value in
the validation functions, then had to update the test cases to support this smaller minimum value.

### Teams

Now that I had user accounts, I want to have people belong to teams, so we can associate the 
databases with a team rather than an individual.  

First I created a schema for the team, using the Phoenix generator:

    $ mix phx.gen.schema Accounts.Team teams name:string token:string

I'm going to create a hashed token in the database for a team that we can use to secure the database
user passwords so the entire team can see them, but other teams can't.

I went into the created migration and added some constraints like a size for the columns and made
name and token required.  I renamed the `:token` column to `:hashed_token`, so we don't accidentally
rehash an existing token. And I created a unique index on the team name to force the teams to all
have unique names.

I went into the Team schema and modified it to have a virtual `token` column to use with forms and
API inputs, and a `hashed_token` column to store the token as a hashed value.  I also created some
changesets to support this.

Now let's join the teams to the users:

    $ mix phx.gen.schema Accounts.TeamMember team_members team_id:references:teams member_id:references:users

I went into the generated migration and changed the `on_delete: :nothing` to `on_delete: :cascade`.

I linked the "users" schema to the "teams" schema.  In "users", I added:

    has_many(:team_members, Accounts.TeamMember)
    many_to_many(:teams, Accounts.Team, join_through: Accounts.TeamMember)

And in "teams," I added:

    has_many(:team_members, Accounts.TeamMember)
    many_to_many(:users, Accounts.User, join_through: Accounts.TeamMember)




