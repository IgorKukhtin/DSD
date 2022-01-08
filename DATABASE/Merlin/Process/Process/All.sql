-- 
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_Check() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_Check' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

 -- ��� ....
 PERFORM lpInsertUpdate_Object_Enum (inId      := zc_Enum_Process_AccessKey_Check()
                                   , inDescId  := zc_Object_Process()
                                   , inCode    := 1
                                   , inName    := '������������ � ��������� ����'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_Check');


END $$;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 08.04.18                                        *
*/
