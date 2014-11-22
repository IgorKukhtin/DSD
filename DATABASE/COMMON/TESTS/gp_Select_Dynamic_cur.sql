-- Function: gp_select_master_child_cur(tvarchar)

-- DROP FUNCTION gp_Select_Dynamic_cur(tvarchar);

CREATE OR REPLACE FUNCTION gp_Select_Dynamic_cur(session tvarchar)
  RETURNS SETOF refcursor AS
$BODY$
DECLARE
  cur1 refcursor; 
BEGIN
  OPEN cur1 FOR EXECUTE 'SELECT 10 as DD';
  RETURN NEXT cur1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gp_Select_Dynamic_cur(tvarchar)
  OWNER TO postgres;
 begin; select * from gp_Select_Dynamic_cur(''); 
 fetch all "<unnamed portal 2>";
-- fetch all "<unnamed portal 4>";
-- commit;