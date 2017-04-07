-- Function: gpSelect_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDateEnd TDateTime;
  DECLARE vbisDocument Boolean;
  DECLARE vbDate180 TDateTime;
  
  DECLARE vbMainJuridicalId Integer;    
    
  DECLARE vbCURRENT_DOW Integer;

  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternal());
    vbUserId := inSession;

    vbCURRENT_DOW := CASE WHEN EXTRACT (DOW FROM CURRENT_DATE) = 0 THEN 7 ELSE EXTRACT (DOW FROM CURRENT_DATE) END ; -- день недели сегодня
   
    --
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    SELECT COALESCE(MB_Document.ValueData, False) :: Boolean AS isDocument 
         , Movement.StatusId
   INTO vbisDocument, vbStatusId
    FROM Movement
        LEFT JOIN MovementBoolean AS MB_Document
               ON MB_Document.MovementId = Movement.Id
              AND MB_Document.DescId = zc_MovementBoolean_Document()
    WHERE Movement.Id =inMovementId;

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
     
   
    -- !!!Только для таких документов!!!
    IF vbisDocument = TRUE AND vbStatusId = zc_Enum_Status_Complete() -- AND inSession <> '3'
    THEN

     PERFORM lpCreateTempTable_OrderInternal_MI(inMovementId, vbObjectId, 0, vbUserId);

     SELECT Object_Unit_View.JuridicalId
            INTO vbMainJuridicalId
         FROM Object_Unit_View 
               JOIN  MovementLinkObject ON MovementLinkObject.ObjectId = Object_Unit_View.Id 
                AND  MovementLinkObject.MovementId = inMovementId 
                AND  MovementLinkObject.DescId = zc_MovementLinkObject_Unit();
             
    
     OPEN Cursor1 FOR
          WITH  
     --Данные Справочника График заказа/доставки
          tmpDateList AS (SELECT ''||tmp.OperDate :: Date || ' (' ||tmpDayOfWeek.DayOfWeekName ||')' AS OperDate
                               , tmpDayOfWeek.Number
                               , tmpDayOfWeek.DayOfWeekName
                          FROM (SELECT generate_series ( CURRENT_DATE,  CURRENT_DATE+interval '6 day', '1 day' :: INTERVAL) AS OperDate) AS tmp
                            LEFT JOIN zfCalc_DayOfWeekName(tmp.OperDate) AS tmpDayOfWeek ON 1=1
                          )
      , tmpOrderShedule AS (SELECT ObjectLink_OrderShedule_Contract.ChildObjectId          AS ContractId --
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 1) ::TFloat AS Value1
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 2) ::TFloat AS Value2
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 3) ::TFloat AS Value3
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 4) ::TFloat AS Value4
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 5) ::TFloat AS Value5
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 6) ::TFloat AS Value6
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 7) ::TFloat AS Value7
                            FROM Object AS Object_OrderShedule
                                 INNER JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                                         ON ObjectLink_OrderShedule_Unit.ObjectId = Object_OrderShedule.Id
                                        AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
                                        AND ObjectLink_OrderShedule_Unit.ChildObjectId = vbUnitId
                                 LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Contract
                                        ON ObjectLink_OrderShedule_Contract.ObjectId = Object_OrderShedule.Id
                                       AND ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
                            WHERE Object_OrderShedule.DescId = zc_Object_OrderShedule()
                              AND Object_OrderShedule.isErased = FALSE
                           )
, tmpOrderSheduleList AS (SELECT tmp.*
                          FROM (
                                select tmpOrderShedule.ContractId, CASE WHEN Value1 in (1,3) THEN 1 ELSE 0 END AS DoW, CASE WHEN Value1 in (2,3) THEN 1 ELSE 0 END AS DoW_D from tmpOrderShedule
                                union select tmpOrderShedule.ContractId, CASE WHEN Value2 in (1,3) THEN 2 ELSE 0 END AS DoW, CASE WHEN Value2 in (2,3) THEN 2 ELSE 0 END AS DoW_D from tmpOrderShedule
                                union select tmpOrderShedule.ContractId, CASE WHEN Value3 in (1,3) THEN 3 ELSE 0 END AS DoW, CASE WHEN Value3 in (2,3) THEN 3 ELSE 0 END AS DoW_D from tmpOrderShedule
                                union select tmpOrderShedule.ContractId, CASE WHEN Value4 in (1,3) THEN 4 ELSE 0 END AS DoW, CASE WHEN Value4 in (2,3) THEN 4 ELSE 0 END AS DoW_D from tmpOrderShedule
                                union select tmpOrderShedule.ContractId, CASE WHEN Value5 in (1,3) THEN 5 ELSE 0 END AS DoW, CASE WHEN Value5 in (2,3) THEN 5 ELSE 0 END AS DoW_D from tmpOrderShedule
                                union select tmpOrderShedule.ContractId, CASE WHEN Value6 in (1,3) THEN 6 ELSE 0 END AS DoW, CASE WHEN Value6 in (2,3) THEN 6 ELSE 0 END AS DoW_D from tmpOrderShedule
                                union select tmpOrderShedule.ContractId, CASE WHEN Value7 in (1,3) THEN 7 ELSE 0 END AS DoW, CASE WHEN Value7 in (2,3) THEN 7 ELSE 0 END AS DoW_D from tmpOrderShedule) AS tmp
                          WHERE tmp.DoW <> 0 OR tmp.DoW_D <> 0
                          )
,tmpAfter AS (SELECT tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
              FROM ( 
                    SELECT tmpOrderSheduleList.ContractId, min (DoW) AS DoW, 0 AS DoW_D
                    FROM tmpOrderSheduleList
                    WHERE tmpOrderSheduleList.DoW > vbCURRENT_DOW 
                      AND tmpOrderSheduleList.DoW > 0
                    GROUP BY tmpOrderSheduleList.ContractId
                    Union
                    SELECT tmpOrderSheduleList.ContractId, 0 AS DoW, min (DoW_D) AS DoW_D
                    FROM tmpOrderSheduleList
                    WHERE tmpOrderSheduleList.DoW_D > vbCURRENT_DOW 
                      AND tmpOrderSheduleList.DoW_D > 0
                    GROUP BY tmpOrderSheduleList.ContractId) as tmp
              GROUP BY tmp.ContractId
              )
, tmpBefore AS (SELECT tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
                FROM (
                    SELECT tmpOrderSheduleList.ContractId,  min (tmpOrderSheduleList.DoW) AS DoW, 0 AS DoW_D
                    FROM tmpOrderSheduleList
                       LEFT JOIN tmpAfter ON tmpAfter.ContractId = tmpOrderSheduleList.ContractId
                    WHERE tmpOrderSheduleList.DoW < vbCURRENT_DOW 
                      AND tmpAfter.ContractId IS NULL
                        AND tmpOrderSheduleList.DoW<>0
                    GROUP BY tmpOrderSheduleList.ContractId
                UNION 
                    SELECT tmpOrderSheduleList.ContractId, 0 AS DoW,  min (tmpOrderSheduleList.DoW_D) AS DoW_D
                    FROM tmpOrderSheduleList
                       LEFT JOIN tmpAfter ON tmpAfter.ContractId = tmpOrderSheduleList.ContractId
                    WHERE tmpOrderSheduleList.DoW_D < vbCURRENT_DOW 
                      AND tmpAfter.ContractId IS NULL
                        AND tmpOrderSheduleList.DoW_D<>0
                    GROUP BY tmpOrderSheduleList.ContractId) as tmp
                GROUP BY tmp.ContractId
                )
, OrderSheduleList AS ( SELECT tmp.ContractId 
                             , tmpDateList.OperDate         AS OperDate_Zakaz
                             , tmpDateList_D.OperDate       AS OperDate_Dostavka
                        FROM (SELECT *
                              FROM tmpAfter
                           union all 
                              SELECT *
                              FROM tmpBefore
                             ) AS tmp
                         LEFT JOIN tmpDateList ON tmpDateList.Number = tmp.DoW
                         LEFT JOIN tmpDateList AS tmpDateList_D ON tmpDateList_D.Number = tmp.DoW_D
                   )
, OrderSheduleListToday AS (SELECT *
                            FROM tmpOrderSheduleList
                            WHERE tmpOrderSheduleList.DoW = vbCURRENT_DOW  OR tmpOrderSheduleList.DoW_D = vbCURRENT_DOW  
                           )
--

 -- Маркетинговый контракт
  , GoodsPromo AS (SELECT tmp.JuridicalId
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

  , tmpMI_Child AS (SELECT MI_Child.ParentId AS MIMasterId
                         , MI_Child.Id       AS MIId
                    FROM MovementItem AS MI_Child 
                    WHERE MI_Child.MovementId = inMovementId
                      AND MI_Child.DescId     = zc_MI_Child()
                      AND MI_Child.isErased   = False
                    )
  
       -- Результат 1
       SELECT
             tmpMI.MovementItemId                                    AS Id
           , tmpMI.GoodsId                                           AS GoodsId
           , Object_Goods.GoodsCodeInt                               AS GoodsCode
           , Object_Goods.GoodsName                                  AS GoodsName
           , Object_Goods.MinimumLot                                 AS Multiplicity
           , Object_Goods.GoodsGroupId                               AS GoodsGroupId
           --, Object_Goods.GoodsGroupName                             AS GoodsGroupName -- ***
           , Object_Goods.NDSKindId                                  AS NDSKindId
           , Object_Goods.NDSKindName                                AS NDSKindName
           , Object_Goods.NDS                                        AS NDS

           , tmpMI.isTOP
           , tmpMI.isUnitTOP                                         AS isTOP_Price
           , tmpMI.isClose
           , tmpMI.isFirst
           , tmpMI.isSecond
           , COALESCE (ObjectBoolean_Goods_SP.ValueData,False) :: Boolean  AS isSP

           , CASE WHEN ObjectBoolean_Goods_SP.ValueData = TRUE 
                   THEN 25088 --zc_Color_GreenL()
                  WHEN tmpMI.isTOP = TRUE
                    OR tmpMI.isUnitTOP = TRUE
                  THEN 16440317         --12615935                                          ---16440317  - розовый как в приходе ELSE zc_Color_White()
                  ELSE zc_Color_White() --0
             END                                                    AS isTopColor
           , CEIL(tmpMI.Amount / COALESCE(Object_Goods.MinimumLot, 1)) * COALESCE(Object_Goods.MinimumLot, 1) ::TFloat  AS CalcAmount
           , tmpMI.Amount   ::TFloat                                AS Amount
           , COALESCE(MIFloat_Summ.ValueData, 0)  ::TFloat          AS Summ
           , COALESCE (tmpMI.isErased, FALSE)     ::Boolean         AS isErased
           , COALESCE (MIFloat_Price.ValueData,0) ::TFloat          AS Price            -- !!!на самом деле здесь zc_MIFloat_PriceFrom!!!
           , COALESCE (MIFloat_JuridicalPrice.ValueData,0) ::TFloat AS SuperFinalPrice

           , COALESCE (ObjectFloat_Goods_PriceOptSP.ValueData,0) ::TFloat AS PriceOptSP

           , tmpMI.MinimumLot            
           , tmpMI.PartionGoodsDate
           , MIString_Comment.ValueData                             AS Comment
           
           , Object_PartnerGoods.Id                                 AS PartnerGoodsId
           , Object_PartnerGoods.ObjectCode                         AS PartnerGoodsCode 
           , Object_PartnerGoods.ValueData                          AS PartnerGoodsName
           , tmpMI.JuridicalId               
           , tmpMI.JuridicalName -- ***
           , tmpMI.ContractId
           , tmpMI.ContractName 
           , tmpMI.MakerName                                        AS MakerName
           
           , COALESCE(MIBoolean_Calculated.ValueData , FALSE)       AS isCalculated--
           , CASE WHEN ObjectBoolean_Goods_SP.ValueData = TRUE THEN 25088 --zc_Color_GreenL()   --товар соц.проекта
                  WHEN tmpMI.PartionGoodsDate < vbDate180 THEN zc_Color_Blue() --456
                  WHEN tmpMI.isTOP = TRUE OR tmpMI.isUnitTOP = TRUE  THEN 15993821 -- 16440317    -- для топ розовый шрифт
                     ELSE 0
                END                                                 AS PartionGoodsDateColor   
           , tmpMI.Remains                                          AS RemainsInUnit
           , tmpMI.MCS

           , tmpMI.MCSIsClose
           , tmpMI.MCSNotRecalc
           , tmpMI.Income                                           AS Income_Amount
           , MIFloat_AmountSecond.ValueData                         AS AmountSecond

           , tmpMI.Amount + COALESCE(MIFloat_AmountSecond.ValueData,0) ::TFloat  AS AmountAll
           , NULLIF(COALESCE(MIFloat_AmountManual.ValueData,  
                         CEIL((tmpMI.Amount+COALESCE(MIFloat_AmountSecond.ValueData,0)) / COALESCE(tmpMI.MinimumLot, 1))
                           * COALESCE(tmpMI.MinimumLot, 1)     ),0)   ::TFloat   AS CalcAmountAll
           , (COALESCE (MIFloat_Price.ValueData,0) * COALESCE(MIFloat_AmountManual.ValueData,  
                         CEIL((tmpMI.Amount+COALESCE(MIFloat_AmountSecond.ValueData,0)) / COALESCE(tmpMI.MinimumLot, 1))
                           * COALESCE(tmpMI.MinimumLot, 1)     ) ) ::TFloat  AS SummAll
           
           , tmpMI.CheckAmount                                      AS CheckAmount
           , tmpMI.SendAmount                                       AS SendAmount
           , tmpMI.AmountDeferred                                   AS AmountDeferred

           , COALESCE (tmpOneJuridical.isOneJuridical, TRUE) :: Boolean AS isOneJuridical
           
           , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN False ELSE True END  ::Boolean AS isPromo
           , COALESCE(MovementPromo.OperDate, Null)  :: TDateTime   AS OperDatePromo
           , COALESCE(MovementPromo.InvNumber, '') ::  TVarChar     AS InvNumberPromo -- ***
           
           , CASE WHEN COALESCE(OrderSheduleListToday.DOW,  0) = 0 THEN False ELSE TRUE END AS isZakazToday
           , CASE WHEN COALESCE(OrderSheduleListToday.DoW_D,0) = 0 THEN False ELSE TRUE END AS isDostavkaToday
           , OrderSheduleList.OperDate_Zakaz    ::TVarChar AS OperDate_Zakaz
           , OrderSheduleList.OperDate_Dostavka ::TVarChar AS OperDate_Dostavka

           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName

       FROM  _tmpOrderInternal_MI AS tmpMI

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.DescId = zc_MIFloat_PriceFrom() -- !!!не ошибка!!!
                                       AND MIFloat_Price.MovementItemId = tmpMI.MovementItemId
            LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice               
                                        ON MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                                       AND MIFloat_JuridicalPrice.MovementItemId = tmpMI.MovementItemId

            LEFT JOIN MovementItemFloat AS MIFloat_Summ                                           
                                        ON MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                       AND MIFloat_Summ.MovementItemId = tmpMI.MovementItemId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()  
            LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                        ON MIFloat_AmountManual.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()  
                                       
            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.DescId = zc_MIString_Comment()
                                        AND MIString_Comment.MovementItemId = tmpMI.MovementItemId
           
            LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated 
                                          ON MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                         AND MIBoolean_Calculated.MovementItemId = tmpMI.MovementItemId
                                   
            LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId 
            LEFT JOIN Object AS Object_PartnerGoods ON Object_PartnerGoods.Id = tmpMI.PartnerGoodsId 
                    
             LEFT JOIN (SELECT tmpMI.MIMasterId, CASE WHEN COUNT (*) > 1 THEN FALSE ELSE TRUE END AS isOneJuridical
                        FROM tmpMI_Child AS tmpMI
                        GROUP BY tmpMI.MIMasterId
                       ) AS tmpOneJuridical ON tmpOneJuridical.MIMasterId = tmpMI.MovementItemId
                       
            LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpMI.JuridicalId
                                AND GoodsPromo.GoodsId = tmpMI.GoodsId 
            LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = GoodsPromo.MovementId

            LEFT JOIN OrderSheduleList ON OrderSheduleList.ContractId = tmpMI.ContractId
            LEFT JOIN OrderSheduleListToday ON OrderSheduleListToday.ContractId = tmpMI.ContractId  
            -- условия хранения
            LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                 ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
            LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId         


            -- получаем GoodsMainId
            LEFT JOIN  ObjectLink AS ObjectLink_Child 
                                  ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                  ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP 
                                     ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                    AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()  
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceOptSP
                                  ON ObjectFloat_Goods_PriceOptSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                 AND ObjectFloat_Goods_PriceOptSP.DescId = zc_ObjectFloat_Goods_PriceOptSP() 
           ;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
          WITH  PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (vbUserId::TVarChar))
              , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (vbUserId::TVarChar))

              , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS T WHERE T.MainJuridicalId = vbMainJuridicalId)

  -- Маркетинговый контракт
  , GoodsPromo AS (SELECT tmp.JuridicalId
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

        SELECT tmpMI.MovementItemId AS MovementItemId
             , MI_Child.Id 
             , Object_Goods.ObjectCode    AS GoodsCode
             , Object_Goods.ValueData     AS GoodsName --_tmpMI.GoodsName
             , COALESCE(JuridicalSettings.Bonus, 0)::TFloat AS Bonus
             , COALESCE (ObjectFloat_Deferment.ValueData, 0)::Integer AS Deferment
/* * /
             , CASE WHEN COALESCE (ObjectFloat_Deferment.ValueData, 0) = 0
                         THEN 0
                    WHEN tmpMI.isTOP = TRUE
                         THEN COALESCE (PriceSettingsTOP.Percent, 0)
                    ELSE PriceSettings.Percent
               END :: TFloat AS Percent
/ */
             , CASE WHEN COALESCE (ObjectFloat_Deferment.ValueData, 0) = 0 AND tmpMI.isTOP = TRUE
                        THEN COALESCE (PriceSettingsTOP.Percent, 0)
                   WHEN COALESCE (ObjectFloat_Deferment.ValueData, 0) = 0 AND tmpMI.isTOP = FALSE
                        THEN COALESCE (PriceSettings.Percent, 0)
                   ELSE 0
              END :: TFloat AS Percent
/**/              

              , Object_Juridical.ValueData     AS JuridicalName
              , MIString_Maker.ValueData       AS MakerName
              , Object_Contract.ValueData      AS ContractName
              , COALESCE(MIDate_PartionGoods.ValueData, Null) ::TDateTime AS PartionGoodsDate
              , CASE WHEN MIDate_PartionGoods.ValueData < vbDate180 THEN zc_Color_Blue() --456
                     ELSE 0
                END                            AS PartionGoodsDateColor      
              , ObjectFloat_Goods_MinimumLot.ValueData      ::TFLoat     AS MinimumLot
              , MI_Child.Amount       ::TFLoat          AS Remains
              , MIFloat_Price.ValueData        ::TFLoat            AS Price 
              , MIFloat_JuridicalPrice.ValueData    ::TFLoat       AS SuperFinalPrice

              , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN False ELSE True END  ::Boolean AS isPromo
              , COALESCE(MovementPromo.OperDate, Null)  :: TDateTime   AS OperDatePromo
              , COALESCE(MovementPromo.InvNumber, '') ::  TVarChar     AS InvNumberPromo -- ***
              , COALESCE(GoodsPromo.ChangePercent, 0) ::  TFLoat       AS ChangePercentPromo
              , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName

        FROM _tmpOrderInternal_MI AS tmpMI
             INNER JOIN MovementItem AS MI_Child 
                                     ON MI_Child.ParentId = tmpMI.MovementItemId
                                    AND MI_Child.DescId = zc_MI_Child()
                                    AND (MI_Child.IsErased = inIsErased OR inIsErased = True)
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Child.ObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_Goods_MinimumLot
                                   ON ObjectFloat_Goods_MinimumLot.ObjectId = MI_Child.ObjectId 
                                  AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
 
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods                                           
                                       ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                      AND MIDate_PartionGoods.MovementItemId = MI_Child.Id
            LEFT JOIN MovementItemFloat AS MIFloat_Price                                           
                                        ON MIFloat_Price.DescId = zc_MIFloat_Price()
                                       AND MIFloat_Price.MovementItemId = MI_Child.Id
            LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice                                           
                                        ON MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                                       AND MIFloat_JuridicalPrice.MovementItemId = MI_Child.Id
                                       
            LEFT JOIN MovementItemString AS MIString_Maker 
                                         ON MIString_Maker.DescId = zc_MIString_Maker()
                                        AND MIString_Maker.MovementItemId = MI_Child.Id
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical 
                                             ON MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                                            AND MILinkObject_Juridical.MovementItemId = MI_Child.Id
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILinkObject_Juridical.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract 
                                             ON MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                            AND MILinkObject_Contract.MovementItemId = MI_Child.Id
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId  

            LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId                                          
                                        ON MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                                       AND MIFloat_MovementItemId.MovementItemId = MI_Child.Id
                                        
            LEFT JOIN MovementItemLastPriceList_View ON MovementItemLastPriceList_View.MovementItemId = MIFloat_MovementItemId.ValueData ::integer
            LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId = Object_Juridical.Id --MovementItemLastPriceList_View.JuridicalId 
                                       AND JuridicalSettings.ContractId = Object_Contract.Id   --MovementItemLastPriceList_View.ContractId
            LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                         ON ObjectFloat_Deferment.ObjectId = Object_Contract.Id
                        AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
            
             LEFT JOIN PriceSettings    ON MIFloat_Price.ValueData BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
             LEFT JOIN PriceSettingsTOP ON MIFloat_Price.ValueData BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice

             LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = Object_Juridical.Id
                                 AND GoodsPromo.GoodsId = tmpMI.GoodsId
             LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = GoodsPromo.MovementId
             -- условия хранения
             LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                  ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
            ;

     RETURN NEXT Cursor2;


    ELSE


    -- !!!Только для ДРУГИХ документов!!!

   PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, 0, vbUserId);

    OPEN Cursor1 FOR
     WITH
     --Данные Справочника График заказа/доставки
          tmpDateList AS (SELECT ''||tmp.OperDate :: Date || ' (' ||tmpDayOfWeek.DayOfWeekName ||')' AS OperDate
                               , tmpDayOfWeek.Number
                               , tmpDayOfWeek.DayOfWeekName
                          FROM (SELECT generate_series ( CURRENT_DATE,  CURRENT_DATE+interval '6 day', '1 day' :: INTERVAL) AS OperDate) AS tmp
                            LEFT JOIN zfCalc_DayOfWeekName(tmp.OperDate) AS tmpDayOfWeek ON 1=1
                          )
      , tmpOrderShedule AS (SELECT ObjectLink_OrderShedule_Contract.ChildObjectId          AS ContractId --
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 1) ::TFloat AS Value1
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 2) ::TFloat AS Value2
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 3) ::TFloat AS Value3
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 4) ::TFloat AS Value4
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 5) ::TFloat AS Value5
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 6) ::TFloat AS Value6
                                 , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 7) ::TFloat AS Value7
                                 , Object_OrderShedule.ValueData AS Value8
                            FROM Object AS Object_OrderShedule
                                 INNER JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                                         ON ObjectLink_OrderShedule_Unit.ObjectId = Object_OrderShedule.Id
                                        AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
                                        AND ObjectLink_OrderShedule_Unit.ChildObjectId = vbUnitId
                                 LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Contract
                                        ON ObjectLink_OrderShedule_Contract.ObjectId = Object_OrderShedule.Id
                                       AND ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
                            WHERE Object_OrderShedule.DescId = zc_Object_OrderShedule()
                              AND Object_OrderShedule.isErased = FALSE
                           )
, tmpOrderSheduleList AS (SELECT tmp.*
                          FROM (
                                select tmpOrderShedule.ContractId, CASE WHEN Value1 in (1,3) THEN 1 ELSE 0 END AS DoW, CASE WHEN Value1 in (2,3) THEN 1 ELSE 0 END AS DoW_D from tmpOrderShedule
                                union select tmpOrderShedule.ContractId, CASE WHEN Value2 in (1,3) THEN 2 ELSE 0 END AS DoW, CASE WHEN Value2 in (2,3) THEN 2 ELSE 0 END AS DoW_D from tmpOrderShedule
                                union select tmpOrderShedule.ContractId, CASE WHEN Value3 in (1,3) THEN 3 ELSE 0 END AS DoW, CASE WHEN Value3 in (2,3) THEN 3 ELSE 0 END AS DoW_D from tmpOrderShedule
                                union select tmpOrderShedule.ContractId, CASE WHEN Value4 in (1,3) THEN 4 ELSE 0 END AS DoW, CASE WHEN Value4 in (2,3) THEN 4 ELSE 0 END AS DoW_D from tmpOrderShedule
                                union select tmpOrderShedule.ContractId, CASE WHEN Value5 in (1,3) THEN 5 ELSE 0 END AS DoW, CASE WHEN Value5 in (2,3) THEN 5 ELSE 0 END AS DoW_D from tmpOrderShedule
                                union select tmpOrderShedule.ContractId, CASE WHEN Value6 in (1,3) THEN 6 ELSE 0 END AS DoW, CASE WHEN Value6 in (2,3) THEN 6 ELSE 0 END AS DoW_D from tmpOrderShedule
                                union select tmpOrderShedule.ContractId, CASE WHEN Value7 in (1,3) THEN 7 ELSE 0 END AS DoW, CASE WHEN Value7 in (2,3) THEN 7 ELSE 0 END AS DoW_D from tmpOrderShedule) AS tmp
                          WHERE tmp.DoW <> 0 OR tmp.DoW_D <> 0
                          )
,tmpAfter AS (SELECT tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
              FROM ( 
                    SELECT tmpOrderSheduleList.ContractId, min (DoW) AS DoW, 0 AS DoW_D
                    FROM tmpOrderSheduleList
                    WHERE tmpOrderSheduleList.DoW > vbCURRENT_DOW 
                      AND tmpOrderSheduleList.DoW > 0
                    GROUP BY tmpOrderSheduleList.ContractId
                    Union
                    SELECT tmpOrderSheduleList.ContractId, 0 AS DoW, min (DoW_D) AS DoW_D
                    FROM tmpOrderSheduleList
                    WHERE tmpOrderSheduleList.DoW_D > vbCURRENT_DOW 
                      AND tmpOrderSheduleList.DoW_D > 0
                    GROUP BY tmpOrderSheduleList.ContractId) as tmp
              GROUP BY tmp.ContractId
              )
, tmpBefore AS (SELECT tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
                FROM (
                    SELECT tmpOrderSheduleList.ContractId,  min (tmpOrderSheduleList.DoW) AS DoW, 0 AS DoW_D
                    FROM tmpOrderSheduleList
                       LEFT JOIN tmpAfter ON tmpAfter.ContractId = tmpOrderSheduleList.ContractId
                    WHERE tmpOrderSheduleList.DoW < vbCURRENT_DOW 
                      AND tmpAfter.ContractId IS NULL
                        AND tmpOrderSheduleList.DoW<>0
                    GROUP BY tmpOrderSheduleList.ContractId
                UNION 
                    SELECT tmpOrderSheduleList.ContractId, 0 AS DoW,  min (tmpOrderSheduleList.DoW_D) AS DoW_D
                    FROM tmpOrderSheduleList
                       LEFT JOIN tmpAfter ON tmpAfter.ContractId = tmpOrderSheduleList.ContractId
                    WHERE tmpOrderSheduleList.DoW_D < vbCURRENT_DOW 
                      AND tmpAfter.ContractId IS NULL
                        AND tmpOrderSheduleList.DoW_D<>0
                    GROUP BY tmpOrderSheduleList.ContractId) as tmp
                GROUP BY tmp.ContractId
                )
, OrderSheduleList AS ( SELECT tmp.ContractId 
                             , tmpDateList.OperDate         AS OperDate_Zakaz
                             , tmpDateList_D.OperDate       AS OperDate_Dostavka
                        FROM (SELECT *
                              FROM tmpAfter
                           union all 
                              SELECT *
                              FROM tmpBefore
                             ) AS tmp
                         LEFT JOIN tmpDateList ON tmpDateList.Number = tmp.DoW
                         LEFT JOIN tmpDateList AS tmpDateList_D ON tmpDateList_D.Number = tmp.DoW_D
                   )
, OrderSheduleListToday AS (SELECT *
                            FROM tmpOrderSheduleList
                            WHERE tmpOrderSheduleList.DoW = vbCURRENT_DOW  OR tmpOrderSheduleList.DoW_D = vbCURRENT_DOW  
                           )
--

         , tmpCheck AS (SELECT MI_Check.ObjectId                  AS GoodsId
                             , -1 * SUM (MIContainer.Amount) ::TFloat  AS Amount
                        FROM Movement AS Movement_Check
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                            AND MovementLinkObject_Unit.ObjectId = vbUnitId
                               INNER JOIN MovementItem AS MI_Check
                                                       ON MI_Check.MovementId = Movement_Check.Id
                                                      AND MI_Check.DescId = zc_MI_Master()
                                                      AND MI_Check.isErased = FALSE
                               LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                                     ON MIContainer.MovementItemId = MI_Check.Id
                                                                    AND MIContainer.DescId = zc_MIContainer_Count() 
                         WHERE Movement_Check.OperDate >= vbOperDate AND Movement_Check.OperDate < vbOperDateEnd
                         -- AND DATE_TRUNC ('DAY', Movement_Check.OperDate) = vbOperDate -- CURRENT_DATE
                          AND Movement_Check.DescId = zc_Movement_Check()
                          AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                        GROUP BY MI_Check.ObjectId 
                        HAVING SUM (MI_Check.Amount) <> 0 
                        )
         -- автоперемещения приход
         , tmpSend AS ( SELECT MI_Send.ObjectId                     AS GoodsId
                             , SUM (MI_Send.Amount) ::TFloat   AS Amount
                        FROM Movement AS Movement_Send
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement_Send.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                            AND MovementLinkObject_Unit.ObjectId = vbUnitId
                               INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                          ON MovementBoolean_isAuto.MovementId = Movement_Send.Id
                                                         AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                                         AND MovementBoolean_isAuto.ValueData = TRUE
                               INNER JOIN MovementItem AS MI_Send
                                                       ON MI_Send.MovementId = Movement_Send.Id
                                                      AND MI_Send.DescId = zc_MI_Master()
                                                      AND MI_Send.isErased = FALSE
                         /*      LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                                     ON MIContainer.MovementItemId = MI_Send.Id
                                                                    AND MIContainer.DescId = zc_MIContainer_Count() 
                                                                    AND MIContainer.isActive = True*/
                        WHERE Movement_Send.OperDate >= vbOperDate - interval '30 day' AND Movement_Send.OperDate < vbOperDateEnd
                          AND Movement_Send.DescId = zc_Movement_Send()
                          AND Movement_Send.StatusId = zc_Enum_Status_UnComplete()
                        GROUP BY MI_Send.ObjectId 
                        HAVING SUM (MI_Send.Amount) <> 0 
                       )

    -- Заказ отложен
    , tmpDeferred AS (SELECT MI_OrderExternal.ObjectId                AS GoodsId
                           , SUM (MI_OrderExternal.Amount) ::TFloat   AS AmountDeferred 
                      FROM Movement AS Movement_OrderExternal
                          INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                     ON MovementBoolean_Deferred.MovementId = Movement_OrderExternal.Id
                                                    AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                    AND MovementBoolean_Deferred.ValueData = TRUE
                          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement_OrderExternal.Id
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                       AND MovementLinkObject_Unit.ObjectId = vbUnitId
                          INNER JOIN MovementItem AS MI_OrderExternal
                                                  ON MI_OrderExternal.MovementId = Movement_OrderExternal.Id
                                                 AND MI_OrderExternal.DescId = zc_MI_Master()
                                                 AND MI_OrderExternal.isErased = FALSE

                          LEFT JOIN MovementLinkMovement AS MLM_Order
                                                         ON MLM_Order.MovementChildId = Movement_OrderExternal.Id     --MLM_Order.MovementId = Movement_Income.Id
                                                        AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
--        LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MLM_Order.MovementChildId
                      WHERE /*Movement_OrderExternal.OperDate >= vbOperDate AND Movement_OrderExternal.OperDate < vbOperDateEnd
                        AND */Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
                        AND Movement_OrderExternal.StatusId = zc_Enum_Status_Complete()
                        AND MLM_Order.MovementId is Null
                      GROUP BY MI_OrderExternal.ObjectId 
                      HAVING SUM (MI_OrderExternal.Amount) <> 0 
                     )

   -- Маркетинговый контракт
  , GoodsPromo AS (SELECT tmp.JuridicalId
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

      , tmpRemains AS (SELECT Container.ObjectId
                            , SUM (Container.Amount) AS Amount
                       FROM Container
                            INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                           ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                          AND ContainerLinkObject_Unit.ObjectId = vbUnitId
                       WHERE Container.DescId = zc_Container_Count()
                         AND Container.Amount<>0
                       GROUP BY Container.ObjectId
                      )

       , tmpIncome AS (SELECT MovementItem_Income.ObjectId               AS Income_GoodsId
                            , SUM (MovementItem_Income.Amount) :: TFloat AS Income_Amount
                       FROM Movement AS Movement_Income
                            INNER JOIN MovementItem AS MovementItem_Income
                                                    ON Movement_Income.Id = MovementItem_Income.MovementId
                                                   AND MovementItem_Income.DescId = zc_MI_Master()
                                                   AND MovementItem_Income.isErased = FALSE
                                                   AND MovementItem_Income.Amount > 0
                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_To.ObjectId = vbUnitId
                            INNER JOIN MovementDate AS MovementDate_Branch
                                                    ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                   AND MovementDate_Branch.DescId = zc_MovementDate_Branch() 
                        WHERE Movement_Income.DescId = zc_Movement_Income()
                          AND MovementDate_Branch.ValueData >= CURRENT_DATE
                          AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                        GROUP BY MovementItem_Income.ObjectId
                      ) 

       -- Результат 1
       SELECT
             tmpMI.Id                                                AS Id
           , COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)              AS GoodsId
           , COALESCE (tmpMI.GoodsCode, tmpGoods.GoodsCode)          AS GoodsCode
           , COALESCE (tmpMI.GoodsName, tmpGoods.GoodsName)          AS GoodsName
           , COALESCE (tmpMI.Goods_isTOP, tmpGoods.Goods_isTOP)      AS isTOP
           , COALESCE (Object_Price_View.isTOP, False)               AS isTOP_Price

           , COALESCE(tmpMI.GoodsGroupId, tmpGoods.GoodsGroupId)     AS GoodsGroupId
           -- , COALESCE(tmpMI.GoodsGroupName, tmpGoods.GoodsGroupName) AS GoodsGroupName -- ***
           , COALESCE(tmpMI.NDSKindId, tmpGoods.NDSKindId)           AS NDSKindId
           , COALESCE(tmpMI.NDSKindName, tmpGoods.NDSKindName)       AS NDSKindName
           , COALESCE(tmpMI.NDS, tmpGoods.NDS)                       AS NDS
           , COALESCE(tmpMI.isClose, tmpGoods.isClose)               AS isClose
           , COALESCE(tmpMI.isFirst, tmpGoods.isFirst)               AS isFirst
           , COALESCE(tmpMI.isSecond, tmpGoods.isSecond)             AS isSecond
           , COALESCE (ObjectBoolean_Goods_SP.ValueData,False) :: Boolean  AS isSP
           , CASE WHEN ObjectBoolean_Goods_SP.ValueData = TRUE 
                   THEN 25088 --zc_Color_GreenL()
                  WHEN COALESCE (tmpMI.Goods_isTOP, tmpGoods.Goods_isTOP) = TRUE
                    OR COALESCE (Object_Price_View.isTOP, False) = TRUE
                   THEN 16440317         --12615935                                                      --16440317  - розовый как в приходе ELSE zc_Color_White()
                  ELSE zc_Color_White() --0
             END                                                    AS isTopColor
           , COALESCE(tmpMI.Multiplicity, tmpGoods.Multiplicity)    AS Multiplicity
           , tmpMI.CalcAmount
           , NULLIF(tmpMI.Amount,0)                                 AS Amount
           , tmpMI.Price * tmpMI.CalcAmount                         AS Summ
           , COALESCE (tmpMI.isErased, FALSE)                       AS isErased
           , tmpMI.Price
           , tmpMI.MinimumLot
           , tmpMI.PartionGoodsDate
           , tmpMI.Comment
           , tmpMI.PartnerGoodsId
           , tmpMI.PartnerGoodsCode 
           , tmpMI.PartnerGoodsName
           , tmpMI.JuridicalId
           , tmpMI.JuridicalName -- ***
           , tmpMI.ContractId
           , tmpMI.ContractName
           , tmpMI.MakerName 
           , tmpMI.SuperFinalPrice 
           , COALESCE (ObjectFloat_Goods_PriceOptSP.ValueData,0) ::TFloat AS PriceOptSP
          -- , COALESCE (tmpMI.PriceOptSP,tmpGoods.PriceOptSP) ::TFloat AS PriceOptSP
          -- , CASE WHEN COALESCE (tmpMI.PriceOptSP,tmpGoods.PriceOptSP)
           , COALESCE(tmpMI.isCalculated, FALSE)                      AS isCalculated
           , CASE WHEN ObjectBoolean_Goods_SP.ValueData = TRUE THEN 25088 --zc_Color_GreenL()   --товар соц.проекта
                  WHEN tmpMI.PartionGoodsDate < vbDate180 THEN zc_Color_Blue() --456
                  WHEN (COALESCE (tmpMI.Goods_isTOP, tmpGoods.Goods_isTOP)= TRUE OR COALESCE (Object_Price_View.isTOP, False)= TRUE) THEN 15993821 -- 16440317    -- для топ розовый шрифт
                     ELSE 0
                END AS PartionGoodsDateColor   
           , Remains.Amount                                         AS RemainsInUnit
           , Object_Price_View.MCSValue                             AS MCS
           , COALESCE (Object_Price_View.MCSIsClose, FALSE)         AS MCSIsClose
           , COALESCE (Object_Price_View.MCSNotRecalc, FALSE)       AS MCSNotRecalc
           , Income.Income_Amount                                   AS Income_Amount
           , tmpMI.AmountSecond                                     AS AmountSecond
           , NULLIF(tmpMI.AmountAll,0)                              AS AmountAll
           , NULLIF(COALESCE(tmpMI.AmountManual,tmpMI.CalcAmountAll),0)      AS CalcAmountAll
           , tmpMI.Price * COALESCE(tmpMI.AmountManual,tmpMI.CalcAmountAll)  AS SummAll
           , tmpCheck.Amount  ::tfloat                                       AS CheckAmount
           , tmpSend.Amount   ::tfloat                                       AS SendAmount

           , tmpDeferred.AmountDeferred                                      AS AmountDeferred

           , COALESCE (SelectMinPrice_AllGoods.isOneJuridical, TRUE) :: Boolean AS isOneJuridical
           
           , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN False ELSE True END  ::Boolean AS isPromo
           , COALESCE(MovementPromo.OperDate, Null)  :: TDateTime   AS OperDatePromo
           , COALESCE(MovementPromo.InvNumber, '') ::  TVarChar     AS InvNumberPromo -- ***

           , CASE WHEN COALESCE(OrderSheduleListToday.DOW,  0) = 0 THEN False ELSE TRUE END AS isZakazToday
           , CASE WHEN COALESCE(OrderSheduleListToday.DoW_D,0) = 0 THEN False ELSE TRUE END AS isDostavkaToday
           , OrderSheduleList.OperDate_Zakaz    ::TVarChar AS OperDate_Zakaz
           , OrderSheduleList.OperDate_Dostavka ::TVarChar AS OperDate_Dostavka

           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
           
--, (select count (*) from OrderSheduleList) ::TVarChar AS OperDate_Dostavka
           
       FROM (SELECT Object_Goods.Id                              AS GoodsId
                  , Object_Goods.GoodsCodeInt                    AS GoodsCode
                  , Object_Goods.GoodsName                       AS GoodsName
                  , Object_Goods.MinimumLot                      AS Multiplicity
                  , COALESCE (Object_Goods.isTOP, False)         AS Goods_isTOP
                  , COALESCE (GoodsPrice.isTop, False)           AS Price_isTOP
                  , Object_Goods.GoodsGroupId                    AS GoodsGroupId
                  -- , Object_Goods.GoodsGroupName                  AS GoodsGroupName -- ***
                  , Object_Goods.NDSKindId                       AS NDSKindId
                  , Object_Goods.NDSKindName                     AS NDSKindName
                  , Object_Goods.NDS                             AS NDS
                  , Object_Goods.isClose                         AS isClose
                  , Object_Goods.isFirst                         AS isFirst
                  , Object_Goods.isSecond                        AS isSecond
                  
             FROM Object_Goods_View AS Object_Goods
                  LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = Object_Goods.Id
             WHERE inShowAll = TRUE
               AND Object_Goods.ObjectId = vbObjectId
               AND Object_Goods.isErased = FALSE
             -- ORDER BY Object_Goods.Id DESC
             -- LIMIT 20000 -- 17664 от 03.11.2016
            ) AS tmpGoods

            FULL JOIN (SELECT MovementItem.Id
                            , MovementItem.ObjectId                                            AS GoodsId
                            , MovementItem.Amount                                              AS Amount
                            , CEIL(MovementItem.Amount / COALESCE(Object_Goods.MinimumLot, 1)) 
                                * COALESCE(Object_Goods.MinimumLot, 1)                         AS CalcAmount
                            , MIFloat_Summ.ValueData                                           AS Summ
                            , Object_Goods.GoodsCodeInt                                        AS GoodsCode
                            , Object_Goods.GoodsName                                           AS GoodsName
                            , Object_Goods.MinimumLot                                          AS Multiplicity
                            , Object_Goods.GoodsGroupId                                        AS GoodsGroupId
                            -- , Object_Goods.GoodsGroupName                                      AS GoodsGroupName -- ***
                            , Object_Goods.NDSKindId                                           AS NDSKindId
                            , Object_Goods.NDSKindName                                         AS NDSKindName
                            , Object_Goods.NDS                                                 AS NDS
                            , Object_Goods.isClose                                             AS isClose
                            , Object_Goods.isFirst                                             AS isFirst 
                            , Object_Goods.isSecond                                            AS isSecond
                            , MIString_Comment.ValueData                                       AS Comment
                            , COALESCE(PriceList.MakerName, MinPrice.MakerName)                AS MakerName
                            , MIBoolean_Calculated.ValueData                                   AS isCalculated
                            , ObjectFloat_Goods_MinimumLot.valuedata                           AS MinimumLot
                            , COALESCE(PriceList.Price, MinPrice.Price)                        AS Price
                            , COALESCE(PriceList.PartionGoodsDate, MinPrice.PartionGoodsDate)  AS PartionGoodsDate
                            , COALESCE(PriceList.GoodsId, MinPrice.GoodsId)                    AS PartnerGoodsId
                            , COALESCE(PriceList.GoodsCode, MinPrice.GoodsCode)                AS PartnerGoodsCode 
                            , COALESCE(PriceList.GoodsName, MinPrice.GoodsName)                AS PartnerGoodsName
                            , COALESCE(PriceList.JuridicalId, MinPrice.JuridicalId)            AS JuridicalId
                            , COALESCE(PriceList.JuridicalName, MinPrice.JuridicalName)        AS JuridicalName
                            , COALESCE(PriceList.ContractId, MinPrice.ContractId)              AS ContractId
                            , COALESCE(PriceList.ContractName, MinPrice.ContractName)          AS ContractName
                            , COALESCE(PriceList.SuperFinalPrice, MinPrice.SuperFinalPrice)    AS SuperFinalPrice
                            , COALESCE (Object_Goods.isTOP, False)                             AS Goods_isTOP
                            , COALESCE (GoodsPrice.isTop, False)                               AS Price_isTOP
                            , MIFloat_AmountSecond.ValueData                                   AS AmountSecond
                            , MovementItem.Amount+COALESCE(MIFloat_AmountSecond.ValueData,0)   AS AmountAll
                            , CEIL((MovementItem.Amount+COALESCE(MIFloat_AmountSecond.ValueData,0)) / COALESCE(Object_Goods.MinimumLot, 1)) 
                               * COALESCE(Object_Goods.MinimumLot, 1)                          AS CalcAmountAll
                            , MIFloat_AmountManual.ValueData                                   AS AmountManual
                            , MovementItem.isErased
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                       
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical 
                                                        ON MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                                                       AND MILinkObject_Juridical.MovementItemId = MovementItem.Id  
                                                       
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract 
                                                        ON MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                                       AND MILinkObject_Contract.MovementItemId = MovementItem.Id  

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods 
                                                        ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                       AND MILinkObject_Goods.MovementItemId = MovementItem.Id  

                       LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated 
                                                     ON MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                                    AND MIBoolean_Calculated.MovementItemId = MovementItem.Id  

                       LEFT JOIN MovementItemString AS MIString_Comment 
                                                    ON MIString_Comment.DescId = zc_MIString_Comment()
                                                   AND MIString_Comment.MovementItemId = MovementItem.Id  

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
                            
                       LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_MinimumLot
                                              ON ObjectFloat_Goods_MinimumLot.ObjectId = COALESCE (PriceList.GoodsId, MinPrice.GoodsId) 
                                             AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                             
                       INNER JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 
                       LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = Object_Goods.Id

                       LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                   ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                         ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()  
                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountManual
                                                         ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual() 
 
                      ) AS tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
            LEFT JOIN Object_Price_View ON COALESCE(tmpMI.GoodsId,tmpGoods.GoodsId) = Object_Price_View.GoodsId
                                       AND Object_Price_View.UnitId = vbUnitId
            LEFT JOIN tmpRemains AS Remains ON Remains.ObjectId = COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)

            LEFT JOIN tmpIncome AS Income ON Income.Income_GoodsId = COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)
                      
             LEFT JOIN tmpCheck ON tmpCheck.GoodsId = COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)
             LEFT JOIN tmpSend ON tmpSend.GoodsId = COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)
             LEFT JOIN tmpDeferred ON tmpDeferred.GoodsId = COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)

             LEFT JOIN (SELECT _tmpMI.MovementItemId, CASE WHEN COUNT (*) > 1 THEN FALSE ELSE TRUE END AS isOneJuridical
                        FROM _tmpMI
                        GROUP BY _tmpMI.MovementItemId
                       ) AS SelectMinPrice_AllGoods ON SelectMinPrice_AllGoods.MovementItemId = tmpMI.Id
             LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpMI.JuridicalId
                                 AND GoodsPromo.GoodsId = COALESCE(tmpMI.GoodsId, tmpGoods.GoodsId)
             LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = GoodsPromo.MovementId

            LEFT JOIN OrderSheduleList ON OrderSheduleList.ContractId = tmpMI.ContractId
            LEFT JOIN OrderSheduleListToday ON OrderSheduleListToday.ContractId = tmpMI.ContractId

            -- условия хранения
            LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                 ON ObjectLink_Goods_ConditionsKeep.ObjectId = COALESCE(tmpMI.GoodsId, tmpGoods.GoodsId)
                                AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
            LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

            -- получаем GoodsMainId
            LEFT JOIN  ObjectLink AS ObjectLink_Child 
                                  ON ObjectLink_Child.ChildObjectId = COALESCE(tmpMI.GoodsId, tmpGoods.GoodsId)
                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                  ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP 
                                     ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                    AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()  
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceOptSP
                                  ON ObjectFloat_Goods_PriceOptSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                 AND ObjectFloat_Goods_PriceOptSP.DescId = zc_ObjectFloat_Goods_PriceOptSP() 
           ;
     RETURN NEXT Cursor1;

     -- Результат 2
     OPEN Cursor2 FOR
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

        SELECT *, CASE WHEN PartionGoodsDate < vbDate180 THEN zc_Color_Blue() --456
                     ELSE 0
                END AS PartionGoodsDateColor      
              , ObjectFloat_Goods_MinimumLot.ValueData           AS MinimumLot
              , MIFloat_Remains.ValueData          AS Remains

              , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN False ELSE True END  ::Boolean AS isPromo
              , COALESCE(MovementPromo.OperDate, Null)  :: TDateTime   AS OperDatePromo
              , COALESCE(MovementPromo.InvNumber, '') ::  TVarChar     AS InvNumberPromo -- ***
              , COALESCE(GoodsPromo.ChangePercent, 0) ::  TFLoat       AS ChangePercentPromo
   
              , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName

        FROM _tmpMI
             LEFT JOIN ObjectFloat AS ObjectFloat_Goods_MinimumLot
                                   ON ObjectFloat_Goods_MinimumLot.ObjectId = _tmpMI.GoodsId 
                                  AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                         ON MIFloat_Remains.MovementItemId = _tmpMI.PriceListMovementItemId
                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
             LEFT JOIN MovementItem ON MovementItem.Id = _tmpMI.MovementItemId
             LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = _tmpMI.JuridicalId
                                 AND GoodsPromo.GoodsId = MovementItem.ObjectId 
             LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = GoodsPromo.MovementId
             -- условия хранения
             LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                  ON ObjectLink_Goods_ConditionsKeep.ObjectId = _tmpMI.GoodsId 
                                 AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

;
   RETURN NEXT Cursor2;

  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.04.17         *
 12.11.16         * 
 09.09.16         *
 31.08.16         *
 04.08.16         *
 28.04.16         *
 12.04.16         *
 23.03.16         *
 03.02.16         *
 23.03.15                         * 
 05.02.15                         * 
 12.11.14                         * add MinimumLot
 05.11.14                         * add MakerName
 22.10.14                         *
 13.10.14                         *
 15.07.14                                                       *
 15.07.14                                                       *
 03.07.14                                                       *
*/

/*
-- вот так хотели залить инфу, но сказали что не надо :)
with tmp1 as (
select distinct MovementItem.*
, coalesce (MIFloat_Price.ValueData, 0) AS Price
, coalesce (MIFloat_JuridicalPrice.ValueData, 0) AS JuridicalPrice
FROM Movement
        inner JOIN MovementBoolean AS MB_Document
               ON MB_Document.MovementId = Movement.Id
              AND MB_Document.DescId = zc_MovementBoolean_Document()
              AND MB_Document.ValueData = TRUE

                            JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = FALSE

            LEFT JOIN MovementItemFloat AS MIFloat_Price                                           
                                        ON MIFloat_Price.DescId = zc_MIFloat_Price()
                                       AND MIFloat_Price.MovementItemId = MovementItem.Id
            LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice                                           
                                        ON MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                                       AND MIFloat_JuridicalPrice.MovementItemId = MovementItem.Id

where Movement.DescId = zc_Movement_OrderInternal()
)
, tmp2 as (select distinct from tmp1)
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 3961103, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '3'); -- FETCH ALL "<unnamed portal 6>";
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 3961103, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '3'); -- FETCH ALL "<unnamed portal 6>";