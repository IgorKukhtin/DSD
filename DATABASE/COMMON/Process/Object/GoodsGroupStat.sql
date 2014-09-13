CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_GoodsGroupStat() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_GoodsGroupStat' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_GoodsGroupStat()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '���������� <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsGroupStat())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_GoodsGroupStat');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.09.14         *
*/
