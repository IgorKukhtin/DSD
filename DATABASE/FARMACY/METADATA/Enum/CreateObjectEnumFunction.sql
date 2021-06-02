-- !!!
-- !!! Глобальные константы
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_Marion() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_Marion' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_BarCode() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_BarCode' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_SiteDiscount() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_SiteDiscount' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_CostCredit() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_CostCredit' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_ConnectParam() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_ConnectParam' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_ConnectReportParam() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_ConnectReportParam' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_ConnectReportParam() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_ConnectReportParam' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_ConnectReportLocalService()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_ConnectReportLocalService' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- Константы на какую разрядность обновлять версию программы
--CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_Program32() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_Program32' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_Program64() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_Program64' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! Роли
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_Role_Admin() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_Admin' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_UnComplete() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_UnComplete' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_CashierPharmacy() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_CashierPharmacy' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_PharmacyManager() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_PharmacyManager' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_SeniorManager() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_SeniorManager' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_Cashless() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_Cashless' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_TimingControl() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_TimingControl' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_DirectorPartner() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_DirectorPartner' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_Spotter() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_Spotter' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_TechnicalRediscount() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_TechnicalRediscount' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_GoodsAccounting() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_GoodsAccounting' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_WorkWithTheFund() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_WorkWithTheFund' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_SendVIP() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_SendVIP' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_PartialSale() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_PartialSale' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_ReportsDoctor() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_ReportsDoctor' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Role_ViewWages() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_ViewWages' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Подразделение для роли Директор Партнер
-- !!!

CREATE OR REPLACE FUNCTION zc_DirectorPartner_UnitID() RETURNS integer AS $BODY$BEGIN RETURN 11300059; END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! Типы оплат
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_FirstForm()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_FirstForm' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_SecondForm() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_SecondForm' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы НДС
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_NDSKind_Common()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_NDSKind_Common' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_NDSKind_Medical() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_NDSKind_Medical' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_NDSKind_Special_0() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_NDSKind_Special_0' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! Типы корректировок долга по приходной накладной
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_ChangeIncomePaymentKind_Bonus()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ChangeIncomePaymentKind_Bonus' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ChangeIncomePaymentKind_Other() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ChangeIncomePaymentKind_Other' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ChangeIncomePaymentKind_ReturnOut() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ChangeIncomePaymentKind_ReturnOut' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ChangeIncomePaymentKind_PartialSale() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ChangeIncomePaymentKind_PartialSale' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Валюты
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_Currency_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Currency_Basis' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы установок для почты
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_EmailKind_OutReport()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EmailKind_OutReport' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EmailKind_OutOrder()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EmailKind_OutOrder' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EmailKind_InPrice() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EmailKind_InPrice' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EmailKind_IncomeMMO() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EmailKind_IncomeMMO' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы импорта
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_Excel()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_Excel' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_DBF() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_DBF' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_MMO() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_MMO' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_ODBC() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_ODBC' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Статусы документов
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_StatusCode_UnComplete() RETURNS Integer AS $BODY$BEGIN RETURN (1); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StatusCode_Complete() RETURNS Integer AS $BODY$BEGIN RETURN (2); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StatusCode_Erased() RETURNS Integer AS $BODY$BEGIN RETURN (3); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_UnComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_UnComplete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_Complete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_Complete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_Erased() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_Erased' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Статусы документов EDI
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_EDIStatus_ORDERS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EDIStatus_ORDERS' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EDIStatus_DESADV() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EDIStatus_DESADV' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EDIStatus_COMDOC() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EDIStatus_COMDOC' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EDIStatus_DECLAR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EDIStatus_DECLAR' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Тип контакта
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ContactPersonKind_CreateOrder()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContactPersonKind_CreateOrder'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContactPersonKind_CheckDocument() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContactPersonKind_CheckDocument' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContactPersonKind_AktSverki()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContactPersonKind_AktSverki'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContactPersonKind_ProcessOrder()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContactPersonKind_ProcessOrder'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContactPersonKind_PriceListIn()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContactPersonKind_PriceListIn'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContactPersonKind_IncomeMMO()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContactPersonKind_IncomeMMO'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы формирования налогового документа
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_Tax()                   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_Tax'                   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_TaxSummaryPartnerS'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_Corrective()                   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_Corrective'                   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_CorrectivePrice()              RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_CorrectivePrice'              AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_Prepay()                       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_Prepay'                       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! Виды товаров
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_GoodsKind_Main() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GoodsKind_Main' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы счетов
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_AccountKind_Active() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountKind_Active' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_AccountKind_Passive() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountKind_Passive' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_AccountKind_All() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountKind_All' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы маршрутов
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_RouteKind_Internal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_RouteKind_Internal' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_RouteKind_External() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_RouteKind_External' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы рабочего времени
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Work()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Work'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_WorkTime()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_WorkTime'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Holiday()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Holiday'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Hospital()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Hospital'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_SkipOut()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_SkipOut'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_SkipIn()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_SkipIn'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_WorkCS()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_WorkCS'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_WorkAS()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_WorkAS'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_WorkNS()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_WorkNS'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_WorkSCS()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_WorkSCS'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_WorkS()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_WorkS'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_WorkSAS()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_WorkSAS'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PayrollType_WorkIS()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PayrollType_WorkIS'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы расчета заработной платы
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_PayrollType_WorkCS()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PayrollType_WorkCS'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PayrollType_WorkAS()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PayrollType_WorkAS'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PayrollType_WorkNS()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PayrollType_WorkNS'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PayrollType_WorkSCS()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PayrollType_WorkSCS'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PayrollType_WorkS()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PayrollType_WorkS'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PayrollType_WorkSAS()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PayrollType_WorkSAS'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PayrollType_WorkI()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PayrollType_WorkI'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Группы расчета заработной платы
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_PayrollGroup_Check()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PayrollGroup_Check'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PayrollGroup_IncomeCheck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PayrollGroup_IncomeCheck'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы модели начисления
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ModelServiceKind_DaySheetWorkTime()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ModelServiceKind_DaySheetWorkTime'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ModelServiceKind_MonthSheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ModelServiceKind_MonthSheetWorkTime' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ModelServiceKind_SatSheetWorkTime()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ModelServiceKind_SatSheetWorkTime'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ModelServiceKind_MonthFundPay()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ModelServiceKind_MonthFundPay'       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ModelServiceKind_TurnFundPay()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ModelServiceKind_TurnFundPay'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы выбора данных
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_InWeight()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_InWeight'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_OutWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_OutWeight' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_InAmount()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_InAmount'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_OutAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_OutAmount' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы сумм для штатного расписания
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_Month()           RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_Month'           AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_Day()             RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_Day'             AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_Personal()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_Personal'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_HoursPlan()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_HoursPlan'       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_HoursDay()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_HoursDay'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_HoursPlanConst()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_HoursPlanConst'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_HoursDayConst()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_HoursDayConst'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_WorkHours()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_WorkHours'       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Состояние договора
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ContractStateKind_Signed()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractStateKind_Signed'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractStateKind_UnSigned() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractStateKind_UnSigned' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractStateKind_Close() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractStateKind_Close' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractStateKind_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractStateKind_Partner' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы условий договоров
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_ChangePercent()          RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_ChangePercent'          AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_ChangePrice()            RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_ChangePrice'            AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_DelayDayCalendar()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_DelayDayCalendar'       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_DelayDayBank()           RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_DelayDayBank'           AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_DelayCreditLimit()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_DelayCreditLimit'       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_DelayPrepay()            RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_DelayPrepay'            AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_CreditPercent()          RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_CreditPercent'          AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_CreditLimit()            RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_CreditLimit'            AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_CreditPercentService()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_CreditPercentService'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_CreditPercentReceived()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_CreditPercentReceived'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusPercentSale()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusPercentSale'       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusPercentSaleReturn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusPercentSaleReturn' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusPercentAccount()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusPercentAccount'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusMonthlyPayment()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusMonthlyPayment'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusMonthlyPaymentAdv() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusMonthlyPaymentAdv' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusUpSaleSummPVAT()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusUpSaleSummPVAT'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusUpSaleSummMVAT()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusUpSaleSummMVAT'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusYearlyPayment()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusYearlyPayment'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_LimitReturn()            RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_LimitReturn'            AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportTime1()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportTime1'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportTime2()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportTime2'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportTime3()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportTime3'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportTime4()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportTime4'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportDistance()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportDistance'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportOneTrip()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportOneTrip'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportRoundTrip() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportRoundTrip'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportPoint()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportPoint'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! Баланс: 1-уровень Управленческих Счетов
-- !!!
-- 10000; "Необоротные активы"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_10000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_10000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Запасы"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_20000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_20000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "Дебиторы"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_30000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_30000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "Денежные средства"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_40000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_40000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "Расходы будущих периодов"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_50000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_50000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60000; "Прибыль будущих периодов"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_60000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_60000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "Кредиторы"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_70000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_70000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80000; "Кредитование"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_80000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_80000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 90000; "Расчеты с бюджетом"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_90000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_90000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 100000; "Собственный капитал"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_100000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_100000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 110000; "Транзит"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_110000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_110000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Баланс: 2-уровень Управленческих Счетов
-- !!!

-- 20000; "Запасы"; 20100; "склад"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Запасы"; 20200; "аптека"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 40000; "Денежные средства"; 40100; "касса"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_40100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_40100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "Денежные средства"; 40300; "рассчетный счет"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_40300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_40300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 70000; "Кредиторы"; 70100; "Поставщики"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 100000; "Собственный капитал"; 100300; "Прибыль текущего периода"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_100300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_100300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Баланс: Управленческие Счета (1+2+3 уровень)
-- !!!

-- 40101; "Касса";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40301; "Расчетный счет";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40301() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40301' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! УП: 2-уровень Управленческие назначения
-- !!!

-- 10000; "Основное сырье"; 10200; "Медикаменты"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_10200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_10200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80000; "Собственный капиталл"; 80400; "Прибыль текущего периода"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_80400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_80400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Баланс: Управленческие Счета (1+2+3 уровень)
-- !!!
-- 100301; "прибыль текущего периода";
CREATE OR REPLACE FUNCTION zc_Enum_Account_100301() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_100301' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- !!!
-- !!! Типы оплат на кассе
-- !!!
-- 0. наличка
CREATE OR REPLACE FUNCTION zc_Enum_PaidType_Cash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidType_Cash' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 1. карточка
CREATE OR REPLACE FUNCTION zc_Enum_PaidType_Card() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidType_Card' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 2. Смешенная карточка + доплата наличными
CREATE OR REPLACE FUNCTION zc_Enum_PaidType_CardADD() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidType_CardAdd' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Загрузки
-- !!!
--Загрузка НТЗ
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_MCS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_MCS' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_MCS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_MCS' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--Загрузка НТЗ в zc_Object_DataExcel
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_MCSExcel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_MCSExcel' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_MCSExcel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_MCSExcel' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--Загрузка Цен
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Price' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Price' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--Загрузка остатков в переучет
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Inventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Inventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Inventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Inventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--Загрузка Минимального округления
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Goods_MinimumLot() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Goods_MinimumLot' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Goods_MinimumLot() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Goods_MinimumLot' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--Загрузка признака <Выгружается в отчете для поставщика>
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Goods_isUpload() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Goods_IsUpload' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Goods_IsUpload() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Goods_IsUpload' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--Загрузка признака <Товар под спецусловия>
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Goods_isSpecCondition() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Goods_IsSpecCondition' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Goods_IsSpecCondition() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Goods_IsSpecCondition' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--Загрузка признака <Условия хранения>
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Goods_ConditionsKeep() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Goods_ConditionsKeep' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Goods_ConditionsKeep() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Goods_ConditionsKeep' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--Загрузка данных в Маркетинговый контракт
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--Загрузка данных в Маркетинговый контракт по подразделению
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PromoUnit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PromoUnit' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PromoUnit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PromoUnit' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--Загрузка Данные по Соц.проекту
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsSP' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsSP' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--Загрузка Данные по Соц.проекту в документ
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsSPMovement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsSPMovement' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsSPMovement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsSPMovement' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--Загрузка доп. данных по Соц.проекту в документ
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsSPDopMovement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsSPDopMovement' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsSPDopMovement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsSPDopMovement' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--Загрузка данных по Соц.проекту Helsi
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsSPMovementHelsi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsSPMovementHelsi' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsSPMovementHelsi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsSPMovementHelsi' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--Загрузка Врач  Соц.проекту
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_MedicSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_MedicSP' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_MedicSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_MedicSP' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--Загрузка Данные по штрих-кодам
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_BarCode' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_BarCode' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--Загрузка Данные по штрих-кодам из прайс-листа
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_BarCode_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_BarCode_Price' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_BarCode_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_BarCode_Price' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--Загрузка Цен в справочник товаров сети
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Goods_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Goods_Price' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Goods_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Goods_Price' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--Загрузка признака Дополнение для СУН1
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_inSupplementSUN1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_inSupplementSUN1' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_inSupplementSUN1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_inSupplementSUN1' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! Типы аналитик для проводок
-- !!!

-- -- Кол-во, реализация, у покупателя
-- CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleCount_10400()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleCount_10400' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- -- Кол-во, реализация, Скидка за вес
-- CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleCount_10500() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleCount_10500' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- -- Кол-во, реализация, Разница в весе
-- CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleCount_40200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleCount_40200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- -- Сумма с/с, реализация, у покупателя
-- CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleSumm_10400()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleSumm_10400' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- -- Сумма с/с, реализация, Скидка за вес
-- CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleSumm_10500() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleSumm_10500' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- -- Сумма с/с, реализация, Разница в весе
-- CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleSumm_40200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleSumm_40200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- -- Сумма, реализация, у покупателя
-- CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleSumm_10100()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleSumm_10100' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- -- Сумма, реализация, Разница с оптовыми ценами
-- CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleSumm_10200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleSumm_10200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- Сумма, реализация, Скидка дополнительная
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleSumm_10300() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleSumm_10300' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- Сумма, возврат, Скидка дополнительная
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_ReturnInSumm_10300() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_ReturnInSumm_10300' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы связей
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_UnitJuridical()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_UnitJuridical' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_UnitUnitId()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_UnitUnitId' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_DefaultFileName()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_DefaultFileName' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_UnitEmailSign()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_UnitEmailSign' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_ClientEmailSubject()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_ClientEmailSubject' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_OldClientLink()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_OldClientLink' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_UploadCompliance()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_UploadCompliance' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_QlikView()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_QlikView' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!!  Статус заказа
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ConfirmedKind_UnComplete()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ConfirmedKind_UnComplete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ConfirmedKind_Complete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ConfirmedKind_Complete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ConfirmedKind_SmsNo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ConfirmedKind_SmsNo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ConfirmedKind_SmsYes() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ConfirmedKind_SmsYes' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!!  Виды соц.проектов
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_SPKind_SP()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SPKind_SP' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SPKind_1303() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SPKind_1303' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Типы срок/не срок
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_PartionDateKind_0() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PartionDateKind_0' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PartionDateKind_1() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PartionDateKind_1' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PartionDateKind_3() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PartionDateKind_3' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PartionDateKind_6() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PartionDateKind_6' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PartionDateKind_Good() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PartionDateKind_Good' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PartionDateKind_Cat_5() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PartionDateKind_Cat_5' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! Источник чека
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_CheckSourceKind_Liki24() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_CheckSourceKind_Liki24' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_CheckSourceKind_Tabletki() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_CheckSourceKind_Tabletki' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Разделение партий в кассе для продажи
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_DivisionParties_UKTVED() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DivisionParties_UKTVED' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Разделы инструкций
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_InstructionsKind_IT() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InstructionsKind_IT' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_InstructionsKind_Managers() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InstructionsKind_Managers' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_InstructionsKind_Marketing() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InstructionsKind_Marketing' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! Шкала расчета премии/штрафы в план по маркетингу
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_ScaleCalcMarketingPlan_AB() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ScaleCalcMarketingPlan_AB' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ScaleCalcMarketingPlan_CC1() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ScaleCalcMarketingPlan_CC1' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ScaleCalcMarketingPlan_D() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ScaleCalcMarketingPlan_D' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! Методы выбора аптек ассортимента
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_MethodsAssortment_Geographically() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_MethodsAssortment_Geographically' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_MethodsAssortment_Sales() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_MethodsAssortment_Sales' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.    Воробкало А.А.  Ярошенко Р.Ф.  Шаблий О.В.
 31.05.21                                                                                                   * zc_Enum_MethodsAssortment_
 16.02.21                                                                                                   * zc_Enum_InstructionsKind_
 13.08.20                                                                                                   * zc_Enum_DivisionParties_UKTVED
 15.06.20                                                                                                   * zc_Enum_CheckSourceKind_Liki24
 24.04.19                                                                                                   * Проверка и погашение рецептов по доступным лекарствам
 19.04.19         * zc_Enum_PartionDateKind...
 15.04.19                                                                                                   * zc_Enum_GlobalConst_ConnectReportLocalService
 02.04.19         * zc_Enum_ImportType_Goods_Price
                    zc_Enum_ImportSetting_Goods_Price
 07.01.19                                                                                                   * zc_Enum_GlobalConst_ConnectReportParam
 02.11.18                                                                                                   * zc_Enum_PaidType_CardADD
 05.06.17                                                                                    * Загрузка данных по штрих-кодам
 23.05.17         * zc_Enum_SPKind_SP, zc_Enum_SPKind_1303
 18.02.16         * add zc_Enum_ImportType_Goods_isSpecCondition, zc_Enum_ImportSetting_Goods_IsSpecCondition
 23.11.15                                                                    *zc_Enum_ImportType_Goods_isUpload,zc_Enum_ImportSetting_Goods_IsUpload
 23.07.14                        * Скопировал для Аптек
*/
