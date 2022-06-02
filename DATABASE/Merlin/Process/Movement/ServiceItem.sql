-- �������� 
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_ServiceItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_ServiceItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_ServiceItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_ServiceItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_ServiceItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_ServiceItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_ServiceItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_ServiceItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_ServiceItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_ServiceItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- �������� <>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_ServiceItem()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ServiceItem())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_ServiceItem');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_ServiceItem()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ServiceItem())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_ServiceItem');
-- Status_ServiceItem
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_ServiceItem()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ServiceItem())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_ServiceItem');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_ServiceItem()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ServiceItem())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_ServiceItem');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_ServiceItem()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ServiceItem())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_ServiceItem');
END $$;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.22         *
*/
