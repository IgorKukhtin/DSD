-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_EDI_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_EDI_Send' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_EDI_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_EDI_Send' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_EDI_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_EDI_Send' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;


DO $$
BEGIN

-- Status_EDI_Send
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_EDI_Send()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_EDI_Send())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_EDI_Send');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_EDI_Send()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_EDI_Send())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_EDI_Send');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_EDI_Send()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_EDI_Send())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_EDI_Send');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.02.18         *
*/
