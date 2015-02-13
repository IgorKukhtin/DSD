CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '���������� <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsPropertyValue())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.02.15                                        *
*/
