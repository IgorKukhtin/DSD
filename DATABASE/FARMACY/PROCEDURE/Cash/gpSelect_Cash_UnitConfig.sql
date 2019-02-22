-- Function: gpSelect_Cash_UnitConfig()

DROP FUNCTION IF EXISTS gpSelect_Cash_UnitConfig (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_UnitConfig (
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (id Integer, Code Integer, Name TVarChar,
               ParentName TVarChar,
               TaxUnitNight Boolean, TaxUnitStartDate TDateTime, TaxUnitEndDate TDateTime
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
   WITH tmpTaxUnitNight AS (SELECT  ObjectLink_TaxUnit_Unit.ChildObjectId               AS UnitId
                            FROM ObjectLink AS ObjectLink_TaxUnit_Unit

                                 LEFT JOIN Object AS Object_TaxUnit
                                                  ON Object_TaxUnit.Id = ObjectLink_TaxUnit_Unit.ObjectId
                                                 AND COALESCE (Object_TaxUnit.isErased, False) = False

                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                       ON ObjectFloat_Value.ObjectId = Object_TaxUnit.Id
                                                      AND ObjectFloat_Value.DescId = zc_ObjectFloat_TaxUnit_Value()


                            WHERE ObjectLink_TaxUnit_Unit.DescId = zc_ObjectLink_TaxUnit_Unit()
                              AND Object_TaxUnit.isErased = False
                              AND COALESCE(ObjectFloat_Value.ValueData, 0) <> 0)
   
   
   SELECT
         Object_Unit.Id                                      AS Id
       , Object_Unit.ObjectCode                              AS Code
       , Object_Unit.ValueData                               AS Name

       , Object_Parent.ValueData                             AS ParentName

       , COALESCE (tmpTaxUnitNight.UnitId, 0) <> 0 
         AND COALESCE(ObjectDate_TaxUnitStart.ValueData ::Time,'00:00') <> '00:00' 
         AND COALESCE(ObjectDate_TaxUnitEnd.ValueData ::Time,'00:00') <> '00:00'                 AS TaxUnitNight

       , CASE WHEN COALESCE(ObjectDate_TaxUnitStart.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_TaxUnitStart.ValueData ELSE Null END ::TDateTime  AS TaxUnitStartDate
       , CASE WHEN COALESCE(ObjectDate_TaxUnitEnd.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_TaxUnitEnd.ValueData ELSE Null END ::TDateTime  AS TaxUnitEndDate

   FROM Object AS Object_Unit

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_TaxUnitStart
                             ON ObjectDate_TaxUnitStart.ObjectId = Object_Unit.Id
                            AND ObjectDate_TaxUnitStart.DescId = zc_ObjectDate_Unit_TaxUnitStart()

        LEFT JOIN ObjectDate AS ObjectDate_TaxUnitEnd
                             ON ObjectDate_TaxUnitEnd.ObjectId = Object_Unit.Id
                            AND ObjectDate_TaxUnitEnd.DescId = zc_ObjectDate_Unit_TaxUnitEnd()

        LEFT JOIN tmpTaxUnitNight ON tmpTaxUnitNight.UnitID = Object_Unit.Id

   WHERE Object_Unit.Id = vbUnitId 
   --LIMIT 1
   ;

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
-- SELECT * FROM gpSelect_Cash_UnitConfig( '308120')