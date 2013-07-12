CREATE OR REPLACE FUNCTION zc_DateEnd() RETURNS TDateTime AS $BODY$BEGIN RETURN ('01.01.2100'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_DateStart_PartionPrimary() RETURNS TDateTime AS $BODY$BEGIN RETURN ('18.03.2013'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.13                                        *
*/
