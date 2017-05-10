CREATE OR REPLACE FUNCTION zc_DateEnd() RETURNS TDateTime AS $BODY$BEGIN RETURN ('01.01.2100'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_DateStart() RETURNS TDateTime AS $BODY$BEGIN RETURN ('01.01.2000'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_BarCodePref_Object() RETURNS TVarChar AS $BODY$BEGIN RETURN ('20100'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_BarCodePref_Movement() RETURNS TVarChar AS $BODY$BEGIN RETURN ('20200'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_BarCodePref_MI() RETURNS TVarChar AS $BODY$BEGIN RETURN ('20300'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- CREATE OR REPLACE FUNCTION zc_Color_Goods_Additional() RETURNS Integer AS $BODY$BEGIN RETURN (14941410); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Color_Goods_Alternative() RETURNS Integer AS $BODY$BEGIN RETURN (16380671); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Warning_Red() RETURNS Integer AS $BODY$BEGIN RETURN (255); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Warning_Navy() RETURNS Integer AS $BODY$BEGIN RETURN (9502720); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_FormClass_Income() RETURNS TVarChar AS $BODY$BEGIN RETURN ('TIncomeForm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_FormClass_ReturnOut() RETURNS TVarChar AS $BODY$BEGIN RETURN ('TReturnOutForm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_FormClass_Inventory() RETURNS TVarChar AS $BODY$BEGIN RETURN ('TInventoryForm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_FormClass_Send() RETURNS TVarChar AS $BODY$BEGIN RETURN ('TSendForm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_FormClass_Loss() RETURNS TVarChar AS $BODY$BEGIN RETURN ('TLossForm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_FormClass_Sale() RETURNS TVarChar AS $BODY$BEGIN RETURN ('TSaleForm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--CREATE OR REPLACE FUNCTION zc_IsLockTable() RETURNS Boolean AS $BODY$BEGIN RETURN (FALSE); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- ����� - !!! VOLATILE !!! - !!!���.....!!!
-- CREATE OR REPLACE FUNCTION zc_Mail_Host()     RETURNS TVarChar AS $BODY$BEGIN RETURN (/*'smtp.mail.ru'*/                 SELECT gpSelect.Value FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= '') AS gpSelect WHERE gpSelect.EmailKindId = zc_Enum_EmailKind_OutReport() AND gpSelect.EmailToolsId = zc_Enum_EmailTools_Host() AND COALESCE (gpSelect.JuridicalId, 0) = /*393052*/ 0);     END; $BODY$ LANGUAGE PLPGSQL VOLATILE;
-- CREATE OR REPLACE FUNCTION zc_Mail_Port()     RETURNS Integer  AS $BODY$BEGIN RETURN (/*465*/                            SELECT gpSelect.Value FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= '') AS gpSelect WHERE gpSelect.EmailKindId = zc_Enum_EmailKind_OutReport() AND gpSelect.EmailToolsId = zc_Enum_EmailTools_Port() AND COALESCE (gpSelect.JuridicalId, 0) = /*393052*/ 0);     END; $BODY$ LANGUAGE PLPGSQL VOLATILE;
-- CREATE OR REPLACE FUNCTION zc_Mail_From()     RETURNS TVarChar AS $BODY$BEGIN RETURN (/*'zakaz_family-neboley@mail.ru'*/ SELECT gpSelect.Value FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= '') AS gpSelect WHERE gpSelect.EmailKindId = zc_Enum_EmailKind_OutReport() AND gpSelect.EmailToolsId = zc_Enum_EmailTools_Mail() AND COALESCE (gpSelect.JuridicalId, 0) = /*393052*/ 0);     END; $BODY$ LANGUAGE PLPGSQL VOLATILE;
-- CREATE OR REPLACE FUNCTION zc_Mail_User()     RETURNS TVarChar AS $BODY$BEGIN RETURN (/*'zakaz_family-neboley@mail.ru'*/ SELECT gpSelect.Value FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= '') AS gpSelect WHERE gpSelect.EmailKindId = zc_Enum_EmailKind_OutReport() AND gpSelect.EmailToolsId = zc_Enum_EmailTools_User() AND COALESCE (gpSelect.JuridicalId, 0) = /*393052*/ 0);     END; $BODY$ LANGUAGE PLPGSQL VOLATILE;
-- CREATE OR REPLACE FUNCTION zc_Mail_Password() RETURNS TVarChar AS $BODY$BEGIN RETURN (/*'fgntrfghfdls6'*/                SELECT gpSelect.Value FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= '') AS gpSelect WHERE gpSelect.EmailKindId = zc_Enum_EmailKind_OutReport() AND gpSelect.EmailToolsId = zc_Enum_EmailTools_Password() AND COALESCE (gpSelect.JuridicalId, 0) = /*393052*/ 0); END; $BODY$ LANGUAGE PLPGSQL VOLATILE;

/*
-- �������� ��� ��� �-��� ����� ������������ � Load_PostgreSqlBoutique, ��� !!!������ �������� =0!!!
CREATE OR REPLACE FUNCTION zc_PriceList_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Juridical_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_FirstForm()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_FirstForm' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_SecondForm() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_SecondForm' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_Currency_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Currency_Basis' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Color_Black() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Red() RETURNS Integer AS $BODY$BEGIN RETURN (1118719); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Aqua() RETURNS Integer AS $BODY$BEGIN RETURN (16777158); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Cyan() RETURNS Integer AS $BODY$BEGIN RETURN (14862279); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_GreenL() RETURNS Integer AS $BODY$BEGIN RETURN (11987626); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Yelow() RETURNS Integer AS $BODY$BEGIN RETURN (8978431); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_White() RETURNS Integer AS $BODY$BEGIN RETURN (16777215); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Blue() RETURNS Integer AS $BODY$BEGIN RETURN (14614528); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
*/


/*
CREATE OR REPLACE FUNCTION zc_Currency_Basis() RETURNS Integer AS $BODY$BEGIN RETURN ((select Id from object where ValueData = '���' and DescId = zc_object_Currency())); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Currency_GRN() RETURNS Integer AS $BODY$BEGIN RETURN ((select Id from object where ValueData = '���' and DescId = zc_object_Currency())); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Currency_EUR() RETURNS Integer AS $BODY$BEGIN RETURN ((select Id from object where ValueData = '����' and DescId = zc_object_Currency())); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Currency_DOL() RETURNS Integer AS $BODY$BEGIN RETURN ((select Id from object where ValueData = '�����' and DescId = zc_object_Currency())); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
*/
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 25.02.17                                        * start
*/
