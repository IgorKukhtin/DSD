-- Function: gpSelect_Cash_TaxUnitNight()

DROP FUNCTION IF EXISTS gpSelect_Cash_TaxUnitNight (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_TaxUnitNight (
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (PriceTaxUnitNight TFloat, ValueTaxUnitNight TFloat
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;

   RETURN QUERY
   SELECT
         ObjectFloat_Price.ValueData                         AS PriceTaxUnitNight
       , ObjectFloat_Value.ValueData                         AS ValueTaxUnitNight

   FROM ObjectLink AS ObjectLink_TaxUnit_Unit

        LEFT JOIN Object AS Object_TaxUnit
                         ON Object_TaxUnit.Id = ObjectLink_TaxUnit_Unit.ObjectId
                        AND COALESCE (Object_TaxUnit.isErased, False) = False

        LEFT JOIN ObjectFloat AS ObjectFloat_Price
                              ON ObjectFloat_Price.ObjectId = Object_TaxUnit.Id
                             AND ObjectFloat_Price.DescId = zc_ObjectFloat_TaxUnit_Price()
        LEFT JOIN ObjectFloat AS ObjectFloat_Value
                              ON ObjectFloat_Value.ObjectId = Object_TaxUnit.Id
                             AND ObjectFloat_Value.DescId = zc_ObjectFloat_TaxUnit_Value()


   WHERE ObjectLink_TaxUnit_Unit.ChildObjectId = vbUnitId
     AND ObjectLink_TaxUnit_Unit.DescId = zc_ObjectLink_TaxUnit_Unit()
     AND Object_TaxUnit.isErased = False;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.02.19                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_Cash_TaxUnitNight( '308120')