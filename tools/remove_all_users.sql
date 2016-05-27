-- cleanup every users
-- Usage: mysql mysql < remove_all_users.sql
-- requires root privileges
--
SET sql_log_bin=0;
DELETE FROM user         WHERE user NOT IN('root', 'debian-sys-maint');
DELETE FROM db           WHERE user NOT IN('root', 'debian-sys-maint');
DELETE FROM columns_priv WHERE user NOT IN('root', 'debian-sys-maint');
FLUSH PRIVILEGES;
