-- Function: gpSelect_MovementItem_PromoBonus()

--DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoBonus (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoBonus (Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoBonus(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN isShowPrice   Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MakerId Integer, MakerCode Integer, MakerName TVarChar
             , Amount TFloat, MIPromoId Integer, MovementPromoId Integer
             , GoodsGroupPromoID Integer, GoodsGroupPromoName TVarChar
             , DateUpdate TDateTime, BonusInetOrder TFloat, isLearnWeek Boolean
             , IsTop Boolean, Price TFloat, PercentMarkup TFloat, isSP Boolean
             , MarginPercent TFloat, PriceSale TFloat, PriceBonus TFloat, PriceBonusSite TFloat
             , isErased Boolean)
 AS
$BODY$
    DECLARE vbUserId   Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoBonus());
    vbUserId:= lpGetUserBySession (inSession);

    raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    CREATE TEMP TABLE MI_Master ON COMMIT DROP AS
     SELECT MovementItem.Id                            AS Id
          , MovementItem.ObjectId                      AS GoodsId
          , Object_Goods_Retail.GoodsMainId            AS GoodsMainId
          , Object_Goods.ObjectCode                    AS GoodsCode
          , Object_Goods.Name                          AS GoodsName
          , MovementItem.Amount                        AS Amount
          , MIFloat_MovementItemId.ValueData::Integer  AS MIPromoId
          , MIPromo.MovementId                         AS MovementPromoId
          , MovementLinkObject_Maker.ObjectId          AS MakerId 
          , MIDate_Update.ValueData                    AS DateUpdate
          , MIFloat_BonusInetOrder.ValueData           AS BonusInetOrder
          , Object_Goods_Retail.IsTop
          , Object_Goods_Retail.Price
          , Object_Goods_Retail.PercentMarkup
          , MovementItem.isErased                      AS isErased
     FROM MovementItem


         LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId  
         LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                   

         LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                     ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                    AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                                                                
         LEFT JOIN MovementItemFloat AS MIFloat_BonusInetOrder
                                     ON MIFloat_BonusInetOrder.MovementItemId = MovementItem.Id
                                    AND MIFloat_BonusInetOrder.DescId = zc_MIFloat_BonusInetOrder()

         LEFT JOIN MovementItemDate AS MIDate_Update
                                    ON MIDate_Update.MovementItemId = MovementItem.Id
                                   AND MIDate_Update.DescId = zc_MIDate_Update()

         LEFT JOIN MovementItem AS MIPromo ON MIPromo.ID = MIFloat_MovementItemId.ValueData::Integer

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Maker
                                      ON MovementLinkObject_Maker.MovementId = MIPromo.MovementId
                                     AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()

     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND (MovementItem.isErased = False OR inIsErased = True);
                                   
    ANALYSE MI_Master;

    raise notice 'Value 2: %', CLOCK_TIMESTAMP();

    CREATE TEMP TABLE tmpGoodsSP ON COMMIT DROP AS
    SELECT DISTINCT MovementItem.ObjectId         AS GoodsId
    FROM Movement
         INNER JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId = Movement.Id
                                AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

         INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE

         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                AND MovementItem.DescId     = zc_MI_Master()
                                AND MovementItem.isErased   = FALSE
                               
         -- Розмір відшкодування за упаковку (Соц. проект) - (15)
         INNER JOIN MovementItemFloat AS MIFloat_PriceSP
                                      ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                     AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
                                     AND COALESCE (MIFloat_PriceSP.ValueData, 0) > 0

    WHERE Movement.DescId = zc_Movement_GoodsSP()
      AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete());
                            
    ANALYSE tmpGoodsSP;

    raise notice 'Value 3: %', CLOCK_TIMESTAMP();
                             
    IF isShowPrice = TRUE
    THEN

        -- Результат такой
        RETURN QUERY
        WITH
           tmpcMarginPercent AS (select * from gpSelect_PromoBonus_CalcMarginPercent(inMovementId := inMovementId,  inSession := inSession))


               SELECT MI_Master.Id                                      AS Id
                    , MI_Master.GoodsId                                 AS GoodsId
                    , MI_Master.GoodsCode                               AS GoodsCode
                    , MI_Master.GoodsName                               AS GoodsName
                    , Object_Maker.Id                                   AS MakerId
                    , Object_Maker.ObjectCode                           AS MakerCode
                    , Object_Maker.ValueData                            AS MakerName
                    , MI_Master.Amount                                  AS Amount
                    , MI_Master.MIPromoId                               AS MIPromoId
                    , MI_Master.MovementPromoId                         AS MovementPromoId
                    , Object_GoodsGroupPromo.ID              AS GoodsGroupPromoID
                    , Object_GoodsGroupPromo.ValueData       AS GoodsGroupPromoName
                    , date_trunc('day',MI_Master.DateUpdate)::TDateTime AS DateUpdate
                    , MI_Master.BonusInetOrder                          AS BonusInetOrder
                    , False                                             AS isLearnWeek
                    , MI_Master.IsTop
                    , MI_Master.Price
                    , MI_Master.PercentMarkup
                    , COALESCE (tmpGoodsSP.GoodsId, 0) > 0              AS isSP
                    , tmpcMarginPercent.MarginPercent
                    , tmpcMarginPercent.PriceSale
                    , ROUND(tmpcMarginPercent.PriceSale * 100.0 / (100.0 + tmpcMarginPercent.MarginPercent) * 
                           (100.0 - NULLIF(MI_Master.Amount, 0) + tmpcMarginPercent.MarginPercent) / 100, 2)::TFloat               AS PriceBonus
                    , ROUND(tmpcMarginPercent.PriceSale * 100.0 / (100.0 + tmpcMarginPercent.MarginPercent) *
                           (100.0 - NULLIF(MI_Master.BonusInetOrder, 0) + tmpcMarginPercent.MarginPercent) / 100, 2)::TFloat      AS PriceBonusSite
                    , COALESCE(MI_Master.IsErased, False)               AS isErased
               FROM MI_Master

                   LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = MI_Master.MakerId

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupPromo 
                                        ON ObjectLink_Goods_GoodsGroupPromo.ObjectId = MI_Master.GoodsId 
                                       AND ObjectLink_Goods_GoodsGroupPromo.DescId = zc_ObjectLink_Goods_GoodsGroupPromo()
                   LEFT JOIN Object AS Object_GoodsGroupPromo ON Object_GoodsGroupPromo.Id = ObjectLink_Goods_GoodsGroupPromo.ChildObjectId
                   
                   LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = MI_Master.GoodsMainId
                   
                   LEFT JOIN tmpcMarginPercent ON tmpcMarginPercent.GoodsId = MI_Master.GoodsId 

                   ;
    ELSE
        -- Результат такой
        RETURN QUERY
               SELECT MI_Master.Id                                      AS Id
                    , MI_Master.GoodsId                                 AS GoodsId
                    , MI_Master.GoodsCode                               AS GoodsCode
                    , MI_Master.GoodsName                               AS GoodsName
                    , Object_Maker.Id                                   AS MakerId
                    , Object_Maker.ObjectCode                           AS MakerCode
                    , Object_Maker.ValueData                            AS MakerName
                    , MI_Master.Amount                                  AS Amount
                    , MI_Master.MIPromoId                               AS MIPromoId
                    , MI_Master.MovementPromoId                         AS MovementPromoId
                    , Object_GoodsGroupPromo.ID              AS GoodsGroupPromoID
                    , Object_GoodsGroupPromo.ValueData       AS GoodsGroupPromoName
                    , date_trunc('day',MI_Master.DateUpdate)::TDateTime AS DateUpdate
                    , MI_Master.BonusInetOrder                          AS BonusInetOrder
                    , False                                             AS isLearnWeek
                    , MI_Master.IsTop
                    , MI_Master.Price
                    , MI_Master.PercentMarkup
                    , COALESCE (tmpGoodsSP.GoodsId, 0) > 0              AS isSP
                    , Null::TFloat                                      AS MarginPercent
                    , Null::TFloat                                      AS PriceSale
                    , Null::TFloat                                      AS PriceBonus
                    , Null::TFloat                                      AS PriceBonusSite
                    , COALESCE(MI_Master.IsErased, False)               AS isErased
               FROM MI_Master
                   
                   LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = MI_Master.MakerId

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupPromo 
                                        ON ObjectLink_Goods_GoodsGroupPromo.ObjectId = MI_Master.GoodsId 
                                       AND ObjectLink_Goods_GoodsGroupPromo.DescId = zc_ObjectLink_Goods_GoodsGroupPromo()
                   LEFT JOIN Object AS Object_GoodsGroupPromo ON Object_GoodsGroupPromo.Id = ObjectLink_Goods_GoodsGroupPromo.ChildObjectId
                                      
                   LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = MI_Master.GoodsMainId
                   
                   ;
    
    END IF;
    
    raise notice 'Value 10: %', CLOCK_TIMESTAMP();
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 17.02.21                                                      *
*/
-- 
select * from gpSelect_MovementItem_PromoBonus(inMovementId := 22188745   , inShowAll := 'False' , inIsErased := 'False' , isShowPrice := 'True' ,  inSession := '3');