-- Function: zfGet_Unit_Retail

DROP FUNCTION IF EXISTS zfGet_Unit_Retail (Integer);

CREATE OR REPLACE FUNCTION zfGet_Unit_Retail (inUnitId Integer)
RETURNS Integer
AS
$BODY$
BEGIN
     -- !!!только так - определяется <Торговая сеть>!!!
     RETURN (COALESCE ((SELECT ObjectLink_Juridical_Retail.ChildObjectId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical
                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                 ), 0));
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfGet_Unit_Retail (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.01.17                                        *
*/

-- тест
-- SELECT (SELECT Object_Retail.ValueData FROM Object AS Object_Retail WHERE Object_Retail.Id = zfGet_Unit_Retail (Object_Unit.Id)) AS RetailName, Object_Unit.* FROM Object AS Object_Unit WHERE Object_Unit.DescId = zc_Object_Unit()
