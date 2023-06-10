CREATE TABLE restaurant (
  id integer PRIMARY KEY,
  name varchar(20),
  description varchar(100),
  rating decimal,
  telephone char(10),
  hours varchar(100)
);

CREATE TABLE address (
  id integer PRIMARY KEY,
  street_number varchar(10),
  streetname varchar(20),
  city varchar(15),
  state varchar(15),
  google_map_link varchar(50),
  restaurant_id integer REFERENCES restaurant(id) UNIQUE
);

/*SELECT
  constraint_name, table_name, column_name
FROM
  information_schema.key_column_usage
WHERE
  table_name = 'restaurant';*/

/*SELECT
  constraint_name, table_name, column_name
FROM
  information_schema.key_column_usage
WHERE
  table_name = 'address';*/

CREATE TABLE category (
  id char(2) PRIMARY KEY,
  name varchar(20),
  description varchar(200)
);

CREATE TABLE dish (
  id integer PRIMARY KEY,
  name varchar(50),
  description varchar(200),
  hot_and_spicy boolean
);

CREATE TABLE review (
  id integer PRIMARY KEY,
  rating decimal,
  description varchar(100),
  date date,
   restaurant_id integer REFERENCES restaurant(id)
);

  /*SELECT constraint_name, table_name, column_name
FROM
  information_schema.key_column_usage
WHERE
  table_name = 'review';*/

-- cross-reference table for dish and category
CREATE TABLE categories_dishes (
  category_id char(2) REFERENCES category(id),
  dish_id integer REFERENCES dish(id),
  price money,
  PRIMARY KEY (category_id, dish_id)
);

-- Inserting dummy data

/* 
 *--------------------------------------------
 Insert values for restaurant
 *--------------------------------------------
 */
INSERT INTO restaurant VALUES (
  1,
  'Bytes of China',
  'Delectable Chinese Cuisine',
  3.9,
  '6175551212',
  'Mon - Fri 9:00 am to 9:00 pm, Weekends 10:00 am to 11:00 pm'
);

/* 
 *--------------------------------------------
 Insert values for address
 *--------------------------------------------
 */
INSERT INTO address VALUES (
  1,
  '2020',
  'Busy Street',
  'Chinatown',
  'MA',
  'http://bit.ly/BytesOfChina',
  1
);

/* 
 *--------------------------------------------
 Insert values for review
 *--------------------------------------------
 */
INSERT INTO review VALUES (
  1,
  5.0,
  'Would love to host another birthday party at Bytes of China!',
  '05-22-2020',
  1
);

INSERT INTO review VALUES (
  2,
  4.5,
  'Other than a small mix-up, I would give it a 5.0!',
  '04-01-2020',
  1
);

INSERT INTO review VALUES (
  3,
  3.9,
  'A reasonable place to eat for lunch, if you are in a rush!',
  '03-15-2020',
  1
);

/* 
 *--------------------------------------------
 Insert values for category
 *--------------------------------------------
 */
INSERT INTO category VALUES (
  'C',
  'Chicken',
  null
);

INSERT INTO category VALUES (
  'LS',
  'Luncheon Specials',
  'Served with Hot and Sour Soup or Egg Drop Soup and Fried or Steamed Rice  between 11:00 am and 3:00 pm from Monday to Friday.'
);

INSERT INTO category VALUES (
  'HS',
  'House Specials',
  null
);

/* 
 *--------------------------------------------
 Insert values for dish
 *--------------------------------------------
 */
INSERT INTO dish VALUES (
  1,
  'Chicken with Broccoli',
  'Diced chicken stir-fried with succulent broccoli florets',
  false
);

INSERT INTO dish VALUES (
  2,
  'Sweet and Sour Chicken',
  'Marinated chicken with tangy sweet and sour sauce together with pineapples and green peppers',
  false
);

INSERT INTO dish VALUES (
  3,
  'Chicken Wings',
  'Finger-licking mouth-watering entree to spice up any lunch or dinner',
  true
);

INSERT INTO dish VALUES (
  4,
  'Beef with Garlic Sauce',
  'Sliced beef steak marinated in garlic sauce for that tangy flavor',
  true
);

INSERT INTO dish VALUES (
  5,
  'Fresh Mushroom with Snow Peapods and Baby Corns',
  'Colorful entree perfect for vegetarians and mushroom lovers',
  false
);

INSERT INTO dish VALUES (
  6,
  'Sesame Chicken',
  'Crispy chunks of chicken flavored with savory sesame sauce',
  false
);

INSERT INTO dish VALUES (
  7,
  'Special Minced Chicken',
  'Marinated chicken breast sauteed with colorful vegetables topped with pine nuts and shredded lettuce.',
  false
);

INSERT INTO dish VALUES (
  8,
  'Hunan Special Half & Half',
  'Shredded beef in Peking sauce and shredded chicken in garlic sauce',
  true
);

/*
 *--------------------------------------------
 Insert valus for cross-reference table, categories_dishes
 *--------------------------------------------
 */
INSERT INTO categories_dishes VALUES (
  'C',
  1,
  6.95
);

INSERT INTO categories_dishes VALUES (
  'C',
  3,
  6.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  1,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  4,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  5,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  6,
  15.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  7,
  16.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  8,
  17.95
);
-- r; alias for restaurant, a; alias for address
SELECT
  r.name AS restaurant_name,
  a.street_number,
  a.streetname,
  r.telephone
FROM
  restaurant r
JOIN
  address a ON r.id = a.restaurant_id;

SELECT
  rating AS best_rating, description
FROM review
 WHERE rating = ( SELECT MAX(rating)
 from review);
 

-- dish_name, price, category
SELECT
  d.name AS dish_name,
  cd.price,
  c.name AS category
FROM 
  dish d
JOIN
  categories_dishes cd ON d.id = cd.dish_id
JOIN category c ON cd.category_id = c.id
ORDER BY
  dish_name;

-- category, dish_name, price
SELECT
  c.name AS category,
  d.name AS dish_name,
  cd.price
FROM 
  dish d
JOIN
  categories_dishes cd ON d.id = cd.dish_id
JOIN category c ON cd.category_id = c.id
ORDER BY
  dish_name;

-- spicy_dish_name, category, price
SELECT
  d.name AS spicy_dish_name,
  c.name AS category,
  cd.price
FROM 
  dish d
JOIN
  categories_dishes cd ON d.id = cd.dish_id
JOIN category c ON cd.category_id = c.id
WHERE d.hot_and_spicy = true;

/*SELECT dish_id, COUNT(dish_id) AS dish_count
FROM categories_dishes
GROUP BY dish_id;*/
/*SELECT d.name AS dish_name, COUNT(cd.dish_id) AS dish_count
FROM categories_dishes
GROUP BY dish_id
HAVING COUNT(dish_id) > 1;*(/)
*/
SELECT
  d.name AS dish_name,
  cd.dish_count
FROM
  dish d
JOIN
  (
    SELECT
      dish_id,
      COUNT(*) AS dish_count
    FROM
      categories_dishes
    GROUP BY
      dish_id
    HAVING
      COUNT(*) > 1
  ) cd ON d.id = cd.dish_id;

