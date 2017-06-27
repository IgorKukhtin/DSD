CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_GoodsProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_GoodsProperty' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_GoodsProperty_TaxDoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_GoodsProperty_TaxDoc' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_GoodsProperty()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '���������� <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsProperty())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_GoodsProperty');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_GoodsProperty_TaxDoc()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '���������� <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsProperty())||'> - ��������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_GoodsProperty_TaxDoc');


END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.06.17         *
 12.02.15                                        *
*/
