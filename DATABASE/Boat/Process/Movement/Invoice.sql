-- �������� <>
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_MovementLink_Invoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_MovementLink_Invoice' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- �������� <>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_MovementLink_Invoice()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_BankAccount())||'> - ��������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_MovementLink_Invoice');
END $$;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.06.21         *
*/