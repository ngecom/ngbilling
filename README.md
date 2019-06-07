# ngbilling
Telecom Billing and Rating for MVNO or Recurring Billing Business

# Supported Business in Free version
  * Any Recurring Invoice Monthly Billing.
  * Any Recurring Invoice Weekly Billing.
  * Any Recurring Invoice yearlly Billing.
  * Any Recurring Invoice Daily Billing.
  * Any Onetime Invoice Or Retail Billing.
 
# Supported Features in Free version 
  * Configurable Framework with plugin extentions. 
  * Scalable Design.
  * Complex Account Structures with multilevel Hierarchy(Level 1 to Level 'N').
  * Custom Fields can be added through User Interface.
  * Good Looking UI for Customers and Admin.(Role access SQL can be provided based on Request)
  * Role Based Security.
  * 1 Format Invoice Template.
  * Catalog Management.
  * Multiple Language Support.
  * Multiple Currency Support.
  * Automated payment processing(1 Free plugin for Authorize.net).
  * Tax percentage support.
  * Absolute discounts.
  * Notifications(Invoice,Payment,Customer,Order)

# Installation
  # Pre-Requisites
    * Java 8.
    * Postgres SQL 9.3 or above
    * Operating System Windows/Linux.
  # Setting up the Database
    * Login to Postgres. 
       psql -U postgres
        (Login may ask for password provide the password which was given during postgres installation)
    * Create the role. 
       CREATE USER ngbillingbase WITH PASSWORD 'ngbillingbase';
    * Create database database_name;
       CREATE DATABASE ngbillingbase
       WITH OWNER = ngbillingbase
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'en_US.UTF-8'
       LC_CTYPE = 'en_US.UTF-8'
       CONNECTION LIMIT = -1;
    * Logout from postgres by entering \q and Run the below command and enter the password 'ngbillingbase'
       psql -U ngbillingbase -d ngbillingbase < \home\rakesh\ngbillingbase\sqls\ngbillingbase.sql
    * Above script will load all required tables to database.
