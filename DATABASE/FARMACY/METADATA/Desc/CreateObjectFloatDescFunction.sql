CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_NDS()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectFloat_Goods_NDS()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PartyCount()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectFloat_Goods_PartyCount()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Price()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 3;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectFloat_Goods_Price()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PercentReprice()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 4;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectFloat_Goods_PercentReprice()
  OWNER TO postgres;
