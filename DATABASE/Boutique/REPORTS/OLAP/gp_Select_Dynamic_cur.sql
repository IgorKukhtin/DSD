-- Function: gp_select_master_child_cur(tvarchar)

-- DROP FUNCTION gp_Select_Dynamic_cur(tvarchar);

CREATE OR REPLACE FUNCTION gp_Select_Dynamic_cur(SQL TBlob, session tvarchar)
  RETURNS SETOF refcursor AS
$BODY$
DECLARE
  cur1 refcursor; 
BEGIN
  OPEN cur1 FOR EXECUTE SQL;
  RETURN NEXT cur1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gp_Select_Dynamic_cur(TBlob, tvarchar)
  OWNER TO postgres;


-- begin; select * from gp_Select_Dynamic_cur('SELECT 10 as DD'::TBlob, ''); 
-- fetch all "<unnamed portal 4>";
-- fetch all "<unnamed portal 4>";
-- commit;