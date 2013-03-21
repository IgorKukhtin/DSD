CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleRight_Role()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectLink_RoleRight_Role()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleRight_Process()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectLink_RoleRight_Process()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserRole_Role()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 3;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectLink_UserRole_Role()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserRole_User()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 4;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_Currency()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 5;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_PaidType()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 6;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_Branch()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 7;
END;  $BODY$ LANGUAGE plpgsql;
