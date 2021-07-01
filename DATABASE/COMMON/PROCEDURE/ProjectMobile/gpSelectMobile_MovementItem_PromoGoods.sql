-- Function: gpSelectMobile_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS gpSelectMobile_MovementItem_PromoGoods (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_MovementItem_PromoGoods(
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id              Integer -- Уникальный идентификатор, формируется в Главной БД, и используется при синхронизации
             , MovementId      Integer -- Уникальный идентификатор документа
             , GoodsId         Integer -- Товар
             , GoodsKindId     Integer -- Вид товара
             , PriceWithOutVAT TFloat  -- Акционная цена без учета НДС
             , PriceWithVAT    TFloat  -- Акционная цена с учетом НДС
             , TaxPromo        TFloat  -- % скидки по акции, информативно - какая скидка применялась для расчета Акционной цены, *важно - используется только для просмотра*
             , isSync          Boolean   
             , Ord Integer
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      IF vbPersonalId IS NOT NULL 
      THEN
           RETURN QUERY
             WITH tmpPromoPartner AS (SELECT Movement_Promo.Id AS PromoId
                                           , ROW_NUMBER() OVER (PARTITION BY MI_PromoPartner.ObjectId, MovementItem_PromoGoods.ObjectId ORDER BY Movement_Promo.Operdate DESC, Movement_PromoPartner.ParentId DESC) AS RowNum
                                      FROM Movement AS Movement_PromoPartner
                                           JOIN MovementItem AS MI_PromoPartner
                                                             ON MI_PromoPartner.MovementId = Movement_PromoPartner.Id
                                                            AND MI_PromoPartner.DescId = zc_MI_Master()
                                                            AND MI_PromoPartner.IsErased = FALSE
                                           JOIN lfSelectMobile_Object_Partner (inIsErased:= FALSE, inSession:= inSession) AS OP ON OP.Id = MI_PromoPartner.ObjectId
                                           JOIN Movement AS Movement_Promo 
                                                         ON Movement_Promo.Id = Movement_PromoPartner.ParentId
                                                        AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                                           JOIN MovementDate AS MovementDate_StartSale
                                                             ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                                            AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                                            AND MovementDate_StartSale.ValueData <= CURRENT_DATE + INTERVAL '10 DAY'
                                           JOIN MovementDate AS MovementDate_EndSale
                                                             ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                                            AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                                                            AND MovementDate_EndSale.ValueData >= CURRENT_DATE   - INTERVAL '10 DAY'
                                           JOIN MovementItem AS MovementItem_PromoGoods 
                                                             ON MovementItem_PromoGoods.MovementId = Movement_Promo.Id
                                                            AND MovementItem_PromoGoods.DescId     = zc_MI_Master()
                                                            AND MovementItem_PromoGoods.IsErased   = FALSE
                                      WHERE Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                                        AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                                        --
                                        AND CASE WHEN OP.isOperDateOrder = TRUE
                                                      THEN MovementDate_StartSale.ValueData
                                                         - (COALESCE (OP.PrepareDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                 ELSE MovementDate_StartSale.ValueData
                                                    - (COALESCE (OP.PrepareDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                    - (COALESCE (OP.DocumentDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                            END <= CURRENT_DATE
                                        AND CASE WHEN OP.isOperDateOrder = TRUE
                                                      THEN MovementDate_EndSale.ValueData
                                                         - (COALESCE (OP.PrepareDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                 ELSE MovementDate_EndSale.ValueData
                                                    - (COALESCE (OP.PrepareDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                    - (COALESCE (OP.DocumentDayCount, 0) :: TVarChar || ' DAY') :: INTERVAL
                                            END >= CURRENT_DATE
                                     )
                , tmpPromo AS (SELECT DISTINCT tmpPromoPartner.PromoId AS Id 
                               FROM tmpPromoPartner 
                               WHERE tmpPromoPartner.RowNum = 1
                              )
             SELECT *
             FROM
            (SELECT MovementItem_PromoGoods.Id AS Id
                  , MovementItem_PromoGoods.MovementId
                  , MovementItem_PromoGoods.ObjectId                          AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)::Integer    AS GoodsKindId
                  , COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0.0)::TFloat AS PriceWithOutVAT
                  , COALESCE (MIFloat_PriceWithVAT.ValueData, 0.0)::TFloat    AS PriceWithVAT
                  , COALESCE (MovementItem_PromoGoods.Amount, 0.0)::TFloat    AS TaxPromo
                  , TRUE                                                      AS isSync
                    --  № п/п
                  , ROW_NUMBER() OVER (PARTITION BY MovementItem_PromoGoods.ObjectId, MovementItem_PromoGoods.MovementId ORDER BY COALESCE (MovementItem_PromoGoods.Amount, 0) DESC) :: Integer AS Ord
             FROM tmpPromo
                  JOIN MovementItem AS MovementItem_PromoGoods 
                                    ON MovementItem_PromoGoods.MovementId = tmpPromo.Id
                                   AND MovementItem_PromoGoods.DescId = zc_MI_Master()
                                   AND MovementItem_PromoGoods.IsErased = FALSE
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem_PromoGoods.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
                  LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                              ON MIFloat_PriceWithOutVAT.MovementItemId = MovementItem_PromoGoods.Id
                                             AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT() 
                  LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                              ON MIFloat_PriceWithVAT.MovementItemId = MovementItem_PromoGoods.Id
                                             AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT() 
            ) AS tmp
             WHERE tmp.Ord = 1
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
            ;
            
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.   Ярошенко Р.Ф.
 29.05.17                                                                          *
 17.03.17                                                                          *
*/

-- SELECT * FROM gpSelectMobile_MovementItem_PromoGoods (inSyncDateIn:= zc_DateStart(), inSession:= zfCalc_UserAdmin())
