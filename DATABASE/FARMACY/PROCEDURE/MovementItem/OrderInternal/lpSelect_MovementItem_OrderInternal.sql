-- Function: lpSelect_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS lpSelect_MovementItem_OrderInternal (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION lpSelect_MovementItem_OrderInternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDateEnd TDateTime;
  DECLARE vbDate180 TDateTime;
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternal());
    vbUserId := inSession;

    --
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    --
    SELECT MovementLinkObject.ObjectId INTO vbUnitId
    FROM MovementLinkObject
    WHERE MovementLinkObject.MovementId = inMovementId
      AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();

    -- определим дату документа
    SELECT date_trunc('day', Movement.OperDate)  INTO vbOperDate
    FROM Movement
    WHERE Movement.Id = inMovementId;
    
    vbOperDateEnd := vbOperDate + INTERVAL '1 DAY';
    vbDate180 := CURRENT_DATE + INTERVAL '180 DAY';
     PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, 0, vbUserId);


     OPEN Cursor1 FOR
     WITH  
    -- Маркетинговый контракт
    GoodsPromo AS (SELECT tmp.JuridicalId
                        , ObjectLink_Child_retail.ChildObjectId AS GoodsId        -- здесь товар "сети"
                        , tmp.MovementId
                        , tmp.ChangePercent
                   FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= vbOperDate) AS tmp   --CURRENT_DATE
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                   AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                    AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                  )
    -- Список цены + ТОП
  , GoodsPrice AS (SELECT Object_Price_View.GoodsId, Object_Price_View.isTOP
                   FROM Object_Price_View
                   WHERE Object_Price_View.UnitId = vbUnitId
                     AND Object_Price_View.isTop  = TRUE
                  )

       -- Результат 1
       SELECT
             tmpMI.Id                   AS Id
           , tmpMI.GoodsId                                           AS GoodsId
           , Object_Goods.GoodsCodeInt                               AS GoodsCode
           , Object_Goods.GoodsName                                  AS GoodsName
           , Object_Goods.MinimumLot                                 AS Multiplicity
           , Object_Goods.GoodsGroupId                               AS GoodsGroupId
           , Object_Goods.GoodsGroupName                             AS GoodsGroupName
           , Object_Goods.NDSKindId                                  AS NDSKindId
           , Object_Goods.NDSKindName                                AS NDSKindName
           , Object_Goods.NDS                                        AS NDS

           , MIBoolean_TOP.ValueData                                 AS isTOP--
           , MIBoolean_UnitTOP.ValueData                             AS isTOP_Price--
           , MIBoolean_Close.ValueData                               AS isClose--
           , MIBoolean_First.ValueData                               AS isFirst--
           , MIBoolean_Second.ValueData                              AS isSecond--

           , CASE WHEN COALESCE (MIBoolean_TOP.ValueData, False) = TRUE
                    OR COALESCE (MIBoolean_UnitTOP.ValueData, False) = TRUE
                  THEN 12615935
                  ELSE 0
             END                                                    AS isTopColor
         --  , COALESCE(tmpMI.Multiplicity, tmpGoods.Multiplicity)    AS Multiplicity --?????????????77777777
           , tmpMI.CalcAmount
           , NULLIF(tmpMI.Amount,0)                                 AS Amount
           , tmpMI.Price * tmpMI.CalcAmount                         AS Summ
           , COALESCE (tmpMI.isErased, FALSE)                       AS isErased
           , tmpMI.Price
           , tmpMI.MinimumLot                                       AS MinimumLot--
           , MIDate_PartionGoods.ValueData                          AS PartionGoodsDate--
           , MIString_Comment.ValueData                             AS Comment--
           , tmpMI.PartnerGoodsCode 
           , tmpMI.PartnerGoodsName
           , tmpMI.JuridicalName 
           , tmpMI.ContractName 
           , MIString_Maker.ValueData                               AS Maker--
           , tmpMI.SuperFinalPrice 
           , COALESCE(MIBoolean_Calculated.ValueData , FALSE)       AS isCalculated--
           , CASE WHEN MIDate_PartionGoods.ValueData < vbDate180 THEN 456
                     ELSE 0
                END                                                 AS PartionGoodsDateColor   
           , MIFloat_Remains.ValueData                              AS RemainsInUnit--
           , MIFloat_MCS.ValueData                                  AS MCS--

           , MIBoolean_MCSIsClose.ValueData                         AS MCSIsClose--
           , MIBoolean_MCSNotRecalc.ValueData                       AS MCSNotRecalc--
           , MIFloat_Income.ValueData                               AS Income_Amount--
           , tmpMI.AmountSecond                                     AS AmountSecond
           , NULLIF(tmpMI.AmountAll,0)                              AS AmountAll
           , NULLIF(COALESCE(tmpMI.AmountManual,tmpMI.CalcAmountAll),0)      AS CalcAmountAll
           , tmpMI.Price * COALESCE(tmpMI.AmountManual,tmpMI.CalcAmountAll)  AS SummAll
           , MIFloat_Check.ValueData                                AS CheckAmount--
           , COALESCE (SelectMinPrice_AllGoods.isOneJuridical, TRUE) :: Boolean AS isOneJuridical
           
           , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN False ELSE True END  ::Boolean AS isPromo
           , COALESCE(MovementPromo.OperDate, Null)  :: TDateTime   AS OperDatePromo
           , COALESCE(MovementPromo.InvNumber, '') ::  TVarChar     AS InvNumberPromo
           
       FROM (SELECT MovementItem.Id
                            , MovementItem.ObjectId                                            AS GoodsId
                            , MovementItem.Amount                                              AS Amount
                            , CEIL(MovementItem.Amount / COALESCE(MIFloat_MinimumLot.ValueData, 1)) 
                                * COALESCE(MIFloat_MinimumLot.ValueData, 1)                    AS CalcAmount
                            , MIFloat_Summ.ValueData                                           AS Summ
                            
                            , MIFloat_MinimumLot.ValueData                                     AS MinimumLot--
                            , COALESCE(PriceList.Price, MinPrice.Price)                        AS Price
                            --, COALESCE(PriceList.PartionGoodsDate, MinPrice.PartionGoodsDate)  AS PartionGoodsDate
                            , COALESCE(PriceList.GoodsCode, MinPrice.GoodsCode)                AS PartnerGoodsCode 
                            , COALESCE(PriceList.GoodsName, MinPrice.GoodsName)                AS PartnerGoodsName
                            , COALESCE(PriceList.JuridicalId, MinPrice.JuridicalId)            AS JuridicalId
                            , COALESCE(PriceList.JuridicalName, MinPrice.JuridicalName)        AS JuridicalName
                            , COALESCE(PriceList.ContractName, MinPrice.ContractName)          AS ContractName
                            , COALESCE(PriceList.SuperFinalPrice, MinPrice.SuperFinalPrice)    AS SuperFinalPrice

                            , MIFloat_AmountSecond.ValueData                                   AS AmountSecond
                            , MovementItem.Amount+COALESCE(MIFloat_AmountSecond.ValueData,0)   AS AmountAll
                            , CEIL((MovementItem.Amount+COALESCE(MIFloat_AmountSecond.ValueData,0)) / COALESCE(MIFloat_MinimumLot.ValueData, 1)) 
                               * COALESCE(MIFloat_MinimumLot.ValueData, 1)                     AS CalcAmountAll
                            , MIFloat_AmountManual.ValueData                                   AS AmountManual
                            , MovementItem.isErased
                               
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                       --
                       LEFT JOIN MovementItemFloat AS MIFloat_MinimumLot                                             
                                        ON MIFloat_MinimumLot.DescId = zc_MIFloat_MinimumLot()
                                       AND MIFloat_MinimumLot.MovementItemId = MovementItem.Id

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical 
                                                        ON MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                                                       AND MILinkObject_Juridical.MovementItemId = MovementItem.Id  
                                                       
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract 
                                                        ON MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                                       AND MILinkObject_Contract.MovementItemId = MovementItem.Id  

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods 
                                                        ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                       AND MILinkObject_Goods.MovementItemId = MovementItem.Id  

                       LEFT JOIN _tmpMI AS PriceList ON COALESCE (PriceList.ContractId, 0) = COALESCE (MILinkObject_Contract.ObjectId, 0)
                                                    AND PriceList.JuridicalId = MILinkObject_Juridical.ObjectId
                                                    AND PriceList.GoodsId = MILinkObject_Goods.ObjectId
                                                    AND PriceList.MovementItemId = MovementItem.Id 

                       LEFT JOIN (SELECT *
                                  FROM (SELECT *, MIN(Id) OVER (PARTITION BY MovementItemId) AS MinId
                                        FROM (SELECT *
                                                   , MIN (SuperFinalPrice) OVER (PARTITION BY MovementItemId) AS MinSuperFinalPrice
                                              FROM _tmpMI
                                             ) AS DDD
                                        WHERE DDD.SuperFinalPrice = DDD.MinSuperFinalPrice
                                       ) AS DDD
                                  WHERE Id = MinId
                                 ) AS MinPrice ON MinPrice.MovementItemId = MovementItem.Id
                            
                       --INNER JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 
                      -- LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = Object_Goods.Id

                       LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                   ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                         ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()  
                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountManual
                                                         ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()  
                      ) AS tmpMI

            --
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods                                           
                                       ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                      AND MIDate_PartionGoods.MovementItemId = tmpMI.Id  
            --
            LEFT JOIN MovementItemFloat AS MIFloat_MCS                                           
                                        ON MIFloat_MCS.DescId = zc_MIFloat_MCS()
                                       AND MIFloat_MCS.MovementItemId = tmpMI.Id  
            --
            LEFT JOIN MovementItemFloat AS MIFloat_Remains                                           
                                        ON MIFloat_Remains.DescId = zc_MIFloat_Remains()
                                       AND MIFloat_Remains.MovementItemId = tmpMI.Id  
            --
            LEFT JOIN MovementItemFloat AS MIFloat_Income                                           
                                        ON MIFloat_Income.DescId = zc_MIFloat_Income()
                                       AND MIFloat_Income.MovementItemId = tmpMI.Id  
            --
            LEFT JOIN MovementItemFloat AS MIFloat_Check                                          
                                        ON MIFloat_Check.DescId = zc_MIFloat_Check()
                                       AND MIFloat_Check.MovementItemId = tmpMI.Id 
            --           
            LEFT JOIN MovementItemString AS MIString_Maker 
                                         ON MIString_Maker.DescId = zc_MIString_Maker()
                                        AND MIString_Maker.MovementItemId = tmpMI.Id  

            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.DescId = zc_MIString_Comment()
                                        AND MIString_Comment.MovementItemId = tmpMI.Id  
            --
            LEFT JOIN MovementItemBoolean AS MIBoolean_Close 
                                          ON MIBoolean_Close.DescId = zc_MIBoolean_Close()
                                         AND MIBoolean_Close.MovementItemId = tmpMI.Id  
            --
            LEFT JOIN MovementItemBoolean AS MIBoolean_First
                                          ON MIBoolean_First.DescId = zc_MIBoolean_First()
                                         AND MIBoolean_First.MovementItemId = tmpMI.Id  
            --
            LEFT JOIN MovementItemBoolean AS MIBoolean_Second
                                          ON MIBoolean_Second.DescId = zc_MIBoolean_Second()
                                         AND MIBoolean_Second.MovementItemId = tmpMI.Id 
            --
            LEFT JOIN MovementItemBoolean AS MIBoolean_TOP
                                          ON MIBoolean_TOP.DescId = zc_MIBoolean_TOP()
                                         AND MIBoolean_TOP.MovementItemId = tmpMI.Id 
            --
            LEFT JOIN MovementItemBoolean AS MIBoolean_UnitTOP
                                          ON MIBoolean_UnitTOP.DescId = zc_MIBoolean_UnitTOP()
                                         AND MIBoolean_UnitTOP.MovementItemId = tmpMI.Id 
            --
            LEFT JOIN MovementItemBoolean AS MIBoolean_MCSNotRecalc
                                          ON MIBoolean_MCSNotRecalc.DescId = zc_MIBoolean_MCSNotRecalc()
                                         AND MIBoolean_MCSNotRecalc.MovementItemId = tmpMI.Id 
            --
            LEFT JOIN MovementItemBoolean AS MIBoolean_MCSIsClose
                                          ON MIBoolean_MCSIsClose.DescId = zc_MIBoolean_MCSIsClose()
                                         AND MIBoolean_MCSIsClose.MovementItemId = tmpMI.Id 

            LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated 
                                          ON MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                         AND MIBoolean_Calculated.MovementItemId = tmpMI.Id  

            LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId 
           
           /* LEFT JOIN Object_Price_View ON COALESCE(tmpMI.GoodsId,tmpGoods.GoodsId) = Object_Price_View.GoodsId
                                       AND Object_Price_View.UnitId = vbUnitId
           */
                    
          --   LEFT JOIN tmpCheck ON tmpCheck.GoodsId = COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)
             LEFT JOIN (SELECT _tmpMI.MovementItemId, CASE WHEN COUNT (*) > 1 THEN FALSE ELSE TRUE END AS isOneJuridical
                        FROM _tmpMI
                        GROUP BY _tmpMI.MovementItemId
                       ) AS SelectMinPrice_AllGoods ON SelectMinPrice_AllGoods.MovementItemId = tmpMI.Id
             LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpMI.JuridicalId
                                 AND GoodsPromo.GoodsId = tmpMI.GoodsId 
             LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = GoodsPromo.MovementId
           ;
     RETURN NEXT Cursor1;

     -- Результат 2
     OPEN Cursor2 FOR
        SELECT  _tmpMI.MovementItemId
              , _tmpMI.GoodsCode
              , _tmpMI.GoodsName
              , _tmpMI.Bonus
              , _tmpMI.Deferment
              , _tmpMI.Percent
              , _tmpMI.SuperFinalPrice
              , Object_Juridical.ValueData     AS JuridicalName
              , MIString_Maker.ValueData       AS MakerName
              , Object_Contract.ValueData      AS ContractName
              , CASE WHEN MIDate_PartionGoods.ValueData < vbDate180 THEN 456
                     ELSE 0
                END                            AS PartionGoodsDateColor      
              , ObjectFloat_Goods_MinimumLot.ValueData           AS MinimumLot
              , MIFloat_Remains.ValueData      AS Remains
              , MIFloat_Price                  AS Price 

        FROM _tmpMI
             LEFT JOIN ObjectFloat AS ObjectFloat_Goods_MinimumLot
                                   ON ObjectFloat_Goods_MinimumLot.ObjectId = _tmpMI.GoodsId 
                                  AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()

            LEFT JOIN MovementItemDate AS MIDate_PartionGoods                                           
                                       ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                      AND MIDate_PartionGoods.MovementItemId = _tmpMI.PriceListMovementItemId

             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                         ON MIFloat_Remains.MovementItemId = _tmpMI.PriceListMovementItemId
                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
             
            LEFT JOIN MovementItemFloat AS MIFloat_Price                                           
                                        ON MIFloat_Price.DescId = zc_MIFloat_Price()
                                       AND MIFloat_Price.MovementItemId = _tmpMI.PriceListMovementItemId

             LEFT JOIN MovementItemString AS MIString_Maker 
                                          ON MIString_Maker.DescId = zc_MIString_Maker()
                                         AND MIString_Maker.MovementItemId = _tmpMI.PriceListMovementItemId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical 
                                              ON MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                                             AND MILinkObject_Juridical.MovementItemId = _tmpMI.PriceListMovementItemId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILinkObject_Juridical.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract 
                                              ON MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                             AND MILinkObject_Contract.MovementItemId = _tmpMI.PriceListMovementItemId
             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId
            ;

   RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.07.16         *
*/

-- тест
-- SELECT * FROM lpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM lpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '2')
