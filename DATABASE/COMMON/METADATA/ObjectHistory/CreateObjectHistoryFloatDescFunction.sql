CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PriceListItem_Value()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectHistoryFloat_PriceListItem_Value()
  OWNER TO postgres;


