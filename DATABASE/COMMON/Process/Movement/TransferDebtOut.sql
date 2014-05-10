-- �������� <������� ����� (������)>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- ������
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_TransferDebtOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_TransferDebtOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_TransferDebtOut_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_TransferDebtOut_Partner' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_TransferDebtOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_TransferDebtOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetUnErased_MI_TransferDebtOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetUnErased_MI_TransferDebtOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_TransferDebtOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_TransferDebtOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_TransferDebtOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_TransferDebtOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_TransferDebtOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_TransferDebtOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

-- �������� <������� ����� (������)>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TransferDebtOut())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_TransferDebtOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TransferDebtOut())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_TransferDebtOut');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_TransferDebtOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TransferDebtOut())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_TransferDebtOut');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetUnErased_MI_TransferDebtOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TransferDebtOut())||'> - ��������������.'
                                  , inEnumName:= 'zc_Enum_Process_SetUnErased_MI_TransferDebtOut');

-- Status_TransferDebtOut
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_TransferDebtOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TransferDebtOut())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_TransferDebtOut');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_TransferDebtOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TransferDebtOut())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_TransferDebtOut');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_TransferDebtOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TransferDebtOut())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_TransferDebtOut');
 
 
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.04.14         *

*/
