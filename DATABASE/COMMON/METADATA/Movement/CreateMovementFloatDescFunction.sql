CREATE OR REPLACE FUNCTION zc_MovementFloat_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Amount', 'Сумма операции' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Amount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc (Code, ItemName)
  SELECT 'zc_MovementFloat_ChangePercent', '(-)% Скидки (+)% Наценки' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercent'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_ChangePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc (Code, ItemName)
  SELECT 'zc_MovementFloat_ChangePrice', 'Скидка в цене' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePrice'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_CurrencyValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_CurrencyValue', 'Курс валюты' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_HoursAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_HoursAdd', 'Кол-во добавленных рабочих часов' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursAdd');

CREATE OR REPLACE FUNCTION zc_MovementFloat_HoursWork() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursWork'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_HoursWork', 'Кол-во рабочих часов' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursWork');

CREATE OR REPLACE FUNCTION zc_MovementFloat_InvNumberTransport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_InvNumberTransport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_InvNumberTransport', 'Номер путевого листа' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_InvNumberTransport');

CREATE OR REPLACE FUNCTION zc_MovementFloat_MovementDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MovementDesc', 'Вид документа' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementDesc');

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
 SELECT 'zc_MovementFloat_TotalCountKg', 'Итого количество, кг' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountKg'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountPartner', 'Итого количество у контрагента' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountPartner'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountTare() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountTare'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountTare', 'Итого количество, тары' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountTare'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountSh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountSh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountSh', 'Итого количество, шт' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountSh'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSumm', 'Итого сумма по накладной (с учетом НДС и скидки)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummService', 'Итого Сумма начислено' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummService'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummCard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummCard', 'Итого сумма на карточку' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCard'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummMinus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMinus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummMinus', 'Итого сумма удержания' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMinus'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummAdd', 'Итого сумма премия' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAdd'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSocialIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSocialIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSocialIn', 'Итого Сумма соц.выплаты (в зарплате)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSocialIn'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSocialAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSocialAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSocialAdd', 'Итого Сумма соц.выплаты (к зарплате)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSocialAdd');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummCardRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCardRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummCardRecalc', 'Итого Сумма на карточку (БН) для распределения' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCardRecalc'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummChild', 'Итого Сумма алименты (удержание)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChild'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPacker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPacker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPacker', 'Итого сумма заготовителю по накладной (с учетом НДС)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPacker');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummMVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummMVAT', 'Итого сумма по накладной (без НДС)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMVAT'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPVAT', 'Итого сумма по накладной (с НДС)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPVAT'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSpending() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSpending'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSpending', 'Итого сумма затрат по накладной (с учетом НДС)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSpending');

CREATE OR REPLACE FUNCTION zc_MovementFloat_VATPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_VATPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_VATPercent', '% НДС' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_VATPercent'); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
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
