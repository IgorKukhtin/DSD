-- Function: gpSelect_MovementItem_PriceSubgroups()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PriceSubgroups (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PriceSubgroups(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Price TFloat
             , isErased Boolean
              )
AS              
$BODY$
    DECLARE vbUserId   Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
     WITH tmpPriceSubgroups AS (SELECT MovementItem.Id                AS Id 
                                     , MovementItem.Amount            AS Price
                                     , ROW_NUMBER() OVER (ORDER BY MovementItem.Amount)::Integer AS Ord
                                FROM MovementItem
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId = zc_MI_Second()
                                  AND MovementItem.isErased = False)
                                      
     SELECT
           MovementItem.Id                      AS Id
         , tmpPriceSubgroups.Ord              AS Code
         , CASE WHEN COALESCE (tmpPriceSubgroups.Ord, 0) = 0
                THEN NULL
                WHEN COALESCE (tmpPriceSubgroups.Ord, 0) = 1
                THEN '0-'||zfConvert_FloatToString (MovementItem.Amount)
                WHEN COALESCE (tmpPriceSubgroups.Ord, 0) > 1
                THEN zfConvert_FloatToString (tmpPriceSubgroupsPrew.Price)||'-'||zfConvert_FloatToString (MovementItem.Amount)
                END::TVarChar                   AS Name
         , MovementItem.Amount                  AS Price
         , MovementItem.isErased                AS isErased
     FROM MovementItem 
     
          LEFT JOIN tmpPriceSubgroups ON tmpPriceSubgroups.Id = MovementItem.Id

          LEFT JOIN tmpPriceSubgroups AS tmpPriceSubgroupsPrew
                                     ON tmpPriceSubgroupsPrew.Ord = tmpPriceSubgroups.Ord - 1
          
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Second()
       AND (MovementItem.isErased = False OR inIsErased = TRUE)
     UNION ALL
     SELECT
           MovementItem.Id                      AS Id
         , (MovementItem.Ord + 1)::Integer      AS Code
         , zfConvert_FloatToString (MovementItem.Price) AS Name
         , MovementItem.Price                   AS Price
         , False                                AS isErased
     FROM tmpPriceSubgroups AS MovementItem
               
     WHERE MovementItem.Ord = (SELECT MAX(tmpPriceSubgroups.Ord) FROM tmpPriceSubgroups)
     ORDER BY 4
          ;

     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.05.22                                                        *
*/
-- 

select * from gpSelect_MovementItem_PriceSubgroups(inMovementId := 27717912 , inIsErased := 'False' ,  inSession := '3');