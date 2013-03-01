-- Function: gp_select_master_child_cur(tvarchar)

-- DROP FUNCTION gp_select_master_child_cur(tvarchar);

CREATE OR REPLACE FUNCTION gp_select_master_child_cur(session tvarchar)
  RETURNS SETOF refcursor AS
$BODY$
DECLARE
  cur1 refcursor; 
  cur2 refcursor; 
BEGIN
  OPEN cur1 FOR SELECT * FROM gp_Select_Master('');
  RETURN NEXT cur1;
  OPEN cur2 FOR SELECT * FROM gp_Select_Child('');
  RETURN NEXT cur2;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gp_select_master_child_cur(tvarchar)
  OWNER TO postgres;
-- begin; select * from gp_select_master_child_cur(''); 
-- fetch all "<unnamed portal 3>";
-- fetch all "<unnamed portal 4>";
-- commit;