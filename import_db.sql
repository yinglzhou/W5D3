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


INSERT INTO
    users(fname, lname)
VALUES
    ('Ying', 'Zhou'),
    ('Kevin', 'Chan'),
    ('Alvin', 'Zablan');


INSERT INTO
    questions(title, body, associated_author_id)
VALUES
    ('Pets', 'What kind of pets do you have?', (SELECT id FROM users WHERE fname = 'Ying' AND lname = 'Zhou'))
    ('Fruits', 'What kind of fruits do you like?', (SELECT id FROM users WHERE fname = 'Kevin' AND lname = 'Chan'))
    ('Colors', 'What kind of colors do you like?', (SELECT id FROM users WHERE fname = 'Ying' AND lname = 'Zhou'))
    ('Languages', 'What kind of coding language do you use?', (SELECT id FROM users WHERE fname = 'Alvin' AND lname = 'Zablan'));


INSERT INTO
    question_follows(question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE title = 'Colors')
        ,(SELECT id FROM users WHERE fname = 'Ying' AND lname = 'Zhou')),

    ((SELECT id FROM questions WHERE title = 'Colors')
        ,(SELECT id FROM users WHERE fname = 'Kevin' AND lname = 'Chan')),

    ((SELECT id FROM questions WHERE title = 'Colors')
        ,(SELECT id FROM users WHERE fname = 'Alvin' AND lname = 'Zablan')),

    ((SELECT id FROM questions WHERE title = 'Fruits')
        ,(SELECT id FROM users WHERE fname = 'Kevin' AND lname = 'Chan'));


INSERT INTO
    replies(subject_question_id, parent_reply_id, body, associated_author_id)
VALUES
    ((SELECT id FROM questions WHERE title = 'Pets'),
        NULL,
        'I have a cat',
        (SELECT id FROM users WHERE fname = 'Ying' AND lname = 'Zhou')),

    ((SELECT id FROM questions WHERE title = 'Pets'),
        (SELECT id FROM replies WHERE body = 'I have a cat' 
        AND subject_question_id = (SELECT id FROM questions WHERE title = 'Pets') 
        AND (SELECT id FROM users WHERE fname = 'Ying' AND lname = 'Zhou')),
        'I have a dog',
        (SELECT id FROM users WHERE fname = 'Kevin' AND lname = 'Chan')),

    ((SELECT id FROM questions WHERE title = 'Languages'),
        NULL,
        'I use Ruby',
        (SELECT id FROM users WHERE fname = 'Alvin' AND lname = 'Zablan')),
    
    ((SELECT id FROM questions WHERE title = 'Languages'),
        (SELECT id FROM replies WHERE body = 'I use Ruby' 
        AND subject_question_id = (SELECT id FROM questions WHERE title = 'Languages') 
        AND (SELECT id FROM users WHERE fname = 'Alvin' AND lname = 'Zablan')),
        'I use Javascript',
        (SELECT id FROM users WHERE fname = 'Kevin' AND lname = 'Chan')),

    ((SELECT id FROM questions WHERE title = 'Languages'),
        (SELECT id FROM replies WHERE body = 'I use Ruby' 
        AND subject_question_id = (SELECT id FROM questions WHERE title = 'Languages') 
        AND (SELECT id FROM users WHERE fname = 'Alvin' AND lname = 'Zablan')),
        'I also use Ruby',
        (SELECT id FROM users WHERE fname = 'Ying' AND lname = 'Zhao'));


INSERT INTO
    question_likes(user_like, user_id, question_id)
VALUES
    (TRUE, (SELECT id FROM users WHERE fname = 'Kevin' AND lname = 'Chan'), (SELECT id FROM questions WHERE title = 'Colors'))





