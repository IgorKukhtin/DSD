-- �������� <����������� (����������� ����)>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_SendDebtMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_SendDebtMember' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_SendDebtMember_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_SendDebtMember_Contract' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;


-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_SendDebtMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_SendDebtMember' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_SendDebtMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_SendDebtMember' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_SendDebtMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_SendDebtMember' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- �������� <����������� (����������� ����)>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_SendDebtMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SendDebtMember())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_SendDebtMember');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_SendDebtMember_Contract()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SendDebtMember())||'> - ��������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_SendDebtMember_Contract');
/*   
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Movement_SendDebtMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SendDebtMember())||'> - ����� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Get_Movement_SendDebtMember');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_Movement_SendDebtMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SendDebtMember())||'> - ��������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Select_Movement_SendDebtMember');

*/                                  
-- Status_
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_SendDebtMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SendDebtMember())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_SendDebtMember');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_SendDebtMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SendDebtMember())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_SendDebtMember');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_SendDebtMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SendDebtMember())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_SendDebtMember');
/*  
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_CompletePeriod_SendDebtMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SendDebtMember())||'>. - ���������� �� ������'
                                  , inEnumName:= 'zc_Enum_Process_CompletePeriod_SendDebtMember');
*/  
 
END $$;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.10.22         *
*/
