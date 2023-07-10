CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PriceListItem_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_PriceListItem_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_PriceListItem(), 'zc_ObjectHistoryFloat_PriceListItem_Value','Цена в прайс-листе' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PriceListItem_Value());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_Price_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_Price_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_PriceListItem(), 'zc_ObjectHistoryFloat_Price_Value','Цена в прайс-листе торговой точки' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_Price_Value());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_Price_MCSValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_Price_MCSValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_PriceListItem(), 'zc_ObjectHistoryFloat_Price_MCSValue','НТЗ товара на торговой точке' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_Price_MCSValue());


CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_Price_MCSPeriod() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_Price_MCSPeriod'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_Price(), 'zc_ObjectHistoryFloat_Price_MCSPeriod','Количество дней для анализа НТЗ' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_Price_MCSPeriod());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_Price_MCSDay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_Price_MCSDay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_Price(), 'zc_ObjectHistoryFloat_Price_MCSDay','Страховой запас дней НТЗ' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_Price_MCSDay());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_MarginCategoryItem_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_MarginCategoryItem_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_MarginCategoryItem(), 'zc_ObjectHistoryFloat_MarginCategoryItem_Value','% наценки' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_MarginCategoryItem_Value());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_MarginCategoryItem_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_MarginCategoryItem_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_MarginCategoryItem(), 'zc_ObjectHistoryFloat_MarginCategoryItem_Price','Минимальная цена' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_MarginCategoryItem_Price());


CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PriceChange_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_PriceChange_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
 SELECT zc_ObjectHistory_PriceChange(), 'zc_ObjectHistoryFloat_PriceChange_Value','расчетная цена' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PriceChange_Value());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PriceChange_PercentMarkup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_PriceChange_PercentMarkup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
 SELECT zc_ObjectHistory_PriceChange(), 'zc_ObjectHistoryFloat_PriceChange_PercentMarkup','% наценки' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PriceChange_PercentMarkup());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PriceChange_FixValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_PriceChange_FixValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
 SELECT zc_ObjectHistory_PriceChange(), 'zc_ObjectHistoryFloat_PriceChange_FixValue','фиксированная цена' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PriceChange_FixValue());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PriceChange_FixPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_PriceChange_FixPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
 SELECT zc_ObjectHistory_PriceChange(), 'zc_ObjectHistoryFloat_PriceChange_FixPercent','ффиксированный % скидки' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PriceChange_FixPercent());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PriceChange_FixDiscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_PriceChange_FixDiscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
 SELECT zc_ObjectHistory_PriceChange(), 'zc_ObjectHistoryFloat_PriceChange_FixDiscount','фиксированная сумма скидки' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PriceChange_FixDiscount());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PersentSalary_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_PersentSalary_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
 SELECT zc_ObjectHistory_PersentSalary(), 'zc_ObjectHistoryFloat_PersentSalary_Value','% фонда зп' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PersentSalary_Value());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PriceChange_Multiplicity() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_PriceChange_Multiplicity'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
 SELECT zc_ObjectHistory_PriceChange(), 'zc_ObjectHistoryFloat_PriceChange_Multiplicity','Кратность отпуска' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PriceChange_Multiplicity());
 
CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PriceSite_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_PriceSite_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_PriceSite(), 'zc_ObjectHistoryFloat_PriceSite_Value','Цена в прайс листе для сайта' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PriceSite_Value());
 
CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_CashSettings_FixedPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_CashSettings_FixedPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_CashSettings(), 'zc_ObjectHistoryFloat_CashSettings_FixedPercent','Фиксированный процент выполнения плана' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_CashSettings_FixedPercent());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_CashSettings_PenMobApp() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_CashSettings_PenMobApp'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_CashSettings(), 'zc_ObjectHistoryFloat_CashSettings_PenMobApp','Сумма штрафа за 1% невыполнения плана по мобильному приложению' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_CashSettings_PenMobApp());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_CashSettings_PrizeThreshold() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_CashSettings_PrizeThreshold'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_CashSettings(), 'zc_ObjectHistoryFloat_CashSettings_PrizeThreshold','Корректировка порога по премии при выполнении плана маркетинга' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_CashSettings_PrizeThreshold());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_CashSettings_MarkPlanThreshol() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_CashSettings_MarkPlanThreshol'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_CashSettings(), 'zc_ObjectHistoryFloat_CashSettings_MarkPlanThreshol','Пороги по маркет плану за вычетом премии' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_CashSettings_MarkPlanThreshol());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_CashSettings_FixedPercentB() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_CashSettings_FixedPercentB'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_CashSettings(), 'zc_ObjectHistoryFloat_CashSettings_FixedPercentB','Фиксированный процент выполнения плана категория B' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_CashSettings_FixedPercentB());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_CashSettings_FixedPercentC() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_CashSettings_FixedPercentC'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_CashSettings(), 'zc_ObjectHistoryFloat_CashSettings_FixedPercentC','Фиксированный процент выполнения плана категория C' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_CashSettings_FixedPercentC());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_CashSettings_FixedPercentD() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_CashSettings_FixedPercentD'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_CashSettings(), 'zc_ObjectHistoryFloat_CashSettings_FixedPercentD','Фиксированный процент выполнения плана категория D' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_CashSettings_FixedPercentD());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_CashSettings_PercPlanMobileApp() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_CashSettings_PercPlanMobileApp'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_CashSettings(), 'zc_ObjectHistoryFloat_CashSettings_PercPlanMobileApp','Процент от чеков для плана по мобильному приложению' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_CashSettings_PercPlanMobileApp());

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.   Шаблий О.В.
 10.07.23                                                                        * zc_ObjectHistoryFloat_CashSettings_PercPlanMobileApp
 08.03.23                                                                        * zc_ObjectHistoryFloat_CashSettings_FixedPercent...
 07.03.23                                                                        * zc_ObjectHistoryFloat_CashSettings_MarkPlanThreshol
 02.03.23                                                                        * zc_ObjectHistoryFloat_CashSettings_PrizeThreshold
 13.02.23                                                                        * zc_ObjectHistoryFloat_CashSettings_PenMobApp
 05.02.23                                                                        * zc_ObjectHistoryFloat_CashSettings_FixedPercent
 09.06.21                                                                        * zc_ObjectHistoryFloat_PriceSite_Value
 30.04.21                                                                        * zc_ObjectHistoryFloat_PriceChange_Multiplicity
 16.04.20         * zc_ObjectHistoryFloat_PersentSalary_Value
 04.12.19                                                                        * zc_ObjectHistoryFloat_PriceChange_FixDiscount
 07.02.19         * zc_ObjectHistoryFloat_PriceChange_FixPercent
 16.08.18         * zc_ObjectHistoryFloat_PriceChange_Value
                    zc_ObjectHistoryFloat_PriceChange_PercentMarkup
                    zc_ObjectHistoryFloat_PriceChange_FixValue
 09.02.17         * add zc_ObjectHistoryFloat_MarginCategoryItem_Price
                        zc_ObjectHistoryFloat_MarginCategoryItem_Value
 24.02.16         * add zc_ObjectHistoryFloat_Price_MCSPeriod
                      , zc_ObjectHistoryFloat_Price_MCSDay
 22.12.15                                                          *zc_ObjectHistoryFloat_Price_Value,zc_ObjectHistoryFloat_Price_MCSValue
 15.12.13                                        * !!!rename!!!
*/
