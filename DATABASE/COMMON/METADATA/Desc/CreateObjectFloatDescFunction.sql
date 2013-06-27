--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ÕŒ¬¿ﬂ —’≈Ã¿ !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Weight'); END;$BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_Amount'); END;$BODY$ LANGUAGE plpgsql;


