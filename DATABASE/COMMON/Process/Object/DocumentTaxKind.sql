CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_DocumentTaxKind_Code() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_DocumentTaxKind_Code' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_DocumentTaxKind_Code()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '���������� <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_DocumentTaxKind())||'> - ��������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_DocumentTaxKind_Code');


END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.11.18         *
*/
