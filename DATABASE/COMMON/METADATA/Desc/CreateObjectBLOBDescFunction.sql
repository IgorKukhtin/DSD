CREATE OR REPLACE FUNCTION zc_objectBlob_form_data()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_objectBlob_form_data()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_objectBlob_UserFormSettings_Data()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_objectBlob_UserFormSettings_Data()
  OWNER TO postgres;

--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ÕŒ¬¿ﬂ —’≈Ã¿ !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
