-- �������� <������� ����������>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_ReturnIn' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Movement_ReturnIn_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Movement_ReturnIn_Contract' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Movement_ReturnIn_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Movement_ReturnIn_Member' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Movement_ReturnIn_SubjectDoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Movement_ReturnIn_SubjectDoc' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- ������
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_ReturnIn' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_ReturnIn_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_ReturnIn_Partner' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_MI_ReturnIn_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_MI_ReturnIn_Price' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_ReturnIn' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetUnErased_MI_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetUnErased_MI_ReturnIn' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_ReturnIn' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_ReturnIn' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_Process_CompletePeriod_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_CompletePeriod_ReturnIn' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_ReturnIn' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

-- �������� <������� ����������>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_ReturnIn()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'(���)> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_ReturnIn');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_ReturnIn()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'(���)> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_ReturnIn');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_ReturnIn_Partner()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_ReturnIn_Partner');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_MI_ReturnIn_Price()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 5
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'> - �������� ���.'
                                  , inEnumName:= 'zc_Enum_Process_Update_MI_ReturnIn_Price');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_ReturnIn()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_ReturnIn');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetUnErased_MI_ReturnIn()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'> - ��������������.'
                                  , inEnumName:= 'zc_Enum_Process_SetUnErased_MI_ReturnIn');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Movement_ReturnIn_Contract()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 7
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Movement_ReturnIn_Contract');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Movement_ReturnIn_Member()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 8
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Movement_ReturnIn_Member');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Movement_ReturnIn_SubjectDoc()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 9
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Movement_ReturnIn_SubjectDoc');
-- Status_ReturnIn
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_ReturnIn()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_ReturnIn');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_ReturnIn()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_ReturnIn');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_ReturnIn()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_ReturnIn');
/*                                  
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_CompletePeriod_ReturnIn()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn())||'> - ���������� �� ������.'
                                  , inEnumName:= 'zc_Enum_Process_CompletePeriod_ReturnIn');                                  
*/  
 
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.09.16         * 
 31.01.14                                        *
*/
