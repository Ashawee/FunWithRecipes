DROP DATABASE IF EXISTS FunWithRecipes;
CREATE DATABASE FunWithRecipes;

DROP ROLE IF EXISTS recipe_admin;
CREATE ROLE admin LOGIN PASSWORD 'recip3Mast3r';

\c FunWithRecipes;

--
-- Table structure for table users
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
  message varchar(250),
  PRIMARY KEY (message_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

--
-- Table structure for table usermessages
--

DROP TABLE IF EXISTS user_messages;
CREATE TABLE usermessages (
  user_id integer REFERENCES users(user_id),
  message_id integer REFERENCES messages(message_id),
  PRIMARY KEY (user_id, message_id)
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

--
-- Table structure for table recipes
--

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
  category_id serial NOT NULL,
  category varchar(135),
  PRIMARY KEY (category_id)
);

--
-- Table structure for table recipe_categories
--
DROP TABLE IF EXISTS recipe_categories;
CREATE TABLE recipesteps (
  recipe_id integer REFERENCES recipes(recipe_id),
  category_id integer REFERENCES categories(category_id),
  PRIMARY KEY (recipe_id, category_id)
);

--
-- Table structure for table recipe_ingredients
--

DROP TABLE IF EXISTS recipe_ingredients;
CREATE TABLE recipe_ingredients (
  recipe_id integer REFERENCES recipes(recipe_id),
  ingredient_id integer REFERENCES ingredients(ingredient_id),
  PRIMARY KEY (recipe_id, step_id)
);


--
-- Table structure for table ingredients
--

DROP TABLE IF EXISTS ingredients;
CREATE TABLE ingredients (
  ingredient_id serial NOT NULL, 
  ingredient varchar(35),
  PRIMARY KEY (ingredient_id), 
);

--
-- Table structure for table steps
--

DROP TABLE IF EXISTS steps;
CREATE TABLE steps (
  step_id serial NOT NULL,
  step varchar(35),
  PRIMARY KEY (step_id)
);

--
-- Table structure for table recipe_steps
--

DROP TABLE IF EXISTS recipe_steps;
CREATE TABLE recipe_steps (
  recipe_id integer REFERENCES recipes(recipe_id),
  step_id integer REFERENCES steps(step_id),
  PRIMARY KEY (recipe_id, step_id)
);



CREATE EXTENSION pgcrypto;
SET timezone = 'America/New_York';
SET timezone = 'UTC';

GRANT SELECT, INSERT, UPDATE, DELET ON ALL TABLES IN SCHEMA public TO recipes_admin;
GRANT SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO recipes_admin;


INSERT INTO users (username, password) VALUES ('ashawee', crypt('gumdrop', gen_salt('bf')));
INSERT INTO users (username, password) VALUES ('tester', crypt('test', gen_salt('bf')));
INSERT INTO users (username, password) VALUES ('Edith', crypt('rain', gen_salt('bf')));

INSERT INTO recipes ()