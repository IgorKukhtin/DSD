-- Change History:
-- 2022-09-19  MJV FIX: Do not add CREATE INDEX statements if they indexes are defined within the Table definition as ADD CONSTRAINT.
-- 2022-12-03  MJV FIX: Handle NULL condition for ENUMs
-- 2022-12-07  MJV FIX: not setting tablespace correctly for user defined tablespaces
do $$ 
<<first_block>>
DECLARE
    cnt int;
BEGIN
  SELECT count(*) into cnt
  FROM pg_catalog.pg_type t LEFT JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace WHERE (t.typrelid = 0 OR (SELECT c.relkind = 'c' FROM pg_catalog.pg_class c WHERE c.oid = t.typrelid)) 
  AND NOT EXISTS(SELECT 1 FROM pg_catalog.pg_type el WHERE el.oid = t.typelem AND el.typarray = t.oid)
  AND n.nspname <> 'pg_catalog' AND n.nspname <> 'information_schema' AND pg_catalog.pg_type_is_visible(t.oid)
  -- AND pg_catalog.format_type(t.oid, NULL) in ('tabledef_fkeys','tabledef_trigs', 'tabledefs');
  AND pg_catalog.format_type(t.oid, NULL) in ('tabledefs');
  IF cnt = 0 THEN
    RAISE INFO 'Creating custom types.';
    -- CREATE TYPE public.tabledef_fkeys AS ENUM ('FKEYS_INTERNAL', 'FKEYS_EXTERNAL', 'FKEYS_COMMENTED', 'FKEYS_NONE');
    -- CREATE TYPE public.tabledef_trigs AS ENUM ('INCLUDE_TRIGGERS', 'NO_TRIGGERS');
	CREATE TYPE public.tabledefs AS ENUM ('FKEYS_INTERNAL', 'FKEYS_EXTERNAL', 'FKEYS_COMMENTED', 'FKEYS_NONE', 'INCLUDE_TRIGGERS', 'NO_TRIGGERS');
  END IF;
end first_block $$;

-- SELECT * FROM _replica.pg_get_tabledef('sample', 'address', false);
DROP FUNCTION IF EXISTS _replica.pg_get_tabledef(character varying,character varying,boolean,tabledefs[]);
CREATE OR REPLACE FUNCTION _replica.pg_get_tabledef(
  in_schema varchar,
  in_table varchar,
  _verbose boolean,
  VARIADIC arr public.tabledefs[] DEFAULT '{}':: public.tabledefs[]
)
RETURNS text
LANGUAGE plpgsql VOLATILE
AS
$$
 /* ********************************************************************************
COPYRIGHT NOTICE FOLLOWS.  DO NOT REMOVE
Copyright (c) 2022 SQLEXEC LLC

Permission to use, copy, modify, and distribute this software and its documentation 
for any purpose, without fee, and without a written agreement is hereby granted, 
provided that the above copyright notice and this paragraph and the following two paragraphs appear in all copies.

IN NO EVENT SHALL SQLEXEC LLC BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,INDIRECT SPECIAL, 
INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE 
OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF SQLEXEC LLC HAS BEEN ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.

SQLEXEC LLC SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. 
THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND SQLEXEC LLC HAS 
NO OBLIGATIONS TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

************************************************************************************ */

-- History:
-- Date	     Description
-- ==========   ======================================================================  
-- 2021-03-20   Original coding using some snippets from 
--              https://stackoverflow.com/questions/2593803/how-to-generate-the-create-table-sql-statement-for-an-existing-table-in-postgr
-- 2021-03-21   Added partitioned table support, i.e., PARTITION BY clause.
-- 2021-03-21   Added WITH clause logic where storage parameters for tables are set.
-- 2021-03-22   Added tablespace logic for tables and indexes.
-- 2021-03-24   Added inheritance-based partitioning support for PG 9.6 and lower.
-- 2022-09-12   Fixed Issue#1: Added fix for PostGIS columns where we do not presume the schema, leave without schema to imply public schema
  DECLARE
    v_table_ddl text;
    v_table_oid bigint;
    v_colrec record;
    v_constraintrec record;
    v_indexrec record;
    v_primary boolean := False;
    v_constraint_name text;
    v_fkey_defs text;
    v_trigger text := '';
    v_partition_key text := '';
    v_partbound text;
    v_parent text;
    v_persist text;
    v_temp  text := ''; 
    v_relopts text;
    v_tablespace text;
    v_pgversion bigint;
    v_table_serial Boolean;
    bPartition boolean;
    bInheritance boolean;
    bRelispartition boolean;
    constraintarr text[] := ARRAY[''];
    constraintelement text;
    bSkip boolean;
	bVerbose boolean := False;

    -- assume defaults for ENUMs at the getgo	
	fkcnt            int := 0;
	trigcnt          int := 0;
    fktype           public.tabledefs := 'FKEYS_INTERNAL';
    trigtype         public.tabledefs := 'NO_TRIGGERS';
    arglen           integer;
	vargs            text;
	avarg            public.tabledefs;

    -- exception variables
    v_ret            text;
    v_diag1          text;
    v_diag2          text;
    v_diag3          text;
    v_diag4          text;
    v_diag5          text;
    v_diag6          text;
	
  BEGIN
    IF _verbose THEN bVerbose = True; END IF;
	
    arglen := array_length($4, 1);
    IF arglen IS NULL THEN
        -- nothing to do, so assume defaults
        NULL;
    ELSE
        -- loop thru args
        -- IF 'NO_TRIGGERS' = ANY ($4)
        -- select array_to_string($4, ',', '***') INTO vargs;
        IF bVerbose THEN RAISE NOTICE 'arguments=%', $4; END IF;
        FOREACH avarg IN ARRAY $4 LOOP
            IF bVerbose THEN RAISE INFO 'arg=%', avarg; END IF;
            IF avarg = 'FKEYS_INTERNAL' OR avarg = 'FKEYS_EXTERNAL' OR avarg = 'FKEYS_COMMENTED' THEN
                fkcnt = fkcnt + 1;
                fktype = avarg;
            ELSEIF avarg = 'INCLUDE_TRIGGERS' OR avarg = 'NO_TRIGGERS' THEN
                trigcnt = trigcnt + 1;
                trigtype = avarg;
            END IF;
        END LOOP;
        IF fkcnt > 1 THEN 
	    RAISE WARNING 'Only one foreign key option can be provided. You provided %', fkcnt;
	    RETURN '';
        ELSEIF trigcnt > 1 THEN 
            RAISE WARNING 'Only one trigger option can be provided. You provided %', trigcnt;
            RETURN '';
        END IF;		   		   
    END IF;
	    
    SELECT c.oid, (select setting from pg_settings where name = 'server_version_num') INTO v_table_oid, v_pgversion FROM pg_catalog.pg_class c LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relkind in ('r','p') AND c.relname = in_table AND n.nspname = in_schema;
    IF bVerbose THEN RAISE NOTICE 'version=%', v_pgversion; END IF;
        	
    -- throw an error if table was not found
    IF (v_table_oid IS NULL) THEN
      RAISE EXCEPTION 'table does not exist';
    END IF;

    -- get user-defined tablespaces if applicable
    SELECT tablespace INTO v_temp FROM pg_tables WHERE schemaname = in_schema and tablename = in_table and tablespace IS NOT NULL;
    IF v_temp IS NULL THEN
      v_tablespace := 'TABLESPACE pg_default';
    ELSE
      v_tablespace := 'TABLESPACE ' || v_temp;
    END IF;    
    
    -- also see if there are any SET commands for this table, ie, autovacuum_enabled=off, fillfactor=70
    WITH relopts AS (SELECT unnest(c.reloptions) relopts FROM pg_class c, pg_namespace n WHERE n.nspname = in_schema and n.oid = c.relnamespace and c.relname = in_table) 
    SELECT string_agg(r.relopts, ', ') as relopts INTO v_temp from relopts r;
    IF v_temp IS NULL THEN
      v_relopts := '';
    ELSE
      v_relopts := ' WITH (' || v_temp || ')';
    END IF;
    
    -- -----------------------------------------------------------------------------------
    -- Create table defs for partitions/children using inheritance or declarative methods.
    -- inheritance: pg_class.relkind = 'r'   pg_class.relispartition=false   pg_class.relpartbound is NULL
    -- declarative: pg_class.relkind = 'r'   pg_class.relispartition=true    pg_class.relpartbound is NOT NULL
    -- -----------------------------------------------------------------------------------
    v_partbound := '';
    bPartition := False;
    bInheritance := False;
    IF v_pgversion < 100000 THEN
      SELECT c2.relname parent INTO v_parent from pg_class c1, pg_namespace n, pg_inherits i, pg_class c2
      WHERE n.nspname = in_schema and n.oid = c1.relnamespace and c1.relname = in_table and c1.oid = i.inhrelid and i.inhparent = c2.oid and c1.relkind = 'r';      
      IF (v_parent IS NOT NULL) THEN
        bPartition   := True;
        bInheritance := True;
      END IF;
    ELSE
      SELECT c2.relname parent, c1.relispartition, pg_get_expr(c1.relpartbound, c1.oid, true) INTO v_parent, bRelispartition, v_partbound from pg_class c1, pg_namespace n, pg_inherits i, pg_class c2
      WHERE n.nspname = in_schema and n.oid = c1.relnamespace and c1.relname = in_table and c1.oid = i.inhrelid and i.inhparent = c2.oid and c1.relkind = 'r';
      IF (v_parent IS NOT NULL) THEN
        bPartition   := True;
        IF bRelispartition THEN
          bInheritance := False;
        ELSE
          bInheritance := True;
        END IF;
      END IF;
    END IF;
   
    IF bPartition THEN
      IF bInheritance THEN
        -- inheritance-based
        v_table_ddl := 'CREATE TABLE ' || in_schema || '.' || in_table || '( '|| E'\n';
        -- Jump to constraints section to add the check constraints
      ELSE
        -- declarative-based
        IF v_relopts <> '' THEN
          v_table_ddl := 'CREATE TABLE ' || in_schema || '.' || in_table || ' PARTITION OF ' || in_schema || '.' || v_parent || ' ' || v_partbound || v_relopts || ' ' || v_tablespace || '; ' || E'\n';
        ELSE
          v_table_ddl := 'CREATE TABLE ' || in_schema || '.' || in_table || ' PARTITION OF ' || in_schema || '.' || v_parent || ' ' || v_partbound || ' ' || v_tablespace || '; ' || E'\n';
        END IF;
        -- Jump to constraints and index section to add the check constraints and indexes and perhaps FKeys
      END IF;
    END IF;
	IF bVerbose THEN RAISE INFO '(1)tabledef so far: %', v_table_ddl; END IF;

    IF NOT bPartition THEN
      -- see if this is unlogged or temporary table
      select c.relpersistence into v_persist from pg_class c, pg_namespace n where n.nspname = in_schema and n.oid = c.relnamespace and c.relname = in_table and c.relkind = 'r';
      IF v_persist = 'u' THEN
        v_temp := 'UNLOGGED';
      ELSIF v_persist = 't' THEN
        v_temp := 'TEMPORARY';
      ELSE
        v_temp := '';
      END IF;
    END IF;
    
    v_table_serial := False;
    
    -- start the create definition for regular tables unless we are in progress creating an inheritance-based child table
    IF NOT bPartition THEN
      v_table_ddl := 'CREATE ' || v_temp || ' TABLE ' || in_schema || '.' || in_table || ' (' || E'\n';
    END IF;
    -- RAISE INFO 'DEBUG2: tabledef so far: %', v_table_ddl;    
    -- define all of the columns in the table unless we are in progress creating an inheritance-based child table
    IF NOT bPartition THEN
      FOR v_colrec IN
        SELECT c.column_name, c.data_type, c.udt_name, c.character_maximum_length, c.is_nullable, c.column_default, c.numeric_precision, c.numeric_scale, c.is_identity, c.identity_generation, c.domain_name        
        FROM information_schema.columns c WHERE (table_schema, table_name) = (in_schema, in_table) ORDER BY ordinal_position
      LOOP
        v_table_ddl := v_table_ddl || '  ' -- note: two char spacer to start, to indent the column
          || v_colrec.column_name || ' '
          -- || CASE WHEN v_colrec.data_type = 'USER-DEFINED' THEN in_schema || '.' || v_colrec.udt_name ELSE v_colrec.data_type END 
          || CASE WHEN v_colrec.udt_name in ('geometry', 'box2d', 'box2df', 'box3d', 'geography', 'geometry_dump', 'gidx', 'spheroid', 'valid_detail') THEN v_colrec.udt_name 
                  WHEN v_colrec.data_type = 'integer' AND v_colrec.column_default ILIKE '%'||in_table||'_'||v_colrec.column_name||'_seq%' THEN 'SERIAL'
                  WHEN v_colrec.data_type = 'bigint' AND v_colrec.column_default ILIKE '%'||in_table||'_'||v_colrec.column_name||'_seq%' THEN 'BIGSERIAL'
                  WHEN v_colrec.data_type = 'USER-DEFINED' THEN in_schema || '.' || v_colrec.udt_name 
                  WHEN v_colrec.domain_name IS NOT NULL THEN in_schema || '.' || v_colrec.domain_name 
                  ELSE v_colrec.data_type END 
          || CASE WHEN v_colrec.is_identity = 'YES' THEN CASE WHEN v_colrec.identity_generation = 'ALWAYS' THEN ' GENERATED ALWAYS AS IDENTITY' ELSE ' GENERATED BY DEFAULT AS IDENTITY' END ELSE '' END
          || CASE WHEN v_colrec.character_maximum_length IS NOT NULL AND v_colrec.domain_name IS NULL THEN ('(' || v_colrec.character_maximum_length || ')') 
                  WHEN v_colrec.numeric_precision > 0 AND v_colrec.numeric_scale > 0 AND v_colrec.domain_name IS NULL THEN '(' || v_colrec.numeric_precision || ',' || v_colrec.numeric_scale || ')' 
             ELSE '' END || ' '
          || CASE WHEN v_colrec.is_nullable = 'NO' THEN 'NOT NULL' ELSE 'NULL' END
          || CASE WHEN v_colrec.data_type in ('integer', 'bigint') AND v_colrec.column_default ILIKE '%'||in_table||'_'||v_colrec.column_name||'_seq%' THEN ' PRIMARY KEY'
                  WHEN v_colrec.column_default IS NOT null THEN (' DEFAULT ' || v_colrec.column_default) ELSE '' END
          || ',' || E'\n';
          
         v_table_serial := v_table_serial OR 
           COALESCE(v_colrec.data_type  in ('integer', 'bigint') AND v_colrec.column_default ILIKE '%'||in_table||'_'||v_colrec.column_name||'_seq%', FALSE);
      END LOOP;
    END IF;
    IF bVerbose THEN RAISE INFO '(2)tabledef so far: %', v_table_ddl; END IF;
    
    -- define all the constraints
    FOR v_constraintrec IN
      SELECT con.conname as constraint_name, con.contype as constraint_type,
        CASE
          WHEN con.contype = 'p' THEN 1 -- primary key constraint
          WHEN con.contype = 'u' THEN 2 -- unique constraint
          WHEN con.contype = 'f' THEN 3 -- foreign key constraint
          WHEN con.contype = 'c' THEN 4
          ELSE 5
        END as type_rank,
        pg_get_constraintdef(con.oid) as constraint_definition
      FROM pg_catalog.pg_constraint con JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid JOIN pg_catalog.pg_namespace nsp ON nsp.oid = connamespace
      WHERE nsp.nspname = in_schema AND rel.relname = in_table
        AND v_table_serial = FALSE AND con.contype = 'p' ORDER BY type_rank
    LOOP
      IF v_constraintrec.type_rank = 1 THEN
          v_primary := True;
          v_constraint_name := v_constraintrec.constraint_name;
          IF bPartition THEN
            continue;
          END IF;
      END IF;
      -- RAISE INFO 'DEBUG4: constraint name= %', v_constraintrec.constraint_name;    
      constraintarr := array_append(constraintarr, v_constraintrec.constraint_name::TEXT);

      IF fktype <> 'FKEYS_INTERNAL' AND v_constraintrec.constraint_type = 'f' THEN
          continue;
      END IF;

      v_table_ddl := v_table_ddl || '  ' -- note: two char spacer to start, to indent the column
        || 'CONSTRAINT' || ' '
        || v_constraintrec.constraint_name || ' '
        || v_constraintrec.constraint_definition
        || ',' || E'\n';
    END LOOP;
    IF bVerbose THEN RAISE INFO '(3)tabledef so far: %', v_table_ddl; END IF;
	
    -- drop the last comma before ending the create statement
    v_table_ddl = substr(v_table_ddl, 0, length(v_table_ddl) - 1) || E'\n';

    -- ---------------------------------------------------------------------------
    -- at this point we have everything up to the last table-enclosing parenthesis
    -- ---------------------------------------------------------------------------
    IF bVerbose THEN RAISE INFO '(4)tabledef so far: %', v_table_ddl; END IF;

    -- See if this is an inheritance-based child table and finish up the table create.
    IF bPartition and bInheritance THEN
      v_table_ddl := v_table_ddl || ') INHERITS (' || in_schema || '.' || v_parent || ') ' || E'\n' || v_relopts || ' ' || v_tablespace || ';' || E'\n';
    END IF;

    IF v_pgversion >= 100000 AND NOT bPartition and NOT bInheritance THEN
      -- See if this is a partitioned table (pg_class.relkind = 'p') and add the partitioned key 
      SELECT pg_get_partkeydef(c1.oid) as partition_key INTO v_partition_key FROM pg_class c1 JOIN pg_namespace n ON (n.oid = c1.relnamespace) LEFT JOIN pg_partitioned_table p ON (c1.oid = p.partrelid) 
      WHERE n.nspname = in_schema and n.oid = c1.relnamespace and c1.relname = in_table and c1.relkind = 'p';

      IF v_partition_key IS NOT NULL AND v_partition_key <> '' THEN
        -- add partition clause
        -- NOTE:  cannot specify default tablespace for partitioned relations
        -- v_table_ddl := v_table_ddl || ') PARTITION BY ' || v_partition_key || ' ' || v_tablespace || ';' || E'\n';  
        v_table_ddl := v_table_ddl || ') PARTITION BY ' || v_partition_key || ';' || E'\n';  
      ELSEIF v_relopts <> '' THEN
        v_table_ddl := v_table_ddl || ') ' || v_relopts || ' ' || v_tablespace || ';' || E'\n';  
      ELSE
        -- end the create definition
        v_table_ddl := v_table_ddl || ') ' || v_tablespace || ';' || E'\n';    
      END IF; 
    ELSE
        v_table_ddl := v_table_ddl || ') ' || v_tablespace || ';' || E'\n';         
    END IF;

    IF bVerbose THEN RAISE INFO '(5)tabledef so far: %', v_table_ddl; END IF;
    
    -- Add closing paren for regular tables
    -- IF NOT bPartition THEN
    -- v_table_ddl := v_table_ddl || ') ' || v_relopts || ' ' || v_tablespace || E';\n';  
    -- END IF;
    -- RAISE NOTICE 'ddlsofar3: %', v_table_ddl;
   
    -- create indexes
/*    FOR v_indexrec IN
      SELECT indexdef, COALESCE(tablespace, 'pg_default') as tablespace, indexname FROM pg_indexes WHERE (schemaname, tablename) = (in_schema, in_table)
    LOOP
      -- RAISE INFO 'DEBUG6: indexname=%', v_indexrec.indexname;             
      -- loop through constraints and skip ones already defined
      bSkip = False;
      FOREACH constraintelement IN ARRAY constraintarr
      LOOP 
         IF constraintelement = v_indexrec.indexname THEN
             -- RAISE INFO 'DEBUG7: skipping index, %', v_indexrec.indexname;
             bSkip = True;
             EXIT;
         END IF;
      END LOOP;   
      if bSkip THEN CONTINUE; END IF;
      
      -- Add IF NOT EXISTS clause so partition index additions will not be created if declarative partition in effect and index already created on parent
      v_indexrec.indexdef := REPLACE(v_indexrec.indexdef, 'CREATE INDEX', 'CREATE INDEX IF NOT EXISTS');
      -- RAISE INFO 'DEBUG8: adding index, %', v_indexrec.indexname;
      
      -- NOTE:  cannot specify default tablespace for partitioned relations
      IF v_partition_key IS NOT NULL AND v_partition_key <> '' THEN
          v_table_ddl := v_table_ddl || v_indexrec.indexdef || ';' || E'\n';
      ELSE
          v_table_ddl := v_table_ddl || v_indexrec.indexdef || ' TABLESPACE ' || v_indexrec.tablespace || ';' || E'\n';
      END IF;
      
    END LOOP;*/
    IF bVerbose THEN RAISE INFO '(6)tabledef so far: %', v_table_ddl; END IF;
    
    -- Handle external foreign key defs here if applicable. 
    IF fktype = 'FKEYS_EXTERNAL' THEN
      SELECT 'ALTER TABLE ONLY ' || n.nspname || '.' || c2.relname || ' ADD CONSTRAINT ' || r.conname || ' ' || pg_catalog.pg_get_constraintdef(r.oid, true) || ';' into v_fkey_defs 
      FROM pg_constraint r, pg_class c1, pg_namespace n, pg_class c2 where r.conrelid = c1.oid and  r.contype = 'f' and n.nspname = in_schema and n.oid = r.connamespace and r.conrelid = c2.oid and c2.relname = in_table;
	  IF v_fkey_defs IS NOT NULL THEN
          v_table_ddl := v_table_ddl || v_fkey_defs;
	  END IF;
    ELSIF  fktype = 'FKEYS_COMMENTED' THEN 
      SELECT '-- ALTER TABLE ONLY ' || n.nspname || '.' || c2.relname || ' ADD CONSTRAINT ' || r.conname || ' ' || pg_catalog.pg_get_constraintdef(r.oid, true) || ';' into v_fkey_defs 
      FROM pg_constraint r, pg_class c1, pg_namespace n, pg_class c2 where r.conrelid = c1.oid and  r.contype = 'f' and n.nspname = in_schema and n.oid = r.connamespace and r.conrelid = c2.oid and c2.relname = in_table;
	  IF v_fkey_defs IS NOT NULL THEN
          v_table_ddl := v_table_ddl || v_fkey_defs;
      END IF;
    END IF;
    IF bVerbose THEN RAISE INFO '(7)tabledef so far: %', v_table_ddl; END IF;
	
    IF trigtype = 'INCLUDE_TRIGGERS' THEN
      select pg_get_triggerdef(t.oid, True) || ';' INTO v_trigger FROM pg_trigger t, pg_class c, pg_namespace n 
      WHERE n.nspname = in_schema and n.oid = c.relnamespace and c.relname = in_table and c.relkind = 'r' and t.tgrelid = c.oid and NOT t.tgisinternal;
      IF v_trigger <> '' THEN
        v_table_ddl := v_table_ddl || v_trigger;
      END IF;  
    END IF;
  
    -- add empty line
    v_table_ddl := v_table_ddl || E'\n';

    RETURN v_table_ddl;
	
    EXCEPTION
    WHEN others THEN
    BEGIN
      GET STACKED DIAGNOSTICS v_diag1 = MESSAGE_TEXT, v_diag2 = PG_EXCEPTION_DETAIL, v_diag3 = PG_EXCEPTION_HINT, v_diag4 = RETURNED_SQLSTATE, v_diag5 = PG_CONTEXT, v_diag6 = PG_EXCEPTION_CONTEXT;
      -- v_ret := 'line=' || v_diag6 || '. '|| v_diag4 || '. ' || v_diag1 || ' .' || v_diag2 || ' .' || v_diag3;
      v_ret := 'line=' || v_diag6 || '. '|| v_diag4 || '. ' || v_diag1;
      RAISE EXCEPTION '%', v_ret;
      -- put additional coding here if necessarY
       RETURN '';
    END;

  END;
$$;
  