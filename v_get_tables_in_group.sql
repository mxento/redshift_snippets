CREATE OR REPLACE VIEW v_get_tables_in_group
(
  groupname,
  grantsql,
  schema,
  tablename
)
AS 
 SELECT pu.groname AS groupname, ((((((('grant '::character varying::text || "substring"((((((((((
        CASE
            WHEN charindex('r'::character varying::text, split_part(split_part(array_to_string(derived_table1.relacl, '|'::character varying::text), pu.groname::character varying::text, 2), '/'::character varying::text, 1)) > 0 THEN ',select '::character varying
            ELSE ''::character varying
        END::text || 
        CASE
            WHEN charindex('w'::character varying::text, split_part(split_part(array_to_string(derived_table1.relacl, '|'::character varying::text), pu.groname::character varying::text, 2), '/'::character varying::text, 1)) > 0 THEN ',update '::character varying
            ELSE ''::character varying
        END::text) || 
        CASE
            WHEN charindex('a'::character varying::text, split_part(split_part(array_to_string(derived_table1.relacl, '|'::character varying::text), pu.groname::character varying::text, 2), '/'::character varying::text, 1)) > 0 THEN ',insert '::character varying
            ELSE ''::character varying
        END::text) || 
        CASE
            WHEN charindex('d'::character varying::text, split_part(split_part(array_to_string(derived_table1.relacl, '|'::character varying::text), pu.groname::character varying::text, 2), '/'::character varying::text, 1)) > 0 THEN ',delete '::character varying
            ELSE ''::character varying
        END::text) || 
        CASE
            WHEN charindex('R'::character varying::text, split_part(split_part(array_to_string(derived_table1.relacl, '|'::character varying::text), pu.groname::character varying::text, 2), '/'::character varying::text, 1)) > 0 THEN ',rule '::character varying
            ELSE ''::character varying
        END::text) || 
        CASE
            WHEN charindex('x'::character varying::text, split_part(split_part(array_to_string(derived_table1.relacl, '|'::character varying::text), pu.groname::character varying::text, 2), '/'::character varying::text, 1)) > 0 THEN ',references '::character varying
            ELSE ''::character varying
        END::text) || 
        CASE
            WHEN charindex('t'::character varying::text, split_part(split_part(array_to_string(derived_table1.relacl, '|'::character varying::text), pu.groname::character varying::text, 2), '/'::character varying::text, 1)) > 0 THEN ',trigger '::character varying
            ELSE ''::character varying
        END::text) || 
        CASE
            WHEN charindex('X'::character varying::text, split_part(split_part(array_to_string(derived_table1.relacl, '|'::character varying::text), pu.groname::character varying::text, 2), '/'::character varying::text, 1)) > 0 THEN ',execute '::character varying
            ELSE ''::character varying
        END::text) || 
        CASE
            WHEN charindex('U'::character varying::text, split_part(split_part(array_to_string(derived_table1.relacl, '|'::character varying::text), pu.groname::character varying::text, 2), '/'::character varying::text, 1)) > 0 THEN ',usage '::character varying
            ELSE ''::character varying
        END::text) || 
        CASE
            WHEN charindex('C'::character varying::text, split_part(split_part(array_to_string(derived_table1.relacl, '|'::character varying::text), pu.groname::character varying::text, 2), '/'::character varying::text, 1)) > 0 THEN ',create '::character varying
            ELSE ''::character varying
        END::text) || 
        CASE
            WHEN charindex('T'::character varying::text, split_part(split_part(array_to_string(derived_table1.relacl, '|'::character varying::text), pu.groname::character varying::text, 2), '/'::character varying::text, 1)) > 0 THEN ',temporary '::character varying
            ELSE ''::character varying
        END::text, 2, 10000)) || 'on '::character varying::text) || derived_table1.namespace::character varying::text) || '.'::character varying::text) || derived_table1.item::character varying::text) || ' to group "'::character varying::text) || pu.groname::character varying::text) || '";'::character varying::text AS grantsql, derived_table1.namespace::character varying AS "schema", derived_table1.item AS tablename
   FROM ( SELECT use.usename AS subject, nsp.nspname AS namespace, c.relname AS item, c.relkind AS "type", use2.usename AS "owner", c.relacl
           FROM pg_user use
     CROSS JOIN pg_class c
   LEFT JOIN pg_namespace nsp ON c.relnamespace = nsp.oid
   LEFT JOIN pg_user use2 ON c.relowner = use2.usesysid
  WHERE c.relowner = use.usesysid AND nsp.nspname <> 'pg_catalog'::name AND nsp.nspname <> 'pg_toast'::name AND nsp.nspname <> 'information_schema'::name
  ORDER BY use.usename, nsp.nspname, c.relname) derived_table1
   LEFT JOIN pg_group pu ON array_to_string(derived_table1.relacl, '|'::character varying::text) ~~ (('% '::character varying::text || pu.groname::character varying::text) || '%'::character varying::text)
  WHERE derived_table1.relacl IS NOT NULL
  ORDER BY pu.groname;
 