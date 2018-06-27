-- Function: gpSelect_ScaleCeh_ArticleLoss()

DROP FUNCTION IF EXISTS gpSelect_ScaleCeh_ArticleLoss (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ScaleCeh_ArticleLoss(
    IN inSession          TVarChar      -- сессия пользователя
)
RETURNS TABLE (ArticleLossId   Integer
             , ArticleLossCode Integer
             , ArticleLossName TVarChar
             , isErased        Boolean
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       SELECT Object_ArticleLoss.Id         AS ArticleLossId
            , Object_ArticleLoss.ObjectCode AS ArticleLossCode
            , Object_ArticleLoss.ValueData  AS ArticleLossName
            , Object_ArticleLoss.isErased   AS isErased

       FROM Object AS Object_ArticleLoss
            LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_ProfitLossDirection
                                 ON ObjectLink_ArticleLoss_ProfitLossDirection.ObjectId = Object_ArticleLoss.Id
                                AND ObjectLink_ArticleLoss_ProfitLossDirection.DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()
            LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId
       WHERE Object_ArticleLoss.DescId = zc_Object_ArticleLoss()
         AND Object_ArticleLoss.ObjectCode <> 0
         AND Object_ArticleLoss.isErased = FALSE
         AND View_ProfitLossDirection.ProfitLossDirectionId = zc_Enum_ProfitLossDirection_20100()
       ORDER BY 3
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_ScaleCeh_ArticleLoss (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.06.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ScaleCeh_ArticleLoss (inSession:=zfCalc_UserAdmin())
