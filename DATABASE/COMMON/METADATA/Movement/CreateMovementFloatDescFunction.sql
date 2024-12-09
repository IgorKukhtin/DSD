
CREATE OR REPLACE FUNCTION zc_MovementFloat_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Amount', 'Сумма операции' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Amount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_AmountCost', 'Сумма затрат' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountCost');

CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountMemberCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountMemberCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_AmountMemberCost', 'Сумма затрат(физ.лицо)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountMemberCost');

CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountCurrency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountCurrency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc (Code, ItemName)
  SELECT 'zc_MovementFloat_AmountCurrency', 'Сумма операции (в валюте)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountCurrency');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc (Code, ItemName)
  SELECT 'zc_MovementFloat_ChangePercent', '(-)% Скидки (+)% Наценки' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercent');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ChangePercentMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercentMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc (Code, ItemName)
  SELECT 'zc_MovementFloat_ChangePercentMin', '% скидки(срок меньше месяца)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercentMin');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ChangePercentPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercentPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc (Code, ItemName)
  SELECT 'zc_MovementFloat_ChangePercentPartner', '(-)% Скидки (+)% Наценки покупателя' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercentPartner');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ChangePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc (Code, ItemName)
  SELECT 'zc_MovementFloat_ChangePrice', 'Скидка в цене' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePrice');

CREATE OR REPLACE FUNCTION zc_MovementFloat_CurrencyPartnerValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyPartnerValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_CurrencyPartnerValue', 'Курс для расчета суммы операции' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyPartnerValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_CurrencyValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_CurrencyValue', 'Курс валюты' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_DayCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DayCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_DayCount', 'Количество дней прогноз' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DayCount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_HoursAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_HoursAdd', 'Кол-во добавленных рабочих часов' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursAdd');

CREATE OR REPLACE FUNCTION zc_MovementFloat_HoursWork() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursWork'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_HoursWork', 'Кол-во рабочих часов' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursWork');

CREATE OR REPLACE FUNCTION zc_MovementFloat_InvNumberTransport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_InvNumberTransport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_InvNumberTransport', 'Номер путевого листа' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_InvNumberTransport');

CREATE OR REPLACE FUNCTION zc_MovementFloat_MedocCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MedocCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MedocCode', 'Код в MEDOC' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MedocCode');

CREATE OR REPLACE FUNCTION zc_MovementFloat_MovementDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MovementDesc', 'Вид документа' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementDesc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_MovementDescNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementDescNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MovementDescNumber', 'Код операции (взвешивание)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementDescNumber');


CREATE OR REPLACE FUNCTION zc_MovementFloat_ParValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ParValue', 'Номинал' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ParPartnerValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParPartnerValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ParPartnerValue', 'Номинал для расчета суммы операции' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParPartnerValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_StartAmountTicketFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_StartAmountTicketFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_StartAmountTicketFuel', 'Начальный остаток талонов на топливо подотчет' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_StartAmountTicketFuel');

CREATE OR REPLACE FUNCTION zc_MovementFloat_StartSummCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_StartSummCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_StartSummCash', 'Начальный остаток денег подотчет' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_StartSummCash');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCount', 'Итого количество' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountChild', 'Итого количество (подчиненные элементы)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountChild');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountKg() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountKg'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
 SELECT 'zc_MovementFloat_TotalCountKg', 'Итого количество, вес' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountKg');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountSh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountSh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountSh', 'Итого количество, шт' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountSh');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountKgFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountKgFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
 SELECT 'zc_MovementFloat_TotalCountKgFrom', 'Итого количество, вес (ушло)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountKgFrom');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountShFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountShFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountShFrom', 'Итого количество, шт (ушло)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountShFrom');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountPartner', 'Итого количество у контрагента' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountPartner');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountTare() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountTare'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountTare', 'Итого количество, тары' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountTare');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountSecond', ' Итого количество дозаказ ' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountSecond');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSumm', 'Итого сумма по накладной (с учетом НДС и скидки)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummTare() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTare'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummTare', 'Итого сумма оборотной тары (с учетом НДС)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTare');


CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSale', 'Сумма реализации' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSale');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummService', 'Итого Сумма начислено' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummService');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummCard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummCard', 'Карта БН - 1ф.' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCard');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummCardRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCardRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummCardRecalc', 'Карта БН (ввод) - 1ф.' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCardRecalc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummCardSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCardSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummCardSecond', 'Карта БН - 2ф.' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCardSecond');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummCardSecondCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCardSecondCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummCardSecondCash', 'Карта БН (касса) - 2ф.' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCardSecondCash');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummCardSecondRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCardSecondRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummCardSecondRecalc', 'Карта БН (ввод) - 2ф.' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCardSecondRecalc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummNalog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummNalog'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummNalog', 'Налоги - удержания с ЗП' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummNalog');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummNalogRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummNalogRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummNalogRecalc', 'Налоги - удержания с ЗП (ввод)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummNalogRecalc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummNalogRet() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummNalogRet'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummNalogRet', 'Налоги - возмещение к ЗП' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummNalogRet');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummNalogRetRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummNalogRetRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummNalogRetRecalc', 'Налоги - возмещение к ЗП (ввод)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummNalogRetRecalc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummChild', 'Алименты - удержание' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChild');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummChildRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChildRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummChildRecalc', 'Алименты - удержание (ввод)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChildRecalc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummAddOth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAddOth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummAddOth', 'Премия (распределено)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAddOth');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummAddOthRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAddOthRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummAddOthRecalc', 'Премия (ввод для распределения)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAddOthRecalc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummMinusExt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMinusExt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummMinusExt', 'Удержания сторон. юр.л.' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMinusExt');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummMinusExtRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMinusExtRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummMinusExtRecalc', 'Удержания сторон. юр.л. (ввод)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMinusExtRecalc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummMinus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMinus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummMinus', 'Удержания' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMinus');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummAdd', 'Премия' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAdd');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummHouseAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummHouseAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummHouseAdd', 'Доплата за жилье' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummHouseAdd');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummHoliday() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummHoliday'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummHoliday', 'Отпускные' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummHoliday');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSocialIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSocialIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSocialIn', 'Соц.выплаты (в зарплате)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSocialIn');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSocialAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSocialAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSocialAdd', 'Соц.выплаты (к зарплате)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSocialAdd');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalAvanceRecalc () RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalAvanceRecalc '); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalAvanceRecalc ', 'Аванс (ввод для распределения)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalAvanceRecalc ');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalAvance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalAvance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalAvance', 'Аванс (распределено)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalAvance');



CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSIP', 'Итого сумма по ценам СИП' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSIP');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPrice', 'Итого сумма по ценам прайса' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPrice');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummToPay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummToPay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummToPay', 'Сумма к выплате' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummToPay');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummTransport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTransport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummTransport', 'Сумма ГСМ (удержание)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTransport');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummTransportAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTransportAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummTransportAdd', 'Сумма командировочные (доплата)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTransportAdd');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummTransportAddLong() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTransportAddLong'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummTransportAddLong', 'Сумма дальнобойные (доплата, тоже командировочные)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTransportAddLong');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummTransportTaxi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTransportTaxi'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummTransportTaxi', 'Сумма на такси (доплата)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTransportTaxi');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPhone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPhone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPhone', 'Сумма Моб.связь (удержание)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPhone');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummChangePercent', 'Сумма скидки' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChangePercent');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummFine() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummFine'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummFine', 'Сумма штрафа' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummFine');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummFineOth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummFineOth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummFineOth', 'Сумма штрафа(распределено)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummFineOth');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummFineOthRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummFineOthRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummFineOthRecalc', 'Сумма штрафа(ввод)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummFineOthRecalc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummHosp() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummHosp'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummHosp', 'Сумма больничного' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummHosp');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummHospOth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummHospOth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummHospOth', 'Сумма больничного(распределено)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummHospOth');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummHospOthRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummHospOthRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummHospOthRecalc', 'Сумма больничного (ввод)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummHospOthRecalc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPacker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPacker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPacker', 'Итого сумма заготовителю по накладной (с учетом НДС)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPacker');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummMVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummMVAT', 'Итого сумма по накладной (без НДС)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMVAT');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPVAT', 'Итого сумма по накладной (с НДС)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPVAT');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummChange', 'Итого сумма скидки по накладной' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChange');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSpending() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSpending'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSpending', 'Итого сумма затрат по накладной (с учетом НДС)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSpending');

CREATE OR REPLACE FUNCTION zc_MovementFloat_VATPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_VATPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_VATPercent', '% НДС' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_VATPercent');

CREATE OR REPLACE FUNCTION zc_MovementFloat_WeighingNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_WeighingNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_WeighingNumber', 'Номер взвешивания' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_WeighingNumber');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalDeficitSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDeficitSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalDeficitSumm', 'Итого сумма недостачи' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDeficitSumm');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalProficitSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalProficitSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalProficitSumm', 'Итого сумма излишка' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalProficitSumm');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalDiff', 'Итого разница в количестве' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDiff');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalDiffSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDiffSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalDiffSumm', 'Итого разница в сумме' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDiffSumm');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPrimeCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPrimeCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPrimeCost', 'Итого сумма себестоимости (покупки)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPrimeCost');

CREATE OR REPLACE FUNCTION zc_MovementFloat_CostPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CostPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_CostPromo', 'Стоимость участия в акции' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CostPromo');

CREATE OR REPLACE FUNCTION zc_MovementFloat_CorrBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CorrBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_CorrBonus', 'Сумма корректировки долга документа по бонусу' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CorrBonus');

CREATE OR REPLACE FUNCTION zc_MovementFloat_CorrOther() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CorrOther'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_CorrOther', 'Сумма корректировки долга документа по прочим причинам' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CorrOther');

CREATE OR REPLACE FUNCTION zc_MovementFloat_StartOdometre() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_StartOdometre'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_StartOdometre', 'Спидометр начальное показание, км' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_StartOdometre');

CREATE OR REPLACE FUNCTION zc_MovementFloat_EndOdometre() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_EndOdometre'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_EndOdometre', 'Спидометр конечное показание, км' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_EndOdometre');

CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_AmountFuel', 'Норма авто' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountFuel');

CREATE OR REPLACE FUNCTION zc_MovementFloat_Reparation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Reparation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Reparation', 'амортизация за 1 км., грн.' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Reparation');

CREATE OR REPLACE FUNCTION zc_MovementFloat_Limit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Limit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Limit', 'лимит грн' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Limit');

CREATE OR REPLACE FUNCTION zc_MovementFloat_LimitDistance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_LimitDistance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_LimitDistance', 'лимит км' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_LimitDistance');

CREATE OR REPLACE FUNCTION zc_MovementFloat_LimitChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_LimitChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_LimitChange', 'лимит (по служебке) грн' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_LimitChange');

CREATE OR REPLACE FUNCTION zc_MovementFloat_LimitDistanceChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_LimitDistanceChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_LimitDistanceChange', 'лимит (по служебке) км' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_LimitDistanceChange');

CREATE OR REPLACE FUNCTION zc_MovementFloat_Distance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Distance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Distance', 'Пробег факт, км' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Distance');

CREATE OR REPLACE FUNCTION zc_MovementFloat_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MovementId', '№ документа Затраты' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementId');

CREATE OR REPLACE FUNCTION zc_MovementFloat_MovementItemId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementItemId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MovementItemId', '№ строчной части в реестре накладных' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementItemId');

CREATE OR REPLACE FUNCTION zc_MovementFloat_MCSPeriod() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MCSPeriod'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MCSPeriod', 'период для расчета НТЗ' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MCSPeriod');

CREATE OR REPLACE FUNCTION zc_MovementFloat_MCSDay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MCSDay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MCSDay', 'на сколько дней НТЗ' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MCSDay');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummFrom', 'Итого сумма (ушло)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummFrom');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummTo', 'Итого сумма (пришло)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTo');

CREATE OR REPLACE FUNCTION zc_MovementFloat_GPSN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_GPSN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_GPSN', 'GPS координаты маршрута (широта)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_GPSN');

CREATE OR REPLACE FUNCTION zc_MovementFloat_GPSE() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_GPSE'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_GPSE', 'GPS координаты маршрута (долгота)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_GPSE');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SP', 'Код соц проекта' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SP');

CREATE OR REPLACE FUNCTION zc_MovementFloat_PriceMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PriceMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_PriceMin', 'Мин. розн.цена' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PriceMin');

CREATE OR REPLACE FUNCTION zc_MovementFloat_PriceMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PriceMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_PriceMax', 'Макс. розн.цена' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PriceMax');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ManualDiscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ManualDiscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ManualDiscount', 'Ручная скидка' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ManualDiscount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_BranchCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_BranchCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_BranchCode', 'Код Филиала' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_BranchCode');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSample() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSample'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSample', 'Итого сумма (СЕМПЛ)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSample');

CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_AmountAccount', 'Сумма в счёте' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountAccount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountPayment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountPayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_AmountPayment', 'Сумма оплаты' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountPayment');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TestingUser_Version() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TestingUser_Version'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TestingUser_Version', 'Версия опроса' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TestingUser_Version');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TestingUser_Question() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TestingUser_Question'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TestingUser_Question', 'Количество вопросов' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TestingUser_Question');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TestingUser_MaxAttempts() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TestingUser_MaxAttempts'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TestingUser_MaxAttempts', 'Количество попыток' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TestingUser_MaxAttempts');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPayAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPayAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPayAdd', 'Сумма доплаты по чеку' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPayAdd');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountOrder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountOrder', 'Итого количество в заказ' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountOrder');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummOrder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummOrder', 'Итого Сумма в заказ' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummOrder');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalHeadCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalHeadCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalHeadCount', 'Итого Кол-во голов (расход)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalHeadCount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalHeadCountChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalHeadCountChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalHeadCountChild', 'Итого Кол-во голов (приход)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalHeadCountChild');


CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPayOth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPayOth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPayOth', 'Итого сумма оплаты по другой форме оплаты' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPayOth');

CREATE OR REPLACE FUNCTION zc_MovementFloat_Replays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Replays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Replays', 'Количество повторов сообщения' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Replays');

CREATE OR REPLACE FUNCTION zc_MovementFloat_MonthCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MonthCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MonthCount', 'Количество месяцев' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MonthCount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ProcGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ProcGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ProcGoods', '% продажи для вып. плана по позиции' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ProcGoods');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ProcUnit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ProcUnit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ProcUnit', '% вып. по аптеке.' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ProcUnit');

CREATE OR REPLACE FUNCTION zc_MovementFloat_Penalty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Penalty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Penalty', 'Штраф за 1% невыполнения' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Penalty');

CREATE OR REPLACE FUNCTION zc_MovementFloat_LoyaltySMID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_LoyaltySMID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_LoyaltySMID', 'Программа лояльности накопительная ID записи покупателя' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_LoyaltySMID');

CREATE OR REPLACE FUNCTION zc_MovementFloat_LoyaltySMSumma() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_LoyaltySMSumma'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_LoyaltySMSumma', 'Сумма в накопление по Программа лояльности накопительная' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_LoyaltySMSumma');

CREATE OR REPLACE FUNCTION zc_MovementFloat_LoyaltySMDiscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_LoyaltySMDiscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_LoyaltySMDiscount', 'Сумма скидки по Программа лояльности накопительная' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_LoyaltySMDiscount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummCompensation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCompensation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummCompensation', 'Компенсация (распределено)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCompensation');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummCompensationRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCompensationRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummCompensationRecalc', 'Компенсация (ввод)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCompensationRecalc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummaManual() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummaManual'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummaManual', 'Сумма, установленная вручную' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummaManual');


CREATE OR REPLACE FUNCTION zc_MovementFloat_NumberSeats() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_NumberSeats'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_NumberSeats', 'Количество мест' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_NumberSeats');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummAuditAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAuditAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummAuditAdd', 'Доплата за ревизию' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAuditAdd');

CREATE OR REPLACE FUNCTION zc_MovementFloat_PromoStateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PromoStateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_PromoStateKind', 'Приоритет для состояния' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PromoStateKind');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummaFund() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummaFund'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummaFund', 'Использование фонда' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummaFund');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalDayAudit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDayAudit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalDayAudit', 'Дней доплата за ревизию' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDayAudit');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummMedicdayAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMedicdayAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummMedicdayAdd', 'Доплата за санобработку' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMedicdayAdd');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalDayMedicday() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDayMedicday'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalDayMedicday', 'Дней доплата за санобработку' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDayMedicday');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSkip() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSkip'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSkip', 'Удержания за прогул' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSkip');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalDaySkip() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDaySkip'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalDaySkip', 'Дней удержаний за прогул' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDaySkip');


CREATE OR REPLACE FUNCTION zc_MovementFloat_ChangePercentLess() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercentLess'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc (Code, ItemName)
  SELECT 'zc_MovementFloat_ChangePercentLess', '% скидки(срок от 1 мес до 3 мес)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercentLess');


CREATE OR REPLACE FUNCTION zc_MovementFloat_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_InvNumber', 'Инвентарный номер' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_InvNumber');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalAmount', 'Итого количество' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalAmount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummRepay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummRepay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummRepay', 'Погашать от суммы' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummRepay');

CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountPresent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountPresent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_AmountPresent', 'Количество подарка' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountPresent');

CREATE OR REPLACE FUNCTION zc_MovementFloat_HoursStop() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursStop'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_HoursStop', 'Кол-во часов ремонта' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursStop');

CREATE OR REPLACE FUNCTION zc_MovementFloat_PartnerCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PartnerCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_PartnerCount', 'Количество ТТ' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PartnerCount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_PartnerCount_no() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PartnerCount_no'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_PartnerCount_no', 'Количество ТТ с признаком Нет оплаты водителю за вес' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PartnerCount_no');

CREATE OR REPLACE FUNCTION zc_MovementFloat_PartKg() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PartKg'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_PartKg', 'Доля продажи' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PartKg');

CREATE OR REPLACE FUNCTION zc_MovementFloat_PercentRet() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PercentRet'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_PercentRet', '% возврата факт (Вес)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PercentRet');

CREATE OR REPLACE FUNCTION zc_MovementFloat_Time() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Time'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Time', 'Время на тест (сек)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Time');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummaDelivery() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummaDelivery'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummaDelivery', 'Сумма доставки' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummaDelivery');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummaReceivedFact() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummaReceivedFact'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummaReceivedFact', 'Сумма получено по факту' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummaReceivedFact');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ZReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ZReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ZReport', 'Номер Z отчета' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ZReport');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSaleNP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSaleNP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSaleNP', 'Сумма продаж "Новая почта"' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSaleNP');

CREATE OR REPLACE FUNCTION zc_MovementFloat_QuestionStorekeeper() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_QuestionStorekeeper'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_QuestionStorekeeper', 'Количество вопросов для теста кладовщику' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_QuestionStorekeeper');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TimeStorekeeper() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TimeStorekeeper'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TimeStorekeeper', 'Время на тест кладовщикам (сек)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TimeStorekeeper');

CREATE OR REPLACE FUNCTION zc_MovementFloat_PercentMarkup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PercentMarkup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_PercentMarkup', '% наценки' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PercentMarkup');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalDeficit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDeficit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalDeficit', 'Итого количество недостачи' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDeficit');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalProficit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalProficit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalProficit', 'Итого количество излишка' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalProficit');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSubstandard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSubstandard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSubstandard', 'Итого количество некондиции' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSubstandard');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummActual() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummActual'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummActual', 'Итого сумма актуально' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummActual');
  
CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummNotActual() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummNotActual'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummNotActual', 'Итого сумма не актуально' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummNotActual');  
  
CREATE OR REPLACE FUNCTION zc_MovementFloat_DaysGrace() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DaysGrace'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_DaysGrace', 'Количество дней отсрочки' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DaysGrace');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_PercentPayment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PercentPayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_PercentPayment', '% доплаты покупателем' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PercentPayment');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_MobileDiscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MobileDiscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MobileDiscount', 'Скидка с мобильного приложения' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MobileDiscount');  
    
CREATE OR REPLACE FUNCTION zc_MovementFloat_ApplicationAward() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ApplicationAward'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ApplicationAward', 'Доплата сотруднику за моб приложение' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ApplicationAward');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountCheck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountCheck'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_AmountCheck', 'Акционный товар от суммы чека' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountCheck');  
    
CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountAct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountAct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_AmountAct', 'Сумма акта' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountAct');  
                        

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummAvCardSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAvCardSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummAvCardSecond', 'Карта БН - 2ф. Аванс' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAvCardSecond');  
 
CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummAvCardSecondRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAvCardSecondRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummAvCardSecondRecalc', 'Карта БН (ввод) - 2ф. Аванс' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAvCardSecondRecalc');  
 
CREATE OR REPLACE FUNCTION zc_MovementFloat_PriceNalog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PriceNalog'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_PriceNalog', 'Ставка налога' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_PriceNalog');  
 
CREATE OR REPLACE FUNCTION zc_MovementFloat_DiffPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DiffPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_DiffPrice', 'Разрешенный % отклонение для цены' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DiffPrice');  
 
CREATE OR REPLACE FUNCTION zc_MovementFloat_RoundPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_RoundPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_RoundPrice', 'Кол-во знаков для округления' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_RoundPrice');  
 
CREATE OR REPLACE FUNCTION zc_MovementFloat_NormHour() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_NormHour'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_NormHour', 'Норма времени' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_NormHour');  
 
CREATE OR REPLACE FUNCTION zc_MovementFloat_BankSecond_num() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_BankSecond_num'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_BankSecond_num', '№ по приоритету для Банк - 2ф.(Восток)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_BankSecond_num');  
 
CREATE OR REPLACE FUNCTION zc_MovementFloat_BankSecondTwo_num() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_BankSecondTwo_num'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_BankSecondTwo_num', '№ по приоритету для Банк - 2ф.(ОТП)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_BankSecondTwo_num');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_BankSecondDiff_num() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_BankSecondDiff_num'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_BankSecondDiff_num', '№ по приоритету для Банк - 2ф.(личный)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_BankSecondDiff_num');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSumm_BankSecond_num() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm_BankSecond_num'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSumm_BankSecond_num', 'Карта Банк - 2ф.(Восток, по приоритету)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm_BankSecond_num');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSumm_BankSecondTwo_num() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm_BankSecondTwo_num'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSumm_BankSecondTwo_num', 'Карта Банк - 2ф.(ОТП, по приоритету)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm_BankSecondTwo_num');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSumm_BankSecondDiff_num() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm_BankSecondDiff_num'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSumm_BankSecondDiff_num', 'Карта Банк - 2ф.(личный, по приоритету)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm_BankSecondDiff_num');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_DelayDay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DelayDay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_DelayDay', 'Отсрочка по договору' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DelayDay');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_RetroBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_RetroBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_RetroBonus', 'Ретро бонус' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_RetroBonus');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_Market() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Market'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Market', 'Маркетинговый бюджет' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Market');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_MarketSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MarketSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MarketSumm', 'Маркетинг' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MarketSumm');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ReturnIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ReturnIn', 'Компенсация возвратов' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ReturnIn');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_Logist() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Logist'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Logist', 'Логистический бонус' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Logist');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_DebtDay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DebtDay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_DebtDay', 'Просроченная дебиторская задолженность, дней' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DebtDay');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_DebtSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DebtSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_DebtSumm', 'Просроченная дебиторская задолженность, грн' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DebtSumm');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_AmountSale', ' 	Объем продаж (статистика за 3м.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountSale');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummSale', 'Сумма продаж (статистика за 3м.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummSale');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountReturnIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_AmountReturnIn', 'Объем возвраты (статистика за 3м.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountReturnIn');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummReturnIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummReturnIn', 'Сумма возвратов (статистика за 3м.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummReturnIn');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_Pay_1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Pay_1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Pay_1', 'Сумма оплаты-1 по накладной' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Pay_1');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_Pay_2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Pay_2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Pay_2', 'Сумма оплаты-2 по накладной' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Pay_2');  
 
CREATE OR REPLACE FUNCTION zc_MovementFloat_Return_1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Return_1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Return_1', 'Сумма возврат-1 по накладной' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Return_1');  

CREATE OR REPLACE FUNCTION zc_MovementFloat_Return_2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Return_2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Return_2', 'Сумма возврат-2 по накладной' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Return_2');  
  
CREATE OR REPLACE FUNCTION zc_MovementFloat_Report() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Report'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Report', 'Отчет' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Report');  

  CREATE OR REPLACE FUNCTION zc_MovementFloat_ChangePercentAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercentAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ChangePercentAmount', '% Скидки в количестве' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercentAmount');  

  CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalLiveWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalLiveWeight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalLiveWeight', 'Живой вес' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalLiveWeight');  




/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.   Шаблий.О.В.
 06.12.24         * zc_MovementFloat_TotalLiveWeight
 27.09.24         * zc_MovementFloat_Report
 23.09.24         * zc_MovementFloat_Pay_1  
                    zc_MovementFloat_Pay_2
                    zc_MovementFloat_Return_1
                    zc_MovementFloat_Return_2                
 20.09.24         * zc_MovementFloat_AmountSale
                    zc_MovementFloat_SummSale
                    zc_MovementFloat_AmountReturnIn
                    zc_MovementFloat_SummReturnIn
 16.09.24         * zc_MovementFloat_DelayDay
                    zc_MovementFloat_RetroBonus
                    zc_MovementFloat_Market
                    zc_MovementFloat_ReturnIn
                    zc_MovementFloat_Logist  
                    zc_MovementFloat_DebtSumm 
                    zc_MovementFloat_DebtDay
                    
 11.03.24         * zc_MovementFloat_TotalSumm_BankSecond_num
                    zc_MovementFloat_TotalSumm_BankSecondTwo_num
                    zc_MovementFloat_TotalSumm_BankSecondDiff_num
 10.03.24         * zc_MovementFloat_BankSecond_num
                    zc_MovementFloat_BankSecondTwo_num
                    zc_MovementFloat_BankSecondDiff_num
 28.02.24         * zc_MovementFloat_NormHour
 08.11.23         * zc_MovementFloat_RoundPrice
                    zc_MovementFloat_DiffPrice       
 04.07.23         * zc_MovementFloat_PriceNalog
 02.05.23         * zc_MovementFloat_TotalSummAvCardSecond
                    zc_MovementFloat_TotalSummAvCardSecondRecalc
 14.03.23                                                                                     * zc_MovementFloat_AmountAct
 25.11.22                                                                                     * zc_MovementFloat_AmountCheck
 27.10.22                                                                                     * zc_MovementFloat_ApplicationAward
 21.07.22                                                                                     * zc_MovementFloat_MobileDiscount
 15.07.22                                                                                     * zc_MovementFloat_PercentPayment
 04.02.22                                                                                     * zc_MovementFloat_DaysGrace
 21.12.21                                                                                     * zc_MovementFloat_TotalSummActual, zc_MovementFloat_TotalSummNotActual
 18.12.21                                                                                     * zc_MovementFloat_TotalSubstandard
 09.12.21                                                                                     * zc_MovementFloat_TotalDeficit, zc_MovementFloat_TotalProficit
 18.11.21         * zc_MovementFloat_TotalSummHouseAdd
 08.09.21                                                                                     * zc_MovementFloat_PercentMarkup
 07.09.21                                                                                     * zc_MovementFloat_QuestionStorekeeper, zc_MovementFloat_TimeStorekeeper
 06.09.21                                                                                     * zc_MovementFloat_TotalSummSaleNP
 01.09.21                                                                                     * zc_MovementFloat_ZReport
 30.07.21                                                                                     * zc_MovementFloat_SummaReceivedFact
 23.07.21                                                                                     * zc_MovementFloat_SummaDelivery
 05.07.21                                                                                     * zc_MovementFloat_Time
 26.04.21         * zc_MovementFloat_PartnerCount
                    zc_MovementFloat_HoursStop
 05.10.20                                                                                     * zc_MovementFloat_AmountPresent
 27.07.20                                                                                     * zc_MovementFloat_SummRepay
 16.07.20                                                                                     * zc_MovementFloat_TotalAmount
 08.07.20                                                                                     * zc_MovementFloat_InvNumber
 06.07.20                                                                                     * zc_MovementFloat_ChangePercentLess
 04.06.20         * zc_MovementFloat_TotalDayAudit
 23.04.20                                                                                     * zc_MovementFloat_SummaFund
 01.04.20         * zc_MovementFloat_PromoStateKind
 25.03.20         * zc_MovementFloat_TotalSummAuditAdd
 03.03.20                                                                                     * zc_MovementFloat_NumberSeats
 03.03.20                                                                                     * zc_MovementFloat_SummaManual
 27.01.20         * zc_MovementFloat_TotalSummCompensation
                    zc_MovementFloat_TotalSummCompensationRecalc
 21.01.20                                                                                     * zc_MovementFloat_LoyaltySMID, zc_MovementFloat_LoyaltySMSumma
 20.11.19                                                                                     * zc_MovementFloat_ProcGoods, zc_MovementFloat_ProcUnit, zc_MovementFloat_Penalty
 04.11.19                                                                                     * zc_MovementFloat_MonthCount
 15.10.19         * zc_MovementFloat_TotalSummFineRecalc
                    zc_MovementFloat_TotalSummHospRecalc
 29.07.19         * zc_MovementFloat_TotalSummFine, zc_MovementFloat_TotalSummHosp
 27.05.19         * zc_MovementFloat_ChangePercentMin
 20.05.19         * zc_MovementFloat_TotalSummSIP
 13.03.19                                                                                     * zc_MovementFloat_Replays
 05.03.19         * zc_MovementFloat_TotalSummPayOth
 22.02.19         * zc_MovementFloat_TotalHeadCount
                    zc_MovementFloat_TotalHeadCountChild
 07.11.18                                                                                     * zc_MovementFloat_TotalCountOrder, zc_MovementFloat_TotalSummOrder
 02.11.18                                                                                     * zc_MovementFloat_TotalSummPayAdd
 15.10.18                                                                                     *
 01.10.18                                                                                     * zc_MovementFloat_AmountAccount, zc_MovementFloat_AmountPayment
 24.09.18         * zc_MovementFloat_TotalSummSample
 29.06.18                                                                                     * zc_MovementFloat_ManualDiscount
 25.06.18         * zc_MovementFloat_TotalSummAddOth
                    zc_MovementFloat_TotalSummAddOthRecalc
 05.01.18         * zc_MovementFloat_TotalSummNalogRet
                    zc_MovementFloat_TotalSummNalogRetRecalc
 22.11.17         * zc_MovementFloat_PriceMin
                    zc_MovementFloat_PriceMax
 20.06.17         * zc_MovementFloat_TotalSummCardSecondCash
 20.02.17         *
 20.06.16         *
 15.01.16         * add zc_MovementFloat_StartOdometre, zc_MovementFloat_EndOdometre, zc_MovementFloat_AmountFuel
                      , zc_MovementFloat_Reparation, zc_MovementFloat_Limit, zc_MovementFloat_LimitDistance
                      , zc_MovementFloat_LimitChange, zc_MovementFloat_LimitDistanceChange, zc_MovementFloat_Distance
 07.12.15                                                                      *zc_MovementFloat_CorrBonus, zc_MovementFloat_CorrOther
 31.10.15                                                                      *zc_MovementFloat_CostPromo
 02.07.15         * rename zc_MovementFloat_ChangePercentTo in zc_MovementFloat_ChangePercentPartner
 29.06.15         * add zc_MovementFloat_ChangePercentTo
 19.10.14                                        * add zc_MovementFloat_TotalCountSecond
 11.10.14                                        * add zc_MovementFloat_WeighingNumber
 23.07.14         * add CurrencyValue
 11.03.14         * add MovementDesc, InvNumberTransport
 19.10.13                                        * add zc_MovementFloat_ChangePrice
 15.10.13                                        * add zc_MovementFloat_StartSummCash and zc_MovementFloat_StartAmountTicketFuel
 30.09.13                                        * restore :-) zc_MovementFloat_Amount - Сумма операции
 29.09.13                                        * del zc_MovementFloat_Cold - Затраты топлива на охлаждение
 29.09.13                                        * del zc_MovementFloat_Norm - Норма расхода топлива
 29.09.13                                        * del zc_MovementFloat_Amount - Сумма операции
 25.09.13         * rename MorningOdometr - StartOdometre, EveningOdometre - EndOdometre; add  HoursWork, HoursAdd
 20.08.13         *  add zc_MovementFloat_MorningOdometre, zc_MovementFloat_EveningOdometre, zc_MovementFloat_Distance, zc_MovementFloat_Cold, zc_MovementFloat_Norm
 13.08.13                                        * add zc_MovementFloat_TotalCountChild and zc_MovementFloat_TotalCountPartner
 10.07.13                                        * PLPGSQL
 08.07.13                                        * НОВАЯ СХЕМА2 - Create and Insert
 30.06.13                                        * НОВАЯ СХЕМА
*/
