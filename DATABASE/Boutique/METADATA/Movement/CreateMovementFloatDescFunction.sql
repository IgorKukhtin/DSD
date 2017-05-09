
CREATE OR REPLACE FUNCTION zc_MovementFloat_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Amount', 'Сумма операции' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Amount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountCurrency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountCurrency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc (Code, ItemName)
  SELECT 'zc_MovementFloat_AmountCurrency', 'Сумма операции (в валюте)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountCurrency');

CREATE OR REPLACE FUNCTION zc_MovementFloat_CurrencyPartnerValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyPartnerValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_CurrencyPartnerValue', 'Курс для расчета суммы операции' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyPartnerValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_CurrencyValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_CurrencyValue', 'Курс валюты' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ParValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ParValue', 'Номинал' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ParPartnerValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParPartnerValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ParPartnerValue', 'Номинал для расчета суммы операции' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParPartnerValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCount', 'Итого количество' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCount'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountPartner', 'Итого количество  у контрагента' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountPartner'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountRemains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountRemains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountRemains', 'Итого количество - Расчетный остаток' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountRemains'); 


CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSumm', 'Итого сумма по документу (в валюте документа)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm'); 

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

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPriceList', 'Итого сумма по PriceList' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPriceList'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummRemainsPriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummRemainsPriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummRemainsPriceList', 'Итого сумма по PriceList - Расчетный остаток' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummRemainsPriceList'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_ChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ChangePercent', '% Скидки, Наценки' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercent'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummBalance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummBalance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummBalance', 'Итого сумма по документу (в ГРН)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummBalance'); 

  CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPay', 'Итого сумма оплаты (в ГРН)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPay'); 

  CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPayOth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPayOth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPayOth', 'Итого сумма оплаты (в ГРН)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPayOth'); 

  CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountReturn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountReturn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountReturn', 'Итого количество возврата' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountReturn'); 

  CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummReturn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummReturn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummReturn', 'Итого сумма возврата со скидкой (в ГРН)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummReturn'); 

  CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPayReturn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPayReturn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPayReturn', 'Итого сумма возврата оплаты (в ГРН)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPayReturn'); 

  
/*-------------------------------------------------------------------------------
 !!!!!!!!!!!!!!!!!!! РАСПОЛАГАЙТЕ ДЕСКИ ПО АЛФАВИТУ !!!!!!!!!!!!!!!!!!!
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.   Роман
 09.05.17         * zc_MovementFloat_TotalSummBalance
                    zc_MovementFloat_TotalSummPay
                    zc_MovementFloat_TotalSummPayOth
                    zc_MovementFloat_TotalCountReturn
                    zc_MovementFloat_TotalSummPayReturn
 02.05.17         * zc_MovementFloat_TotalSummRemainsPriceList
                    zc_MovementFloat_TotalCountRemains
 13.04.17                                                         *
 10.04.17         * zc_MovementFloat_TotalSummPriceList
 25.02.17                                        * start
*/
