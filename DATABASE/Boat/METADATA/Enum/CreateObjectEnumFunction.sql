-- !!!
-- !!! Роли
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_Role_Admin() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_Admin' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Статусы документов
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_StatusCode_UnComplete() RETURNS Integer AS $BODY$BEGIN RETURN (1); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StatusCode_Complete() RETURNS Integer AS $BODY$BEGIN RETURN (2); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StatusCode_Erased() RETURNS Integer AS $BODY$BEGIN RETURN (3); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_UnComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_UnComplete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_Complete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_Complete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_Erased() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_Erased' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--загрузка справочников
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Boat() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Boat' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Boat() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Boat' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Boat1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Boat1' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Boat1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Boat1' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsGroup' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsGroup' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Partner' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Partner' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

 -- !!!
-- !!! Типы импорта
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_Excel()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_Excel' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_DBF() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_DBF' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_MMO() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_MMO' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_ODBC() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_ODBC' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;



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

