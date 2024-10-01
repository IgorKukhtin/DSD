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

CREATE OR REPLACE FUNCTION zc_Movement_ProfitIncomeService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ProfitIncomeService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ProfitIncomeService', 'Начисления по бонусам (прибыль будущих периодов)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ProfitIncomeService');


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

CREATE OR REPLACE FUNCTION zc_Movement_CurrencyList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_CurrencyList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_CurrencyList', 'Курсы валют для расчетов' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_CurrencyList');

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

CREATE OR REPLACE FUNCTION zc_Movement_PromoInvoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PromoInvoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PromoInvoice', 'Счета для акции' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PromoInvoice');

CREATE OR REPLACE FUNCTION zc_Movement_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_InfoMoney', 'Статьи затрат для акции' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_InfoMoney');


CREATE OR REPLACE FUNCTION zc_Movement_Reprice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Reprice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Reprice', 'Переоценка' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Reprice');

CREATE OR REPLACE FUNCTION zc_Movement_ChangeIncomePayment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ChangeIncomePayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ChangeIncomePayment', 'Изменение долга по приходу' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ChangeIncomePayment');
  
CREATE OR REPLACE FUNCTION zc_Movement_IncomeCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_IncomeCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_IncomeCost', 'Затраты в приходе от поставщика' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_IncomeCost');
  
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

CREATE OR REPLACE FUNCTION zc_Movement_ReestrTransportGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReestrTransportGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReestrTransportGoods', 'Реестры ТТН' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReestrTransportGoods');

CREATE OR REPLACE FUNCTION zc_Movement_ReestrIncome() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReestrIncome'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReestrIncome', 'Реестры накладных (поставщик)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReestrIncome');

CREATE OR REPLACE FUNCTION zc_Movement_ReestrReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReestrReturnOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReestrReturnOut', 'Реестры накладных (возврат поставщику)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReestrReturnOut');

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

CREATE OR REPLACE FUNCTION zc_Movement_MarginCategoryUnit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_MarginCategoryUnit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_MarginCategoryUnit', 'Список аптек/юр.лиц' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_MarginCategoryUnit');

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

CREATE OR REPLACE FUNCTION zc_Movement_TestingUser() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_TestingUser'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_TestingUser', 'Результаты тестирования фармацевтов' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_TestingUser');

CREATE OR REPLACE FUNCTION zc_Movement_ListDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ListDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ListDiff', 'Лист отказов' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ListDiff');

CREATE OR REPLACE FUNCTION zc_Movement_UnnamedEnterprises() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_UnnamedEnterprises'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_UnnamedEnterprises', 'Безнал Предприятий' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_UnnamedEnterprises');

CREATE OR REPLACE FUNCTION zc_Movement_KPU() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_KPU'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_KPU', 'Данные для ртчета по КПУ' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_KPU');

CREATE OR REPLACE FUNCTION zc_Movement_ReportUnLiquid() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReportUnLiquid'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReportUnLiquid', 'Отчет по неликвидному товару' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReportUnLiquid');

CREATE OR REPLACE FUNCTION zc_Movement_EmployeeSchedule() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_EmployeeSchedule'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_EmployeeSchedule', 'График работы сотрудеиков' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_EmployeeSchedule');

CREATE OR REPLACE FUNCTION zc_Movement_MemberHoliday() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_MemberHoliday'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_MemberHoliday', 'Приказы по отпускам' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_MemberHoliday');

CREATE OR REPLACE FUNCTION zc_Movement_PUSH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PUSH'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PUSH', 'PUSH сообщения для кассиров' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PUSH');

CREATE OR REPLACE FUNCTION zc_Movement_SendPartionDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SendPartionDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SendPartionDate', 'Изменение срок/ не срок' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SendPartionDate');

CREATE OR REPLACE FUNCTION zc_Movement_OrderInternalPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderInternalPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderInternalPromo', 'Заявки внутренние(маркет-товары)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderInternalPromo');

CREATE OR REPLACE FUNCTION zc_Movement_OrderInternalPromoPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderInternalPromoPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderInternalPromoPartner', 'Список дистрибьютеров для ОТЧЕТА' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderInternalPromoPartner');

CREATE OR REPLACE FUNCTION zc_Movement_OrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderFinance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderFinance', 'Планирование платежей' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderFinance');

CREATE OR REPLACE FUNCTION zc_Movement_OrderSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderSale', 'Планирование Продаж по сетям' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderSale');

CREATE OR REPLACE FUNCTION zc_Movement_Wages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Wages'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Wages', 'З/П сотрудников' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Wages');

CREATE OR REPLACE FUNCTION zc_Movement_PersonalRate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PersonalRate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PersonalRate', 'Ставки заработной платы' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PersonalRate');

CREATE OR REPLACE FUNCTION zc_Movement_Loyalty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Loyalty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Loyalty', 'Программа лояльности' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Loyalty');

CREATE OR REPLACE FUNCTION zc_Movement_PermanentDiscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PermanentDiscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PermanentDiscount', 'Постоянная скидка по сети' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PermanentDiscount');

CREATE OR REPLACE FUNCTION zc_Movement_IlliquidUnit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_IlliquidUnit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_IlliquidUnit', 'Неликвиды по подразделениям' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_IlliquidUnit');

CREATE OR REPLACE FUNCTION zc_Movement_LoyaltySaveMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_LoyaltySaveMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_LoyaltySaveMoney', 'Программа лояльности накопительная' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_LoyaltySaveMoney');

CREATE OR REPLACE FUNCTION zc_Movement_TechnicalRediscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_TechnicalRediscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_TechnicalRediscount', 'Технический переучет' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_TechnicalRediscount');

CREATE OR REPLACE FUNCTION zc_Movement_SendAsset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SendAsset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SendAsset', 'Перемещение (ОС)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SendAsset');

CREATE OR REPLACE FUNCTION zc_Movement_LossAsset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_LossAsset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_LossAsset', 'Списание ОС' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_LossAsset');

CREATE OR REPLACE FUNCTION zc_Movement_SaleAsset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SaleAsset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SaleAsset', 'Продажа ОС' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SaleAsset');

CREATE OR REPLACE FUNCTION zc_Movement_ProjectsImprovements() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ProjectsImprovements'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ProjectsImprovements', 'Проекты/Доработки' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ProjectsImprovements');

CREATE OR REPLACE FUNCTION zc_Movement_SendPartionDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SendPartionDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SendPartionDateChange', 'Заявки изменения срока годности' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SendPartionDateChange');

CREATE OR REPLACE FUNCTION zc_Movement_IncomeHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_IncomeHouseholdInventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_IncomeHouseholdInventory', 'Приходы хозяйственного инвентаря ' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_IncomeHouseholdInventory');
 
CREATE OR REPLACE FUNCTION zc_Movement_WriteOffHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_WriteOffHouseholdInventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_WriteOffHouseholdInventory', 'Списание хозяйственного инвентаря' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_WriteOffHouseholdInventory');
 
 
CREATE OR REPLACE FUNCTION zc_Movement_ComputerAccessoriesRegister() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ComputerAccessoriesRegister'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ComputerAccessoriesRegister', 'Компьютерные аксессуары' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ComputerAccessoriesRegister');

CREATE OR REPLACE FUNCTION zc_Movement_InventoryHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_InventoryHouseholdInventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_InventoryHouseholdInventory', 'Инвентаризация хозяйственного инвентаря' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_InventoryHouseholdInventory');
 
CREATE OR REPLACE FUNCTION zc_Movement_Layout() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Layout'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Layout', 'Выкладка' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Layout');

CREATE OR REPLACE FUNCTION zc_Movement_LoyaltyPresent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_LoyaltyPresent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_LoyaltyPresent', 'Программа лояльности, подарок' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_LoyaltyPresent');

CREATE OR REPLACE FUNCTION zc_Movement_RelatedProduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_RelatedProduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_RelatedProduct', 'Сопутствующие товары' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_RelatedProduct');

CREATE OR REPLACE FUNCTION zc_Movement_SaleExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SaleExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SaleExternal', 'Продажа покупателя (внешняя)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SaleExternal');

CREATE OR REPLACE FUNCTION zc_Movement_DistributionPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_DistributionPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_DistributionPromo', 'Раздача акционных материалов' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_DistributionPromo');

CREATE OR REPLACE FUNCTION zc_Movement_FinalSUA() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_FinalSUA'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_FinalSUA', 'Итоговый СУА' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_FinalSUA');

CREATE OR REPLACE FUNCTION zc_Movement_PromoBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PromoBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PromoBonus', 'Корректировка цены реализации с учетом бонуса' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PromoBonus');

CREATE OR REPLACE FUNCTION zc_Movement_ProfitLossResult() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ProfitLossResult'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ProfitLossResult', 'Корректировка цены реализации с учетом бонуса' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ProfitLossResult');


CREATE OR REPLACE FUNCTION zc_Movement_OrderGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderGoods', 'Планирование Продаж по товарам' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderGoods');

CREATE OR REPLACE FUNCTION zc_Movement_OrderGoodsDetail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderGoodsDetail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderGoodsDetail', 'Планирование Продаж по товарам (детализация)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderGoodsDetail');


CREATE OR REPLACE FUNCTION zc_Movement_RepriceSite() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_RepriceSite'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_RepriceSite', 'Переоценка для сайта' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_RepriceSite');

CREATE OR REPLACE FUNCTION zc_Movement_ContractGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ContractGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ContractGoods', 'Товары в договорах(Спецификация)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ContractGoods');

CREATE OR REPLACE FUNCTION zc_Movement_TestingTuning() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_TestingTuning'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_TestingTuning', 'Настрока тестирования Фармацевтов' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_TestingTuning');


CREATE OR REPLACE FUNCTION zc_Movement_SheetWorkTimeClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SheetWorkTimeClose'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SheetWorkTimeClose', 'Закрытие периода, Табель учета рабочего времени' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SheetWorkTimeClose');

CREATE OR REPLACE FUNCTION zc_Movement_PromoInvoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PromoInvoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PromoInvoice', 'Счета для акции' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PromoInvoice');

CREATE OR REPLACE FUNCTION zc_Movement_EmployeeScheduleVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_EmployeeScheduleVIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_EmployeeScheduleVIP', 'График работы VIP менеджеров' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_EmployeeScheduleVIP');

CREATE OR REPLACE FUNCTION zc_Movement_WagesVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_WagesVIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_WagesVIP', 'З/П VIP менеджеров' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_WagesVIP');


CREATE OR REPLACE FUNCTION zc_Movement_PromoStat() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PromoStat'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PromoStat', 'Статистика продаж для акций' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PromoStat');

CREATE OR REPLACE FUNCTION zc_Movement_PromoPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PromoPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PromoPlan', 'Планирование акций' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PromoPlan');

CREATE OR REPLACE FUNCTION zc_Movement_PersonalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PersonalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PersonalGroup', 'Список бригады' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PersonalGroup');

CREATE OR REPLACE FUNCTION zc_Movement_Pretension() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Pretension'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Pretension', 'Претензия' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Pretension');

CREATE OR REPLACE FUNCTION zc_Movement_OrderReturnTare() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderReturnTare'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderReturnTare', 'Заявка на возврат тары от покупателя' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderReturnTare');

CREATE OR REPLACE FUNCTION zc_Movement_LayoutFile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_LayoutFile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_LayoutFile', 'Выкладка файлы для аптек' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_LayoutFile');

CREATE OR REPLACE FUNCTION zc_Movement_GoodsSP_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_GoodsSP_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_GoodsSP_1303', 'Товары Соц. проекта 1303' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_GoodsSP_1303');

CREATE OR REPLACE FUNCTION zc_Movement_CompetitorMarkups() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_CompetitorMarkups'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_CompetitorMarkups', 'Сравнение наценок с конкурентами' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_CompetitorMarkups');

CREATE OR REPLACE FUNCTION zc_Movement_GoodsSPRegistry_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_GoodsSPRegistry_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_GoodsSPRegistry_1303', 'Реестр товаров Соц. проекта 1303' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_GoodsSPRegistry_1303');

CREATE OR REPLACE FUNCTION zc_Movement_GoodsSPSearch_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_GoodsSPSearch_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_GoodsSPSearch_1303', 'Реестр товаров Соц. проекта 1303 для поиска' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_GoodsSPSearch_1303');

CREATE OR REPLACE FUNCTION zc_Movement_PersonalTransport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PersonalTransport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PersonalTransport', 'Начисление проезд' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PersonalTransport');

CREATE OR REPLACE FUNCTION zc_Movement_FilesToCheck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_FilesToCheck'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_FilesToCheck', 'Файлы для проверки' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_FilesToCheck');

CREATE OR REPLACE FUNCTION zc_Movement_SalePromoGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SalePromoGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SalePromoGoods', 'Отпуск акционных товаров' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SalePromoGoods');

CREATE OR REPLACE FUNCTION zc_Movement_SendDebtMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SendDebtMember'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SendDebtMember', 'Документ Взаимозачет (Физ. лица)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SendDebtMember');

CREATE OR REPLACE FUNCTION zc_Movement_AsinoPharmaSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_AsinoPharmaSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_AsinoPharmaSP', 'Социальная программа Асино Фарма Старт' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_AsinoPharmaSP');

CREATE OR REPLACE FUNCTION zc_Movement_ChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ChangePercent', 'Акт по предоставлению скидки' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ChangePercent');

CREATE OR REPLACE FUNCTION zc_Movement_GoodsSPInform_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_GoodsSPInform_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_GoodsSPInform_1303', 'Реестр товаров Соц. проекта 1303 сведения о предельных оптово-отпускных ценах' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_GoodsSPInform_1303');

CREATE OR REPLACE FUNCTION zc_Movement_GoodsSP408_1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_GoodsSP408_1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_GoodsSP408_1303', 'Реестр 408 товаров Соц. проекта 1303' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_GoodsSP408_1303');

CREATE OR REPLACE FUNCTION zc_Movement_ConvertRemains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ConvertRemains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ConvertRemains', 'Конвертация остатков' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ConvertRemains');

CREATE OR REPLACE FUNCTION zc_Movement_PersonalGroupSummAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PersonalGroupSummAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PersonalGroupSummAdd', 'Премия за лучшую бригаду' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PersonalGroupSummAdd');

CREATE OR REPLACE FUNCTION zc_Movement_BankSecondNum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_BankSecondNum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_BankSecondNum', 'Приоритет распределения по банкам ЗП - Ф2' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_BankSecondNum');

CREATE OR REPLACE FUNCTION zc_Movement_ChoiceCell() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ChoiceCell'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ChoiceCell', 'Места отбора' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ChoiceCell');

CREATE OR REPLACE FUNCTION zc_Movement_PromoTrade() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PromoTrade'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PromoTrade', 'Трейд-маркетинг' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PromoTrade');

CREATE OR REPLACE FUNCTION zc_Movement_PromoTradeCondition() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PromoTradeCondition'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PromoTradeCondition', 'Коммерческие условия' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PromoTradeCondition');

CREATE OR REPLACE FUNCTION zc_Movement_PromoTradeHistory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PromoTradeHistory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PromoTradeHistory', 'История клиента' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PromoTradeHistory');

CREATE OR REPLACE FUNCTION zc_Movement_PromoTradeSign() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PromoTradeSign'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PromoTradeSign', 'Согласование' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PromoTradeSign');

 

/*-------------------------------------------------------------------------------
 ИСТОР
 ИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.  Шаблий О.В.
 18,09,24         * zc_Movement_PromoTradeSign
 27.08.24         * zc_Movement_PromoTrade
 24.08.24         * zc_Movement_ChoiceCell
 10.03.24         * zc_Movement_BankSecondNum
 27.02.24         * zc_Movement_PersonalGroupSummAdd
 25.10.23                                                                                     * zc_Movement_ConvertRemains
 11.04.23                                                                                     * zc_Movement_GoodsSP408_1303
 01.04.23                                                                                     * zc_Movement_GoodsSPInform_1303
 02.03.23         * zc_Movement_ChangePercent
 27.02.23                                                                                     * zc_Movement_AsinoPharmaSP
 21.02.23         * zc_Movement_CurrencyList
 28.10.22         * zc_Movement_SendDebtMember
 07.09.22                                                                                     * zc_Movement_SalePromoGoods
 03.09.22                                                                                     * zc_Movement_FilesToCheck
 23.08.22         * zc_Movement_PersonalTransport
 23.06.22                                                                                     * zc_Movement_GoodsSPSearch_1303
 14.05.22                                                                                     * zc_Movement_GoodsSPRegistry_1303
 04.05.22                                                                                     * zc_Movement_CompetitorMarkups
 07.04.22                                                                                     * zc_Movement_GoodsSP_1303
 04.02.22                                                                                     * zc_Movement_LayoutFile
 06.01.22         * zc_Movement_OrderReturnTare
 01.12.21                                                                                     * zc_Movement_Pretension
 22.11.21         * zc_Movement_PersonalGroup
 20.10.21         * zc_Movement_PromoStat
                    zc_Movement_PromoPlan
 17.09.21                                                                                     * zc_Movement_WagesVIP
 15.09.21                                                                                     * zc_Movement_EmployeeScheduleVIP
 03.09.21         * zc_Movement_PromoInvoice
 06.07.21                                                                                     * zc_Movement_TestingTuning
 05.07.21         * zc_Movement_ContractGoods
 10.06.21                                                                                     * zc_Movement_RepriceSite
 08.06.21         * zc_Movement_OrderGoods
 09.03.21         * zc_Movement_ProfitLossResult
 16.02.21                                                                                     * zc_Movement_PromoBonus
 11.02.21                                                                                     * zc_Movement_FinalSUA
 31.11.20         * zc_Movement_ReestrIncome
 04.11.20                                                                                     * zc_Movement_DistributionPromo
 13.10.20                                                                                     * zc_Movement_RelatedProduct
 27.08.20         * zc_Movement_Layout
 28.07.20         * zc_Movement_ProfitIncomeService
 17.07.20                                                                                     * zc_Movement_InventoryHouseholdInventory
 14.07.20                                                                                     * zc_Movement_ComputerAccessoriesRegister
 10.07.20                                                                                     * zc_Movement_WriteOffHouseholdInventory
 01.07.20                                                                                     * zc_Movement_SendPartionDateChange
 18.06.20         * zc_Movement_LossAsset
                    zc_Movement_SaleAsset
 12.05.20                                                                                     * zc_Movement_ProjectsImprovements
 16.03.20         * zc_Movement_SendAsset
 14.02.20                                                                                     * zc_Movement_TechnicalRediscount
 31.01.20         * zc_Movement_ReestrTransportGoods
 27.12.19                                                                                     * zc_Movement_LoyaltySaveMoney
 20.12.19                                                                                     * zc_Movement_IlliquidUnit
 06.12.19                                                                                     * zc_Movement_PermanentDiscount
 04.11.19                                                                                     * zc_Movement_Loyalty
 20.09.19         * zc_Movement_PersonalRate
 21.08.19                                                                                     * zc_Movement_Wages
 29.07.19         * zc_Movement_OrderFinance
 15.04.19         * zc_Movement_OrderInternalPromo
                    zc_Movement_OrderInternalPromoPartner
 02.04.19         * zc_Movement_SendPartionDate
 10.03.19                                                                                     * zc_Movement_PUSH
 20.12.18         * zc_Movement_MemberHoliday
 07.12.18                                                                                     *  zc_Movement_EmployeeSchedule
 19.11.18         * zc_Movement_ReportUnLiquid
 04.10.18                                                                                     *  zc_Movement_KPU
 30.09.18                                                                                     *  zc_Movement_UnnamedEnterprises
 15.09.18         * zc_Movement_ListDiff
 11.09.18                                                                                     * zc_Movement_TestingUser
 10.09.18         * zc_Movement_MarginCategoryUnit
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
