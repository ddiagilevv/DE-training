-- Создаем пользователя ANALYST с паролем
CREATE USER ANALYST WITH PASSWORD 'secure_password';

-- Предоставляем права USAGE на схему OperationalData
GRANT USAGE ON SCHEMA OperationalData TO ANALYST;
-- Предоставляем права USAGE на схему RefData
GRANT USAGE ON SCHEMA RefData TO ANALYST;

-- Предоставляем права на чтение (SELECT) всех таблиц в схеме OperationalData
GRANT SELECT ON ALL TABLES IN SCHEMA OperationalData TO ANALYST;
-- Предоставляем права на чтение (SELECT) всех таблиц в схеме RefData
GRANT SELECT ON ALL TABLES IN SCHEMA RefData TO ANALYST;

-- Отзываем права на вставку, обновление, удаление для всех таблиц в схеме OperationalData
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA OperationalData FROM ANALYST;
-- Отзываем права на вставку, обновление, удаление для всех таблиц в схеме RefData
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA RefData FROM ANALYST;

-- Чтобы изменения в правах применялись также и к будущим таблицам, устанавливаем DEFAULT PRIVILEGES для схемы OperationalData
ALTER DEFAULT PRIVILEGES IN SCHEMA OperationalData
REVOKE INSERT, UPDATE, DELETE ON TABLES FROM ANALYST;

-- Устанавливаем DEFAULT PRIVILEGES для схемы RefData
ALTER DEFAULT PRIVILEGES IN SCHEMA RefData
REVOKE INSERT, UPDATE, DELETE ON TABLES FROM ANALYST;

-- Замените 'secure_password' на пароль, который вы хотите использовать для пользователя ANALYST
