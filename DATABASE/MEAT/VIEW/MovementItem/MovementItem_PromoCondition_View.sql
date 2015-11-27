--

DROP VIEW IF EXISTS MovementItem_PromoCondition_View;

CREATE OR REPLACE VIEW MovementItem_PromoCondition_View AS
    SELECT
        MovementItem.Id                    AS Id                  -- Идентификатор
      , MovementItem.MovementId            AS MovementId          -- Код документа <Акция>
      , MovementItem.ObjectId              AS ConditionPromoId    -- ИД объекта <Условие участия в акции>
      , Object_ConditionPromo.ObjectCode   AS ConditionPromoCode  -- Код объекта <Условие участия в акции>
      , Object_ConditionPromo.ValueData    AS ConditionPromoName  -- Наименование объекта <Условие участия в акции>
      , MovementItem.Amount                AS Amount              -- Значение (% скидки / % компенсации)
      , MIString_Comment.ValueData         AS Comment             -- Примечание
      , MovementItem.isErased              AS isErased            -- Удален
    FROM  MovementItem
        LEFT JOIN Object AS Object_ConditionPromo
                         ON Object_ConditionPromo.Id = MovementItem.ObjectId
        LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                           ON MIString_Comment.MovementItemId = MovementItem.ID
                                          AND MIString_Comment.DescId = zc_MIString_Comment()
        
    WHERE MovementItem.DescId = zc_MI_Child();


ALTER TABLE MovementItem_PromoCondition_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 02.11.15                                                         *
*/

-- тест
-- SELECT * FROM MovementItem_PromoCondition_View WHERE MovementId = 2641111
