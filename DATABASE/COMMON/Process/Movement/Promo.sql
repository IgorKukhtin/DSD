-- �������� <>
CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Movement_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Movement_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Movement_Promo_Data() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Movement_Promo_Data' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Movement_Promo_ChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Movement_Promo_ChangePercent' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- ������
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetUnErased_MI_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetUnErased_MI_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_MI_Promo_Plan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_MI_Promo_Plan' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_MI_Promo_MainDiscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_MI_Promo_MainDiscount' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;


DO $$
BEGIN

-- ��������
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Movement_Promo()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - ��������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Get_Movement_Promo');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_Promo()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_Promo');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Movement_Promo_Data()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - �������� ���� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Movement_Promo_Data');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Movement_Promo_ChangePercent()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - �������� ���� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Movement_Promo_ChangePercent');

-- ������
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_Promo()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_Promo');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_Promo()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_Promo');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetUnErased_MI_Promo()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - ��������������.'
                                  , inEnumName:= 'zc_Enum_Process_SetUnErased_MI_Promo');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_MI_Promo_Plan()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_MI_Promo_Plan');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_MI_Promo_MainDiscount()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 5
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_MI_Promo_MainDiscount');

-- Status_Promo
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_Promo()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_Promo');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_Promo()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_Promo');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_Promo()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_Promo');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.11.15                                        *
*/
