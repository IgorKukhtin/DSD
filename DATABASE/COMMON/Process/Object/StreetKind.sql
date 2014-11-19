CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_StreetKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_StreetKind' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_StreetKind()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '���������� <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_StreetKind())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_StreetKind');


END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.14         *
*/
