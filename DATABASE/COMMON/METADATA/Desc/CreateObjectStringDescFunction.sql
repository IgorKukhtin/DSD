CREATE OR REPLACE FUNCTION zc_ObjectString_Currency_InternalName()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 3;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_Currency_InternalName()
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

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_GLNCode()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 9;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_Partner_GLNCode()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectString_Bank_MFO()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 10;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_Bank_MFO()
  OWNER TO postgres;


CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_InvNumber()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 11;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_Contract_InvNumber()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_Comment()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 12;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_Contract_Comment()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_BarCode()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 13;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_GoodsPropertyValue_BarCode()
  OWNER TO postgres;
  
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_Article()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 14;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_GoodsPropertyValue_Article()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 15;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_ArticleGLN()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 16;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1;
ALTER FUNCTION zc_ObjectString_GoodsPropertyValue_ArticleGLN()
  OWNER TO postgres;
  
--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!


CREATE OR REPLACE FUNCTION zc_ObjectString_User_Password() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Password'); END;$BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_ObjectString_User_Login() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Login'); END;$BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectString_Car_RegistrationCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_RegistrationCertificate'); END;$BODY$ LANGUAGE plpgsql;

-- Это универсальное свойство, может использоваться у всех объектов
CREATE OR REPLACE FUNCTION  zc_ObjectString_Enum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = ' zc_ObjectString_Enum'); END;$BODY$ LANGUAGE plpgsql;
