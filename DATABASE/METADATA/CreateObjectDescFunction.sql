-- Function: zc_user()

-- DROP FUNCTION zc_user();

CREATE OR REPLACE FUNCTION zc_user()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_user()
  OWNER TO postgres;
