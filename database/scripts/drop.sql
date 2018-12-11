-- drop tables
DROP TABLE transaction_tags;
DROP TABLE tags;
DROP TRIGGER tagCheck;
DROP TABLE transactions;
DROP TABLE account_people;
DROP TABLE account;
DROP TABLE people;
DROP TABLE bank;

-- drop views
DROP VIEW transaction_details;

-- drop stored procedures
DROP FUNCTION getAllSubTags;
DROP PROCEDURE recursive_getAllSubTags;
DROP FUNCTION getAmount;