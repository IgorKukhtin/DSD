-- !!!
-- !!! Роли
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_Role_Admin() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_Admin' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Глобальные константы
-- !!!
-- Эта ф-ция НЕ нужна
-- CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_ConnectParam() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_ConnectParam' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! TERRY !!! - Эта ф-ция нужна - !!!VOLATILE!!!
-- CREATE OR REPLACE FUNCTION zc_Enum_Goods_Debt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM Object WHERE DescId = zc_Object_Goods() AND ObjectCode = 1); END;  $BODY$ LANGUAGE PLPGSQL VOLATILE;

-- !!! PODIUM !!! - Эта ф-ция нужна - !!!VOLATILE!!!
-- CREATE OR REPLACE FUNCTION zc_Enum_Goods_Debt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM Object WHERE DescId = zc_Object_Goods() AND ObjectCode = -1); END;  $BODY$ LANGUAGE PLPGSQL VOLATILE;

-- !!!
-- !!! Типы аналитик для проводок
-- !!!

