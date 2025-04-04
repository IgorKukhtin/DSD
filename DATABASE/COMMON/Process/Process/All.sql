-- Other
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_NotCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_NotCost' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_MemberHoliday() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_MemberHoliday' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- ��������
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PeriodCloseAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PeriodCloseAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PeriodCloseTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PeriodCloseTax' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_UserOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_UserOrder' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_UserBranch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_UserBranch' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_UserOrderBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_UserOrderBasis' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_UserIrna() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_UserIrna' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_PriceListItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_MI_OperPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_MI_OperPrice' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_ModelService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_ModelService' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_StaffList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_StaffList' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportKrRog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportKrRog' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportNikolaev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportNikolaev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportKharkov() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportKharkov' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportCherkassi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportCherkassi' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportDoneck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportDoneck' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportOdessa() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportOdessa' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportLviv() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportLviv' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportIrna() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportIrna' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideCommerce() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideCommerce' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideCommerceAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideCommerceAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideKrRog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideKrRog' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideNikolaev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideNikolaev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideKharkov() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideKharkov' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideCherkassi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideCherkassi' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideDoneck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideDoneck' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideOdessa() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideOdessa' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideLviv() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideLviv' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideIrna() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideIrna' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideTech() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideTech' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceProduction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceProduction' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceAdmin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceAdmin' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceSbit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceSbit' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceMarketing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceMarketing' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceSB() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceSB' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceFirstForm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceFirstForm' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceSbitM() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceSbitM' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServicePav() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServicePav' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceOther() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceOther' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceKrRog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceKrRog' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceNikolaev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceNikolaev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceKharkov() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceKharkov' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceCherkassi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceCherkassi' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceDoneck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceDoneck' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceOdessa() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceOdessa' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceLviv() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceLviv' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceIrna() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceIrna' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Cash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Cash' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashOfficialDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashOfficialDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashKrRog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashKrRog' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashNikolaev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashNikolaev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashKharkov() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashKharkov' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashCherkassi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashCherkassi' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashDoneck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashDoneck' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashOdessa() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashOdessa' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashLviv() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashLviv' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashIrna() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashIrna' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceKrRog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceKrRog' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceNikolaev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceNikolaev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceKharkov() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceKharkov' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceCherkassi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceCherkassi' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceOdessa() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceOdessa' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceLviv() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceLviv' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceIrna() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceIrna' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServicePav() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServicePav' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentUser() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentUser' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentTaxAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentTaxAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentTaxCorrectiveAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentTaxCorrectiveAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentBread() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentBread' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentOdessa() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentOdessa' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentKrRog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentKrRog' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentNikolaev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentNikolaev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentKharkov() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentKharkov' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentCherkassi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentCherkassi' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentLviv() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentLviv' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentIrna() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentIrna' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- 15 - ������ �������
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportVinnica() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportVinnica' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideVinnica() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideVinnica' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceVinnica() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceVinnica' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashVinnica() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashVinnica' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceVinnica() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceVinnica' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentVinnica() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentVinnica' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;


DO $$
BEGIN

-- 15 - ������ �������

 -- zc_Object_Branch, �� ������� �������������� ��������� � ����������� ��� ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportVinnica()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 11
                                   , inName:= '��������� ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportVinnica');

 -- Vinnica, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideVinnica()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 105
                                   , inName:= '����������� ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideVinnica');

 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashVinnica()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 23
                                   , inName:= '����� ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashVinnica');

 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceVinnica()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 35
                                   , inName:= '������ ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceVinnica');

 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentVinnica()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 44
                                   , inName:= '��������� �������� ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentVinnica');

-- end - 15 - ������ �������

 -- ��� ....
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Cash()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 2
                                   , inName:= '��������� ��������� ����� ������ ��� �� 1 ����.'
                                   , inEnumName:= 'zc_Enum_Process_Update_Cash');
                                   

 -- ��� ....
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_MI_OperPrice()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= '��������� ������������� ���� � ���������.'
                                   , inEnumName:= 'zc_Enum_Process_Update_MI_OperPrice');

 -- ��� ....
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_PriceListItem()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 2
                                   , inName:= '��������� ��������� ���� � ����� ������.'
                                   , inEnumName:= 'zc_Enum_Process_Update_PriceListItem');
                                   
 -- ��� ....
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_ModelService()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= '��������� ������������� ������ ����������.'
                                   , inEnumName:= 'zc_Enum_Process_Update_Object_ModelService');

 -- ��� ....
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_StaffList()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 2
                                   , inName:= '��������� ��������� ������� ����������.'
                                   , inEnumName:= 'zc_Enum_Process_Update_Object_StaffList');

 -- ��� ������ �������������� �����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_UserOrder()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= '������������ ������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_UserOrder');
                                   
 -- ��� ������ �������������� - ������ �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_UserOrderBasis()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= '������ ������ ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_UserOrderBasis');
                                   
 -- ��� ������ �������������� ����� �� ������� ��
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_UserBranch()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= '������������ ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_UserBranch');

 -- ��� Irna
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_UserIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= '������������ Irna'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_UserIrna');

 -- zc_Enum_Process_AccessKey_PeriodCloseAll
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PeriodCloseAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1001
                                   , inName:= '�������� ������ ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PeriodCloseAll');
 -- zc_Enum_Process_AccessKey_PeriodCloseTax
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PeriodCloseTax()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1002
                                   , inName:= '�������� ������ �����+������������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PeriodCloseTax');

 -- zc_Object_Goods, ��� ���������� �������������� ���������� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= '��������� ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportAll');

 -- zc_Object_Branch, �� ������� �������������� ��������� � ����������� ��� ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 2
                                   , inName:= '��������� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportDnepr');

 -- zc_Object_Branch, �� ������� �������������� ��������� � ����������� ��� ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 3
                                   , inName:= '��������� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportKiev');

 -- ������ ���, ����������� � ������������ - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 4
                                   , inName:= '��������� ������ ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportKrRog');
 -- ��������, ����������� � ������������ - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 5
                                   , inName:= '��������� �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportNikolaev');
 -- �������, ����������� � ������������ - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 6
                                   , inName:= '��������� ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportKharkov');
 -- ��������, ����������� � ������������ - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 7
                                   , inName:= '��������� �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportCherkassi');
                                   

 -- ������, ����������� � ������������ - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportDoneck()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 8
                                   , inName:= '��������� ������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportDoneck');
 -- ���������, ����������� � ������������ - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 9
                                   , inName:= '��������� ��������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportZaporozhye');
 -- ������, ����������� � ������������ - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportOdessa()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 10
                                   , inName:= '��������� ������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportOdessa');

                                   
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashAll');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashDnepr');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashOfficialDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� �����-�� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashOfficialDnepr');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashKiev');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ������ ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashKrRog');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashNikolaev');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashKharkov');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashCherkassi');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashDoneck()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashDoneck');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashOdessa()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashOdessa');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ��������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashZaporozhye');

                                   
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= '������ ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceDnepr');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 32
                                   , inName:= '������ ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceKiev');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= '������ �� ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceKrRog');
                                  
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= '������ �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceNikolaev');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= '������ ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceKharkov');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= '������ �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceCherkassi');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceOdessa()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= '������ ������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceOdessa');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= '������ ��������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceZaporozhye');

 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceLviv()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 32
                                   , inName:= '������ ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceLviv');
                                   
 -- �� ���� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 33
                                   , inName:= '������ ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceIrna');

 -- �� ��������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServicePav()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 34
                                   , inName:= '������ ��������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServicePav');

 -- �� ������������ �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentUser()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 41
                                   , inName:= '��������� �������� ������������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentUser');

 -- �� �������������� ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 41
                                   , inName:= '��������� �������� ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentAll');
 -- �� �������������� ��������� - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentTaxAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 41
                                   , inName:= '��������� ��������� ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentTaxAll');
 -- �� �������������� ��������� - �������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentTaxCorrectiveAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 41
                                   , inName:= '��������� ������������� ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentTaxCorrectiveAll');

 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= '��������� �������� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentDnepr');

 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentBread()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= '��������� �������� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentBread');
                                   
 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= '��������� �������� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentKiev');
 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= '��������� �������� ��������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentZaporozhye');
 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentOdessa()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= '��������� �������� ������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentOdessa');

 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= '��������� �������� ������ ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentKrRog');

 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 43
                                   , inName:= '��������� �������� �������� (������) (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentNikolaev');

 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= '��������� �������� ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentKharkov');

 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= '��������� �������� �������� (����������) (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentCherkassi');

                                   
                                   
 -- ALL, ��� ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 101
                                   , inName:= '����������� ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideAll');
 -- ��������, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideCommerce()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 101
                                   , inName:= '����������� �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideCommerce');
 -- �������� + ����, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideCommerceAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 101
                                   , inName:= '����������� �������� + ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideCommerceAll');

 -- �����, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 102
                                   , inName:= '����������� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideDnepr');
 -- ����, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 103
                                   , inName:= '����������� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideKiev');
 -- ������ ���, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 104
                                   , inName:= '����������� ������ ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideKrRog');
 -- ��������, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 105
                                   , inName:= '����������� �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideNikolaev');
 -- �������, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 106
                                   , inName:= '����������� ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideKharkov');
 -- ��������, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 107
                                   , inName:= '����������� �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideCherkassi');

 -- ������, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideDoneck()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 108
                                   , inName:= '����������� ������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideDoneck');
 -- ���������, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 109
                                   , inName:= '����������� ��������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideZaporozhye');
 -- ������, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideOdessa()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 110
                                   , inName:= '����������� ������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideOdessa');

 -- ������, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideTech()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 121
                                   , inName:= '����������� �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideTech');


 -- �� ������������, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceProduction()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 201
                                   , inName:= '�� ������������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceProduction');
 -- �� �����, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceAdmin()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 202
                                   , inName:= '�� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceAdmin');
 -- �� ������������ �����, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceSbit()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 203
                                   , inName:= '�� ������������ ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceSbit');
 -- �� ����� ����������, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceMarketing()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 204
                                   , inName:= '�� ����� ���������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceMarketing');
 -- �� ��, ������, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceSB()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 205
                                   , inName:= '�� ��, ������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceSB');
 -- �� �������� ��, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceFirstForm()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 206
                                   , inName:= '�� �������� �� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceFirstForm');
 -- �� ������������ �����, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceSbitM()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 207
                                   , inName:= '�� ������������ ����� - ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceSbitM');
 -- �� ���������, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServicePav()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 208
                                   , inName:= '�� ��������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServicePav');
 -- �� ���������, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceOther()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 209
                                   , inName:= '�� ������ ������������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceOther');


 -- �� Kiev, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 221
                                   , inName:= '�� Kiev (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceKiev');
 -- �� KrRog, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 222
                                   , inName:= '�� KrRog (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceKrRog');
 -- �� Nikolaev, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 223
                                   , inName:= '�� Nikolaev (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceNikolaev');
 -- �� Kharkov, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 224
                                   , inName:= '�� Kharkov (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceKharkov');
 -- �� Cherkassi, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 225
                                   , inName:= '�� Cherkassi (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceCherkassi');
 -- �� Doneck, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceDoneck()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 226
                                   , inName:= '�� Doneck (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceDoneck');
 -- �� Odessa, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceOdessa()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 227
                                   , inName:= '�� Odessa (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceOdessa');
 -- �� Zaporozhye, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 228
                                   , inName:= '�� Zaporozhye (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceZaporozhye');
                                   

 -- zc_Object_Branch, �� ������� �������������� ��������� � ����������� ��� ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportLviv()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 3
                                   , inName:= '��������� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportLviv');

 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 4
                                   , inName:= '��������� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportIrna');

 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashLviv()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashLviv');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 22
                                   , inName:= '����� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashIrna');

 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentLviv()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= '��������� �������� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentLviv');
 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 43
                                   , inName:= '��������� �������� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentIrna');
 -- Lviv, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideLviv()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 103
                                   , inName:= '����������� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideLviv');
 -- Irna, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 104
                                   , inName:= '����������� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideIrna');

 -- �� Lviv, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceLviv()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 221
                                   , inName:= '�� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceLviv');
 -- �� Irna, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 222
                                   , inName:= '�� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceIrna');
                       
 -- �� Vinnica, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceVinnica()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 223
                                   , inName:= '�� ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceVinnica');

 -- �����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_NotCost()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= '����������� ��������� �/�'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_NotCost');

 -- �����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_MemberHoliday()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= '�������� �������� <��.�� �� ���� (������ �� ��������)>'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_MemberHoliday');

                                   
/*
 -- ������� ���� 
 PERFORM gpInsertUpdate_Object_RoleProcess2 (ioId        := tmpData.RoleRightId
                                           , inRoleId    := tmpRole.RoleId
                                           , inProcessId := tmpProcess.ProcessId
                                           , inSession   := zfCalc_UserAdmin())
 -- AccessKey  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_Right_Branch_Dnepr() AS ProcessId
           ) AS tmpProcess ON 1=1
      -- ������� ��� ������������ �����
      LEFT JOIN (SELECT ObjectLink_RoleRight_Role.ObjectId         AS RoleRightId
                      , ObjectLink_RoleRight_Role.ChildObjectId    AS RoleId
                      , ObjectLink_RoleRight_Process.ChildObjectId AS ProcessId
                 FROM ObjectLink AS ObjectLink_RoleRight_Role
                      JOIN ObjectLink AS ObjectLink_RoleRight_Process ON ObjectLink_RoleRight_Process.ObjectId = ObjectLink_RoleRight_Role.ObjectId
                                                                     AND ObjectLink_RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
                 WHERE ObjectLink_RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
                ) AS tmpData ON tmpData.RoleId    = tmpRole.RoleId
                            AND tmpData.ProcessId = tmpProcess.ProcessId
 WHERE tmpData.RoleId IS NULL
 ;
*/

 
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.11.14                                        * add zc_Enum_Process_AccessKey_DocumentAll
 23.09.14                                        * add zc_Enum_Process_AccessKey_PeriodClose...
 17.09.14                                        * add zc_Enum_Process_AccessKey_PersonalServiceFirstForm
 10.09.14                                        * add zc_Enum_Process_AccessKey_PersonalService...
 08.09.14                                        * add zc_Enum_Process_AccessKey_Guide...
 07.04.14                                        * add zc_Enum_Process_AccessKey_DocumentBread
 10.02.14                                        * add zc_Enum_Process_AccessKey_Document...
 28.12.13                                        * add zc_Enum_Process_AccessKey_Service...
 26.12.13                                        * add zc_Enum_Process_AccessKey_Cash...
 14.12.13                                        * add zc_Enum_Process_AccessKey_GuideAll
 07.12.13                                        *
*/

/*
-- !!!update AccessKeyId!!!
update Movement set AccessKeyId = zc_Enum_Process_AccessKey_CashKiev() from MovementItem where MovementItem.MovementId = Movement.Id and MovementItem.ObjectId = 14686  and Movement.DescId = zc_Movement_Cash() and AccessKeyId <> zc_Enum_Process_AccessKey_CashKiev();
update Movement set AccessKeyId = zc_Enum_Process_AccessKey_CashKrRog() from MovementItem where MovementItem.MovementId = Movement.Id and MovementItem.ObjectId = 279788  and Movement.DescId = zc_Movement_Cash() and AccessKeyId <> zc_Enum_Process_AccessKey_CashKrRog();
update Movement set AccessKeyId = zc_Enum_Process_AccessKey_CashNikolaev() from MovementItem where MovementItem.MovementId = Movement.Id and MovementItem.ObjectId = 279789  and Movement.DescId = zc_Movement_Cash() and AccessKeyId <> zc_Enum_Process_AccessKey_CashKharkov();
update Movement set AccessKeyId = zc_Enum_Process_AccessKey_CashKharkov() from MovementItem where MovementItem.MovementId = Movement.Id and MovementItem.ObjectId = 279790  and Movement.DescId = zc_Movement_Cash() and AccessKeyId <> zc_Enum_Process_AccessKey_CashKharkov();
update Movement set AccessKeyId = zc_Enum_Process_AccessKey_CashCherkassi() from MovementItem where MovementItem.MovementId = Movement.Id and MovementItem.ObjectId = 279791  and Movement.DescId = zc_Movement_Cash() and AccessKeyId <> zc_Enum_Process_AccessKey_CashKharkov();
update Movement set AccessKeyId = zc_Enum_Process_AccessKey_CashDoneck() from MovementItem where MovementItem.MovementId = Movement.Id and MovementItem.ObjectId = 280185  and Movement.DescId = zc_Movement_Cash() and AccessKeyId <> zc_Enum_Process_AccessKey_CashKharkov();
update Movement set AccessKeyId = zc_Enum_Process_AccessKey_CashOdessa() from MovementItem where MovementItem.MovementId = Movement.Id and MovementItem.ObjectId = 280296  and Movement.DescId = zc_Movement_Cash() and AccessKeyId <> zc_Enum_Process_AccessKey_CashKharkov();

update Movement set AccessKeyId  = caSE  WHEN MovementLinkObject_To.ObjectId = 8411 -- ����� �� � ����
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN MovementLinkObject_To.ObjectId = 346093 -- ����� �� �.������
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa() 
                          WHEN MovementLinkObject_To.ObjectId = 8413 -- ����� �� �.������ ���
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog() 
                          WHEN MovementLinkObject_To.ObjectId = 8417 -- ����� �� �.�������� (������)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev() 
                          WHEN MovementLinkObject_To.ObjectId = 8425 -- ����� �� �.�������
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov() 
                          WHEN MovementLinkObject_To.ObjectId = 8415 -- ����� �� �.�������� (����������)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi() 
                     end
from MovementLinkObject AS MovementLinkObject_To
                                         
where Movement.DescId = zc_Movement_ReturnIn()
and AccessKeyId  <> caSE  WHEN MovementLinkObject_To.ObjectId = 8411 -- ����� �� � ����
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN MovementLinkObject_To.ObjectId = 346093 -- ����� �� �.������
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa() 
                          WHEN MovementLinkObject_To.ObjectId = 8413 -- ����� �� �.������ ���
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog() 
                          WHEN MovementLinkObject_To.ObjectId = 8417 -- ����� �� �.�������� (������)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev() 
                          WHEN MovementLinkObject_To.ObjectId = 8425 -- ����� �� �.�������
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov() 
                          WHEN MovementLinkObject_To.ObjectId = 8415 -- ����� �� �.�������� (����������)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi() 
                     end

and MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                        AND MovementLinkObject_To.ObjectId in (8411 -- 
                                                                             , 346093 -- ����� �� �.������
                                                                             , 8413 -- ����� �� �.������ ���
                                                                             , 8417 -- ����� �� �.�������� (������)
                                                                             , 8425 -- ����� �� �.�������
                                                                             , 8415)
*/