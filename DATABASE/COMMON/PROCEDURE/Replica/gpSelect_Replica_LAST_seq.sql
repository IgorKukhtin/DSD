-- Function: _replica.gpSelect_Replica_LAST_seq()

DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_LAST_seq();

CREATE OR REPLACE FUNCTION _replica.gpSelect_Replica_LAST_seq()
RETURNS BigInt
AS
$BODY$
BEGIN

     RETURN (SELECT last_value + 1001 from _replica.table_update_data_id_seq);
   --RETURN (SELECT last_value + 1001 from _replica.table_update_data_two_id_seq);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.07.20          *

*/

-- тест
-- SELECT * FROM _replica.gpSelect_Replica_LAST_seq ()
