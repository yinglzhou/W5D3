PRAGMA foreign_keys = ON

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    associated_author_id INTEGER NOT NULL

    FOREIGN KEY(associated_author_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id)
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies(
    id INTEGER PRIMARY KEY, 
    subject_question_id INTEGER NOT NULL,
    parent_reply_id INTEGER, 
    body TEXT NOT NULL,
    associated_author_id INTEGER NOT NULL,

    FOREIGN KEY (subject_question_id) REFERENCES questions(id)
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
    FOREIGN KEY (associated_author_id) REFERENCES users(id)
);

CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY, 
    user_like BOOLEAN NOT NULL,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL

    FOREIGN KEY (question_id) REFERENCES questions(id)
    FOREIGN KEY (user_id) REFERENCES users(id)
);