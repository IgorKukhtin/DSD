CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_ConnectParam()       RETURNS integer AS $BODY$BEGIN RETURN (0); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_ConnectReportParam() RETURNS integer AS $BODY$BEGIN RETURN (0); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_IsLockTable() RETURNS Boolean AS $BODY$BEGIN RETURN (FALSE); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_IsLockTableCycle() RETURNS Boolean AS $BODY$BEGIN RETURN (TRUE); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_IsLockTableSecond() RETURNS Integer AS $BODY$BEGIN RETURN (5); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_DateEnd() RETURNS TDateTime AS $BODY$BEGIN RETURN ('01.01.2100'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_DateStart() RETURNS TDateTime AS $BODY$BEGIN RETURN ('01.01.2000'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_BarCodePref_Object() RETURNS TVarChar AS $BODY$BEGIN RETURN ('2210'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_BarCodePref_Movement() RETURNS TVarChar AS $BODY$BEGIN RETURN ('2230'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_BarCodePref_MI() RETURNS TVarChar AS $BODY$BEGIN RETURN ('2240'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_InvNumber_Status_UnComlete() RETURNS TVarChar AS $BODY$BEGIN RETURN ('***'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_InvNumber_Status_Erased()    RETURNS TVarChar AS $BODY$BEGIN RETURN ('---'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Color_Warning_Red() RETURNS Integer AS $BODY$BEGIN RETURN (255); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Warning_Navy() RETURNS Integer AS $BODY$BEGIN RETURN (9502720); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- CREATE OR REPLACE FUNCTION zc_IsLockTable() RETURNS Boolean AS $BODY$BEGIN RETURN (FALSE); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Color_UnEnabl() RETURNS Integer AS $BODY$BEGIN RETURN (12500670); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Black()   RETURNS Integer AS $BODY$BEGIN RETURN (0);        END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_White()   RETURNS Integer AS $BODY$BEGIN RETURN (16777215); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Red()     RETURNS Integer AS $BODY$BEGIN RETURN (1118719);  END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Blue()    RETURNS Integer AS $BODY$BEGIN RETURN (14614528); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Color_Aqua() RETURNS Integer AS $BODY$BEGIN RETURN (16777158); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Cyan() RETURNS Integer AS $BODY$BEGIN RETURN (14862279); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_GreenL() RETURNS Integer AS $BODY$BEGIN RETURN (11987626); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Yelow() RETURNS Integer AS $BODY$BEGIN RETURN (8978431); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Lime() RETURNS Integer AS $BODY$BEGIN RETURN (65280); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Pink() RETURNS Integer AS $BODY$BEGIN RETURN (16440317); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


CREATE OR REPLACE FUNCTION zc_Currency_Basis() RETURNS Integer AS $BODY$BEGIN RETURN ((select Id from object where ValueData = '���' and DescId = zc_object_Currency())); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Currency_GRN() RETURNS Integer AS $BODY$BEGIN RETURN ((select Id from object where ValueData = '���' and DescId = zc_object_Currency())); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Currency_EUR() RETURNS Integer AS $BODY$BEGIN RETURN ((select Id from object where ValueData = '����' and DescId = zc_object_Currency())); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Currency_USD() RETURNS Integer AS $BODY$BEGIN RETURN ((select Id from object where ValueData = '�����' and DescId = zc_object_Currency())); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- CREATE OR REPLACE FUNCTION zfCalc_UserAdmin() RETURNS .....;

/*
-- �������� ��� ��� �-��� ����� ������������ � Load_PostgreSqlBoutique, ��� !!!������ �������� =0!!!

-- CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_FirstForm()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_FirstForm'  AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_SecondForm() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_SecondForm' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_CardForm()   RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_CardForm'   AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

*/

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.01.22                                        *
*/
