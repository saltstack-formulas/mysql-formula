-- cleanup every users (except those mentioned)
-- Usage:
--   mysql mysql < remove_all_users.sql
-- requires root privileges!
--
-- remote_exec: mysql -u root --password="$(salt-call config.get mysql:server:root_password --out=newline_values_only)" mysql < remove_all_users.sql
SET sql_log_bin=0;
DELETE FROM user         WHERE user NOT IN('root', 'debian-sys-maint');
DELETE FROM db           WHERE user NOT IN('root', 'debian-sys-maint');
DELETE FROM columns_priv WHERE user NOT IN('root', 'debian-sys-maint');
FLUSH PRIVILEGES;
