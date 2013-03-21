CREATE OR REPLACE FUNCTION zc_ObjectString_user_password()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectString_User_password()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectString_user_login()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectString_User_login()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectString_Currency_FullName()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 3;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_Currency_FullName()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_OKPO()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 4;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_Juridical_OKPO()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_INN()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 5;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_Juridical_INN()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_Phone()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 6;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_Juridical_Phone()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_Address()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 7;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_Juridical_Address()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_GLNCode()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 8;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_Juridical_GLNCode()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_FullName()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 9;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_Juridical_FullName()
  OWNER TO postgres;

