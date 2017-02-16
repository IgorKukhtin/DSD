-- !!!                     
-- !!! Роли
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_Role_Admin() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_Admin' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Role_Transport() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_Transport' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Role_Bread() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_Bread' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Role_1107() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_1107' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Role_CashReplace() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_CashReplace' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Глобальные константы
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_Marion() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_Marion' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_BarCode() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_BarCode' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_ConnectParam() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_ConnectParam' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы счетов
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_AccountKind_Active() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountKind_Active' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_AccountKind_Passive() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountKind_Passive' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_AccountKind_All() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountKind_All' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


