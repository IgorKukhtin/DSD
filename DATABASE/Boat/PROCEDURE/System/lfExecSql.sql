CREATE OR REPLACE FUNCTION lfExecSql(IN SqlText tvarchar) RETURNS void AS $BODY$
begin
  EXECUTE SqlText;
END;
$BODY$LANGUAGE plpgsql;