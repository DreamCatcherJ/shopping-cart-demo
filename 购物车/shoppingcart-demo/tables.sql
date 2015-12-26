-- 创建T_Good表
CREATE TABLE IF NOT EXISTS T_Good
(
goodId INTEGER PRIMARY KEY NOT NULL,
good TEXT,
"createAt" TEXT DEFAULT (datetime('now', 'localtime'))
);

