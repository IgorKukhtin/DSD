CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_ContractGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_ContractGoods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_isErased_ContractGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_isErased_ContractGoods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;


DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_ContractGoods()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '���������� <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_ContractGoods())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_ContractGoods');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_isErased_ContractGoods()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '���������� <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_ContractGoods())||'> - ��������/��������������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_isErased_ContractGoods');


END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.02.15         * add zc_Enum_Process_Update_Object_isErased_ContractGoods
 05.02.15         *
*/
