-- cleanup every users (except those mentioned)
-- Usage:
--   mysql mysql < remove_all_users.sql
--   #or
--   salt-cp 'minion' remove_all_users.sql /root
--   salt 'minion' cmd.run 'mysql mysql < remove_all_users.sql'
-- requires root privileges!
--
SET sql_log_bin=0;
DELETE FROM user         WHERE user NOT IN('root', 'debian-sys-maint');
DELETE FROM db           WHERE user NOT IN('root', 'debian-sys-maint');
DELETE FROM columns_priv WHERE user NOT IN('root', 'debian-sys-maint');
FLUSH PRIVILEGES;
