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
  directions varchar(300),
  created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  PRIMARY KEY (recipe_id)
);

--
-- Table structure for table recipes
--

DROP TABLE IF EXISTS comments CASCADE;
CREATE TABLE comments (
  comment_id serial NOT NULL, 
  comment varchar(135),
  recipe_id integer REFERENCES recipes(recipe_id),
  PRIMARY KEY (comment_id)
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
-- Table structure for table recipe_categories
--

DROP TABLE IF EXISTS recipe_categories CASCADE;
CREATE TABLE recipe_categories (
  recipe_id integer REFERENCES recipes(recipe_id),
  category_id integer REFERENCES categories(category_id),
  PRIMARY KEY (recipe_id, category_id)
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


CREATE EXTENSION pgcrypto;
SET timezone = 'America/New_York';
SET timezone = 'UTC';

GRANT SELECT, INSERT, UPDATE, DELETE ON users, recipes, messages, ingredients, categories, recipe_categories, recipe_ingredients TO recipes_admin;
GRANT SELECT, UPDATE ON users_user_id_seq, recipes_recipe_id_seq, ingredients_ingredient_id_seq, categories_category_id_seq, messages_message_id_seq TO recipes_admin;

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

INSERT INTO recipes (recipe, difficulty, created, image, directions) VALUES ('Lasagna', 'Easy', NOW(), 'Lasagna.png',
'Brown and drain the ground beef. Add Sauce and simmer. Cook the Noodles. Mix the Ricotta, egg, one cup of parmesan cheese in a large bowl.In large pan, layer the ingredients. Bake at 350, uncovered, for 45 minutes.');
INSERT INTO recipes (recipe, difficulty, created, image, directions) VALUES ('Cheesecake', 'Meduim', NOW(), 'Cheescake.png',
'Mix ingredients, bake until done');
INSERT INTO recipes (recipe, difficulty, created, image, directions) VALUES ('Fruit Salad', 'Easy', NOW(), 'FruitSalad.png', 
'Mix ingredients, refridgerate.');
INSERT INTO recipes (recipe, difficulty, created, image, directions) VALUES ('Red Velvet Cake', 'Hard', NOW(), 'RedVelvetCake.png', 
'Follow package instructions.');


INSERT INTO categories (category) VALUES ('Beautiful Breakfast');
INSERT INTO categories (category) VALUES ('Lovely Lunches');
INSERT INTO categories (category) VALUES ('Dreamy Dinners');
INSERT INTO categories (category) VALUES ('Delightful Desserts');

INSERT INTO recipe_categories (recipe_id, category_id) VALUES (1, 3);
INSERT INTO recipe_categories (recipe_id, category_id) VALUES (2, 4);
INSERT INTO recipe_categories (recipe_id, category_id) VALUES (3, 4);
INSERT INTO recipe_categories (recipe_id, category_id) VALUES (4, 4);

INSERT INTO ingredients (ingredient) VALUES ('Shredded Mozerella Cheese');
INSERT INTO ingredients (ingredient) VALUES ('Lasagna pasta');
INSERT INTO ingredients (ingredient) VALUES ('Ricotta Cheese');
INSERT INTO ingredients (ingredient) VALUES ('Lasagna pasta');
INSERT INTO ingredients (ingredient) VALUES ('Salt');
INSERT INTO ingredients (ingredient) VALUES ('Egg');
INSERT INTO ingredients (ingredient) VALUES ('Parmesan Cheese');

INSERT INTO ingredients (ingredient) VALUES ('Mixed fruit');
INSERT INTO ingredients (ingredient) VALUES ('Apples');
INSERT INTO ingredients (ingredient) VALUES ('Bananas');
INSERT INTO ingredients (ingredient) VALUES ('Grapes');
INSERT INTO ingredients (ingredient) VALUES ('Shredded Sharp Cheddar');
INSERT INTO ingredients (ingredient) VALUES ('Cream Cheese');
INSERT INTO ingredients (ingredient) VALUES ('Sweetened Condensed Milk');

INSERT INTO ingredients (ingredient) VALUES ('Butter');
INSERT INTO ingredients (ingredient) VALUES ('Graham Crackers');
INSERT INTO ingredients (ingredient) VALUES ('Sugar');

INSERT INTO ingredients (ingredient) VALUES ('Red food coloring');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,1);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,2);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (1,7);

INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (2,8);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (2,9);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (2,10);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (2,11);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (2,12);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (2,13);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (2,14);

INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (3,15);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (3,16);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (3,17);

INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (4,15);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (4,6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (4,18);
