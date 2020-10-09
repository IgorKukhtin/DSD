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
    group by T.table_name, B.table_name; 
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎĞÈß ĞÀÇĞÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎĞ
               Ïîäìîãèëüíûé Â.Â.
 07.10.20          *
*/
