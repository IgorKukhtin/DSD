-- Function: gpSelect_MovementItem_PromoCondition()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoCondition (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoCondition(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
        Id                 Integer  --идентификатор
      , MovementId         Integer  --ИД документа <Акция>
      , ConditionPromoId   Integer  --ИД объекта <Условие участия в акции>
      , ConditionPromoCode Integer  --код объекта  <Условие участия в акции>
      , ConditionPromoName TVarChar --наименование объекта <Условие участия в акции>
      , Amount             TFloat   --Значение
      , Comment            TVarChar --Комментарий
      , isErased           Boolean  --удален
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoCondition());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
        SELECT
            MI_PromoCondition.Id                 --идентификатор
          , MI_PromoCondition.MovementId         --ИД документа <Акция>
          , MI_PromoCondition.ConditionPromoId   --ИД объекта <товар>
          , MI_PromoCondition.ConditionPromoCode --код объекта  <товар>
          , MI_PromoCondition.ConditionPromoName --наименование объекта <товар>
          , MI_PromoCondition.Amount             --% скидки на товар
          , MI_PromoCondition.Comment            --Комментарий
          , MI_PromoCondition.isErased           --удален
        FROM
            MovementItem_PromoCondition_View AS MI_PromoCondition
        WHERE
            MI_PromoCondition.MovementId = inMovementId
            AND
            (
                MI_PromoCondition.isErased = FALSE
                OR
                inIsErased = TRUE
            );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PromoCondition (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 25.11.15                                                          * Comment
 05.11.15                                                          *
*/