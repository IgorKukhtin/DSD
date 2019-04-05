-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_SendPartionDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_SendPartionDate' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_SendPartionDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_SendPartionDate' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_SendPartionDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_SendPartionDate' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_CompleteDate_SendPartionDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_CompleteDate_SendPartionDate' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN
-- Status_SendPartionDate
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_SendPartionDate()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SendPartionDate())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_SendPartionDate');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_SendPartionDate()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SendPartionDate())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_SendPartionDate');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_SendPartionDate()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SendPartionDate())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_SendPartionDate');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_CompleteDate_SendPartionDate()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SendPartionDate())||'> - ���������� ������ ������.'
                                  , inEnumName:= 'zc_Enum_Process_CompleteDate_SendPartionDate');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.04.19         *
*/
