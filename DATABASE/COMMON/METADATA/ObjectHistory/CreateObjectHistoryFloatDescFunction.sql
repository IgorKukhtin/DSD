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

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
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
