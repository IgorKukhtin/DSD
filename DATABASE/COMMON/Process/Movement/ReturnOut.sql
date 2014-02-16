-- �������� <������� ����������>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_ReturnOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- ������
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_ReturnOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_ReturnOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetUnErased_MI_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetUnErased_MI_ReturnOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_ReturnOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_ReturnOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_Process_CompletePeriod_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_CompletePeriod_ReturnOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_ReturnOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

-- �������� <������� ����������>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_ReturnOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnOut())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_ReturnOut');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_ReturnOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= '������ ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnOut())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_ReturnOut');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_ReturnOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnOut())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_ReturnOut');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetUnErased_MI_ReturnOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnOut())||'> - ��������������.'
                                  , inEnumName:= 'zc_Enum_Process_SetUnErased_MI_ReturnOut');
-- Status_ReturnOut
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_ReturnOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnOut())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_ReturnOut');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_ReturnOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnOut())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_ReturnOut');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_ReturnOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnOut())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_ReturnOut');
/*                                  
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_CompletePeriod_ReturnOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnOut())||'> - ���������� �� ������.'
                                  , inEnumName:= 'zc_Enum_Process_CompletePeriod_ReturnOut');                                  
*/  
 
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.02.14                                        *
*/
