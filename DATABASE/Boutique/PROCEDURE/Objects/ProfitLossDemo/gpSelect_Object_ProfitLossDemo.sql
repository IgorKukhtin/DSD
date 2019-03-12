-- Function: gpSelect_Object_ProfitLossDemo(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ProfitLossDemo (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProfitLossDemo(
    IN inIsShowAll   Boolean  ,     --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer,
               ProfitLossId Integer, ProfitLossCode Integer, ProfitLossName TVarChar, 
               UnitId Integer, UnitCode Integer, UnitName TVarChar,
               Value TFloat, 
               isErased Boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProfitLossDemo());
   
     RETURN QUERY 
     WITH
     tmpProfitLossDemo AS (SELECT Object_ProfitLossDemo.Id                        AS Id
                                , ObjectLink_ProfitLoss_ProfitLoss.ChildObjectId  AS ProfitLossId
                                , ObjectLink_ProfitLoss_Unit.ChildObjectId        AS UnitId
                                , ObjectFloat_Value.ValueData                     AS Value
                                , Object_ProfitLossDemo.isErased                  AS isErased

                           FROM Object AS Object_ProfitLossDemo
                                LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLoss
                                       ON ObjectLink_ProfitLoss_ProfitLoss.ObjectId = Object_ProfitLossDemo.Id
                                      AND ObjectLink_ProfitLoss_ProfitLoss.DescId   = zc_ObjectLink_ProfitLossDemo_ProfitLoss()

                                LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_Unit
                                       ON ObjectLink_ProfitLoss_Unit.ObjectId = Object_ProfitLossDemo.Id
                                      AND ObjectLink_ProfitLoss_Unit.DescId   = zc_ObjectLink_ProfitLossDemo_Unit()

                                LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                        ON ObjectFloat_Value.ObjectId = Object_ProfitLossDemo.Id 
                                                       AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ProfitLossDemo_Value()

                           WHERE Object_ProfitLossDemo.DescId = zc_Object_ProfitLossDemo()
                           )
   , tmpUnion AS (SELECT Object_ProfitLoss.Id  AS ProfitLossId
                       , Object_Unit.Id        AS UnitId
                  FROM Object AS Object_ProfitLoss 
                       FULL JOIN Object AS Object_Unit 
                                        ON 1=1
                                       AND Object_Unit.DescId = zc_Object_Unit()
                                       AND Object_Unit.isErased = FALSE
                  WHERE Object_ProfitLoss.DescId = zc_Object_ProfitLoss()
                    AND Object_ProfitLoss.isErased = FALSE
                    AND inIsShowAll = TRUE
                 )

        SELECT COALESCE (Object_ProfitLossDemo.Id, 0)         AS Id
           
             , Object_ProfitLoss.Id            AS ProfitLossId
             , Object_ProfitLoss.ObjectCode    AS ProfitLossCode
             , Object_ProfitLoss.ValueData     AS ProfitLossName
             
             , Object_Unit.Id                  AS UnitId
             , Object_Unit.ObjectCode          AS UnitCode
             , Object_Unit.ValueData           AS UnitName
  
             , COALESCE (Object_ProfitLossDemo.Value, 0) :: TFloat AS Value
             , COALESCE (Object_ProfitLossDemo.isErased, FALSE)    AS isErased
           
        FROM tmpProfitLossDemo AS Object_ProfitLossDemo
            FULL JOIN tmpUnion ON tmpUnion.ProfitLossId = Object_ProfitLossDemo.ProfitLossId
                              AND tmpUnion.UnitId       = Object_ProfitLossDemo.UnitId
                              
            LEFT JOIN Object AS Object_ProfitLoss ON Object_ProfitLoss.Id = COALESCE (tmpUnion.ProfitLossId, Object_ProfitLossDemo.ProfitLossId)

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (tmpUnion.UnitId, Object_ProfitLossDemo.UnitId)
        ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.06.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProfitLossDemo(true,'2')
-- SELECT * FROM gpSelect_Object_ProfitLossDemo(false,'2')
