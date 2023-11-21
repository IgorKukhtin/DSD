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
  /*where T.table_name NOT ILIKE 'objecthistorylink'
      and T.table_name NOT ILIKE 'objecthistorylinkdesc'
      and T.table_name NOT ILIKE 'container'
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
      and T.table_name NOT ILIKE 'wms_to_host_message'
      and T.table_name NOT ILIKE 'movementitem'
      and T.table_name NOT ILIKE 'objectbooleandesc'
      and T.table_name NOT ILIKE 'objectdatedesc'
      and T.table_name NOT ILIKE 'objecthistoryfloatdesc'
      and T.table_name NOT ILIKE 'objectfloat'
      and T.table_name NOT ILIKE 'wms_movement_weighingproduction22'
      and T.table_name NOT ILIKE 'movementitemfloatdesc'
      and T.table_name NOT ILIKE 'movementdatedesc'
      and T.table_name NOT ILIKE 'movementitemdate'
      and T.table_name NOT ILIKE 'wms_mi_weighingproduction'

      and T.table_name NOT ILIKE 'containerlinkobjectdesc'
      and T.table_name NOT ILIKE 'movementitemstringdesc'
      and T.table_name NOT ILIKE 'movementlinkobject'
      and T.table_name NOT ILIKE 'objectboolean'
      and T.table_name NOT ILIKE 'objectstringdesc'
      and T.table_name NOT ILIKE 'movementitemboolean'
      and T.table_name NOT ILIKE 'objecthistorystringdesc'
      and T.table_name NOT ILIKE 'userprotocol'
      and T.table_name NOT ILIKE 'containerdesc'
      and T.table_name NOT ILIKE 'historycost'
      and T.table_name NOT ILIKE 'movementdesc'*/

/*      
where T.table_name ILIKE 'movementitemstring'
   OR T.table_name ILIKE 'movementstringdesc'
   OR T.table_name ILIKE 'periodclose'
   OR T.table_name ILIKE 'movementlinkmovementdesc'
   OR T.table_name ILIKE 'movementstring'
   OR T.table_name ILIKE 'wms_message'
   OR T.table_name ILIKE 'movementitemprotocol_arc'
   OR T.table_name ILIKE 'objecthistorydatedesc'
   OR T.table_name ILIKE 'movementitemreport'
   OR T.table_name ILIKE 'movementlinkobjectdesc'
   OR T.table_name ILIKE 'objectstring'
   OR T.table_name ILIKE 'wms_object_pack'
   OR T.table_name ILIKE 'movementfloat'
   OR T.table_name ILIKE 'movementblob'
   OR T.table_name ILIKE 'movementblobdesc'
   OR T.table_name ILIKE 'objectlinkdesc'
   OR T.table_name ILIKE 'remainsolaptable'
   OR T.table_name ILIKE 'lockprotocol'
   OR T.table_name ILIKE 'objectfloatdesc'
   OR T.table_name ILIKE 'movement'
   OR T.table_name ILIKE 'movementitembooleandesc'
   OR T.table_name ILIKE 'movementbooleandesc'
   OR T.table_name ILIKE 'objectblobdesc'
   OR T.table_name ILIKE 'reportprotocol'
   OR T.table_name ILIKE 'objectprotocol'
   OR T.table_name ILIKE 'wms_tohostheader'
where T.table_name ILIKE 'movementitemcontainer'
   OR T.table_name ILIKE 'soldtable'
   OR T.table_name ILIKE 'resourseitemprotocol'*/

-- where T.table_name ILIKE 'MovementItemLinkObject'
-- where T.table_name ILIKE 'soldtable'
--   OR T.table_name ILIKE 'MovementItemProtocol_arc'

-- wms-1
-- where T.table_name ILIKE 'objectprotocol'
--    OR T.table_name ILIKE 'movementitemprotocol'
--   OR T.table_name ILIKE 'movementprotocol'

-- truncate table resourseprotocol
-- truncate table resourseitemprotocol

/* where  T.table_name ILIKE 'resourseprotocol'
     OR T.table_name ILIKE 'tmpprotocol'
     OR T.table_name ILIKE 'userprotocol'
     OR T.table_name ILIKE 'soldtable'
     OR T.table_name ILIKE 'movementBlob'
*/

-- cloud   
-- where T.table_name NOT ILIKE 'movementitemfloat'
/*   AND T.table_name NOT ILIKE 'ObjectBlob'
   and T.table_name NOT ILIKE 'container'
   and T.table_name NOT ILIKE 'containerdesc'
   and T.table_name NOT ILIKE 'containerlinkobject'
   and T.table_name NOT ILIKE 'movement'
   and T.table_name NOT ILIKE 'historycost'
   and T.table_name NOT ILIKE 'loginprotocol'
*/

    where T.table_name NOT ILIKE 'ObjectBlob'
      /*and T.table_name NOT ILIKE 'movementitemfloat'

      and T.table_name NOT ILIKE 'container'
      and T.table_name NOT ILIKE 'containerdesc'
      and T.table_name NOT ILIKE 'containerlinkobject'
      and T.table_name NOT ILIKE 'containerlinkobjectdesc'
      and T.table_name NOT ILIKE 'defaultkeys'
      and T.table_name NOT ILIKE 'defaultvalue'
      and T.table_name NOT ILIKE 'defermentpaymentolaptable'
      and T.table_name NOT ILIKE 'historycost'
      and T.table_name NOT ILIKE 'historycost_err'
      and T.table_name NOT ILIKE 'lockprotocol'
      and T.table_name NOT ILIKE 'loginprotocol'
      and T.table_name NOT ILIKE '_micontainer_20_03_2020_test'
      and T.table_name NOT ILIKE 'movement'
      and T.table_name NOT ILIKE 'movementblob'
      and T.table_name NOT ILIKE 'movementblobdesc'
      and T.table_name NOT ILIKE 'movementboolean'
      and T.table_name NOT ILIKE 'movementbooleandesc'
      and T.table_name NOT ILIKE 'movementdate'
      and T.table_name NOT ILIKE 'movementdatedesc'
      and T.table_name NOT ILIKE 'movementdesc'
      and T.table_name NOT ILIKE 'movementfloat'
      and T.table_name NOT ILIKE 'movementfloatdesc'
      and T.table_name NOT ILIKE 'movementitem'
      and T.table_name NOT ILIKE 'movementitemboolean'
      and T.table_name NOT ILIKE 'movementitembooleandesc'*/

/*
    where T.table_name ILIKE 'resourseprotocol'
       OR T.table_name ILIKE 'tmpprotocol'
       OR T.table_name ILIKE 'userprotocol'
       OR T.table_name ILIKE 'wms_from_host_error'
       OR T.table_name ILIKE 'wms_message'
       OR T.table_name ILIKE 'wms_mi_incoming'
       OR T.table_name ILIKE 'wms_mi_weighingproduction'
       OR T.table_name ILIKE 'wms_movement_weighingproduction'
       OR T.table_name ILIKE 'wms_movement_weighingproduction22'
       OR T.table_name ILIKE 'wms_object_goodsbygoodskind'
       OR T.table_name ILIKE 'wms_object_pack'
       OR T.table_name ILIKE 'wms_tohostdetail'
       OR T.table_name ILIKE 'wms_to_host_error'
       OR T.table_name ILIKE 'wms_tohostheader'
       OR T.table_name ILIKE 'wms_to_host_message'
       OR T.table_name ILIKE 'soldtable'
       OR T.table_name ILIKE 'resourseitemprotocol'
       */

    /*where T.table_name ILIKE 'container'
       or T.table_name ILIKE 'containerlinkobject'
       or T.table_name ILIKE 'movementitemcontainer'*/
       
--       or T.table_name ILIKE 'movement'
--       or T.table_name ILIKE 'movementitem'

    group by T.table_name, B.table_name
  order by case when T.table_name ilike 'resourseitemprotocol' then 102 
                when T.table_name ilike 'soldtable' then 101
                when T.table_name ilike 'movementitemfloat' then 1
                when T.table_name ilike 'ObjectBlob' then 2
                else 100 end
           , T.table_name
    OFFSET 21
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
