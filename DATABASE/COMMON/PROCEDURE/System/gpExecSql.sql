CREATE OR REPLACE FUNCTION gpExecSql(IN SqlText tvarchar, IN Session TVarChar) RETURNS void AS $BODY$
begin
  EXECUTE SqlText;
END;
$BODY$LANGUAGE plpgsql;