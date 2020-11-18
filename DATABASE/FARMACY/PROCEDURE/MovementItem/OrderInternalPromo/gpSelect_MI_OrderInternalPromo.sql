-- Function: gpSelect_MovementItem_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalPromo (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalPromo(
    IN inMovementId  Integer      , -- ключ Документа
    --IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , AmountManual TFloat
             , Price TFloat, Summ TFloat
             , PriceSIP TFloat, SummSIP TFloat
             , AmountTotal TFloat
             , AmountOut_avg TFloat
             , RemainsDay TFloat
             , RemainsDay2 TFloat
             , MovementId_Promo Integer, InvNumber_Promo_Full TVarChar, MakerName_Promo TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , GoodsGroupPromoId Integer, GoodsGroupPromoName TVarChar
             , MinExpirationDate TDateTime
             , isReport Boolean
             , isChecked Boolean
             , isComplement Boolean
             , AddToM TFloat
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE vbObjectId Integer;
    DECLARE vbDays     TFloat;
    DECLARE vbAreaId   Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternalPromo());
    vbUserId:= lpGetUserBySession (inSession);

    -- поиск <Торговой сети>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- проверяем регион пользователя
    vbAreaId:= (SELECT outAreaId FROM gpGet_Area_byUser (inSession::TVarChar));
    --
    IF COALESCE (vbAreaId, 0) = 0
    THEN
        vbAreaId:= (SELECT AreaId FROM gpGet_User_AreaId (inSession::TVarChar));
    END IF;

     SELECT DATE_PART ( 'day', ((Movement.OperDate - MovementDate_StartSale.ValueData)+ INTERVAL '1 DAY'))
    INTO vbDays
     FROM Movement
        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
     WHERE Movement.Id = inMovementId;

        -- Результат
        RETURN QUERY
        WITH
        tmpPartner AS (SELECT DISTINCT MovementLinkObject_Juridical.ObjectId AS JuridicalId
                       FROM Movement 
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                       ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                       WHERE Movement.DescId = zc_Movement_OrderInternalPromoPartner()
                         AND Movement.ParentId = inMovementId
                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                       )
      , tmpMI_Child AS (SELECT MovementItem.Id
                             , MovementItem.ParentId
                             , COALESCE (MIFloat_AmountManual.ValueData,0) AS AmountManual
                             , COALESCE (MIFloat_Remains.ValueData,0)      AS Remains
                             , COALESCE (MIFloat_AmountOut.ValueData,0)    AS AmountOut
                        FROM MovementItem
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                                         ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                                         ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountOut
                                                         ON MIFloat_AmountOut.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId = zc_MI_Child()
                          AND MovementItem.isErased = FALSE
                        )

      , tmpMI_Master AS (SELECT MovementItem.Id
                              , MovementItem.ObjectId
                              , MovementItem.Amount                                       ::TFloat AS Amount
                              , COALESCE (tmpChild_AmountManual.AmountManual,0)           ::TFloat AS AmountManual
                              , (COALESCE (tmpChild.Remains,0) + COALESCE (MovementItem.Amount,0)) AS AmountTotal
                              , CASE WHEN COALESCE (vbDays, 0) <> 0 THEN (COALESCE (tmpChild.AmountOut,0) / vbDays) ELSE 0 END AS AmountOut_avg
                              , CASE WHEN (COALESCE (tmpChild.AmountOut,0) / vbDays) <> 0 
                                     THEN (COALESCE (tmpChild.Remains,0) + COALESCE (MovementItem.Amount,0) - COALESCE (tmpChild_AmountManual.AmountManual,0)) / (COALESCE (tmpChild.AmountOut,0) / vbDays)
                                     ELSE 0
                                END                             AS RemainsDay
                              , MILinkObject_Juridical.ObjectId AS JuridicalId
                              , MILinkObject_Contract.ObjectId  AS ContractId
                              , MovementItem.IsErased           AS IsErased
                         FROM MovementItem
                              LEFT JOIN (SELECT MovementItem.ParentId
                                              , SUM (COALESCE (MovementItem.Remains,0))      AS Remains
                                              , SUM (COALESCE (MovementItem.AmountOut,0))    AS AmountOut
                                         FROM tmpMI_Child AS MovementItem
                                         WHERE COALESCE (MovementItem.AmountManual,0) = 0
                                         GROUP BY MovementItem.ParentId
                                         ) AS tmpChild ON tmpChild.ParentId = MovementItem.Id

                              LEFT JOIN (SELECT MovementItem.ParentId
                                              , SUM (COALESCE (MovementItem.AmountManual,0)) AS AmountManual
                                         FROM tmpMI_Child AS MovementItem
                                         WHERE COALESCE (MovementItem.AmountManual,0) <> 0
                                         GROUP BY MovementItem.ParentId
                                         ) AS tmpChild_AmountManual ON tmpChild_AmountManual.ParentId = MovementItem.Id

                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical
                                                               ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                               ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId = zc_MI_Master()
                           AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
                        )

      , tmpMI_Child_Calc AS (SELECT tmpMI_Child.*
                                  , CASE WHEN COALESCE (vbDays,0) <> 0 AND COALESCE (tmpMI_Master.RemainsDay,0) <> 0 THEN (((tmpMI_Child.AmountOut / vbDays) * tmpMI_Master.RemainsDay - COALESCE (tmpMI_Child.Remains,0)) / tmpMI_Master.RemainsDay) ELSE 0 END :: TFloat AS Koeff
                             FROM tmpMI_Child
                                  LEFT JOIN tmpMI_Master ON tmpMI_Master.Id = tmpMI_Child.ParentId
                             WHERE COALESCE (tmpMI_Child.AmountManual,0) = 0
                         )

      -- Пересчитывает кол-во дней остатка без аптек с отриц. коэфф.
      , tmpMI_Master2 AS (SELECT MovementItem.Id
                               , (COALESCE (tmpChild.Remains,0) + COALESCE (MovementItem.Amount,0)) AS AmountTotal
                               , CASE WHEN COALESCE (vbDays,0) <> 0 THEN (COALESCE (tmpChild.AmountOut,0) / vbDays) ELSE 0 END AS AmountOut_avg
                               , CASE WHEN (COALESCE (tmpChild.AmountOut,0) / vbDays) <> 0 
                                      THEN (COALESCE (tmpChild.Remains,0) + COALESCE (MovementItem.Amount,0) - COALESCE (MovementItem.AmountManual,0)) / (COALESCE (tmpChild.AmountOut,0) / vbDays)
                                      ELSE 0
                                 END AS RemainsDay
                          FROM tmpMI_Master AS MovementItem
                               LEFT JOIN (SELECT MovementItem.ParentId
                                               , SUM (COALESCE (MovementItem.Remains,0))   AS Remains
                                               , SUM (COALESCE (MovementItem.AmountOut,0)) AS AmountOut
                                          FROM tmpMI_Child_Calc AS MovementItem
                                          WHERE COALESCE (MovementItem.Koeff,0) > 0
                                          GROUP BY MovementItem.ParentId
                                          ) AS tmpChild ON tmpChild.ParentId = MovementItem.Id
                          )

      , tmpMI_Float_Price AS (SELECT MovementItemFloat.*
                              FROM MovementItemFloat
                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                              )

      , tmpMIFloat_PromoMovement AS (SELECT MovementItemFloat.MovementItemId
                                          , MovementItemFloat.ValueData :: Integer
                                     FROM MovementItemFloat
                                     WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                       AND MovementItemFloat.DescId = zc_MIFloat_PromoMovementId()
                                     )

      /*, tmpMILO AS (SELECT MovementItemLinkObject.*
                              FROM MovementItemLinkObject
                              WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Juridical()
                                                                    , zc_MILinkObject_Contract()
                                                                    )
                              )*/

      , tmpMLO_Maker AS (SELECT MovementLinkObject.*
                         FROM MovementLinkObject
                         WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMIFloat_PromoMovement.ValueData FROM tmpMIFloat_PromoMovement)
                           AND MovementLinkObject.DescId = zc_MovementLinkObject_Maker()
                         )

      , tmpMIPromo AS (SELECT tmpMovement.Id                       AS MovementId
                            , MI_Promo.ObjectId                    AS GoodsId
                            , MIFloat_Price.ValueData     ::TFloat AS Price
                       FROM (SELECT DISTINCT tmpMIFloat_PromoMovement.ValueData AS Id
                             FROM tmpMIFloat_PromoMovement
                             ) AS tmpMovement
                          LEFT JOIN MovementItem AS MI_Promo 
                                                 ON MI_Promo.MovementId = tmpMovement.Id
                                                AND MI_Promo.DescId = zc_MI_Master()
                                                AND MI_Promo.isErased = FALSE
                          INNER JOIN (SELECT tmpMI_Master.ObjectId 
                                      FROM tmpMI_Master
                                      ) AS tmpGoods ON tmpGoods.ObjectId = MI_Promo.ObjectId
                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MI_Promo.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                      )

      , tmpMinExpirationDate AS (SELECT tmpMI_Master.Id
                                      , tmpMI_Master.ObjectId
                                      , tmpMI_Master.JuridicalId
                                      , tmpMI_Master.ContractId
                                      , MIN (LoadPriceListItem.ExpirationDate)  AS MinExpirationDate
                                FROM tmpMI_Master
                                     JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = tmpMI_Master.ObjectId 
                                     LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                                                     ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                                                    AND PriceList_GoodsLink.ObjectId = tmpMI_Master.JuridicalId
                                     LEFT JOIN LoadPriceList ON LoadPriceList.JuridicalId = tmpMI_Master.JuridicalId
                                                             AND LoadPriceList.ContractId  = COALESCE (tmpMI_Master.ContractId, 0)
                                                             AND (   (COALESCE (LoadPriceList.AreaId, 0) = vbAreaId AND COALESCE (vbAreaId,0)<>0)
                                                                  OR (COALESCE (vbAreaId,0)=0 AND COALESCE (LoadPriceList.AreaId, 0) = zc_Area_basis())
                                                                  OR COALESCE (LoadPriceList.AreaId, 0) =0
                                                                  )
                                     LEFT JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = LoadPriceList.Id
                                                                AND LoadPriceListItem.GoodsId = Object_LinkGoods_View.GoodsMainId
                                GROUP BY tmpMI_Master.Id
                                       , tmpMI_Master.ObjectId
                                       , tmpMI_Master.JuridicalId
                                       , tmpMI_Master.ContractId
                                )

           ----
           SELECT MovementItem.Id
                , MovementItem.ObjectId                    AS GoodsId
                , Object_Goods.ObjectCode                  AS GoodsCode
                , Object_Goods.ValueData                   AS GoodsName
                , MovementItem.Amount             ::TFloat AS Amount
                , MovementItem.AmountManual       ::TFloat AS AmountManual
                , MIFloat_Price.ValueData         ::TFloat AS Price
                , (COALESCE(MovementItem.Amount,0) * COALESCE(MIFloat_Price.ValueData,0)) ::TFloat AS Summ
                , tmpMIPromo.Price                ::TFloat AS PriceSIP
                , (COALESCE(MovementItem.Amount,0) * COALESCE(tmpMIPromo.Price,0))        ::TFloat AS SummSIP
                
                , MovementItem.AmountTotal   ::TFloat
                , MovementItem.AmountOut_avg ::TFloat
                , MovementItem.RemainsDay    ::TFloat
                , tmpMI_Master2.RemainsDay   ::TFloat AS RemainsDay2

                , Movement_Promo.Id           AS MovementId_Promo
                , ('№ ' || Movement_Promo.InvNumber || ' от ' || Movement_Promo.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Promo_Full
                , Object_Maker.ValueData      AS MakerName_Promo
                
                , Object_Juridical.Id         AS JuridicalId
                , Object_Juridical.ValueData  AS JuridicalName

                , Object_Contract.Id          AS ContractId
                , Object_Contract.ValueData   AS ContractName

                , Object_GoodsGroup.Id              AS GoodsGroupId
                , Object_GoodsGroup.ValueData       AS GoodsGroupName

                , Object_GoodsGroupPromo.Id              AS GoodsGroupPromoId
                , Object_GoodsGroupPromo.ValueData       AS GoodsGroupPromoName
                
                , tmpMinExpirationDate.MinExpirationDate :: TDateTime AS MinExpirationDate

                , CASE WHEN tmpPartner.JuridicalId IS NOT NULL THEN TRUE ELSE FALSE END AS isReport
                , COALESCE (MIBoolean_Checked.ValueData, False)                         AS isChecked
                , COALESCE (MIBoolean_Complement.ValueData, False)                      AS isComplement
                , MIFloat_AddToM.ValueData                                              AS  AddToM

                , MovementItem.IsErased       AS IsErased
           FROM tmpMI_Master AS MovementItem
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId    

              LEFT JOIN tmpMI_Float_Price AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
              LEFT JOIN tmpMI_Float_Price AS MIFloat_AddToM
                                          ON MIFloat_AddToM.MovementItemId = MovementItem.Id
                                         AND MIFloat_AddToM.DescId = zc_MIFloat_AmountAdd()

              LEFT JOIN tmpMIFloat_PromoMovement AS MIFloat_PromoMovement
                                                 ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                --AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
              LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                            ON MIBoolean_Checked.MovementItemId = MovementItem.Id
                                           AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
              LEFT JOIN MovementItemBoolean AS MIBoolean_Complement
                                            ON MIBoolean_Complement.MovementItemId = MovementItem.Id
                                           AND MIBoolean_Complement.DescId = zc_MIBoolean_Complement()

              LEFT JOIN Movement AS Movement_Promo ON Movement_Promo.Id = MIFloat_PromoMovement.ValueData
            
              LEFT JOIN tmpMLO_Maker AS MovementLinkObject_Maker
                                     ON MovementLinkObject_Maker.MovementId = Movement_Promo.Id
                                   -- AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
              LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = MovementLinkObject_Maker.ObjectId

              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.JuridicalId
              LEFT JOIN Object AS Object_Contract  ON Object_Contract.Id  = MovementItem.ContractId

              LEFT JOIN tmpPartner ON tmpPartner.JuridicalId = MovementItem.JuridicalId

              LEFT JOIN tmpMI_Master2 ON tmpMI_Master2.Id = MovementItem.Id

              LEFT JOIN tmpMIPromo ON tmpMIPromo.MovementId = Movement_Promo.Id
                                  AND tmpMIPromo.GoodsId = MovementItem.ObjectId

              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = MovementItem.ObjectId
                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
              LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupPromo 
                                   ON ObjectLink_Goods_GoodsGroupPromo.ObjectId = MovementItem.ObjectId
                                  AND ObjectLink_Goods_GoodsGroupPromo.DescId = zc_ObjectLink_Goods_GoodsGroupPromo()
              LEFT JOIN Object AS Object_GoodsGroupPromo ON Object_GoodsGroupPromo.Id = ObjectLink_Goods_GoodsGroupPromo.ChildObjectId
              
              LEFT JOIN tmpMinExpirationDate ON tmpMinExpirationDate.Id = MovementItem.Id

              ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 13.11.20                                                      *
 04.12.19         *
 09.05.19         * AmountManual
 15.04.19         *
*/

--select * from gpSelect_MovementItem_OrderInternalPromo(inMovementId := 0, inIsErased := 'False' ,  inSession := '3');
--select * from gpSelect_MovementItem_OrderInternalPromoChild(inMovementId := 0, inIsErased := 'False' ,  inSession := '3');

-- select * from gpSelect_MI_OrderInternalPromo(inMovementId := 13840564 , inIsErased := 'False' ,  inSession := '3');
-- select * from gpSelect_MI_OrderInternalPromo(inMovementId := 15291839 , inIsErased := 'False' ,  inSession := '3');
