-- Function: gpSelect_MovementItem_PromoGoods_Mobile()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoGoods_Mobile (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoGoods_Mobile (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoGoods_Mobile(
    IN inMovementId Integer  , --
    IN inMemberId   Integer  , -- 
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id              Integer -- Уникальный идентификатор, формируется в Главной БД, и используется при синхронизации
             , MovementId      Integer -- Уникальный идентификатор документа
             , GoodsId         Integer -- Товар
             , GoodsCode       Integer -- Товар
             , GoodsName       TVarChar -- Товар
             , GoodsKindId     Integer -- Вид товара
             , GoodsKindName   TVarChar-- Вид товара
             , MeasureId       Integer -- 
             , MeasureName     TVarChar--
             , TradeMarkName   TVarChar--
             , PriceWithOutVAT TFloat  -- Акционная цена без учета НДС
             , PriceWithVAT    TFloat  -- Акционная цена с учетом НДС
             , TaxPromo        TFloat  -- % скидки по акции, информативно - какая скидка применялась для расчета Акционной цены, *важно - используется только для просмотра*
             , isSync          Boolean   
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbMemberId Integer;
   DECLARE calcSession TVarChar;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbMemberId:= (SELECT tmp.MemberId FROM gpGetMobile_Object_Const (inSession) AS tmp);
      IF (COALESCE(inMemberId,0) <> 0 AND COALESCE(vbMemberId,0) <> inMemberId)
        THEN
            RAISE EXCEPTION 'Ошибка.Не достаточно прав доступа.'; 
      END IF;

      calcSession := (SELECT CAST (ObjectLink_User_Member.ObjectId AS TVarChar) 
                      FROM ObjectLink AS ObjectLink_User_Member
                      WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                        AND ObjectLink_User_Member.ChildObjectId = inMemberId);

      RETURN QUERY
       SELECT tmpMI.Id
            , tmpMI.MovementId
            , tmpMI.GoodsId
            , Object_Goods.ObjectCode    AS GoodsCode
            , Object_Goods.ValueData     AS GoodsName
            , tmpMI.GoodsKindId
            , Object_GoodsKind.ValueData AS GoodsKindName

            , Object_Measure.Id          AS MeasureId  
            , Object_Measure.ValueData   AS MeasureName
            , Object_TradeMark.ValueData AS TradeMarkName

            , tmpMI.PriceWithOutVAT
            , tmpMI.PriceWithVAT
            , tmpMI.TaxPromo
            , tmpMI.isSync
       FROM gpSelectMobile_MovementItem_PromoGoods (zc_DateStart(), calcSession) AS tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

       WHERE tmpMI.MovementId = inMovementId
         AND tmpMI.isSync = TRUE
 ;
            
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.   Ярошенко Р.Ф.
 13.06.17         * add inMemberId
 29.03.17         *
*/

-- SELECT * FROM gpSelect_MovementItem_PromoGoods_Mobile (inSyncDateIn:= zc_DateStart(), inSession:= zfCalc_UserAdmin())
