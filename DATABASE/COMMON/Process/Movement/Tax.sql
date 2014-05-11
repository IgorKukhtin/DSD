-- �������� <��������� ���������>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_Tax' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_Tax_From_Kind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_Tax_From_Kind' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Movement_Tax_IsRegistered() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Movement_Tax_IsRegistered' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- ������
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_Tax' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_Tax' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetUnErased_MI_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetUnErased_MI_Tax' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_Tax' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_Tax' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_Process_CompletePeriod_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_CompletePeriod_Tax' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_Tax' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

-- �������� <��������� ���������>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_Tax()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_Tax');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_Tax_From_Kind()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax())||'> - ������������/���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_Tax_From_Kind');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Movement_Tax_IsRegistered()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax())||'> - ��������� <��������������� (��/���)>.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Movement_Tax_IsRegistered');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_Tax()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_Tax');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_Tax()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_Tax');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetUnErased_MI_Tax()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax())||'> - ��������������.'
                                  , inEnumName:= 'zc_Enum_Process_SetUnErased_MI_Tax');
-- Status_Tax
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_Tax()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_Tax');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_Tax()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_Tax');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_Tax()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_Tax');
/*
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_CompletePeriod_Tax()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax())||'> - ���������� �� ������.'
                                  , inEnumName:= 'zc_Enum_Process_CompletePeriod_Tax');
*/

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.02.14                                                       *
*/
