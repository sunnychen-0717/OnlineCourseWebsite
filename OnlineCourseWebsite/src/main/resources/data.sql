-- 清空舊資料（選用，確保每次啟動都是乾淨的）
DELETE FROM users;

-- 插入老師帳號
INSERT INTO users (id, username, password, full_name, email, phone_number, role)
VALUES (1, 'db_teacher', '{noop}123456', 'Professor Chen', 'teacher@hkmu.edu.hk', '12345678', 'ROLE_TEACHER');

-- 插入學生帳號
INSERT INTO users (id, username, password, full_name, email, phone_number, role)
VALUES (2, 'db_test', '{noop}123456', 'DB Tester', 'test@hkmu.edu.hk', '98765432', 'ROLE_STUDENT');