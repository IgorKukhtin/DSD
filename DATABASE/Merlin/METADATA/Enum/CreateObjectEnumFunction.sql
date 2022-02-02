-- !!!
-- !!! ����
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_Role_Admin() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_Admin' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ������� ����������
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_StatusCode_UnComplete() RETURNS Integer AS $BODY$BEGIN RETURN (1); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StatusCode_Complete() RETURNS Integer AS $BODY$BEGIN RETURN (2); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StatusCode_Erased() RETURNS Integer AS $BODY$BEGIN RETURN (3); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_UnComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_UnComplete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_Complete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_Complete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_Erased() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_Erased' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;



 -- !!!
-- !!! ���� �������
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_Excel()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_Excel' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_DBF() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_DBF' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_MMO() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_MMO' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_ODBC() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_ODBC' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� ������/������
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_In()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_In'  AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_Out() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_Out' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;



-- !!!
-- !!! ���������� ���������
-- !!!
-- ��� �-��� �� �����
-- CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_ConnectParam() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_ConnectParam' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! ���� �������� ��� ��������
-- !!!


-- !!! �������� c������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_InfoMoney' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_InfoMoney' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! �������� �������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Unit' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Unit' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!! �������� ���������� ������/������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_CommentInfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_CommentInfoMoney' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_CommentInfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_CommentInfoMoney' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! �������� ���������� �������� �����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_CommentMoveMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_CommentMoveMoney' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_CommentMoveMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_CommentMoveMoney' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! �������� �������� ������/������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_InfoMoneyDetail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_InfoMoneyDetail' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_InfoMoneyDetail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_InfoMoneyDetail' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
