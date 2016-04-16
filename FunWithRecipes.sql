DROP DATABASE IF EXISTS funwithrecipes;
CREATE DATABASE funwithrecipes;

DROP ROLE IF EXISTS recipes_admin;
CREATE ROLE recipes_admin LOGIN PASSWORD 'recip3Mast3r';

\c funwithrecipes;

--
-- Table structure for table users
--

DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
  user_id serial NOT NULL,
  username varchar(35) NOT NULL default '', 
  password text, 
  PRIMARY KEY (user_id)
  
  );

--
-- Table structure for table messages
--

DROP TABLE IF EXISTS messages CASCADE;
CREATE TABLE messages (
  message_id serial NOT NULL, 
  message varchar(250),
  created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  PRIMARY KEY (message_id)
);

--
-- Table structure for table usermessages
--

DROP TABLE IF EXISTS user_messages CASCADE;
CREATE TABLE user_messages (
  user_id integer REFERENCES users(user_id),
  message_id integer REFERENCES messages(message_id),
  PRIMARY KEY (user_id, message_id)
);

--
-- Table structure for table recipes
--

DROP TABLE IF EXISTS recipes CASCADE;
CREATE TABLE recipes (
  recipe_id serial NOT NULL,
  recipe varchar(50),
  difficulty varchar(35),
  image varchar(135), 
  category_id integer REFERENCES categories(category_id),
  created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  PRIMARY KEY (recipe_id)
);


--
-- Table structure for table recipes
--

DROP TABLE IF EXISTS categories CASCADE;
CREATE TABLE categories (
  category_id serial NOT NULL,
  category varchar(135),
  PRIMARY KEY (category_id)
);

--
-- Table structure for table ingredients
--

DROP TABLE IF EXISTS ingredients CASCADE;
CREATE TABLE ingredients (
  ingredient_id serial NOT NULL, 
  ingredient varchar(35),
  PRIMARY KEY (ingredient_id) 
);

--
-- Table structure for table recipe_ingredients
--

DROP TABLE IF EXISTS recipe_ingredients;
CREATE TABLE recipe_ingredients (
  recipe_id integer REFERENCES recipes(recipe_id),
  ingredient_id integer REFERENCES ingredients(ingredient_id),
  PRIMARY KEY (recipe_id, ingredient_id)
);


--
-- Table structure for table steps
--

DROP TABLE IF EXISTS steps CASCADE;
CREATE TABLE steps (
  step_id serial NOT NULL,
  step_number integer,
  step varchar(125),
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

GRANT SELECT, INSERT, UPDATE, DELETE ON users, recipes, steps, ingredients, categories TO recipes_admin;
GRANT SELECT, UPDATE ON users_user_id_seq, recipes_recipe_id_seq, ingredients_ingredient_id_seq, categories_category_id_seq TO recipes_admin;

INSERT INTO users (username, password) VALUES ('ashawee', crypt('gumdrop', gen_salt('bf')));
INSERT INTO users (username, password) VALUES ('tester', crypt('test', gen_salt('bf')));
INSERT INTO users (username, password) VALUES ('Edith', crypt('rain', gen_salt('bf')));

INSERT INTO messages (message, created) VALUES ('Wow, what a great site for sharing recipes!', NOW());
INSERT INTO messages (message, created) VALUES ('I love that lasagna recipe!', NOW());
INSERT INTO messages (message, created) VALUES ('Cooking can be fun, amazing!', NOW());
INSERT INTO messages (message, created) VALUES ('I do NOT like to cook, but I made the lasagna and it was easy.', NOW());
INSERT INTO messages (message, created) VALUES ('Five stars, really cool. ', NOW());

INSERT INTO user_messages (user_id, message_id) VALUES (1,1);
INSERT INTO user_messages (user_id, message_id) VALUES (1,3);
INSERT INTO user_messages (user_id, message_id) VALUES (2,2);
INSERT INTO user_messages (user_id, message_id) VALUES (3,4);
INSERT INTO user_messages (user_id, message_id) VALUES (1,5);

INSERT INTO recipes (recipe, difficulty, created, image) VALUES ('Lasagna', 'Easy', NOW(), 'https:\/\/cs350-apontive.c9users.io\/static\/img\/recipe\/Lasagna.png');

INSERT INTO categories (category) VALUES ('Beautiful Breakfast');
INSERT INTO categories (category) VALUES ('Lovely Lunches');
INSERT INTO categories (category) VALUES ('Dreamy Dinners');

INSERT INTO ingredients (ingredient) VALUES ('Shredded Mozerella Cheese');
INSERT INTO ingredients (ingredient) VALUES ('Lasagna pasta');
INSERT INTO ingredients (ingredient) VALUES ('Ricotta Cheese');
INSERT INTO ingredients (ingredient) VALUES ('Lasagna pasta');
INSERT INTO ingredients (ingredient) VALUES ('Salt');
INSERT INTO ingredients (ingredient) VALUES ('Egg');
INSERT INTO ingredients (ingredient) VALUES ('Parmesan Cheese');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,1);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,2);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,7);

INSERT INTO steps (step_number, step) VALUES (1, 'Brown and drain the ground beef (if using). Add Sauce and simmer');
INSERT INTO steps (step_number, step) VALUES (2, 'Cook the Noodles according to package instructions');
INSERT INTO steps (step_number, step) VALUES (3, 'Mix the Ricotta, egg, 1 cup of parmesan cheese in a large bowl.');
INSERT INTO steps (step_number, step) VALUES (4, 'In large pan, layer the ingredients, making the top layer only sauce and a coating of parmesan cheese');
INSERT INTO steps (step_number, step) VALUES (5, 'Bake at 350, uncovered, for 45 minutes.');

INSERT INTO recipe_steps (recipe_id, step_id) VALUES (1,1);
INSERT INTO recipe_steps (recipe_id, step_id) VALUES (1,2);
INSERT INTO recipe_steps (recipe_id, step_id) VALUES (1,3);
INSERT INTO recipe_steps (recipe_id, step_id) VALUES (1,4);
INSERT INTO recipe_steps (recipe_id, step_id) VALUES (1,5);