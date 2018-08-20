CREATE OR REPLACE FUNCTION zc_Movement_Income() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Income'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Income', 'Приход от поставщика' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Income');

CREATE OR REPLACE FUNCTION zc_Movement_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReturnOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReturnOut', 'Возврат поставщику' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReturnOut');

CREATE OR REPLACE FUNCTION zc_Movement_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Send'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Send', 'Перемещение' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Send');

CREATE OR REPLACE FUNCTION zc_Movement_SendOnPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SendOnPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SendOnPrice', 'Перемещение по цене' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SendOnPrice');

CREATE OR REPLACE FUNCTION zc_Movement_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Sale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Sale', 'Продажа' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Sale');

CREATE OR REPLACE FUNCTION zc_Movement_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReturnIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReturnIn', 'Возврат от покупателя' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReturnIn');

CREATE OR REPLACE FUNCTION zc_Movement_Loss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Loss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Loss', 'Списание' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Loss');

CREATE OR REPLACE FUNCTION zc_Movement_ProductionUnion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ProductionUnion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ProductionUnion', 'Производство - смешивание' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ProductionUnion');

CREATE OR REPLACE FUNCTION zc_Movement_ProductionSeparate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ProductionSeparate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ProductionSeparate', 'Производство - разделение' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ProductionSeparate');

CREATE OR REPLACE FUNCTION zc_Movement_Inventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Inventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Inventory', 'Инвентаризация' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Inventory');

CREATE OR REPLACE FUNCTION zc_Movement_OrderExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderExternal', 'Заявки сторонние' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderExternal');

CREATE OR REPLACE FUNCTION zc_Movement_OrderInternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderInternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderInternal', 'Заявки внутренние' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderInternal');

CREATE OR REPLACE FUNCTION zc_Movement_Cash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Cash', 'Касса, приход/расход' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Cash');

CREATE OR REPLACE FUNCTION zc_Movement_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_BankAccount', 'Расчетный счет, приход/расход' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_BankAccount');

CREATE OR REPLACE FUNCTION zc_Movement_BankStatement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_BankStatement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_BankStatement', 'Выписка банка' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_BankStatement');

CREATE OR REPLACE FUNCTION zc_Movement_BankStatementItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_BankStatementItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_BankStatementItem', 'Элемент выписки банка' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_BankStatementItem');

CREATE OR REPLACE FUNCTION zc_Movement_Service() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Service'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Service', 'Начисления услуг по Юридическому лицу' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Service');

CREATE OR REPLACE FUNCTION zc_Movement_PersonalService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PersonalService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PersonalService', 'Начисление зарплаты' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PersonalService');

CREATE OR REPLACE FUNCTION zc_Movement_PersonalReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PersonalReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PersonalReport', 'Авансовый отчет' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PersonalReport');

CREATE OR REPLACE FUNCTION zc_Movement_ExchangeCurrency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ExchangeCurrency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ExchangeCurrency', 'Обмен валюты' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ExchangeCurrency');

CREATE OR REPLACE FUNCTION zc_Movement_Transport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Transport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Transport', 'Путевой лист' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Transport');

CREATE OR REPLACE FUNCTION zc_Movement_PersonalSendCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PersonalSendCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PersonalSendCash', 'Движение денег с подотчета на подотчет' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PersonalSendCash');

CREATE OR REPLACE FUNCTION zc_Movement_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SheetWorkTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SheetWorkTime', 'Табель учета рабочего времени' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SheetWorkTime');

CREATE OR REPLACE FUNCTION zc_Movement_PersonalAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PersonalAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PersonalAccount', 'Расчеты подотчета с юр.лицом' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PersonalAccount');

CREATE OR REPLACE FUNCTION zc_Movement_TransportService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_TransportService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_TransportService', 'Начисления наемный транспорт' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_TransportService');

CREATE OR REPLACE FUNCTION zc_Movement_LossDebt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_LossDebt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_LossDebt', 'Списание задолженности' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_LossDebt');

CREATE OR REPLACE FUNCTION zc_Movement_SendDebt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SendDebt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SendDebt', 'Взаимозачет (Юридические лица)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SendDebt');


CREATE OR REPLACE FUNCTION zc_Movement_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Tax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Tax', 'Налоговая накладная' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Tax');

CREATE OR REPLACE FUNCTION zc_Movement_TaxCorrective() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_TaxCorrective'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_TaxCorrective', 'Корректировка к налоговой накладной' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_TaxCorrective');

CREATE OR REPLACE FUNCTION zc_Movement_ProfitLossService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ProfitLossService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ProfitLossService', 'Начисления по Юридическому лицу (расходы будущих периодов)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ProfitLossService');

CREATE OR REPLACE FUNCTION zc_Movement_WeighingPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_WeighingPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_WeighingPartner', 'Взвешивание (контрагент)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_WeighingPartner');

CREATE OR REPLACE FUNCTION zc_Movement_WeighingProduction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_WeighingProduction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_WeighingProduction', 'Взвешивание (производство)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_WeighingProduction');

CREATE OR REPLACE FUNCTION zc_Movement_TransferDebtOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_TransferDebtOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_TransferDebtOut', 'Перевод долга (расход)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_TransferDebtOut');

CREATE OR REPLACE FUNCTION zc_Movement_TransferDebtIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_TransferDebtIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_TransferDebtIn', 'Перевод долга (приход)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_TransferDebtIn');

CREATE OR REPLACE FUNCTION zc_Movement_EDI() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_EDI'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_EDI', 'EDI документ' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_EDI');

CREATE OR REPLACE FUNCTION zc_Movement_EDI_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_EDI_Send'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_EDI_Send', 'Документ для отправки в EDI' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_EDI_Send');

CREATE OR REPLACE FUNCTION zc_Movement_PriceCorrective() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PriceCorrective'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PriceCorrective', 'Корректировка цены' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PriceCorrective');

CREATE OR REPLACE FUNCTION zc_Movement_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PriceList', 'Прайс-лист' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PriceList');

CREATE OR REPLACE FUNCTION zc_Movement_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Currency', 'Курсовая разница' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Currency');

CREATE OR REPLACE FUNCTION zc_Movement_FounderService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_FounderService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_FounderService', 'Начисления учредителям' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_FounderService');

CREATE OR REPLACE FUNCTION zc_Movement_QualityParams() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_QualityParams'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_QualityParams', 'Качественное удостоверение (параметры)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_QualityParams');

CREATE OR REPLACE FUNCTION zc_Movement_QualityDoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_QualityDoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_QualityDoc', 'Качественное удостоверение (документы)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_QualityDoc');

CREATE OR REPLACE FUNCTION zc_Movement_QualityNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_QualityNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_QualityNumber', 'Качественное удостоверение (номера)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_QualityNumber');


CREATE OR REPLACE FUNCTION zc_Movement_TransportGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_TransportGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_TransportGoods', 'Товаро-транспортная накладная' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_TransportGoods');

CREATE OR REPLACE FUNCTION zc_Movement_Check() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Check'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Check', 'Кассовый чек' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Check');

CREATE OR REPLACE FUNCTION zc_Movement_Medoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Medoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Medoc', 'Документы из MEDOC' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Medoc');
  
CREATE OR REPLACE FUNCTION zc_Movement_Payment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Payment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Payment', 'Документы оплат приходных накладных' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Payment');

CREATE OR REPLACE FUNCTION zc_Movement_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Promo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Promo', 'Акция' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Promo');

CREATE OR REPLACE FUNCTION zc_Movement_PromoUnit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PromoUnit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PromoUnit', 'Маркетинговый контракт для подразделения' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PromoUnit');


CREATE OR REPLACE FUNCTION zc_Movement_PromoPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PromoPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PromoPartner', 'Список покупателей для акции' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PromoPartner');
/*
Update Movement SET DescId = zc_Movement_PromoPartner()
Where Movement.DescId = zc_Movement_Promo() AND Movement.ParentId is not null;
*/
CREATE OR REPLACE FUNCTION zc_Movement_PromoAdvertising() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PromoAdvertising'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PromoAdvertising', 'Список Рекламной поддержки' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PromoAdvertising');

CREATE OR REPLACE FUNCTION zc_Movement_Reprice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Reprice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Reprice', 'Переоценка' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Reprice');

CREATE OR REPLACE FUNCTION zc_Movement_ChangeIncomePayment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ChangeIncomePayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ChangeIncomePayment', 'Изменение долга по приходу' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ChangeIncomePayment');
  
CREATE OR REPLACE FUNCTION zc_Movement_CostService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_CostService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_CostService', 'Затрата по Начисления услуг по Юридическому лицу' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_CostService');

CREATE OR REPLACE FUNCTION zc_Movement_CostTransport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_CostTransport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_CostTransport', 'Затрата по путевому листу' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_CostTransport');

CREATE OR REPLACE FUNCTION zc_Movement_Over() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Over'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Over', 'Излишки (распределение по аптекам)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Over');

CREATE OR REPLACE FUNCTION zc_Movement_OrderIncome() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderIncome'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderIncome', 'Заявка поставщику' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderIncome');

CREATE OR REPLACE FUNCTION zc_Movement_Invoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Invoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Invoice', 'Счет' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Invoice');

CREATE OR REPLACE FUNCTION zc_Movement_IncomeAsset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_IncomeAsset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_IncomeAsset', 'Приход от поставщика (ОС)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_IncomeAsset');

CREATE OR REPLACE FUNCTION zc_Movement_EntryAsset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_EntryAsset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_EntryAsset', 'Документ ОС - ввод в эксплуатацию' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_EntryAsset');

CREATE OR REPLACE FUNCTION zc_Movement_MobileBills() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_MobileBills'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_MobileBills', 'Затраты на мобильную связь' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_MobileBills');

CREATE OR REPLACE FUNCTION zc_Movement_Reestr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Reestr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Reestr', 'Реестры накладных' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Reestr');

CREATE OR REPLACE FUNCTION zc_Movement_ReestrReturn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReestrReturn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReestrReturn', 'Реестры накладных(возврат)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReestrReturn');

CREATE OR REPLACE FUNCTION zc_Movement_StoreReal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_StoreReal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_StoreReal', 'Фактический остаток по ТТ' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_StoreReal');

CREATE OR REPLACE FUNCTION zc_Movement_Task() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Task'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Task', 'Задание Торговому агенту' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Task');

CREATE OR REPLACE FUNCTION zc_Movement_Visit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Visit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Visit', 'Визит на торговую точку' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Visit');

CREATE OR REPLACE FUNCTION zc_Movement_RouteMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_RouteMember'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_RouteMember', 'Маршрут торгового агента' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_RouteMember');

CREATE OR REPLACE FUNCTION zc_Movement_MarginCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_MarginCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_MarginCategory', 'Категории наценки (САУЦ)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_MarginCategory');

CREATE OR REPLACE FUNCTION zc_Movement_PromoCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PromoCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PromoCode', 'Промо-коды' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PromoCode');

CREATE OR REPLACE FUNCTION zc_Movement_LossPersonal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_LossPersonal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_LossPersonal', 'Корректировка задолженности (Сотрудники ЗП)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_LossPersonal');

CREATE OR REPLACE FUNCTION zc_Movement_GoodsSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_GoodsSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_GoodsSP', 'Товары Соц.проекта' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_GoodsSP');

CREATE OR REPLACE FUNCTION zc_Movement_RepriceChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_RepriceChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_RepriceChange', 'Переоценка' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_RepriceChange');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 20.08.18         * zc_Movement_RepriceChange
 14.08.18         * zc_Movement_GoodsSP
 27.02.18         * zc_Movement_LossPersonal
 13.12.17         * zc_Movement_PromoCode
 17.11.17         * zc_Movement_MarginCategory
 27.03.17         * zc_Movement_RouteMember
 26.03.17         * zc_Movement_Visit
 24.03.17         * zc_Movement_Task
 20.10.16         * zc_Movement_Reestr
 27.09.16         * zc_Movement_MobileBills
 27.08.16         * zc_Movement_EntryAsset
 29.07.16         * zc_Movement_IncomeAsset
 16.07.16         * zc_Movement_Invoice
 06.07.16         * zc_Movement_Over, zc_Movement_OrderIncome
 31.10.15                                                                        *zc_Movement_Promo
 29.10.15                                                                        *zc_Movement_Payment
 05.05.15                       * add zc_Movement_Check
 27.03.15         				 * add zc_Movement_TransportGoods
 09.02.15         						* add zc_Movement_GoodsQuality
 03.09.14         * add zc_Movement_FounderService
 04.07.14                      	                 		* + zc_Movement_PriceList
 06.06.14                                                       * change Zakaz to Order  zc_Movement_OrderInternal, zc_Movement_OrderExternal
 29.05.14         * add zc_Movement_PriceCorrective
 22.04.14         * add TransferDebtOut, TransferDebtIn
 11.03.14         * add zc_Movement_WeighingPartner
 17.02.14         						* add zc_Movement_ProfitLossService
 08.02.14         						* add zc_Movement_Tax, zc_Movement_TaxCorrective
 24.01.14         *
 14.01.14                                        * add zc_Movement_LossDebt
 22.12.13         * add  zc_Movement_PersonalAccount, zc_Movement_TrasportService
 01.10.13         * add  zc_Movement_SheetWorkTime
 30.09.13                                        * add zc_Movement_PersonalSendCash
 20.08.13         * add  zc_Movement_Transport
 13.08.13         * add  zc_Movement_BankStatementItem
 12.08.13         * add  zc_Movement_BankAccount, zc_Movement_BankStatement, zc_Movement_Service, zc_Movement_PersonalService, zc_Movement_PersonalReport, zc_Movement_ExchangeCurrency
 19.07.13         * add  zc_Movement_ZakazInternal, zc_Movement_ZakazExternal
 19.07.13         * add  zc_Movement_Inventory
 16.07.13                                        * add zc_Movement_SendOnPrice, zc_Movement_ProductionSeparate, zc_Movement_Loss
 16.07.13                                        * НОВАЯ СХЕМА2 - Create and Insert
 30.06.13                                        * НОВАЯ СХЕМА
*/
