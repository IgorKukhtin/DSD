-- Function: gpSelect_Object_TaxUnit()

DROP FUNCTION IF EXISTS gpSelect_Object_TaxUnit(Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TaxUnit(
    IN inUnitId          Integer ,
    IN inShowAll         Boolean ,
    IN inisErased        Boolean ,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitName TVarChar
             , Price TFloat, PriceLimit TFloat
             , Value TFloat
             , isErased boolean) AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_TaxUnit());
   vbUserId:= inSession;

   -- определяется <Торговая сеть>
   vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

   IF inShowAll THEN
      RETURN QUERY 
      WITH 
      tmpTaxUnit AS (SELECT Object_TaxUnit.Id           AS Id
                          , ObjectLink_TaxUnit_Unit.ChildObjectId AS UnitId
                          , ObjectFloat_Price.ValueData AS Price
                          , ObjectFloat_Value.ValueData AS Value
                          , Object_TaxUnit.isErased     AS isErased
                      FROM Object AS Object_TaxUnit
                          INNER JOIN ObjectLink AS ObjectLink_TaxUnit_Unit
                                               ON ObjectLink_TaxUnit_Unit.ObjectId = Object_TaxUnit.Id
                                              AND ObjectLink_TaxUnit_Unit.DescId = zc_ObjectLink_TaxUnit_Unit()
                                              AND (ObjectLink_TaxUnit_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
                          
                          LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                                ON ObjectFloat_Price.ObjectId = Object_TaxUnit.Id
                                               AND ObjectFloat_Price.DescId = zc_ObjectFloat_TaxUnit_Price()
                          LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                                ON ObjectFloat_Value.ObjectId = Object_TaxUnit.Id
                                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_TaxUnit_Value()
                     WHERE Object_TaxUnit.DescId = zc_Object_TaxUnit()
                      AND (Object_TaxUnit.isErased = inisErased OR inisErased = TRUE)
                     )

    , tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                    FROM ObjectLink AS ObjectLink_Unit_Juridical
                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                           AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                    WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                      AND (ObjectLink_Unit_Juridical.ObjectId = inUnitId OR inUnitId = 0)
                    )
          
    , tmpData AS (SELECT DD.Id
                       , DD.UnitId
                       , DD.Price
                       , (COALESCE ((SELECT MIN (FF.Price) 
                             FROM tmpTaxUnit AS FF 
                             WHERE FF.Price > DD.Price 
                               AND FF.UnitId = DD.UnitId
                               AND FF.isErased = FALSE 
                               AND DD.isErased = FALSE
                               ), 100000)-0.01) :: TFloat  AS PriceLimit
                       , DD.Value
                       , DD.isErased
                  FROM tmpTaxUnit AS DD
                  )
      -- результат
      SELECT COALESCE (tmpData.Id, 0)    AS Id
           , Object_Unit.Id              AS UnitId
           , Object_Unit.ValueData       AS UnitName
           , COALESCE (tmpData.Price, 0)      :: TFloat AS Price
           , COALESCE (tmpData.PriceLimit, 0) :: TFloat AS PriceLimit
           , COALESCE (tmpData.Value, 0)      :: TFloat AS Value
           , CASE WHEN COALESCE (tmpData.isErased, FALSE) = TRUE OR Object_Unit.isErased = TRUE THEN TRUE ELSE FALSE END :: Boolean AS isErased
      FROM tmpUnit
           FULL JOIN tmpData ON tmpData.UnitId = tmpUnit.UnitId
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (tmpUnit.UnitId, tmpData.UnitId)
      ;
   ELSE
      RETURN QUERY 
      WITH 
      tmpTaxUnit AS (SELECT Object_TaxUnit.Id           AS Id
                          , Object_Unit.Id              AS UnitId
                          , Object_Unit.ValueData       AS UnitName 
                          , ObjectFloat_Price.ValueData AS Price
                          , ObjectFloat_Value.ValueData AS Value
                          , Object_TaxUnit.isErased     AS isErased
                      FROM Object AS Object_TaxUnit
                          INNER JOIN ObjectLink AS ObjectLink_TaxUnit_Unit
                                               ON ObjectLink_TaxUnit_Unit.ObjectId = Object_TaxUnit.Id
                                              AND ObjectLink_TaxUnit_Unit.DescId = zc_ObjectLink_TaxUnit_Unit()
                                              AND (ObjectLink_TaxUnit_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
                          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_TaxUnit_Unit.ChildObjectId
                          LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                                ON ObjectFloat_Price.ObjectId = Object_TaxUnit.Id
                                               AND ObjectFloat_Price.DescId = zc_ObjectFloat_TaxUnit_Price()
                          LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                                ON ObjectFloat_Value.ObjectId = Object_TaxUnit.Id
                                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_TaxUnit_Value()
                     WHERE Object_TaxUnit.DescId = zc_Object_TaxUnit()
                      AND (Object_TaxUnit.isErased = inisErased OR inisErased = TRUE)
                     )
          
      SELECT DD.Id
           , DD.UnitId
           , DD.UnitName
           , DD.Price
           , (COALESCE ((SELECT MIN (FF.Price) 
                 FROM tmpTaxUnit AS FF 
                 WHERE FF.Price > DD.Price 
                   AND FF.UnitId = DD.UnitId
                   AND FF.isErased = FALSE 
                   AND DD.isErased = FALSE
                   ), 100000)-0.01) :: TFloat  AS PriceLimit
           , DD.Value
           , DD.isErased
      FROM tmpTaxUnit AS DD
      ;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_TaxUnit (0, False, TRUE, '2')  order by 2