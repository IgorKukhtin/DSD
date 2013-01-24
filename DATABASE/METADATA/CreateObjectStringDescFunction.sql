-- Function: zc_user_password()

-- DROP FUNCTION zc_user_password();

CREATE OR REPLACE FUNCTION zc_user_password()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_user_password()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_user_login()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_user_login()
  OWNER TO postgres;
