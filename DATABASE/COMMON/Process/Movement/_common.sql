-- �������� <������ ����� � ��������� �� ��������>
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_MI_Price_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_MI_Price_Currency' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- �������� <>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_MI_Price_Currency()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '����������� ���� ��������� � ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_MI_Price_Currency');

END $$;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.11.14                                        *
*/
