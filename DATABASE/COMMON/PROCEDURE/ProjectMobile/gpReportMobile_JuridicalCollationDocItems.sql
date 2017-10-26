-- Function: gpReportMobile_JuridicalCollationDocItems

DROP FUNCTION IF EXISTS gpReportMobile_JuridicalCollationDocItems (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReportMobile_JuridicalCollationDocItems (
    IN inMovementId Integer  , -- ИД документа
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (MovementId     Integer
             , MovementItemId Integer
             , GoodsId        Integer
             , GoodsCode      Integer
             , GoodsName      TVarChar
             , GoodsKindId    Integer
             , GoodsKindName  TVarChar
             , Price          TFloat
             , Amount         TFloat
             , isPromo        Boolean
              )
AS $BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- Результат
      RETURN QUERY
        SELECT MovementItem.MovementId
             , MovementItem.Id                 AS MovementItemId
             , MovementItem.ObjectId           AS GoodsId
             , Object_Goods.ObjectCode         AS GoodsCode
             , Object_Goods.ValueData          AS GoodsName
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
             , COALESCE (Object_GoodsKind.ValueData, '')::TVarChar AS GoodsKindName
             , MIFloat_Price.ValueData         AS Price
             , MovementItem.Amount
             , (MIFloat_PromoMovementId.ValueData IS NOT NULL)::Boolean AS isPromo
        FROM Movement
             JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
             LEFT JOIN Object AS Object_Goods
                              ON Object_Goods.Id = MovementItem.ObjectId
                             AND Object_Goods.DescId = zc_Object_Goods() 
             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind
                              ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
                             AND Object_GoodsKind.DescId = zc_Object_GoodsKind()
             LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                         ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                        AND MIFloat_PromoMovementId.DescId = zc_MIFloat_PromoMovementId()                 
        WHERE Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_Sale())
          AND Movement.Id = inMovementId;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.   Ярошенко Р.Ф.
 04.09.17                                                                         *
*/

-- тест
-- SELECT * FROM gpReportMobile_JuridicalCollationDocItems (inMovementId:= 5280790, inSession:= zfCalc_UserAdmin());
-- пример с акционными позициями
-- SELECT * FROM gpReportMobile_JuridicalCollationDocItems (inMovementId:= 5280745, inSession:= zfCalc_UserAdmin());
