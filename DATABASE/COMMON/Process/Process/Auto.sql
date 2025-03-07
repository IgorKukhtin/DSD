CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_PrimeCost()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_PrimeCost'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_ReComplete()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_ReComplete'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_Pack()         RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_Pack'         AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_Kopchenie()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_Kopchenie'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_Defroster()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_Defroster'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_PartionDate()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_PartionDate'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_PartionClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_PartionClose' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_Send()         RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_Send'         AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_ReturnIn()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_ReturnIn'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_Medoc()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_Medoc'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_Peresort()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_Peresort'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

 -- ��� 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_PartionDate()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1001
                                   , inName:= '������ ������ �/� (��) �� ���������'
                                   , inEnumName:= 'zc_Enum_Process_Auto_PartionDate');

 -- ��� 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_PartionClose()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1002
                                   , inName:= '������ ������ �/� (��) ��� ��������'
                                   , inEnumName:= 'zc_Enum_Process_Auto_PartionClose');
 -- ��� 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_PrimeCost()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1003
                                   , inName:= '������ �/�'
                                   , inEnumName:= 'zc_Enum_Process_Auto_PrimeCost');
 -- ��� 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_Defroster()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1004
                                   , inName:= '������/������ ����� ���������'
                                   , inEnumName:= 'zc_Enum_Process_Auto_Defroster');

 -- ��� 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_Pack()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1005
                                   , inName:= '������/������ ��� ��������'
                                   , inEnumName:= 'zc_Enum_Process_Auto_Pack');
 -- ��� 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_Kopchenie()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1006
                                   , inName:= '������/������ ��� ��������'
                                   , inEnumName:= 'zc_Enum_Process_Auto_Kopchenie');

 -- ��� 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_Send()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1007
                                   , inName:= '������/������ ����� �������'
                                   , inEnumName:= 'zc_Enum_Process_Auto_Send');

 -- ��� 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_ReturnIn()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1008
                                   , inName:= '������� - �������� � �������'
                                   , inEnumName:= 'zc_Enum_Process_Auto_ReturnIn');

 -- ��� 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_ReComplete()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1009
                                   , inName:= '�������������� - � �������� �������'
                                   , inEnumName:= 'zc_Enum_Process_Auto_ReComplete');

 -- ��� 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_Medoc()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1010
                                   , inName:= 'Medoc - ���� ��������'
                                   , inEnumName:= 'zc_Enum_Process_Auto_Medoc');
 
 -- ��� 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_Peresort()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1011
                                   , inName:= '�������������� ��������'
                                   , inEnumName:= 'zc_Enum_Process_Auto_Peresort');

END $$;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.07.15                                        *
*/
