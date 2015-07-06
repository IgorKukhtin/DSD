CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_PartionDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_PartionDate' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_PartionClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_PartionClose' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;


DO $$
BEGIN

 -- ��� 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_PartionDate()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1001
                                   , inName:= '������ ������ �/� (��) �� ���������'
                                   , inEnumName:= 'zc_Enum_Process_Auto_PartionDate');

 -- ��� 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_PartionClose()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1002
                                   , inName:= '������ ������ �/� (��) ��� ��������'
                                   , inEnumName:= 'zc_Enum_Process_Auto_PartionClose');

 
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.07.15                                        *
*/
