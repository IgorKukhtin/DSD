CREATE OR REPLACE FUNCTION zc_Object_RoleRight_Role()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_Object_RoleRight_Role()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_Object_RoleRight_Process()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_Object_RoleRight_Process()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_Object_UserRole_Role()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 3;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_Object_UserRole_Role()
  OWNER TO postgres;
