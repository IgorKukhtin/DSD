-- ��������
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Movement_Check_OperDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Movement_Check_OperDate' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Movement_Check_InsertDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Movement_Check_InsertDate' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- ��������
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Movement_Check_OperDate()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Check())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Movement_Check_OperDate');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Movement_Check_InsertDate()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Check())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Movement_Check_InsertDate');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.11.22         * zc_Enum_Process_Update_Movement_Check_InsertDate
 19.01.17         *
*/
