CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_UserByGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_UserByGroup' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_isErased_UserByGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_isErased_UserByGroup' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_UserByGroup()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '���������� <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_UserByGroup())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_UserByGroup');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_isErased_UserByGroup()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '���������� <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_UserByGroup())||'> - ��������/��������������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_isErased_UserByGroup');
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.04.22         *
*/
