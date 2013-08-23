CREATE OR REPLACE FUNCTION zc_isHistoryCost_byInfoMoneyDetail() RETURNS Boolean AS $BODY$BEGIN RETURN (FALSE AND zc_isHistoryCost()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_isHistoryCost() RETURNS Boolean AS $BODY$BEGIN RETURN (TRUE); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_DateEnd() RETURNS TDateTime AS $BODY$BEGIN RETURN ('01.01.2100'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_DateStart_PartionGoods() RETURNS TDateTime AS $BODY$BEGIN RETURN ('18.03.2013'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_DateStart_ObjectCostOnUnit() RETURNS TDateTime AS $BODY$BEGIN RETURN ('01.09.2013'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- CREATE OR REPLACE FUNCTION zc_PriceList_ProductionSeparate() RETURNS Integer AS $BODY$BEGIN RETURN (19183); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE; -- select Id_Postgres from PriceList_byHistory where Id = zc_def_PriceList_onRecalcProduction();

-- CREATE OR REPLACE FUNCTION zc_PriceList_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (19134); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE; -- select Id_Postgres from PriceList_byHistory where Id = 2;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.08.13                                        * del zc_PriceList_ProductionSeparate and zc_PriceList_Basis, эти ф-ции создадутся при зугрузке данных (Load_PostgreSql.exe)
 09.08.13                                        * add zc_isHistoryCost and zc_isHistoryCost_byInfoMoneyDetail
 06.08.13                                        * ? как сделать что б некоторые ф-ции определялись после загрузки данных (а не при нинициализации БД)
 21.07.13                                        * add zc_PriceList_ProductionSeparate and zc_PriceList_Basis
 16.07.13                                        *
 12.07.13                                        *
*/
