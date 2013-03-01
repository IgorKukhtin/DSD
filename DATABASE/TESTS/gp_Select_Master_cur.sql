-- Function: gp_Select_Master_cur()

-- DROP FUNCTION gp_Select_Master_cur(TVarChar);

CREATE OR REPLACE FUNCTION gp_Select_Master_cur(Session TVarChar)
  RETURNS SETOF refcursor AS
$BODY$
DECLARE
  cur1 refcursor; 
BEGIN
  OPEN cur1 FOR SELECT * FROM gp_Select_Master('');
  RETURN NEXT cur1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gp_Select_Master_cur(TVarChar)
  OWNER TO postgres;


--SELECT * FROM gp_Select_Master_cur('')