PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (id, fname, lname)
VALUES
  (1, 'Ziyuan', 'Han'),
  (2, 'Will', 'Weihnacht'),
  (3, 'Taylor', 'Muself'),
  (4, 'Rex', 'Kho');

INSERT INTO
    questions (id, title, body, author_id)
VALUES
    (1, 'Tickets', 'Somone buying tickets?', 1),
    (2, 'Venmo', 'Everone has Venmo?', 4),
    (3, 'Join', 'Can I come iceskating as well?', 3),
    (4, 'Flex', 'Do we have flex time today?', 2),
    (5, 'Other staff', 'Can other staff comee?', 3);

INSERT INTO
    question_follows (id,user_id,question_id)
VALUES
    (1,1,1),
    (1,1,2),
    (1,1,3),
    (1,2,3),
    (1,4,3);

INSERT INTO
    replies(id,body,user_id,parent_id,question_id)
VALUES
    (1,'I have venmo',1,NULL,2),
    (2,'I have venmo too',3,1,2),
    (3,'No flex time today',3,NULL,4),
    (4,'Can we add a flex time?',1,3,4),
    (5, 'No flex time?',4,4,4);

INSERT INTO
    question_likes(id,user_id,question_id)
VALUES
    (1,1,4),
    (2,2,4),
    (3,3,4),
    (4,3,2);