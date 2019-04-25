-- Function: gpSelect_Object_RetailCostCredit()

DROP FUNCTION IF EXISTS gpSelect_Object_RetailCostCredit(Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RetailCostCredit(
    IN inRetailId          Integer ,
    IN inShowAll         Boolean ,
    IN inisErased        Boolean ,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , RetailId Integer, RetailName TVarChar
             , MinPrice TFloat, PriceLimit TFloat
             , Percent TFloat
             , isErased boolean) AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_RetailCostCredit());
   vbUserId:= inSession;

   -- определяется <Торговая сеть>
   vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

   IF inShowAll THEN
      RETURN QUERY 
      WITH 
      tmpRetailCostCredit AS (SELECT Object_RetailCostCredit.Id           AS Id
                          , ObjectLink_RetailCostCredit_Retail.ChildObjectId AS RetailId
                          , ObjectFloat_MinPrice.ValueData AS MinPrice
                          , ObjectFloat_Percent.ValueData AS Percent
                          , Object_RetailCostCredit.isErased     AS isErased
                      FROM Object AS Object_RetailCostCredit
                          INNER JOIN ObjectLink AS ObjectLink_RetailCostCredit_Retail
                                               ON ObjectLink_RetailCostCredit_Retail.ObjectId = Object_RetailCostCredit.Id
                                              AND ObjectLink_RetailCostCredit_Retail.DescId = zc_ObjectLink_RetailCostCredit_Retail()
                                              AND (ObjectLink_RetailCostCredit_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                          
                          LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                                ON ObjectFloat_MinPrice.ObjectId = Object_RetailCostCredit.Id
                                               AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_RetailCostCredit_MinPrice()
                          LEFT JOIN ObjectFloat AS ObjectFloat_Percent 
                                                ON ObjectFloat_Percent.ObjectId = Object_RetailCostCredit.Id
                                               AND ObjectFloat_Percent.DescId = zc_ObjectFloat_RetailCostCredit_Percent()
                     WHERE Object_RetailCostCredit.DescId = zc_Object_RetailCostCredit()
                      AND (Object_RetailCostCredit.isErased = inisErased OR inisErased = TRUE)
                     )

    , tmpRetail  AS  (SELECT ObjectLink_Retail_Juridical.ObjectId AS RetailId
                    FROM ObjectLink AS ObjectLink_Retail_Juridical
                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Retail_Juridical.ChildObjectId
                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                           AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                    WHERE ObjectLink_Retail_Juridical.DescId = zc_ObjectLink_Retail_Juridical()
                      AND (ObjectLink_Retail_Juridical.ObjectId = inRetailId OR inRetailId = 0)
                    )
          
    , tmpData AS (SELECT DD.Id
                       , DD.RetailId
                       , DD.MinPrice
                       , (COALESCE ((SELECT MIN (FF.MinPrice) 
                             FROM tmpRetailCostCredit AS FF 
                             WHERE FF.MinPrice > DD.MinPrice 
                               AND FF.RetailId = DD.RetailId
                               AND FF.isErased = FALSE 
                               AND DD.isErased = FALSE
                               ), 100000)-0.01) :: TFloat  AS PriceLimit
                       , DD.Percent
                       , DD.isErased
                  FROM tmpRetailCostCredit AS DD
                  )
      -- результат
      SELECT COALESCE (tmpData.Id, 0)    AS Id
           , Object_Retail.Id              AS RetailId
           , Object_Retail.ValueData       AS RetailName
           , COALESCE (tmpData.MinPrice, 0)      :: TFloat AS MinPrice
           , COALESCE (tmpData.PriceLimit, 0) :: TFloat AS PriceLimit
           , COALESCE (tmpData.Percent, 0)      :: TFloat AS Percent
           , CASE WHEN COALESCE (tmpData.isErased, FALSE) = TRUE OR Object_Retail.isErased = TRUE THEN TRUE ELSE FALSE END :: Boolean AS isErased
      FROM tmpRetail
           FULL JOIN tmpData ON tmpData.RetailId = tmpRetail.RetailId
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = COALESCE (tmpRetail.RetailId, tmpData.RetailId)
      ;
   ELSE
      RETURN QUERY 
      WITH 
      tmpRetailCostCredit AS (SELECT Object_RetailCostCredit.Id           AS Id
                          , Object_Retail.Id              AS RetailId
                          , Object_Retail.ValueData       AS RetailName 
                          , ObjectFloat_MinPrice.ValueData AS MinPrice
                          , ObjectFloat_Percent.ValueData AS Percent
                          , Object_RetailCostCredit.isErased     AS isErased
                      FROM Object AS Object_RetailCostCredit
                          INNER JOIN ObjectLink AS ObjectLink_RetailCostCredit_Retail
                                               ON ObjectLink_RetailCostCredit_Retail.ObjectId = Object_RetailCostCredit.Id
                                              AND ObjectLink_RetailCostCredit_Retail.DescId = zc_ObjectLink_RetailCostCredit_Retail()
                                              AND (ObjectLink_RetailCostCredit_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_RetailCostCredit_Retail.ChildObjectId
                          LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                                ON ObjectFloat_MinPrice.ObjectId = Object_RetailCostCredit.Id
                                               AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_RetailCostCredit_MinPrice()
                          LEFT JOIN ObjectFloat AS ObjectFloat_Percent 
                                                ON ObjectFloat_Percent.ObjectId = Object_RetailCostCredit.Id
                                               AND ObjectFloat_Percent.DescId = zc_ObjectFloat_RetailCostCredit_Percent()
                     WHERE Object_RetailCostCredit.DescId = zc_Object_RetailCostCredit()
                      AND (Object_RetailCostCredit.isErased = inisErased OR inisErased = TRUE)
                     )
          
      SELECT DD.Id
           , DD.RetailId
           , DD.RetailName
           , DD.MinPrice
           , (COALESCE ((SELECT MIN (FF.MinPrice) 
                 FROM tmpRetailCostCredit AS FF 
                 WHERE FF.MinPrice > DD.MinPrice 
                   AND FF.RetailId = DD.RetailId
                   AND FF.isErased = FALSE 
                   AND DD.isErased = FALSE
                   ), 100000)-0.01) :: TFloat  AS PriceLimit
           , DD.Percent
           , DD.isErased
      FROM tmpRetailCostCredit AS DD
      ;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.04.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_RetailCostCredit (0, False, TRUE, '2')  order by 2