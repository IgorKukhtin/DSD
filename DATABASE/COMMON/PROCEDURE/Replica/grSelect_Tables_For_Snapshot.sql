-- Function: grSelect_Tables_For_Snapshot()

DROP FUNCTION IF EXISTS _replica.grSelect_Tables_For_Snapshot();

CREATE OR REPLACE FUNCTION _replica.grSelect_Tables_For_Snapshot()
RETURNS TABLE (
    table_name          TVarChar,
    key_fields          TVarChar, 
    is_composite_key    Boolean,
    has_blob            Boolean
) AS
$BODY$
BEGIN  
 
	return query
    select 
        T.table_name :: TVarChar, 
        string_agg(key_column, ',') :: TVarChar as key_fields, 
        case when max(position) > 1 then 1 else 0 end :: Boolean as is_composite_key,
        case when B.table_name is not null then 1 else 0 end ::Boolean as has_blob
      --case when T.table_name ILIKE 'ObjectBlob' then 1 else 0 end ::Boolean as has_blob
    from
    (
      select kcu.table_name,
             kcu.ordinal_position as position,
             kcu.column_name as key_column
      from information_schema.table_constraints tco
      join information_schema.key_column_usage kcu 
           on kcu.constraint_name = tco.constraint_name
           and kcu.constraint_schema = tco.constraint_schema
           and kcu.constraint_name = tco.constraint_name
      where tco.constraint_type = 'PRIMARY KEY' and kcu.table_schema = 'public'
      order by kcu.table_name,
               position
    ) T
    left join 
    (
      select C.table_name
      from information_schema.columns C
      where table_schema = 'public' and data_type = 'text'
    ) B on T.table_name = B.table_name
  /*where T.table_name NOT ILIKE 'MovementItem'
      and T.table_name NOT ILIKE 'objecthistorylinkdesc'
      and T.table_name NOT ILIKE 'Container'
      and T.table_name NOT ILIKE 'movementitemlinkobject'
      and T.table_name NOT ILIKE 'movementitemlinkobjectdesc'
      and T.table_name NOT ILIKE 'objectdesc'
      and T.table_name NOT ILIKE 'movementfloatdesc'
      and T.table_name NOT ILIKE 'objectprint'
      and T.table_name NOT ILIKE 'movementlinkmovement'
      and T.table_name NOT ILIKE 'objecthistorystring'
      and T.table_name NOT ILIKE 'movementprotocol_arc'
      and T.table_name NOT ILIKE 'objecthistorydate'
      and T.table_name NOT ILIKE 'defaultkeys'
      and T.table_name NOT ILIKE 'movementdate'
      and T.table_name NOT ILIKE 'objectbooleandesc'
      and T.table_name NOT ILIKE 'objectprotocol'
      and T.table_name NOT ILIKE 'wms_tohostheader'
      and T.table_name NOT ILIKE 'objectblobdesc'
      and T.table_name NOT ILIKE 'reportprotocol'
      and T.table_name NOT ILIKE 'movement'
      and T.table_name NOT ILIKE 'movementitembooleandesc'
      and T.table_name NOT ILIKE 'movementbooleandesc'

      and T.table_name not ILIKE 'movementitemcontainer'*/
    group by T.table_name, B.table_name
  --order by case when T.table_name ilike 'movementblob' then 0 else 1 end
    ; 
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               œÓ‰ÏÓ„ËÎ¸Ì˚È ¬.¬.
 07.10.20          *
*/

-- ÚÂÒÚ
-- SELECT * FROM _replica.grSelect_Tables_For_Snapshot()