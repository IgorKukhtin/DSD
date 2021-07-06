-- �������� <>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_ContractGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_ContractGoods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- ������
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_ContractGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_ContractGoods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_ContractGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_ContractGoods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetUnErased_MI_ContractGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetUnErased_MI_ContractGoods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_ContractGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_ContractGoods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_ContractGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_ContractGoods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_ContractGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_ContractGoods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

-- ��������
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_ContractGoods()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ContractGoods())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_ContractGoods');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_ContractGoods()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ContractGoods())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_ContractGoods');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_ContractGoods()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '������ ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ContractGoods())||'> - �������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_ContractGoods');                                 
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetUnErased_MI_ContractGoods()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= '������ ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ContractGoods())||'> - �������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_SetUnErased_MI_ContractGoods');  


-- Status_ContractGoods
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_ContractGoods()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ContractGoods())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_ContractGoods');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_ContractGoods()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ContractGoods())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_ContractGoods');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_ContractGoods()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ContractGoods())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_ContractGoods');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.06.21         *
*/
