CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_ObjectCode_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_ObjectCode_Basis' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_ObjectCode_Basis()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '<������� ���> - ��������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_ObjectCode_Basis');


END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.04.22         *
*/
