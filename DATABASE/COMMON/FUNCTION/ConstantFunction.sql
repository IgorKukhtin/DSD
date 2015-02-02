CREATE OR REPLACE FUNCTION zc_isHistoryCost_byInfoMoneyDetail() RETURNS Boolean AS $BODY$BEGIN RETURN (TRUE AND zc_isHistoryCost()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_isHistoryCost() RETURNS Boolean AS $BODY$BEGIN RETURN (TRUE); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_DateEnd() RETURNS TDateTime AS $BODY$BEGIN RETURN ('01.01.2100'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_DateStart() RETURNS TDateTime AS $BODY$BEGIN RETURN ('01.01.2000'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_DateStart_PartionGoods() RETURNS TDateTime AS $BODY$BEGIN RETURN ('18.03.2013'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_DateStart_ObjectCostOnUnit() RETURNS TDateTime AS $BODY$BEGIN RETURN ('01.10.2010'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_BarCodePref_Object() RETURNS TVarChar AS $BODY$BEGIN RETURN ('201'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_BarCodePref_Movement() RETURNS TVarChar AS $BODY$BEGIN RETURN ('202'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_BarCodePref_MI() RETURNS TVarChar AS $BODY$BEGIN RETURN ('203'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

/*
-- Значения для эти ф-ций будут сформированы в Load_PostgreSql, или !!!руками значения =0!!!
CREATE OR REPLACE FUNCTION zc_Measure_Sh() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Measure_Kg() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_GoodsKind_WorkProgress() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_PriceList_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_PriceList_ProductionSeparate() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_PriceList_Bread() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_InfoMoneyDestination_WorkProgress() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Branch_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Juridical_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
*/

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.05.14                                        * add rem zc_PriceList_Bread
 20.10.13                                        * add rem zc_Juridical_Basis
 22.09.13                                        * add rem zc_Branch_Basis
 09.08.13                                        * rem zc_PriceList_ProductionSeparate and zc_PriceList_Basis, эти ф-ции создадутся при зугрузке данных (Load_PostgreSql.exe)
 09.08.13                                        * add zc_isHistoryCost and zc_isHistoryCost_byInfoMoneyDetail
 06.08.13                                        * ? как сделать что б некоторые ф-ции определялись после загрузки данных (а не при нинициализации БД)
 21.07.13                                        * add zc_PriceList_ProductionSeparate and zc_PriceList_Basis
 16.07.13                                        *
 12.07.13                                        *
*/
