-- Function: gp_Select_Cross_cur(tvarchar)

-- DROP FUNCTION gp_Select_Cross_cur(tvarchar);

CREATE OR REPLACE FUNCTION gp_Select_Cross_cur(session tvarchar)
  RETURNS SETOF refcursor AS
$BODY$
DECLARE
  cur1 refcursor; 
  cur2 refcursor; 
BEGIN
  OPEN cur1 FOR  EXECUTE 'SELECT * FROM crosstab(
	''select OperDate,
	    descid,
	    count(*) 
	    from movement where descid in( zc_Movement_Income(), zc_Movement_productionunion())
	 group by descid, operdate order by operdate'',
         ''select id from movementdesc where id in(zc_Movement_Income(), zc_Movement_productionunion())'')
         AS ct(OperDate DATE, MovIncome INTEGER, movprodunion integer)';  RETURN NEXT cur1;
  OPEN cur2 FOR SELECT * FROM gp_Select_Child('');
  RETURN NEXT cur2;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gp_Select_Cross_cur(tvarchar)
  OWNER TO postgres;
-- begin; select * from gp_select_master_child_cur(''); 
-- fetch all "<unnamed portal 3>";
-- fetch all "<unnamed portal 4>";
-- commit;


SELECT * FROM crosstab(
	'select a ,
	    descid,
	    count(*) 
	    from generate_series((now() - ''1000 days''::interval)::date, now()::date, ''1 DAY''::interval) a
	    join movement on a = movement.OperDate
	 
	 where descid in( zc_Movement_Income(), zc_Movement_productionunion())
	 group by descid, operdate, a order by operdate',
         'select id from movementdesc where id in(zc_Movement_Income(), zc_Movement_productionunion())')
         AS ct(OperDate DATE, MovIncome INTEGER, movprodunion integer)