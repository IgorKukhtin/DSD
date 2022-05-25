-- Function: _replica.zc_isReplica_two()

-- DROP FUNCTION _replica.zc_isReplica_two();

CREATE OR REPLACE FUNCTION _replica.zc_isReplica_two()
RETURNS Boolean
AS
$BODY$
BEGIN 
     RETURN FALSE;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
  
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 20.02.21                                        *
*/

-- vacuum full _replica.table_update_data_two
-- vacuum analyze _replica.table_update_data_two
-- truncate table _replica.table_update_data_two
-- SELECT min (Id) , max (Id) , max (Id)   - min (Id) FROM _replica.table_update_data_two 
-- SELECT min (Id) , max (Id) , max (Id)   - min (Id) FROM _replica.table_update_data
/*insert into _replica.table_update_data
 SELECT * FROM _replica.table_update_data_two
 where id >= (select max(Id) from _replica.table_update_data) + 1
and  Id <= ...
order by Id
limit 10000000
*/

-- select last_value + 1001 from _replica.table_update_data_two_id_seq
-- alter sequence if exists _replica.table_update_data_id_seq restart with 4162328153;
-- alter sequence if exists _replica.table_update_data_two_id_seq restart with 4971964134;


-- òåñò
-- SELECT _replica.zc_isReplica_two();
