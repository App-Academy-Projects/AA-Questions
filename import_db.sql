PRAGMA foreign_keys = ON;  -- This statement makes sqlite3 actually respect the foreign key constraints you've added in 'CREATE TABLE' statements


DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id  INTEGER NOT NULL,
    question_id  INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

-- SEEDING THE DATABASE

-- USERS
INSERT INTO
    users (fname, lname)
VALUES
    ("Ali", "Ahmed"), ("John", "Mic"), ("Mark", "Bob");

SELECT * FROM users;

-- QUESTIONS
INSERT INTO
  questions (title, body, author_id)
VALUES
    ("TITLE OF FIRST QUESTION", "FIRST QUESTION BODY", 1),
    ("TITLE OF SECOND QUESTION", "SECOND QUESTION BODY", 1),
    ("TITLE OF THIRD QUESTION", "THIRD QUESTION BODY", 2),
    ("TITLE OF FOURTH QUESTION", "FOURTH QUESTION BODY", 3);

SELECT * FROM questions;

-- QUESTION_FOLLOWS
INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1, 1),
  (1, 2),
  (2, 1),
  (3, 2),
  (3, 3);

SELECT * FROM question_follows;

-- REPLIES
INSERT INTO
  replies (question_id, parent_reply_id, author_id, body)
VALUES
    (2, 1, 2, "BODY OF REPLY ON REPLY WITH ID = 2 ON QUESTION WITH ID = 2"),
    (1, NULL, 3, "BODY OF REPLY ON QUESTION WITH ID = 2"),
    (3, 2, 3, "BODY OF REPLY ON REPLY WITH ID = 3 ON QUESTION WITH ID = 3");

SELECT * FROM replies;

-- QUESTION_LIKES
INSERT INTO
  question_likes (user_id, question_id)
VALUES
    (1, 3), (2, 1), (1, 2), (3, 2), (3, 3);

SELECT * FROM question_likes;