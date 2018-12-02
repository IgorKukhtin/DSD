-- Function: lfSelect_Object_Unit_isOutlet()

DROP FUNCTION IF EXISTS lfSelect_Object_Unit_isOutlet();

CREATE OR REPLACE FUNCTION lfSelect_Object_Unit_isOutlet()
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar, DiscountTax TFloat)
AS
$BODY$
BEGIN

     -- Результат
     RETURN QUERY
       SELECT Object_Unit.Id                  AS UnitId
            , Object_Unit.ObjectCode          AS UnitCode
            , Object_Unit.ValueData           AS UnitName
            , OF_Unit_DiscountTax.ValueData   AS DiscountTax
       FROM Object AS Object_Unit
            INNER JOIN ObjectFloat AS OF_Unit_DiscountTax
                                   ON OF_Unit_DiscountTax.ObjectId  = Object_Unit.Id
                                  AND OF_Unit_DiscountTax.DescId    = zc_ObjectFloat_Unit_DiscountTax()
                                  AND OF_Unit_DiscountTax.ValueData <> 0
       WHERE Object_Unit.DescId = zc_Object_Unit()
         -- AND Object_Unit.isErased = FALSE
      ;

 END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.12.18                                        *
*/

-- тест
-- SELECT * FROM lfSelect_Object_Unit_isOutlet ()
