-- Function: gpSelect_Replica_union()

DROP FUNCTION IF EXISTS gpSelect_Replica_union (Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_Replica_union(
    IN inId_start     Integer,
    IN inId_end       Integer
)
RETURNS TABLE (Part Integer, Value Text
) AS
$BODY$
BEGIN

   RETURN QUERY 
      SELECT  10, 'SELECT *'
UNION SELECT * FROM gpSelect_Replica_part11 (inId_start, inId_end)
UNION SELECT 12, ' AS RESULT'
UNION SELECT 20, 'FROM table_update_data'
UNION SELECT * FROM gpSelect_Replica_part30 (inId_start, inId_end)
UNION SELECT  40, 'ORDER BY'
ORDER BY 1;
     
END;
$BODY$


LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.07.20          *

*/


-- ����
--SELECT * FROM gpSelect_Replica_union (507150,607155)
--SELECT * from _replica.table_update_data order by id desc limit 100