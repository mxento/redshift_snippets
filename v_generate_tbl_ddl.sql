CREATE OR REPLACE VIEW v_generate_tbl_ddl
(
  schemaname,
  tablename,
  seq,
  ddl
)
AS 
 SELECT derived_table4.schemaname, derived_table4.tablename, derived_table4.seq, derived_table4.ddl
   FROM ( SELECT derived_table3.schemaname, derived_table3.tablename, derived_table3.seq, derived_table3.ddl
           FROM ((((((((((((( SELECT n.nspname AS schemaname, c.relname AS tablename, 0 AS seq, ('--DROP TABLE "'::text + n.nspname::text + '"."'::text + c.relname::text + '";'::text)::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
             WHERE c.relkind = 'r'::"char"
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 2 AS seq, ('CREATE TABLE IF NOT EXISTS "'::text + n.nspname::text + '"."'::text + c.relname::text + '"'::text)::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
             WHERE c.relkind = 'r'::"char")
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 5 AS seq, '('::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
             WHERE c.relkind = 'r'::"char")
        UNION 
                 SELECT derived_table1.schemaname, derived_table1.tablename, derived_table1.seq, ('\011'::text + derived_table1.col_delim + derived_table1.col_name + ' '::text + derived_table1.col_datatype + ' '::text + derived_table1.col_nullable + ' '::text + derived_table1.col_default + ' '::text + derived_table1.col_encoding)::character varying AS ddl
                   FROM ( SELECT n.nspname AS schemaname, c.relname AS tablename, 100000000 + a.attnum AS seq, 
                                CASE
                                    WHEN a.attnum > 1 THEN ','::text
                                    ELSE ''::text
                                END AS col_delim, '"'::text + a.attname::text + '"'::text AS col_name, 
                                CASE
                                    WHEN strpos(upper(format_type(a.atttypid, a.atttypmod)), 'CHARACTER VARYING'::text) > 0 THEN "replace"(upper(format_type(a.atttypid, a.atttypmod)), 'CHARACTER VARYING'::text, 'VARCHAR'::text)
                                    WHEN strpos(upper(format_type(a.atttypid, a.atttypmod)), 'CHARACTER'::text) > 0 THEN "replace"(upper(format_type(a.atttypid, a.atttypmod)), 'CHARACTER'::text, 'CHAR'::text)
                                    ELSE upper(format_type(a.atttypid, a.atttypmod))
                                END AS col_datatype, 
                                CASE
                                    WHEN format_encoding(a.attencodingtype::integer) = 'none'::bpchar THEN ''::text
                                    ELSE 'ENCODE '::text + format_encoding(a.attencodingtype::integer)::text
                                END AS col_encoding, 
                                CASE
                                    WHEN a.atthasdef IS TRUE THEN 'DEFAULT '::text + adef.adsrc
                                    ELSE ''::text
                                END AS col_default, 
                                CASE
                                    WHEN a.attnotnull IS TRUE THEN 'NOT NULL'::text
                                    ELSE ''::text
                                END AS col_nullable
                           FROM pg_namespace n
                      JOIN pg_class c ON n.oid = c.relnamespace
                 JOIN pg_attribute a ON c.oid = a.attrelid
            LEFT JOIN pg_attrdef adef ON a.attrelid = adef.adrelid AND a.attnum = adef.adnum
           WHERE c.relkind = 'r'::"char" AND a.attnum > 0
           ORDER BY a.attnum) derived_table1)
        UNION 
                ( SELECT n.nspname AS schemaname, c.relname AS tablename, 200000000 + con.oid::integer AS seq, ('\011,'::text + pg_get_constraintdef(con.oid))::character varying AS ddl
                   FROM pg_constraint con
              JOIN pg_class c ON c.relnamespace = con.connamespace AND c.oid = con.conrelid
         JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relkind = 'r'::"char" AND pg_get_constraintdef(con.oid) !~~ 'FOREIGN KEY%'::text
        ORDER BY 200000000 + con.oid::integer))
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 299999999 AS seq, ')'::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
             WHERE c.relkind = 'r'::"char")
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 300000000 AS seq, 'BACKUP NO'::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
         JOIN ( SELECT split_part(pg_conf."key"::text, '_'::text, 5) AS id
                      FROM pg_conf
                     WHERE pg_conf."key" ~~ 'pg_class_backup_%'::text AND split_part(pg_conf."key"::text, '_'::text, 4) = (( SELECT pg_database.oid
                              FROM pg_database
                             WHERE pg_database.datname = current_database()))::text) t ON t.id = c.oid::text
        WHERE c.relkind = 'r'::"char")
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 1 AS seq, '--WARNING: This DDL inherited the BACKUP NO property from the source table'::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
         JOIN ( SELECT split_part(pg_conf."key"::text, '_'::text, 5) AS id
                      FROM pg_conf
                     WHERE pg_conf."key" ~~ 'pg_class_backup_%'::text AND split_part(pg_conf."key"::text, '_'::text, 4) = (( SELECT pg_database.oid
                              FROM pg_database
                             WHERE pg_database.datname = current_database()))::text) t ON t.id = c.oid::text
        WHERE c.relkind = 'r'::"char")
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 300000001 AS seq, 
                        CASE
                            WHEN c.reldiststyle = 0 THEN 'DISTSTYLE EVEN'::text
                            WHEN c.reldiststyle = 1 THEN 'DISTSTYLE KEY'::text
                            WHEN c.reldiststyle = 8 THEN 'DISTSTYLE ALL'::text
                            ELSE '<<Error - UNKNOWN DISTSTYLE>>'::text
                        END::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
             WHERE c.relkind = 'r'::"char")
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 400000000 + a.attnum AS seq, ('DISTKEY ("'::text + a.attname::text + '")'::text)::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
         JOIN pg_attribute a ON c.oid = a.attrelid
        WHERE c.relkind = 'r'::"char" AND a.attisdistkey IS TRUE AND a.attnum > 0)
        UNION 
                 SELECT derived_table2.schemaname, derived_table2.tablename, derived_table2.seq, 
                        CASE
                            WHEN derived_table2.min_sort < 0 THEN 'INTERLEAVED SORTKEY ('::text
                            ELSE 'SORTKEY ('::text
                        END::character varying AS ddl
                   FROM ( SELECT n.nspname AS schemaname, c.relname AS tablename, 499999999 AS seq, min(a.attsortkeyord) AS min_sort
                           FROM pg_namespace n
                      JOIN pg_class c ON n.oid = c.relnamespace
                 JOIN pg_attribute a ON c.oid = a.attrelid
                WHERE c.relkind = 'r'::"char" AND abs(a.attsortkeyord) > 0 AND a.attnum > 0
                GROUP BY n.nspname, c.relname, 3) derived_table2)
        UNION 
                ( SELECT n.nspname AS schemaname, c.relname AS tablename, 500000000 + abs(a.attsortkeyord) AS seq, 
                        CASE
                            WHEN abs(a.attsortkeyord) = 1 THEN '\011"'::text + a.attname::text + '"'::text
                            ELSE '\011, "'::text + a.attname::text + '"'::text
                        END::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
         JOIN pg_attribute a ON c.oid = a.attrelid
        WHERE c.relkind = 'r'::"char" AND abs(a.attsortkeyord) > 0 AND a.attnum > 0
        ORDER BY abs(a.attsortkeyord)))
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 599999999 AS seq, '\011)'::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
         JOIN pg_attribute a ON c.oid = a.attrelid
        WHERE c.relkind = 'r'::"char" AND abs(a.attsortkeyord) > 0 AND a.attnum > 0)
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 600000000 AS seq, ';'::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
             WHERE c.relkind = 'r'::"char") derived_table3
UNION 
        ( SELECT 'zzzzzzzz'::name AS schemaname, 'zzzzzzzz'::name AS tablename, 700000000 + con.oid::integer AS seq, ('ALTER TABLE '::text + n.nspname::text + '.'::text + c.relname::text + ' ADD '::text + pg_get_constraintdef(con.oid)::character varying(1024)::text + ';'::text)::character varying AS ddl
           FROM pg_constraint con
      JOIN pg_class c ON c.relnamespace = con.connamespace AND c.oid = con.conrelid
   JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE c.relkind = 'r'::"char" AND pg_get_constraintdef(con.oid) ~~ 'FOREIGN KEY%'::text
  ORDER BY 700000000 + con.oid::integer)
  ORDER BY 1, 2, 3) derived_table4;


COMMIT;