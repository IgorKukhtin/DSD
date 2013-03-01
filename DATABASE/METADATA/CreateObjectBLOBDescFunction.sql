CREATE OR REPLACE FUNCTION zc_object_form_data()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_object_form_data()
  OWNER TO postgres;

