# Orion

A project to manage business activities for reseller.

## Getting Started

---------------------
        v1.0
---------------------
Fonctionalites
    - Creation caissier
    - Creation activite
    - Creation caisse
    - Passation des transactions
    - Actualisation du solde apres transaction
    - Pret et emprunt

------------------
        v1.1
------------------
Major changes
        - Activity : Now activity have dynamic informations (inputs are added as needed for a particular activity)
        - Activity have fields that cannot be displayed on web
        - Activity have a status to check if it can be visible on web
        - Getting one activity to get inputs associated to the activity
        - Account activity : activities_id changed to activity_id
        - Getting one account now returns activities avatar, name and id
        - Bill integrated and validated on each account
        - User can see they statistics (each activity)
        - Admin can get history of transactions per activity (he can choose fields that will be visible on the report)
        - Admin users can create branches
        - Each account activity is associated to a created branch
        - Icons update on Admin menu
        - Refund internal credits with double validation
        - Close the day with super account verification (Cashier->Agregator, Agregator->Admin)
        - Provision account with level verification (Agregator->Cashier, Admin->all)
        - Design of list display updated (list tile design)
        
