CREATE OR REPLACE FUNCTION zc_object_user_password()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_object_user_password()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_object_user_login()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_object_user_login()
  OWNER TO postgres;
