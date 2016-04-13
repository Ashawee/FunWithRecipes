DROP DATABASE IF EXISTS FunWithRecipes;
CREATE DATABASE FunWithRecipes;

DROP ROLE IF EXISTS recipe_admin;
CREATE ROLE admin LOGIN PASSWORD 'recip3Mast3r';

\c FunWithRecipes;

--
-- Table structure for table Users
--

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  user_id serial NOT NULL,
  username varchar(35) NOT NULL default '', 
  password text,
  PRIMARY KEY (user_id)
  
  );
  
--
-- Table structure for table messages
--

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
  message_id serial NOT NULL, 
  message_created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  user_id INTEGER NOT NULL,
  message varchar(250),
  PRIMARY KEY (message_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

--
-- Table structure for table recipes
--

DROP TABLE IF EXISTS recipes;
CREATE TABLE recipes (
  recipe_id serial NOT NULL,
  user_id INTEGER NOT NULL,
  recipe_category_id INTEGER NOT NULL,
  recipe_name varchar(50),
  difficulty varchar(35),
  recipe_created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  PRIMARY KEY (recipe_id), 
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (recipe_category_id) REFERENCES recipe_category(recipe_category_id)
);


DROP TABLE IF EXISTS recipe_category;
CREATE TABLE recipe_category (
  recipe_category_id serial NOT NULL,
  recipe_category_type varchar(35),
  recipe_category_name varchar(135),
  PRIMARY KEY (recipe_category_id)
);

DROP TABLE IF EXISTS ingredients;
CREATE TABLE ingredients (
  ingredient_id serial NOT NULL, 
  ingredient varchar(35),
  PRIMARY KEY (ingredient_id), 
);


DROP TABLE IF EXISTS steps;
CREATE TABLE steps (
  step_id serial NOT NULL,
  step_name varchar(35),
  PRIMARY KEY (step_id)
);



--
-- Table structure for table user_message
--

CREATE EXTENSION pgcrypto;
SET timezone = 'America/New_York';
SET timezone = 'UTC';

GRANT SELECT, INSERT, UPDATE, DELET ON ALL TABLES IN SCHEMA public TO recipes_admin;
GRANT SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO recipes_admin;


INSERT INTO users (username, password) VALUES ('ashawee', crypt('gumdrop', gen_salt('bf')));
INSERT INTO users (username, password) VALUES ('tester', crypt('test', gen_salt('bf')));
INSERT INTO users (username, password) VALUES ('Edith', crypt('rain', gen_salt('bf')));

INSERT INTO recipes ()