-- �������� <>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_OrderClient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_OrderClient' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Movement_OrderClient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Movement_OrderClient' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Movement_OrderClient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_Movement_OrderClient' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_OrderClient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_OrderClient' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_OrderClient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_OrderClient' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_OrderClient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_OrderClient' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_CompletePeriod_OrderClient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_CompletePeriod_OrderClient' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- �������� <>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_OrderClient()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderClient())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_OrderClient');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Movement_OrderClient()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderClient())||'> - ����� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Get_Movement_OrderClient');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_Movement_OrderClient()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderClient())||'> - ��������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Select_Movement_OrderClient');

-- Status_OrderClient
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_OrderClient()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderClient())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_OrderClient');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_OrderClient()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderClient())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_OrderClient');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_OrderClient()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderClient())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_OrderClient');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_CompletePeriod_OrderClient()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderClient())||'> - ���������� �� ������.'
                                  , inEnumName:= 'zc_Enum_Process_CompletePeriod_OrderClient');

END $$;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.02.21         *
*/
