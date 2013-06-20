CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_isCorporate()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectBoolean_Juridical_isCorporate()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_isReceiptNeed()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectBoolean_Goods_isReceiptNeed()
  OWNER TO postgres;

