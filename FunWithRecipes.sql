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

INSERT INTO users (username, password) VALUES ('ashawee', crypt('gumdrop', gen_salt('bf')));
INSERT INTO users (username, password) VALUES ('tester', crypt('test', gen_salt('bf')));
INSERT INTO users (username, password) VALUES ('Edith', crypt('rain', gen_salt('bf')));

--
-- Table structure for table messages
--

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
  message_id serial NOT NULL, 
  message varchar(250),
  created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  PRIMARY KEY (message_id),
);

INSERT INTO messages (message, created) VALUES ('Wow, what a great site for sharing recipes!', NOW());
INSERT INTO messages (message, created) VALUES ('I love that lasagna recipe!', NOW());
INSERT INTO messages (message, created) VALUES ('Cooking can be fun, amazing!', NOW());
INSERT INTO messages (message, created) VALUES ('I do NOT like to cook, but I made the lasagna and it was easy.', NOW());
INSERT INTO messages (message, created) VALUES ('Five stars, really cool. ', NOW());

--
-- Table structure for table usermessages
--

DROP TABLE IF EXISTS user_messages;
CREATE TABLE usermessages (
  user_id integer REFERENCES users(user_id),
  message_id integer REFERENCES messages(message_id),
  PRIMARY KEY (user_id, message_id)
);

INSERT INTO user_messages (user_id, message_id) VALUES (1,1);
INSERT INTO user_messages (user_id, message_id) VALUES (1,3);
INSERT INTO user_messages (user_id, message_id) VALUES (2,2);
INSERT INTO user_messages (user_id, message_id) VALUES (3,4);
INSERT INTO user_messages (user_id, message_id) VALUES (1,5);

--
-- Table structure for table recipes
--

DROP TABLE IF EXISTS recipes;
CREATE TABLE recipes (
  recipe_id serial NOT NULL,
  recipe varchar(50),
  difficulty varchar(35),
  category_id REFERENCES categories(category_id),
  created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  PRIMARY KEY (recipe_id), 
);


INSERT INTO recipes (recipe, difficulty, created) VALUES ('Lasagna', 'Easy', NOW());
INSERT INTO recipes (recipe, difficulty, created) VALUES ('Fruit Salad', 'Easy', NOW());
INSERT INTO recipes (recipe, difficulty, created) VALUES ('French Toast', 'Easy', NOW());

--
-- Table structure for table recipes
--

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
  category_id serial NOT NULL,
  category varchar(135),
  PRIMARY KEY (category_id)
);

INSERT INTO categories (category) VALUES ('Beautiful Breakfast');
INSERT INTO categories (category) VALUES ('Lovely Lunches');
INSERT INTO categories (category) VALUES ('Dreamy Dinners');



--
-- Table structure for table recipe_ingredients
--

DROP TABLE IF EXISTS recipe_ingredients;
CREATE TABLE recipe_ingredients (
  recipe_id integer REFERENCES recipes(recipe_id),
  ingredient_id integer REFERENCES ingredients(ingredient_id),
  PRIMARY KEY (recipe_id, step_id)
);

INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,1);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,2);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,7);
--
-- Table structure for table ingredients
--

DROP TABLE IF EXISTS ingredients;
CREATE TABLE ingredients (
  ingredient_id serial NOT NULL, 
  ingredient varchar(35),
  PRIMARY KEY (ingredient_id), 
);

INSERT INTO ingredients (ingredient) VALUES ('Shredded Mozerella Cheese');
INSERT INTO ingredients (ingredient) VALUES ('Lasagna pasta');
INSERT INTO ingredients (ingredient) VALUES ('Ricotta Cheese');
INSERT INTO ingredients (ingredient) VALUES ('Lasagna pasta');
INSERT INTO ingredients (ingredient) VALUES ('Salt');
INSERT INTO ingredients (ingredient) VALUES ('Egg');
INSERT INTO ingredients (ingredient) VALUES ('Parmesan Cheese');

--
-- Table structure for table steps
--

DROP TABLE IF EXISTS steps;
CREATE TABLE steps (
  step_id serial NOT NULL,
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
