-- Other
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_NotCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_NotCost' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_MemberHoliday() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_MemberHoliday' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Документ
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

-- 15 - Филиал Винница
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportVinnica() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportVinnica' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideVinnica() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideVinnica' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceVinnica() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceVinnica' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashVinnica() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashVinnica' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceVinnica() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceVinnica' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentVinnica() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentVinnica' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;


DO $$
BEGIN

-- 15 - Филиал Винница

 -- zc_Object_Branch, по Филиалу ограничиваются Документы и Справочники для Транспорта
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportVinnica()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 11
                                   , inName:= 'Транспорт Винница (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportVinnica');

 -- Vinnica, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideVinnica()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 105
                                   , inName:= 'Справочники Винница (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideVinnica');

 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashVinnica()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 23
                                   , inName:= 'Касса Винница (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashVinnica');

 -- по Филиалу ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceVinnica()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 35
                                   , inName:= 'Услуги Винница (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceVinnica');

 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentVinnica()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 44
                                   , inName:= 'Документы товарные Винница (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentVinnica');

-- end - 15 - Филиал Винница

 -- для ....
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Cash()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 2
                                   , inName:= 'Разрешено изменение кассы больше чем за 1 день.'
                                   , inEnumName:= 'zc_Enum_Process_Update_Cash');
                                   

 -- для ....
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_MI_OperPrice()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= 'Разрешена корректировка цены в документе.'
                                   , inEnumName:= 'zc_Enum_Process_Update_MI_OperPrice');

 -- для ....
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_PriceListItem()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 2
                                   , inName:= 'Разрешено изменение цены в любом прайсе.'
                                   , inEnumName:= 'zc_Enum_Process_Update_PriceListItem');
                                   
 -- для ....
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_ModelService()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= 'Разрешена корректировка Модели начисления.'
                                   , inEnumName:= 'zc_Enum_Process_Update_Object_ModelService');

 -- для ....
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_StaffList()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 2
                                   , inName:= 'Разрешено изменение Штатное расписание.'
                                   , inEnumName:= 'zc_Enum_Process_Update_Object_StaffList');

 -- для заявок ограничиваются Контрагенты
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_UserOrder()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= 'Пользователь заявки (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_UserOrder');
                                   
 -- для заявок ограничивается - только сырье
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_UserOrderBasis()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= 'Заявки только сырье (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_UserOrderBasis');
                                   
 -- для заявок ограничивается отчет по расчету ЗП
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_UserBranch()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= 'Пользователь филиала (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_UserBranch');

 -- для Irna
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_UserIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= 'Пользователь Irna'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_UserIrna');

 -- zc_Enum_Process_AccessKey_PeriodCloseAll
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PeriodCloseAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1001
                                   , inName:= 'Закрытый период ВСЕ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PeriodCloseAll');
 -- zc_Enum_Process_AccessKey_PeriodCloseTax
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PeriodCloseTax()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1002
                                   , inName:= 'Закрытый период Налог+Корректировки (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PeriodCloseTax');

 -- zc_Object_Goods, для Транспорта ограничивается Справочник Товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= 'Транспорт все (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportAll');

 -- zc_Object_Branch, по Филиалу ограничиваются Документы и Справочники для Транспорта
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 2
                                   , inName:= 'Транспорт Днепр (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportDnepr');

 -- zc_Object_Branch, по Филиалу ограничиваются Документы и Справочники для Транспорта
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 3
                                   , inName:= 'Транспорт Киев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportKiev');

 -- Кривой Рог, ограничения в справочниках - Транспорт
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 4
                                   , inName:= 'Транспорт Кривой Рог (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportKrRog');
 -- Николаев, ограничения в справочниках - Транспорт
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 5
                                   , inName:= 'Транспорт Николаев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportNikolaev');
 -- Харьков, ограничения в справочниках - Транспорт
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 6
                                   , inName:= 'Транспорт Харьков (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportKharkov');
 -- Черкассы, ограничения в справочниках - Транспорт
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 7
                                   , inName:= 'Транспорт Черкассы (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportCherkassi');
                                   

 -- Донецк, ограничения в справочниках - Транспорт
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportDoneck()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 8
                                   , inName:= 'Транспорт Донецк (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportDoneck');
 -- Запорожье, ограничения в справочниках - Транспорт
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 9
                                   , inName:= 'Транспорт Запорожье (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportZaporozhye');
 -- Одесса, ограничения в справочниках - Транспорт
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportOdessa()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 10
                                   , inName:= 'Транспорт Одесса (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportOdessa');

                                   
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса ВСЕ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashAll');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса Днепр (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashDnepr');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashOfficialDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса Днепр-БН (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashOfficialDnepr');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса Киев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashKiev');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса КРИВОЙ РОГ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashKrRog');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса НИКОЛАЕВ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashNikolaev');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса ХАРЬКОВ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashKharkov');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса ЧЕРКАССЫ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashCherkassi');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashDoneck()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса ДОНЕЦК (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashDoneck');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashOdessa()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса ОДЕССА (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashOdessa');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса Запорожье (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashZaporozhye');

                                   
 -- по Филиалу ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= 'Услуги Днепр (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceDnepr');
 -- по Филиалу ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 32
                                   , inName:= 'Услуги Киев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceKiev');
 -- по Филиалу ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= 'Услуги Кр Рог (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceKrRog');
                                  
 -- по Филиалу ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= 'Услуги НИКОЛАЕВ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceNikolaev');
 -- по Филиалу ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= 'Услуги ХАРЬКОВ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceKharkov');
 -- по Филиалу ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= 'Услуги ЧЕРКАССЫ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceCherkassi');
 -- по Филиалу ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceOdessa()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= 'Услуги Одесса (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceOdessa');
 -- по Филиалу ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= 'Услуги Запорожье (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceZaporozhye');

 -- по Филиалу ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceLviv()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 32
                                   , inName:= 'Услуги Львов (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceLviv');
                                   
 -- по Ирне ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 33
                                   , inName:= 'Услуги Ирна (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceIrna');

 -- по Павильону ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServicePav()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 34
                                   , inName:= 'Услуги Павильоны (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServicePav');

 -- по Пользователю ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentUser()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 41
                                   , inName:= 'Документы товарные пользователя (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentUser');

 -- НЕ ограничиваются Документы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 41
                                   , inName:= 'Документы товарные все (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentAll');
 -- НЕ ограничиваются Документы - Налоговые
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentTaxAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 41
                                   , inName:= 'Документы Налоговые все (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentTaxAll');
 -- НЕ ограничиваются Документы - Корректировки
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentTaxCorrectiveAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 41
                                   , inName:= 'Документы Корректировки все (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentTaxCorrectiveAll');

 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= 'Документы товарные Днепр (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentDnepr');

 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentBread()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= 'Документы товарные Хлеб (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentBread');
                                   
 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= 'Документы товарные Киев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentKiev');
 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= 'Документы товарные Запорожье (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentZaporozhye');
 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentOdessa()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= 'Документы товарные Одесса (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentOdessa');

 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= 'Документы товарные Кривой Рог (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentKrRog');

 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 43
                                   , inName:= 'Документы товарные Николаев (Херсон) (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentNikolaev');

 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= 'Документы товарные Харьков (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentKharkov');

 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= 'Документы товарные Черкассы (Кировоград) (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentCherkassi');

                                   
                                   
 -- ALL, нет ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 101
                                   , inName:= 'Справочники все (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideAll');
 -- Коммерсы, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideCommerce()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 101
                                   , inName:= 'Справочники Коммерсы (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideCommerce');
 -- Коммерсы + мясо, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideCommerceAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 101
                                   , inName:= 'Справочники Коммерсы + мясо (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideCommerceAll');

 -- Днепр, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 102
                                   , inName:= 'Справочники Днепр (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideDnepr');
 -- Киев, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 103
                                   , inName:= 'Справочники Киев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideKiev');
 -- Кривой Рог, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 104
                                   , inName:= 'Справочники Кривой Рог (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideKrRog');
 -- Николаев, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 105
                                   , inName:= 'Справочники Николаев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideNikolaev');
 -- Харьков, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 106
                                   , inName:= 'Справочники Харьков (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideKharkov');
 -- Черкассы, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 107
                                   , inName:= 'Справочники Черкассы (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideCherkassi');

 -- Донецк, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideDoneck()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 108
                                   , inName:= 'Справочники Донецк (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideDoneck');
 -- Запорожье, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 109
                                   , inName:= 'Справочники Запорожье (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideZaporozhye');
 -- Одесса, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideOdessa()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 110
                                   , inName:= 'Справочники Одесса (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideOdessa');

 -- Одесса, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideTech()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 121
                                   , inName:= 'Справочники Технолог (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideTech');


 -- ЗП Производство, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceProduction()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 201
                                   , inName:= 'ЗП Производство (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceProduction');
 -- ЗП Админ, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceAdmin()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 202
                                   , inName:= 'ЗП Админ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceAdmin');
 -- ЗП Коммерческий отдел, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceSbit()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 203
                                   , inName:= 'ЗП Коммерческий отдел (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceSbit');
 -- ЗП отдел Маркетинга, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceMarketing()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 204
                                   , inName:= 'ЗП отдел Маркетинга (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceMarketing');
 -- ЗП СБ, Охрана, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceSB()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 205
                                   , inName:= 'ЗП СБ, Охрана (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceSB');
 -- ЗП карточки БН, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceFirstForm()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 206
                                   , inName:= 'ЗП карточки БН (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceFirstForm');
 -- ЗП Коммерческий отдел, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceSbitM()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 207
                                   , inName:= 'ЗП Коммерческий отдел - мясо (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceSbitM');
 -- ЗП Павильоны, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServicePav()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 208
                                   , inName:= 'ЗП Павильоны (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServicePav');
 -- ЗП Павильоны, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceOther()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 209
                                   , inName:= 'ЗП прочие недвижимость (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceOther');


 -- ЗП Kiev, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 221
                                   , inName:= 'ЗП Kiev (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceKiev');
 -- ЗП KrRog, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 222
                                   , inName:= 'ЗП KrRog (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceKrRog');
 -- ЗП Nikolaev, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 223
                                   , inName:= 'ЗП Nikolaev (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceNikolaev');
 -- ЗП Kharkov, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 224
                                   , inName:= 'ЗП Kharkov (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceKharkov');
 -- ЗП Cherkassi, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 225
                                   , inName:= 'ЗП Cherkassi (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceCherkassi');
 -- ЗП Doneck, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceDoneck()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 226
                                   , inName:= 'ЗП Doneck (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceDoneck');
 -- ЗП Odessa, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceOdessa()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 227
                                   , inName:= 'ЗП Odessa (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceOdessa');
 -- ЗП Zaporozhye, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 228
                                   , inName:= 'ЗП Zaporozhye (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceZaporozhye');
                                   

 -- zc_Object_Branch, по Филиалу ограничиваются Документы и Справочники для Транспорта
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportLviv()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 3
                                   , inName:= 'Транспорт Львов (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportLviv');

 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 4
                                   , inName:= 'Транспорт Ирна (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportIrna');

 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashLviv()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса Львов (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashLviv');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 22
                                   , inName:= 'Касса Ирна (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashIrna');

 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentLviv()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= 'Документы товарные Львов (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentLviv');
 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 43
                                   , inName:= 'Документы товарные Ирна (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentIrna');
 -- Lviv, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideLviv()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 103
                                   , inName:= 'Справочники Львов (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideLviv');
 -- Irna, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 104
                                   , inName:= 'Справочники Ирна (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideIrna');

 -- ЗП Lviv, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceLviv()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 221
                                   , inName:= 'ЗП Львов (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceLviv');
 -- ЗП Irna, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceIrna()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 222
                                   , inName:= 'ЗП Ирна (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceIrna');
                       
 -- ЗП Vinnica, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceVinnica()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 223
                                   , inName:= 'ЗП Винница (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceVinnica');

 -- ограничения
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_NotCost()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= 'Ограничение просмотра с/с'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_NotCost');

 -- ограничения
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_MemberHoliday()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= 'Разрешен просмотр <Ср.ЗП за день (Приказ по отпускам)>'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_MemberHoliday');

                                   
/*
 -- заливка прав 
 PERFORM gpInsertUpdate_Object_RoleProcess2 (ioId        := tmpData.RoleRightId
                                           , inRoleId    := tmpRole.RoleId
                                           , inProcessId := tmpProcess.ProcessId
                                           , inSession   := zfCalc_UserAdmin())
 -- AccessKey  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_Right_Branch_Dnepr() AS ProcessId
           ) AS tmpProcess ON 1=1
      -- находим уже существующие права
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
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

update Movement set AccessKeyId  = caSE  WHEN MovementLinkObject_To.ObjectId = 8411 -- Склад ГП ф Киев
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN MovementLinkObject_To.ObjectId = 346093 -- Склад ГП ф.Одесса
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa() 
                          WHEN MovementLinkObject_To.ObjectId = 8413 -- Склад ГП ф.Кривой Рог
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog() 
                          WHEN MovementLinkObject_To.ObjectId = 8417 -- Склад ГП ф.Николаев (Херсон)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev() 
                          WHEN MovementLinkObject_To.ObjectId = 8425 -- Склад ГП ф.Харьков
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov() 
                          WHEN MovementLinkObject_To.ObjectId = 8415 -- Склад ГП ф.Черкассы (Кировоград)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi() 
                     end
from MovementLinkObject AS MovementLinkObject_To
                                         
where Movement.DescId = zc_Movement_ReturnIn()
and AccessKeyId  <> caSE  WHEN MovementLinkObject_To.ObjectId = 8411 -- Склад ГП ф Киев
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN MovementLinkObject_To.ObjectId = 346093 -- Склад ГП ф.Одесса
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa() 
                          WHEN MovementLinkObject_To.ObjectId = 8413 -- Склад ГП ф.Кривой Рог
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog() 
                          WHEN MovementLinkObject_To.ObjectId = 8417 -- Склад ГП ф.Николаев (Херсон)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev() 
                          WHEN MovementLinkObject_To.ObjectId = 8425 -- Склад ГП ф.Харьков
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov() 
                          WHEN MovementLinkObject_To.ObjectId = 8415 -- Склад ГП ф.Черкассы (Кировоград)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi() 
                     end

and MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                        AND MovementLinkObject_To.ObjectId in (8411 -- 
                                                                             , 346093 -- Склад ГП ф.Одесса
                                                                             , 8413 -- Склад ГП ф.Кривой Рог
                                                                             , 8417 -- Склад ГП ф.Николаев (Херсон)
                                                                             , 8425 -- Склад ГП ф.Харьков
                                                                             , 8415)
*/