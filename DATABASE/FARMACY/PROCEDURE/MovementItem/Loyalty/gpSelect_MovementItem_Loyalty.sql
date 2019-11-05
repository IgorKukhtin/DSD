-- Function: gpSelect_MovementItem_Loyalty()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Loyalty (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Loyalty(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id         Integer
             , Amount      TFloat
             , Count      Integer
             , isErased   Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- поиск <Торговой сети>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- Результат
    RETURN QUERY

       SELECT MI_Loyalty.Id
            , MI_Loyalty.Amount 
            , MIFloat_Count.ValueData::Integer  AS Count
            , MI_Loyalty.IsErased
       FROM MovementItem AS MI_Loyalty
   
            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MI_Loyalty.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()                                    

       WHERE MI_Loyalty.MovementId = inMovementId
         AND MI_Loyalty.DescId = zc_MI_Master()
         AND (MI_Loyalty.isErased = FALSE or inIsErased = TRUE)
       ORDER BY Amount;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.11.19                                                       *
*/

-- select * from gpSelect_MovementItem_Loyalty(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3'::TVarChar);