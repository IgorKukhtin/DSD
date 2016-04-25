--- Function: gpSelect_MovementItem_PromoChild()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoChild (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoChild(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , Comment TVarChar, IsErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

        RETURN QUERY
           SELECT MI_Promo.Id
                , Object_Juridical.Id                   AS JuridicalId
                , Object_Juridical.ObjectCode           AS JuridicalCode
                , Object_Juridical.ValueData            AS JuridicalName
                , MIString_Comment.ValueData ::TVarChar AS Comment
                , MI_Promo.IsErased
           FROM MovementItem AS MI_Promo
               LEFT JOIN MovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MI_Promo.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()
          
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MI_Promo.ObjectId

           WHERE MI_Promo.MovementId = inMovementId
             AND MI_Promo.DescId = zc_MI_Child()
             AND (MI_Promo.isErased = FALSE or inIsErased = TRUE);
  
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 24.04.16         *
*/

--select * from gpSelect_MovementItem_PromoChild(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');