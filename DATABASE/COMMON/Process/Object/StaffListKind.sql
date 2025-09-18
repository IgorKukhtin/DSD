CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_StaffListKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_StaffListKind' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_StaffListKind()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '���������� <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_StaffListKind())||'> - ��������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_StaffListKind');


END $$;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.25         *
*/
