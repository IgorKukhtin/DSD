-- �������� <������>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_MobileBills() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_MobileBills' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- ������
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_MobileBills() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_MobileBills' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_MobileBills() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_MobileBills' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_MobileBills() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_MobileBills' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_MobileBills() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_MobileBills' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_CompletePeriod_MobileBills() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_CompletePeriod_MobileBills' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MobileBills() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MobileBills' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;


DO $$


BEGIN

-- �������� <������>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_MobileBills()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_MobileBills())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_MobileBills');
                                 
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_MobileBills()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '������ ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_MobileBills())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_MobileBills');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_MobileBills()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '������ ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_MobileBills())||'> - �������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_MobileBills');                                 

-- Status_MobileBills
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_MobileBills()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_MobileBills())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_MobileBills');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_MobileBills()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_MobileBills())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_MobileBills');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MobileBills()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_MobileBills())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MobileBills');
                                  
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_CompletePeriod_MobileBills()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_MobileBills())||'> - ���������� �� ������.'
                                  , inEnumName:= 'zc_Enum_Process_CompletePeriod_MobileBills');                                  

 
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.09.16         *

*/
