-- Function: gpSelect_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inIsLink      Boolean      , -- проверка привязки к поставщику
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
     
    -- таблица Регион поставщика
    CREATE TEMP TABLE tmpJuridicalArea (UnitId Integer, JuridicalId Integer, AreaId Integer, AreaName TVarChar, isDefault Boolean) ON COMMIT DROP;
      INSERT INTO tmpJuridicalArea (UnitId, JuridicalId, AreaId, AreaName, isDefault)
                  SELECT DISTINCT 
                         tmp.UnitId                   AS UnitId            
                       , tmp.JuridicalId              AS JuridicalId
                       , tmp.AreaId_Juridical         AS AreaId
                       , tmp.AreaName_Juridical       AS AreaName
                       , tmp.isDefault_JuridicalArea  AS isDefault
                  FROM lpSelect_Object_JuridicalArea_byUnit (vbUnitId, 0) AS tmp;
  
    -- !!!Только для таких документов!!!
    IF vbisDocument = TRUE AND vbStatusId = zc_Enum_Status_Complete() AND inSession <> '3'
    THEN

     PERFORM lpCreateTempTable_OrderInternal_MI(inMovementId, vbObjectId, 0, vbUserId);

     SELECT ObjectLink_Unit_Juridical.ChildObjectId
         INTO vbMainJuridicalId
     FROM MovementLinkObject
          INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                         ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject.ObjectId
                        AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
         
     WHERE MovementLinkObject.MovementId = inMovementId 
       AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();
           
     OPEN Cursor1 FOR
     WITH  
        --Данные Справочника График заказа/доставки
        tmpDateList AS (SELECT ''||tmpDayOfWeek.DayOfWeekName|| '-' || DATE_PART ('day', tmp.OperDate :: Date) ||'' AS OperDate
                           --''||tmp.OperDate :: Date || ' (' ||tmpDayOfWeek.DayOfWeekName ||')' AS OperDate
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
      , tmpAfter AS (SELECT tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
                     FROM ( 
                           SELECT tmpOrderSheduleList.ContractId, min (DoW) AS DoW, 0 AS DoW_D
                           FROM tmpOrderSheduleList
                           WHERE tmpOrderSheduleList.DoW > vbCURRENT_DOW 
                             AND tmpOrderSheduleList.DoW > 0
                           GROUP BY tmpOrderSheduleList.ContractId
                         UNION
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
                            --, tmp.MovementId
                            , tmp.ChangePercent
                            , COALESCE(MovementPromo.OperDate, Null)  :: TDateTime   AS OperDatePromo
                            , COALESCE(MovementPromo.InvNumber, '') ::  TVarChar     AS InvNumberPromo -- ***
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
                            LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = tmp.MovementId
                       )

        -- Список цены + ТОП
      , GoodsPrice AS (SELECT Price_Goods.ChildObjectId           AS GoodsId
                            , COALESCE(Price_Top.ValueData,False) AS isTop   
                       FROM ObjectLink AS ObjectLink_Price_Unit
                            INNER JOIN ObjectBoolean     AS Price_Top
                                    ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                                   AND Price_Top.ValueData = True
                            LEFT JOIN ObjectLink       AS Price_Goods
                                   ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                       WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                       )

      , tmpMI_Child AS (SELECT MI_Child.ParentId AS MIMasterId
                             , MI_Child.Id       AS MIId
                        FROM MovementItem AS MI_Child 
                        WHERE MI_Child.MovementId = inMovementId
                          AND MI_Child.DescId     = zc_MI_Child()
                          AND MI_Child.isErased   = False
                        )

      , tmpGoodsMain AS (SELECT tmpMI.GoodsId
                              , COALESCE (ObjectBoolean_Goods_SP.ValueData,False)  :: Boolean  AS isSP
                              , CAST ((COALESCE (ObjectFloat_Goods_PriceOptSP.ValueData,0) * 1.1) AS NUMERIC (16,2))    :: TFloat   AS PriceOptSP
                              , CASE WHEN DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData) = vbOperDate THEN TRUE ELSE FALSE END  AS isMarketToday 
                              , DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData)                   ::TDateTime  AS LastPriceDate
                              , COALESCE (ObjectFloat_CountPrice.ValueData,0) ::TFloat AS CountPrice
                         FROM  _tmpOrderInternal_MI AS tmpMI
                                -- получаем GoodsMainId
                                LEFT JOIN  ObjectLink AS ObjectLink_Child 
                                                      ON ObjectLink_Child.ChildObjectId = tmpMI.GoodsId
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
                                LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                                     ON ObjectDate_LastPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()
                                LEFT JOIN ObjectFloat AS ObjectFloat_CountPrice
                                                      ON ObjectFloat_CountPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                     AND ObjectFloat_CountPrice.DescId = zc_ObjectFloat_Goods_CountPrice() 
                         )
  
      , tmpMI AS (SELECT tmpMI.*
                       , Object_Goods.ObjectCode                          AS GoodsCode
                       , Object_Goods.ValueData                           AS GoodsName
                       , ObjectLink_Object.ChildObjectId                  AS RetailId
                       , ObjectFloat_Goods_MinimumLot.ValueData           AS Multiplicity  --MinimumLot
                       , ObjectLink_Goods_GoodsGroup.ChildObjectId        AS GoodsGroupId
                       , ObjectLink_Goods_NDSKind.ChildObjectId           AS NDSKindId
                       , Object_NDSKind.ValueData                         AS NDSKindName
                       , ObjectFloat_NDSKind_NDS.ValueData                AS NDS
   
                       , CEIL(tmpMI.Amount / COALESCE(ObjectFloat_Goods_MinimumLot.ValueData, 1)) * COALESCE(ObjectFloat_Goods_MinimumLot.ValueData, 1) ::TFloat  AS CalcAmount
                       , COALESCE(Object_ConditionsKeep.ValueData, '')      :: TVarChar AS ConditionsKeepName
                       , tmpGoodsMain.isSP
                       , tmpGoodsMain.PriceOptSP
                       , tmpGoodsMain.isMarketToday       -- CURRENT_DATE
                       , tmpGoodsMain.LastPriceDate
                       , tmpGoodsMain.CountPrice
            
                  FROM  _tmpOrderInternal_MI AS tmpMI
                     
                        -- условия хранения
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                             ON ObjectLink_Goods_ConditionsKeep.ObjectId = tmpMI.GoodsId 
                                            AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                        LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId         
    
                        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
        
                        -- торговая сеть
                        LEFT JOIN  ObjectLink AS ObjectLink_Object 
                                              ON ObjectLink_Object.ObjectId = tmpMI.GoodsId
                                             AND ObjectLink_Object.DescId = zc_ObjectLink_Goods_Object()    
                                             
                        -- получаем GoodsMainId
                        LEFT JOIN tmpGoodsMain ON tmpGoodsMain.GoodsId = tmpMI.GoodsId 
                         
                      
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                             ON ObjectLink_Goods_NDSKind.ObjectId = tmpMI.GoodsId 
                                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
                
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                             ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId 
                                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                        LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_MinimumLot
                                               ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI.GoodsId 
                                              AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                              ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
                  )

      -- выбираю все MovementItemFloat
      , tmpMIF AS (SELECT *
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                   )
      
      , tmpMIF_Price AS (SELECT tmpMIF.*
                         FROM tmpMIF
                         WHERE tmpMIF.DescId = zc_MIFloat_PriceFrom() -- !!!не ошибка!!!
                         )

      , tmpMIF_JuridicalPrice AS (SELECT tmpMIF.*
                                  FROM tmpMIF
                                  WHERE tmpMIF.DescId = zc_MIFloat_JuridicalPrice()
                                  )
      , tmpMIF_Summ  AS (SELECT tmpMIF.*
                         FROM tmpMIF
                         WHERE tmpMIF.DescId = zc_MIFloat_Summ()
                         )
      , tmpMIF_AmountSecond AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_AmountSecond()  
                                )
      , tmpMIF_AmountManual AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_AmountManual()
                                 )

      , tmpMIString_Comment AS (SELECT MIString_Comment.*
                                FROM MovementItemString AS MIString_Comment 
                                WHERE MIString_Comment.DescId = zc_MIString_Comment()
                                  AND MIString_Comment.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                                )

      , tmpMIBoolean_Calculated AS (SELECT MIBoolean_Calculated.*
                                    FROM tmpMI
                                         INNER JOIN MovementItemBoolean AS MIBoolean_Calculated 
                                                ON MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                               AND MIBoolean_Calculated.MovementItemId = tmpMI.MovementItemId
                                   ) 
      -- на остатке стоит 0 и они были в заказе вчерашнем и позавчерашнем - НО их в приходе НЕТ сегодня и они опять повторно попали в текущий заказ. 
      -- Такие позиции лучше подсветить строку цветом - голубым, зеленым и сделать, наверно, допколонку - ограничить по таким позициям весь заказ. 
      -- Выбираем товары остаток =0, приход сегодня = 0
      , tmpGoodsList AS (SELECT tmpMI.GoodsId                AS GoodsId
                              , COALESCE (tmpMI.Amount, 0)   AS Amount
                              , COALESCE (tmpMI.Remains, 0)  AS Remains
                              , COALESCE (tmpMI.Income, 0)   AS Income
                         FROM tmpMI
                         WHERE COALESCE (tmpMI.Amount, 0) > 0   --COALESCE (tmpMI.Remains, 0) = 0 AND COALESCE (tmpMI.Income, 0) = 0 AND
                        )
      , tmpLastOrder AS (SELECT Movement.Id
                              , ROW_NUMBER() OVER (ORDER BY Movement.Id DESC, Movement.Operdate DESC) AS Ord
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MLO_Unit
                                                            ON MLO_Unit.MovementId = Movement.Id
                                                           AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                           AND MLO_Unit.ObjectId   = vbUnitId
                         WHERE Movement.DescId = zc_Movement_OrderInternal()
                           AND Movement.Operdate >= vbOperDate - INTERVAL '30 DAY' AND Movement.Operdate < vbOperDate
                        )
      -- заказы вчера / позавчера
      , tmpOrderLast_2days AS (SELECT tmpGoodsList.GoodsId
                                    , COUNT (DISTINCT Movement.Id) AS Amount
                               FROM tmpLastOrder AS Movement
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                    INNER JOIN tmpGoodsList ON tmpGoodsList.GoodsId = MovementItem.ObjectId
                                                           AND tmpGoodsList.Remains = 0 
                                                           AND tmpGoodsList.Income = 0 
                               WHERE Movement.Ord IN (1, 2)
                               GROUP BY tmpGoodsList.GoodsId
                               )
      -- повторный заказ  --позиции, которые уже заказаны в прошлом Автозаказе точки, но не пришли на точку и опять стоят в следующем Автозаказе а том же кол-ве или больше 
      , tmpRepeat AS (SELECT tmpGoods.GoodsId
                          ,  CASE WHEN tmpGoods.Amount >= COALESCE (MovementItem.Amount, 0) THEN TRUE ELSE FALSE END isRepeat 
                      FROM tmpLastOrder AS Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                           INNER JOIN (SELECT tmpGoodsList.GoodsId, tmpGoodsList.Amount
                                       FROM tmpGoodsList
                                       WHERE tmpGoodsList.Income = 0
                                       ) AS tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId 
                      WHERE Movement.Ord = 1
                     )  

      -- нет привязки по поставщику в последних 10 внутренних заказах
      -- товары без привязки к поставщику
      -- расчет через кнопку, т.к. отрабатывает не быстро
      , tmpGoodsNotLink AS (SELECT DISTINCT tmpGoodsList.GoodsId
                            FROM tmpGoodsList
                                 LEFT JOIN (SELECT DISTINCT tmpGoodsList.GoodsId
                                            FROM tmpGoodsList
                                               /*LEFT JOIN Object_LinkGoods_View AS LinkGoods_Partner_Main
                                                                                 ON LinkGoods_Partner_Main.GoodsId = tmpGoodsList.GoodsId  -- Связь товара поставщика с общим
                                     
                                                 INNER JOIN Object_LinkGoods_View AS LinkGoods_Main_Retail -- связь товара сети с главным товаром
                                                                                  ON LinkGoods_Main_Retail.GoodsMainId = LinkGoods_Partner_Main.GoodsMainId*/
                                                                                  
                                                 -- получаем GoodsMainId
                                                 INNER JOIN  ObjectLink AS ObjectLink_Child 
                                                                       ON ObjectLink_Child.ChildObjectId = tmpGoodsList.GoodsId 
                                                                      AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                                 LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                                                       ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                      AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
      
                                                 --  LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                                 --                                  ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                                 -- товары сети по главному GoodsMainId
                                                 LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain 
                                                                        ON ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()  
                                                                       AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = ObjectLink_Main.ChildObjectId --Object_LinkGoods_View.GoodsMainId
                                            
                                                 LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                                 ON ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                                                AND ObjectLink_LinkGoods_Goods.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                                                     
                                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                                                   ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                                   AND ObjectLink_Goods_Object.DescId  = zc_ObjectLink_Goods_Object()
                                                                                  
                                                 INNER JOIN Object ON Object.id = ObjectLink_Goods_Object.ChildObjectId AND Object.Descid = zc_Object_Juridical() 
                                            ) AS tmp ON tmp.GoodsId = tmpGoodsList.GoodsId
                            WHERE tmp.GoodsId IS NULL
                              AND inIsLink = TRUE
                            )

      , tmpOrderLast_10 AS (SELECT tmpGoodsNotLink.GoodsId
                                 , COUNT (DISTINCT Movement.Id) AS Amount
                            FROM tmpLastOrder AS Movement 
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                 INNER JOIN tmpGoodsNotLink ON tmpGoodsNotLink.GoodsId = MovementItem.ObjectId 
                            WHERE Movement.Ord <= 10
                            GROUP BY tmpGoodsNotLink.GoodsId
                            ) 
             
                                               
       -- Результат 1
       SELECT
             tmpMI.MovementItemId                                   AS Id
           , tmpMI.GoodsId                                          AS GoodsId
           , tmpMI.GoodsCode                                        AS GoodsCode
           , tmpMI.GoodsName                                        AS GoodsName
           , Object_Retail.ValueData                                AS RetailName
           , tmpMI.Multiplicity                                     AS Multiplicity
           , tmpMI.GoodsGroupId                                     AS GoodsGroupId
           , tmpMI.NDSKindId                                        AS NDSKindId
           , tmpMI.NDSKindName                                      AS NDSKindName
           , tmpMI.NDS                                              AS NDS

           , tmpMI.isTOP                                            AS isTOP
           , tmpMI.isUnitTOP                                        AS isTOP_Price
           , tmpMI.isClose
           , tmpMI.isFirst
           , tmpMI.isSecond
           , tmpMI.isSP

           , tmpMI.isMarketToday
           , tmpMI.LastPriceDate  

           , CASE WHEN tmpMI.isSP = TRUE THEN 25088 --zc_Color_GreenL()
                  WHEN tmpMI.isTOP = TRUE OR tmpMI.isUnitTOP = TRUE THEN 16440317         --12615935      ---16440317  - розовый как в приходе ELSE zc_Color_White()
                  ELSE zc_Color_White() --0
             END                                                    AS isTopColor
           , tmpMI.CalcAmount
           , tmpMI.Amount   ::TFloat                                AS Amount
           , COALESCE(MIFloat_Summ.ValueData, 0)  ::TFloat          AS Summ
           , COALESCE (tmpMI.isErased, FALSE)     ::Boolean         AS isErased
           , COALESCE (MIFloat_Price.ValueData,0) ::TFloat          AS Price            -- !!!на самом деле здесь zc_MIFloat_PriceFrom!!!
           , COALESCE (MIFloat_JuridicalPrice.ValueData,0) ::TFloat AS SuperFinalPrice

           , tmpMI.PriceOptSP
           , CASE WHEN tmpMI.isSP = TRUE AND MIFloat_Price.ValueData > tmpMI.PriceOptSP THEN TRUE ELSE FALSE END isPriceDiff
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
           , CASE WHEN tmpMI.isSP = TRUE THEN 25088 --zc_Color_GreenL()   --товар соц.проекта
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
           , tmpMI.CountPrice
           , COALESCE (tmpOneJuridical.isOneJuridical, TRUE) :: Boolean AS isOneJuridical
           
           , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN False ELSE True END  ::Boolean AS isPromo
           , COALESCE(GoodsPromo.OperDatePromo, Null)  :: TDateTime   AS OperDatePromo
           , COALESCE(GoodsPromo.InvNumberPromo, '')   ::  TVarChar   AS InvNumberPromo -- ***
           
           , CASE WHEN COALESCE(OrderSheduleListToday.DOW,  0) = 0 THEN False ELSE TRUE END AS isZakazToday
           , CASE WHEN COALESCE(OrderSheduleListToday.DoW_D,0) = 0 THEN False ELSE TRUE END AS isDostavkaToday
           , OrderSheduleList.OperDate_Zakaz    ::TVarChar AS OperDate_Zakaz
           , OrderSheduleList.OperDate_Dostavka ::TVarChar AS OperDate_Dostavka

           , tmpMI.ConditionsKeepName

           , CASE WHEN COALESCE(OrderSheduleListToday.DOW,  0) <> 0 THEN 12910591      -- бледно желтый
                  WHEN COALESCE (tmpOrderLast_2days.Amount, 0)  > 1 THEN 16777134      -- цвет фона - голубой подрязд 2 дня заказ; 
                  WHEN COALESCE (tmpOrderLast_10.Amount, 0)     > 9 THEN 167472630     -- цвет фона - розовый подрязд 10 заказов нет привязки к товару поставщика; 
                  ELSE zc_Color_White()
             END  AS OrderShedule_Color  

           
           , CASE WHEN COALESCE (tmpOrderLast_2days.Amount, 0) > 1 THEN 16777134   -- цвет фона - голубой подрязд 2 дня заказ; 
                  WHEN COALESCE (tmpOrderLast_10.Amount, 0) > 9 THEN 167472630     -- цвет фона - розовый подрязд 10 заказов нет привязки к товару поставщика; 
                  ELSE  zc_Color_White()
             END  AS Fond_Color
             
           , CASE WHEN COALESCE (tmpOrderLast_2days.Amount, 0) > 1 THEN TRUE  
                  ELSE  FALSE
             END  AS isLast_2days
           , COALESCE (tmpRepeat.isRepeat, FALSE) AS isRepeat  
        
           -- , tmpJuridicalArea.AreaId                                      AS AreaId
           -- , COALESCE (tmpJuridicalArea.AreaName, '')      :: TVarChar    AS AreaName
           
           -- , Object_Area.ValueData                         :: TVarChar    AS AreaName_Goods
           
           , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean     AS isDefault
           
       FROM tmpMI        --_tmpOrderInternal_MI AS
            LEFT JOIN (SELECT tmpMI.MIMasterId, CASE WHEN COUNT (*) > 1 THEN FALSE ELSE TRUE END AS isOneJuridical
                       FROM tmpMI_Child AS tmpMI
                       GROUP BY tmpMI.MIMasterId
                      ) AS tmpOneJuridical ON tmpOneJuridical.MIMasterId = tmpMI.MovementItemId           

            LEFT JOIN Object AS Object_PartnerGoods ON Object_PartnerGoods.Id = tmpMI.PartnerGoodsId
            LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpMI.JuridicalId
                                AND GoodsPromo.GoodsId = tmpMI.GoodsId                                    

            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = tmpMI.RetailId
            
            LEFT JOIN OrderSheduleList ON OrderSheduleList.ContractId = tmpMI.ContractId                  
            LEFT JOIN OrderSheduleListToday ON OrderSheduleListToday.ContractId = tmpMI.ContractId        

            LEFT JOIN tmpMIBoolean_Calculated AS MIBoolean_Calculated ON MIBoolean_Calculated.MovementItemId = tmpMI.MovementItemId    

            LEFT JOIN tmpMIF_Price          AS MIFloat_Price          ON MIFloat_Price.MovementItemId          = tmpMI.MovementItemId  
            LEFT JOIN tmpMIF_JuridicalPrice AS MIFloat_JuridicalPrice ON MIFloat_JuridicalPrice.MovementItemId = tmpMI.MovementItemId  
            LEFT JOIN tmpMIF_Summ           AS MIFloat_Summ           ON MIFloat_Summ.MovementItemId           = tmpMI.MovementItemId  
            LEFT JOIN tmpMIF_AmountSecond   AS MIFloat_AmountSecond   ON MIFloat_AmountSecond.MovementItemId   = tmpMI.MovementItemId  
            LEFT JOIN tmpMIF_AmountManual   AS MIFloat_AmountManual   ON MIFloat_AmountManual.MovementItemId   = tmpMI.MovementItemId  

            LEFT JOIN tmpMIString_Comment AS MIString_Comment ON MIString_Comment.MovementItemId = tmpMI.MovementItemId      
            
            LEFT JOIN tmpOrderLast_2days ON tmpOrderLast_2days.GoodsId   = tmpMI.GoodsId 
            LEFT JOIN tmpOrderLast_10    ON tmpOrderLast_10.GoodsId      = tmpMI.GoodsId
            LEFT JOIN tmpRepeat          ON tmpRepeat.GoodsId            = tmpMI.GoodsId
            
            LEFT JOIN tmpJuridicalArea   ON tmpJuridicalArea.JuridicalId = tmpMI.JuridicalId
            
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Area 
                                 ON ObjectLink_Goods_Area.ObjectId = tmpMI.PartnerGoodsId
                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId
           ;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
     WITH  
        PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (vbUserId::TVarChar))
      , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (vbUserId::TVarChar))

      , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS T WHERE T.MainJuridicalId = vbMainJuridicalId)

       -- Маркетинговый контракт
      , GoodsPromo AS (SELECT tmp.JuridicalId
                            , ObjectLink_Child_retail.ChildObjectId AS GoodsId        -- здесь товар "сети"
                            , tmp.MovementId
                            , tmp.ChangePercent
                            , COALESCE(MovementPromo.OperDate, Null)  :: TDateTime   AS OperDatePromo
                            , COALESCE(MovementPromo.InvNumber, '') ::  TVarChar     AS InvNumberPromo -- ***
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
                                        LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = tmp.MovementId
                      )
 
      , tmpMI_Child AS (SELECT MI_Child.ParentId
                             , MI_Child.Id 
                             , MI_Child.ObjectId
                             , MI_Child.Amount
                        FROM MovementItem AS MI_Child 
                        WHERE MI_Child.MovementId = inMovementId
                          AND MI_Child.DescId     = zc_MI_Child()
                          AND (MI_Child.IsErased = inIsErased OR inIsErased = True)
                        )
--
      , tmpMIDate_PartionGoods AS (SELECT MIDate_PartionGoods.*
                                   FROM tmpMI_Child
                                        LEFT JOIN MovementItemDate AS MIDate_PartionGoods                                           
                                               ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                              AND MIDate_PartionGoods.MovementItemId = tmpMI_Child.Id
                         )
      , tmpMIFloat_Price AS (SELECT MIFloat_Price.*
                             FROM tmpMI_Child
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price                                           
                                         ON MIFloat_Price.DescId = zc_MIFloat_Price()
                                        AND MIFloat_Price.MovementItemId = tmpMI_Child.Id
                         )
      , tmpMIFloat_JuridicalPrice AS (SELECT MIFloat_JuridicalPrice.*
                                      FROM tmpMI_Child
                                           LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice                                           
                                                  ON MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                                                 AND MIFloat_JuridicalPrice.MovementItemId = tmpMI_Child.Id
                                      )           
      , tmpMIString_Maker AS (SELECT MIString_Maker.*
                              FROM tmpMI_Child
                                   LEFT JOIN MovementItemString AS MIString_Maker 
                                          ON MIString_Maker.DescId = zc_MIString_Maker()
                                         AND MIString_Maker.MovementItemId = tmpMI_Child.Id             -- and 1=0
                              ) 
      , tmpJuridical AS (SELECT MILinkObject_Juridical.MovementItemId
                                    , Object_Juridical.Id                 AS JuridicalId
                                    , Object_Juridical.ValueData          AS JuridicalName
                         FROM tmpMI_Child
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical 
                                     ON MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()     --and 1=0
                                    AND MILinkObject_Juridical.MovementItemId = tmpMI_Child.Id
                              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILinkObject_Juridical.ObjectId 
                        ) 
      , tmpContract AS (SELECT MILinkObject_Contract.MovementItemId
                                    , Object_Contract.Id                 AS ContractId
                                    , Object_Contract.ValueData          AS ContractName
                                    , ObjectFloat_Deferment.ValueData    AS Deferment
                        FROM tmpMI_Child
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract 
                                                              ON MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                                             AND MILinkObject_Contract.MovementItemId = tmpMI_Child.Id     
                             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId
                 
                             LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                                                   ON ObjectFloat_Deferment.ObjectId = Object_Contract.Id
                                                  AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
                        ) 
           
      , tmpGoods AS (SELECT tmpMI_Child.ObjectId             AS GoodsId
                          , Object_Goods.ObjectCode          AS GoodsCode
                          , Object_Goods.ValueData           AS GoodsName 
                          , ObjectFloat_Goods_MinimumLot.ValueData    AS MinimumLot
                          , Object_ConditionsKeep.ValueData           AS ConditionsKeepName
                     FROM tmpMI_Child
                          -- условия хранения
                          LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                               ON ObjectLink_Goods_ConditionsKeep.ObjectId = tmpMI_Child.ObjectId
                                              AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                          LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
             
                          LEFT JOIN ObjectFloat AS ObjectFloat_Goods_MinimumLot
                                                ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI_Child.ObjectId 
                                               AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
             
                          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Child.ObjectId
                    )
                    
        SELECT tmpMI.MovementItemId                           AS MovementItemId
             , MI_Child.Id 
             , tmpGoods.GoodsCode
             , tmpGoods.GoodsName --_tmpMI.GoodsName
             , COALESCE(JuridicalSettings.Bonus, 0)::TFloat   AS Bonus
             , COALESCE (tmpContract.Deferment, 0)::Integer   AS Deferment
---
             , CASE WHEN COALESCE (tmpContract.Deferment, 0) = 0
                         THEN 0
                    WHEN tmpMI.isTOP = TRUE
                         THEN COALESCE (PriceSettingsTOP.Percent, 0)
                    ELSE PriceSettings.Percent
               END :: TFloat AS Percent
---
             , CASE WHEN COALESCE (tmpContract.Deferment, 0) = 0 AND tmpMI.isTOP = TRUE
                        THEN COALESCE (PriceSettingsTOP.Percent, 0)
                   WHEN COALESCE (tmpContract.Deferment, 0) = 0 AND tmpMI.isTOP = FALSE
                        THEN COALESCE (PriceSettings.Percent, 0)
                   ELSE 0
              END :: TFloat AS Percent
---            
              , tmpJuridical.JuridicalName
              , MIString_Maker.ValueData                      AS MakerName
              , tmpContract.ContractName
              , COALESCE(MIDate_PartionGoods.ValueData, Null) ::TDateTime AS PartionGoodsDate
              , CASE WHEN MIDate_PartionGoods.ValueData < vbDate180 THEN zc_Color_Blue() --456
                     ELSE 0
                END                                           AS PartionGoodsDateColor      
              , tmpGoods.MinimumLot                 ::TFLoat  AS MinimumLot
              , MI_Child.Amount                     ::TFLoat  AS Remains
              , MIFloat_Price.ValueData             ::TFLoat  AS Price 
              , MIFloat_JuridicalPrice.ValueData    ::TFLoat  AS SuperFinalPrice

              , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN False ELSE True END  ::Boolean AS isPromo
              , COALESCE(GoodsPromo.OperDatePromo, Null)   :: TDateTime  AS OperDatePromo
              , COALESCE(GoodsPromo.InvNumberPromo, '')    :: TVarChar   AS InvNumberPromo -- ***
              , COALESCE(GoodsPromo.ChangePercent, 0)      :: TFLoat     AS ChangePercentPromo
              , COALESCE(tmpGoods.ConditionsKeepName, '')  :: TVarChar   AS ConditionsKeepName
              
              , tmpJuridicalArea.AreaId                                   AS AreaId
              , COALESCE (tmpJuridicalArea.AreaName, '')      :: TVarChar AS AreaName
              
              , Object_Area.ValueData                         :: TVarChar AS AreaName_Goods
              
              , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean  AS isDefault
              
        FROM _tmpOrderInternal_MI AS tmpMI
             INNER JOIN tmpMI_Child AS MI_Child ON MI_Child.ParentId = tmpMI.MovementItemId
             LEFT JOIN tmpGoods                 ON tmpGoods.GoodsId  = MI_Child.ObjectId

             LEFT JOIN tmpMIDate_PartionGoods    AS MIDate_PartionGoods    ON MIDate_PartionGoods.MovementItemId    = MI_Child.Id
             LEFT JOIN tmpMIFloat_Price          AS MIFloat_Price          ON MIFloat_Price.MovementItemId          = MI_Child.Id
             LEFT JOIN tmpMIFloat_JuridicalPrice AS MIFloat_JuridicalPrice ON MIFloat_JuridicalPrice.MovementItemId = MI_Child.Id
             LEFT JOIN tmpMIString_Maker         AS MIString_Maker         ON MIString_Maker.MovementItemId         = MI_Child.Id 
             LEFT JOIN tmpJuridical                                        ON tmpJuridical.MovementItemId           = MI_Child.Id
             LEFT JOIN tmpContract                                         ON tmpContract.MovementItemId            = MI_Child.Id   
             
             LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId = tmpJuridical.JuridicalId --MovementItemLastPriceList_View.JuridicalId 
                                        AND JuridicalSettings.ContractId  = tmpContract.ContractId     --MovementItemLastPriceList_View.ContractId

             LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpJuridical.JuridicalId
                                 AND GoodsPromo.GoodsId     = tmpMI.GoodsId            --             and 1=0

             LEFT JOIN PriceSettings    ON MIFloat_Price.ValueData BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice  -- and 1=0
             LEFT JOIN PriceSettingsTOP ON MIFloat_Price.ValueData BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice  -- and 1=0

             --LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = GoodsPromo.MovementId
             LEFT JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = tmpJuridical.JuridicalId
             
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Area 
                                 ON ObjectLink_Goods_Area.ObjectId = tmpMI.PartnerGoodsId
                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId
            
          ;

     RETURN NEXT Cursor2;


    ELSE


    -- !!!Только для ДРУГИХ документов!!!

   PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, 0, vbUserId);
   --RAISE EXCEPTION 'Ошибка.';
    OPEN Cursor1 FOR
     WITH
     --Данные Справочника График заказа/доставки
        tmpDateList AS (SELECT ''||tmpDayOfWeek.DayOfWeekName|| '-' || DATE_PART ('day', tmp.OperDate :: Date) ||'' AS OperDate
                             --''||tmp.OperDate :: Date || ' (' ||tmpDayOfWeek.DayOfWeekName ||')' AS OperDate
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
      , tmpAfter AS (SELECT tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
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
                           GROUP BY tmpOrderSheduleList.ContractId
                           ) AS tmp
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
      , tmpCheck AS (SELECT MI_Check.ObjectId                       AS GoodsId
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
                      WHERE Movement_Check.OperDate >= vbOperDate 
                        AND Movement_Check.OperDate < vbOperDateEnd
                       AND Movement_Check.DescId = zc_Movement_Check()
                       AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                     GROUP BY MI_Check.ObjectId 
                     HAVING SUM (MI_Check.Amount) <> 0 
                     )
       -- автоперемещения приход
      , tmpSend AS ( SELECT MI_Send.ObjectId                AS GoodsId
                          , SUM (MI_Send.Amount) ::TFloat   AS Amount
                     FROM Movement AS Movement_Send
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Send.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId
                            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                      ON MovementBoolean_Deferred.MovementId = Movement_Send.Id
                                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                            -- закомментил - пусть будут все перемещения, не только Авто
                            /*INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                       ON MovementBoolean_isAuto.MovementId = Movement_Send.Id
                                                      AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                      AND MovementBoolean_isAuto.ValueData  = TRUE*/
                            INNER JOIN MovementItem AS MI_Send
                                                    ON MI_Send.MovementId = Movement_Send.Id
                                                   AND MI_Send.DescId = zc_MI_Master()
                                                   AND MI_Send.isErased = FALSE
                     -- WHERE Movement_Send.OperDate >= vbOperDate - interval '30 DAY' 
                     WHERE Movement_Send.OperDate BETWEEN CURRENT_DATE - INTERVAL '30 DAY' AND CURRENT_DATE + INTERVAL '30 DAY'
                       AND Movement_Send.OperDate < vbOperDateEnd
                       AND Movement_Send.DescId = zc_Movement_Send()
                       AND Movement_Send.StatusId = zc_Enum_Status_UnComplete()
                       AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                     GROUP BY MI_Send.ObjectId
                     HAVING SUM (MI_Send.Amount) <> 0 
                    )

     -- Заказ отложен
      , tmpDeferred_All AS (SELECT Movement_OrderExternal.Id
                                 , MI_OrderExternal.ObjectId                AS GoodsId
                                 , SUM (MI_OrderExternal.Amount) ::TFloat   AS Amount 
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
                            WHERE Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
                              AND Movement_OrderExternal.StatusId = zc_Enum_Status_Complete()
                            GROUP BY MI_OrderExternal.ObjectId, Movement_OrderExternal.Id
                            HAVING SUM (MI_OrderExternal.Amount) <> 0 
                       )
      , tmpDeferred AS (SELECT Movement_OrderExternal.GoodsId                 AS GoodsId
                             , SUM (Movement_OrderExternal.Amount) ::TFloat   AS AmountDeferred 
                        FROM tmpDeferred_All AS Movement_OrderExternal
                            LEFT JOIN MovementLinkMovement AS MLM_Order
                                                           ON MLM_Order.MovementChildId = Movement_OrderExternal.Id     --MLM_Order.MovementId = Movement_Income.Id
                                                          AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                        WHERE MLM_Order.MovementId is Null
                        GROUP BY Movement_OrderExternal.GoodsId
                        HAVING SUM (Movement_OrderExternal.Amount) <> 0 
                       )
 
        -- Маркетинговый контракт
      , GoodsPromo AS (SELECT tmp.JuridicalId
                            , ObjectLink_Child_retail.ChildObjectId AS GoodsId        -- здесь товар "сети"
                            , tmp.MovementId
                            , tmp.ChangePercent
                            , MovementPromo.OperDate                AS OperDatePromo
                            , MovementPromo.InvNumber               AS InvNumberPromo -- ***
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
                                        LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = tmp.MovementId
                      )
        -- Список цены + ТОП
      , GoodsPrice AS (SELECT Price_Goods.ChildObjectId           AS GoodsId
                            , COALESCE(Price_Top.ValueData,False) AS isTop   
                       FROM ObjectLink AS ObjectLink_Price_Unit
                            INNER JOIN ObjectBoolean     AS Price_Top
                                    ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                                   AND Price_Top.ValueData = True
                            LEFT JOIN ObjectLink       AS Price_Goods
                                   ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                       WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
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
                         AND MovementDate_Branch.ValueData BETWEEN CURRENT_DATE - INTERVAL '7 DAY' AND CURRENT_DATE + INTERVAL '7 DAY'
                         AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                       GROUP BY MovementItem_Income.ObjectId
                     ) 

      , tmpOF_Goods_MinimumLot AS (SELECT *
                                   FROM ObjectFloat 
                                   WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                     AND COALESCE (ObjectFloat.ValueData, 0) <> 0
                       )
                           
      , tmpMI_All AS (SELECT MovementItem.*
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                         )
        
      , tmpMI_Master AS (SELECT tmpMI.*
                              , CEIL(tmpMI.Amount / COALESCE(ObjectFloat_Goods_MinimumLot.ValueData , 1)) 
                                * COALESCE(ObjectFloat_Goods_MinimumLot.ValueData , 1)                       AS CalcAmount
                              , ObjectFloat_Goods_MinimumLot.ValueData                                       AS MinimumLot
                              
                              /*, Object_Goods.ObjectCode                                                    AS GoodsCode     -- GoodsCodeInt
                              , Object_Goods.ValueData                                                       AS GoodsName
                               , ObjectLink_Goods_GoodsGroup.ChildObjectId                                   AS GoodsGroupId
                              , ObjectLink_Goods_NDSKind.ChildObjectId                                       AS NDSKindId
                              , Object_NDSKind.ValueData                                                     AS NDSKindName
                              , ObjectFloat_NDSKind_NDS.ValueData                                            AS NDS
                              , COALESCE(ObjectBoolean_Goods_Close.ValueData, false)                         AS isClose
                              , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)                           AS Goods_isTOP
                              , COALESCE(ObjectBoolean_First.ValueData, False)                               AS isFirst
                              , COALESCE(ObjectBoolean_Second.ValueData, False)                              AS isSecond
                              */
                              , COALESCE (GoodsPrice.isTOP, False)                                           AS Price_isTOP
            
                         FROM tmpMI_All AS tmpMI
                               --LEFT JOIN tmpGoodsMain ON tmpGoodsMain.GoodsId = tmpMI.ObjectId
                               LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = tmpMI.ObjectId
       
                               LEFT JOIN tmpOF_Goods_MinimumLot AS ObjectFloat_Goods_MinimumLot
                                                                ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI.ObjectId
                                                              -- AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                         )

      , tmpGoods AS (SELECT ObjectLink_Goods_Object.ObjectId                       AS GoodsId
                          , Object_Goods.ObjectCode                                AS GoodsCode
                          , Object_Goods.ValueData                                 AS GoodsName
                          , ObjectLink_Goods_GoodsGroup.ChildObjectId              AS GoodsGroupId
                          , ObjectLink_Goods_NDSKind.ChildObjectId                 AS NDSKindId
                          , Object_NDSKind.ValueData                               AS NDSKindName
                          , ObjectFloat_NDSKind_NDS.ValueData                      AS NDS
                          , ObjectFloat_Goods_MinimumLot.ValueData                 AS Multiplicity
                          , COALESCE(ObjectBoolean_Goods_Close.ValueData, false)   AS isClose
                          , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)     AS Goods_isTOP
                          , COALESCE (GoodsPrice.isTop, False)                     AS Price_isTOP
                          , COALESCE(ObjectBoolean_First.ValueData, False)         AS isFirst
                          , COALESCE(ObjectBoolean_Second.ValueData, False)        AS isSecond

                     FROM ObjectLink AS ObjectLink_Goods_Object
                          INNER JOIN Object AS Object_Goods 
                                            ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 
                                           AND Object_Goods.isErased = FALSE

                          LEFT JOIN tmpMI_Master ON tmpMI_Master.ObjectId = ObjectLink_Goods_Object.ObjectId

                          LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = Object_Goods.Id

                          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                               ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_Goods_Object.ObjectId
                                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

                          LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                               ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                              AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                          LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
                  
                          LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                               AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                  
                          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                                  ON ObjectBoolean_Goods_Close.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                 AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()
                  
                          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                  ON ObjectBoolean_Goods_TOP.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                 AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
                  
                          LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                                  ON ObjectBoolean_First.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                 AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First() 
                          LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                                  ON ObjectBoolean_Second.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                 AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second() 
                         
                          LEFT JOIN tmpOF_Goods_MinimumLot  AS ObjectFloat_Goods_MinimumLot
                                                 ON ObjectFloat_Goods_MinimumLot.ObjectId = ObjectLink_Goods_Object.ObjectId
                                           --     AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                     WHERE (inShowAll = TRUE OR tmpMI_Master.Id is not null)
                       AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                       AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                    )
                    
      , tmpMIF AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Master.Id FROM tmpMI_Master)
                   )
      , tmpMIF_Summ AS (SELECT tmpMIF.*
                        FROM tmpMIF
                        WHERE tmpMIF.DescId = zc_MIFloat_Summ()
                        )
      , tmpMIF_AmountSecond AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_AmountSecond()
                                )
      , tmpMIF_AmountManual AS (SELECT tmpMIF.*
                        FROM tmpMIF
                        WHERE tmpMIF.DescId = zc_MIFloat_AmountManual() 
                                )

      , tmpMILinkObject_Juridical AS (SELECT MILinkObject_Juridical.*
                                      FROM tmpMI_Master
                                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical
                                                  ON MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                                                 AND MILinkObject_Juridical.MovementItemId = tmpMI_Master.Id
                                     ) 
      , tmpMILinkObject_Contract AS (SELECT MILinkObject_Contract.*                                     
                                     FROM tmpMI_Master
                                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract 
                                                 ON MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                                AND MILinkObject_Contract.MovementItemId = tmpMI_Master.Id 
                                    ) 
      , tmpMILinkObject_Goods AS (SELECT MILinkObject_Goods.*
                                  FROM tmpMI_Master
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods 
                                              ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                             AND MILinkObject_Goods.MovementItemId = tmpMI_Master.Id
                                 )
                                                       
      , tmpMIString_Comment AS (SELECT MIString_Comment.*
                                FROM MovementItemString AS MIString_Comment 
                                WHERE MIString_Comment.DescId = zc_MIString_Comment()
                                  AND MIString_Comment.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                )

      , tmpMIBoolean_Calculated AS (SELECT MIBoolean_Calculated.*
                                    FROM tmpMI_Master
                                         INNER JOIN MovementItemBoolean AS MIBoolean_Calculated 
                                                ON MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                               AND MIBoolean_Calculated.MovementItemId = tmpMI_Master.Id
                                   ) 

      , tmpMinPrice AS (SELECT *
                        FROM (SELECT *, MIN(Id) OVER (PARTITION BY MovementItemId) AS MinId
                              FROM (SELECT *
                                         , MIN (SuperFinalPrice) OVER (PARTITION BY MovementItemId) AS MinSuperFinalPrice
                                    FROM _tmpMI
                                   ) AS DDD
                              WHERE DDD.SuperFinalPrice = DDD.MinSuperFinalPrice
                             ) AS DDD
                        WHERE Id = MinId
                       )      
                               
      , tmpMI AS (SELECT MovementItem.Id
                       , MovementItem.ObjectId                                            AS GoodsId
                       , MovementItem.Amount                                              AS Amount
                       , MovementItem.CalcAmount
                       , MIFloat_Summ.ValueData                                           AS Summ
                       , MovementItem.MinimumLot                                          AS Multiplicity
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
                       --, MovementItem.Goods_isTOP
                       , MovementItem.Price_isTOP
                       , MIFloat_AmountSecond.ValueData                                   AS AmountSecond
                       , MovementItem.Amount+COALESCE(MIFloat_AmountSecond.ValueData,0)   AS AmountAll
                       , CEIL((MovementItem.Amount+COALESCE(MIFloat_AmountSecond.ValueData,0)) / COALESCE(MovementItem.MinimumLot, 1))
                          * COALESCE(MovementItem.MinimumLot, 1)                          AS CalcAmountAll
                       , MIFloat_AmountManual.ValueData                                   AS AmountManual
                       , MovementItem.isErased
                  FROM tmpMI_Master AS MovementItem                       

                       LEFT JOIN tmpMILinkObject_Juridical AS MILinkObject_Juridical ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                                       
                       LEFT JOIN tmpMILinkObject_Contract AS MILinkObject_Contract ON MILinkObject_Contract.MovementItemId = MovementItem.Id

                       LEFT JOIN tmpMILinkObject_Goods AS MILinkObject_Goods ON MILinkObject_Goods.MovementItemId = MovementItem.Id

                       LEFT JOIN tmpMIBoolean_Calculated AS MIBoolean_Calculated ON MIBoolean_Calculated.MovementItemId = MovementItem.Id

                       LEFT JOIN tmpMIString_Comment AS MIString_Comment ON MIString_Comment.MovementItemId = MovementItem.Id  

                       LEFT JOIN _tmpMI AS PriceList ON COALESCE (PriceList.ContractId, 0) = COALESCE (MILinkObject_Contract.ObjectId, 0)
                                                    AND PriceList.JuridicalId = MILinkObject_Juridical.ObjectId
                                                    AND PriceList.GoodsId = MILinkObject_Goods.ObjectId
                                                    AND PriceList.MovementItemId = MovementItem.Id

                       LEFT JOIN tmpMinPrice AS MinPrice ON MinPrice.MovementItemId = MovementItem.Id
                            
                       LEFT JOIN tmpOF_Goods_MinimumLot AS ObjectFloat_Goods_MinimumLot
                                                        ON ObjectFloat_Goods_MinimumLot.ObjectId = COALESCE (PriceList.GoodsId, MinPrice.GoodsId)
                                            --- AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                             
                       LEFT JOIN tmpMIF_Summ AS MIFloat_Summ ON MIFloat_Summ.MovementItemId = MovementItem.Id
                       LEFT JOIN tmpMIF_AmountSecond AS MIFloat_AmountSecond ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                       LEFT JOIN tmpMIF_AmountManual AS MIFloat_AmountManual ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
--LIMIT 2
                  )

      , tmpPriceView AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                              , MCS_Value.ValueData                     AS MCSValue
                              , Price_Goods.ChildObjectId               AS GoodsId
                              , COALESCE(MCS_isClose.ValueData,False)   AS MCSIsClose
                              , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc
                              , COALESCE(Price_Top.ValueData,False)     AS isTop
                         FROM ObjectLink AS ObjectLink_Price_Unit
                              LEFT JOIN ObjectLink AS Price_Goods
                                                   ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                               
                              LEFT JOIN tmpMI_Master ON tmpMI_Master.ObjectId = Price_Goods.ChildObjectId  -- goodsId
                              LEFT JOIN ObjectFloat AS MCS_Value
                                                    ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                              LEFT JOIN ObjectBoolean AS MCS_isClose
                                                      ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                              LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                                      ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                              LEFT JOIN ObjectBoolean AS Price_Top
                                                      ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                         WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                           AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                           AND (inShowAll = TRUE OR tmpMI_Master.Id is not null)
                      )

      , tmpData AS (SELECT tmpMI.Id                                                AS Id
                         , COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)              AS GoodsId
                         , tmpGoods.GoodsCode                                      AS GoodsCode
                         , tmpGoods.GoodsName                                      AS GoodsName
                         , tmpGoods.Goods_isTOP                                    AS isTOP
                         , tmpGoods.GoodsGroupId                                   AS GoodsGroupId
                         , tmpGoods.NDSKindId                                      AS NDSKindId
                         , tmpGoods.NDSKindName                                    AS NDSKindName
                         , tmpGoods.NDS                                            AS NDS
                         , tmpGoods.isClose                                        AS isClose
                         , tmpGoods.isFirst                                        AS isFirst
                         , tmpGoods.isSecond                                       AS isSecond
                         --
                         , COALESCE (tmpMI.Multiplicity, tmpGoods.Multiplicity)    AS Multiplicity
                         , tmpMI.CalcAmount                                        AS CalcAmount
                         , NULLIF(tmpMI.Amount,0)                                  AS Amount
                         , tmpMI.Price * tmpMI.CalcAmount                          AS Summ
                         , COALESCE (tmpMI.isErased, FALSE)                        AS isErased
                         , tmpMI.Price
                         , tmpMI.MinimumLot
                         , tmpMI.PartionGoodsDate
                         , tmpMI.Comment
                         , tmpMI.PartnerGoodsId
                         , tmpMI.PartnerGoodsCode 
                         , tmpMI.PartnerGoodsName
                         , tmpMI.JuridicalId
                         , tmpMI.JuridicalName                                     -- ***
                         , tmpMI.ContractId
                         , tmpMI.ContractName
                         , tmpMI.MakerName
                         , tmpMI.SuperFinalPrice 
                         , COALESCE(tmpMI.isCalculated, FALSE)                     AS isCalculated
                         , tmpMI.AmountSecond                                      AS AmountSecond
                         , NULLIF(tmpMI.AmountAll,0)                               AS AmountAll
                         , NULLIF(COALESCE(tmpMI.AmountManual,tmpMI.CalcAmountAll),0)      AS CalcAmountAll
                         , tmpMI.Price * COALESCE(tmpMI.AmountManual,tmpMI.CalcAmountAll)  AS SummAll
                    FROM tmpGoods
                         FULL JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId 
                   )

      , tmpOB_SP AS (SELECT *
                     FROM ObjectBoolean AS ObjectBoolean_Goods_SP 
                     WHERE ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()
                       AND COALESCE (ObjectBoolean_Goods_SP.ValueData, False) = TRUE
                    )
      , tmpOF_Main AS (SELECT *
                       FROM ObjectFloat
                       WHERE ObjectFloat.DescId IN (zc_ObjectFloat_Goods_PriceOptSP(), zc_ObjectFloat_Goods_CountPrice())
                       )
      , tmpGoodsMain AS (SELECT tmpMI.GoodsId                                                           AS GoodsId
                              , COALESCE (ObjectBoolean_Goods_SP.ValueData, False)          :: Boolean  AS isSP
                              , CAST ((COALESCE (ObjectFloat_Goods_PriceOptSP.ValueData,0) * 1.1) AS NUMERIC (16,2))    :: TFloat   AS PriceOptSP
                              , CASE WHEN DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData) = vbOperDate THEN TRUE ELSE FALSE END  AS isMarketToday 
                              , DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData)          ::TDateTime AS LastPriceDate
                              , COALESCE (ObjectFloat_CountPrice.ValueData,0)               ::TFloat    AS CountPrice
                         FROM tmpData AS tmpMI
                                -- получаем GoodsMainId
                                LEFT JOIN ObjectLink AS ObjectLink_Child 
                                                     ON ObjectLink_Child.ChildObjectId = tmpMI.GoodsId
                                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                LEFT JOIN ObjectLink AS ObjectLink_Main 
                                                     ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                    AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                LEFT JOIN tmpOB_SP AS ObjectBoolean_Goods_SP 
                                                   ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId
                                                   
                                LEFT JOIN tmpOF_Main AS ObjectFloat_Goods_PriceOptSP
                                                     ON ObjectFloat_Goods_PriceOptSP.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectFloat_Goods_PriceOptSP.DescId = zc_ObjectFloat_Goods_PriceOptSP()

                                LEFT JOIN tmpOF_Main AS ObjectFloat_CountPrice
                                                     ON ObjectFloat_CountPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectFloat_CountPrice.DescId = zc_ObjectFloat_Goods_CountPrice()
                                                     
                                LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                                     ON ObjectDate_LastPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()
                         )

      -- условия хранения
      , tmpGoodsConditionsKeep AS (SELECT ObjectLink_Goods_ConditionsKeep.ObjectId                  AS GoodsId
                                        , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
                                   FROM ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                        LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
                                   WHERE ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep() 
                                     AND ObjectLink_Goods_ConditionsKeep.ObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpData AS tmpMI)
                                  )
                                  
      -- на остатке стоит 0 и они были в заказе вчерашнем и позавчерашнем - НО их в приходе НЕТ сегодня и они опять повторно попали в текущий заказ.
      -- Такие позиции лучше подсветить строку цветом - голубым, зеленым и сделать, наверно, допколонку - ограничить по таким позициям весь заказ.
      -- Выбираем товары
      , tmpGoodsList AS (SELECT tmpMI.GoodsId                      AS GoodsId
                              , COALESCE (tmpMI.Amount, 0)         AS Amount
                              , COALESCE (Remains.Amount, 0)       AS RemainsAmount
                              , COALESCE (Income.Income_Amount, 0) AS IncomeAmount
                         FROM tmpMI
                              LEFT JOIN tmpRemains AS Remains ON Remains.ObjectId      = tmpMI.GoodsId
                              LEFT JOIN tmpIncome  AS Income  ON Income.Income_GoodsId = tmpMI.GoodsId
                         WHERE COALESCE (tmpMI.Amount, 0) > 0
                        )
      , tmpLastOrder AS (SELECT Movement.Id
                              , ROW_NUMBER() OVER (ORDER BY Movement.Id DESC, Movement.Operdate DESC) AS Ord
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MLO_Unit
                                                            ON MLO_Unit.MovementId = Movement.Id
                                                           AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                           AND MLO_Unit.ObjectId   = vbUnitId
                         WHERE Movement.DescId = zc_Movement_OrderInternal()
                           AND Movement.Operdate >= vbOperDate - INTERVAL '30 DAY' AND Movement.Operdate < vbOperDate
                         )
      -- заказы вчера / позавчера
      , tmpOrderLast_2days AS (SELECT tmpGoodsList.GoodsId
                                    , COUNT (DISTINCT Movement.Id) AS Amount
                               FROM tmpLastOrder AS Movement
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                    INNER JOIN tmpGoodsList ON tmpGoodsList.GoodsId = MovementItem.ObjectId
                                                           AND tmpGoodsList.RemainsAmount = 0                  -- остаток = 0
                                                           AND tmpGoodsList.IncomeAmount = 0                    -- приход сегодня = 0
                               WHERE Movement.Ord IN (1, 2)
                               GROUP BY tmpGoodsList.GoodsId
                               )
      -- повторный заказ  --позиции, которые уже заказаны в прошлом Автозаказе точки, но не пришли на точку и опять стоят в следующем Автозаказе а том же кол-ве или больше 
      , tmpRepeat AS (SELECT tmpGoods.GoodsId
                          ,  CASE WHEN tmpGoods.Amount >= COALESCE (MovementItem.Amount, 0) THEN TRUE ELSE FALSE END isRepeat
                      FROM tmpLastOrder AS Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                           INNER JOIN (SELECT tmpGoodsList.GoodsId, tmpGoodsList.Amount
                                       FROM tmpGoodsList
                                       WHERE COALESCE (tmpGoodsList.IncomeAmount, 0) = 0
                                         AND COALESCE (tmpGoodsList.Amount, 0) > 0
                                       ) AS tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                      WHERE Movement.Ord = 1
                     )

      -- нет привязки по поставщику в последних 10 внутренних заказах
      -- товары без привязки к поставщику
      -- расчет через кнопку, т.к. отрабатывает не быстро
      , tmpGoodsNotLink AS (SELECT DISTINCT tmpGoodsList.GoodsId
                            FROM tmpGoodsList
                                 LEFT JOIN (SELECT DISTINCT tmpGoodsList.GoodsId
                                            FROM tmpGoodsList
                                                 /*LEFT JOIN Object_LinkGoods_View AS LinkGoods_Partner_Main
                                                                                 ON LinkGoods_Partner_Main.GoodsId = tmpGoodsList.GoodsId  -- Связь товара поставщика с общим
                                     
                                                 INNER JOIN Object_LinkGoods_View AS LinkGoods_Main_Retail -- связь товара сети с главным товаром
                                                                                  ON LinkGoods_Main_Retail.GoodsMainId = LinkGoods_Partner_Main.GoodsMainId
                                                 INNER JOIN Object on Object.id = LinkGoods_Main_Retail.ObjectId and Object.Descid = zc_Object_Juridical()
                                                 */
                                                 -- получаем GoodsMainId
                                                 INNER JOIN  ObjectLink AS ObjectLink_Child 
                                                                       ON ObjectLink_Child.ChildObjectId = tmpGoodsList.GoodsId 
                                                                      AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                                 LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                                                       ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                      AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
      
                                                 --  LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                                 --                                  ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                                 -- товары сети по главному GoodsMainId
                                                 LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain 
                                                                        ON ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()  
                                                                       AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = ObjectLink_Main.ChildObjectId --Object_LinkGoods_View.GoodsMainId
                                            
                                                 LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                                 ON ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                                                AND ObjectLink_LinkGoods_Goods.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                                                     
                                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                                                   ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                                   AND ObjectLink_Goods_Object.DescId  = zc_ObjectLink_Goods_Object()
                                                                                  
                                                 INNER JOIN Object ON Object.id = ObjectLink_Goods_Object.ChildObjectId AND Object.Descid = zc_Object_Juridical() 
                                              ) AS tmp ON tmp.GoodsId = tmpGoodsList.GoodsId
                            WHERE tmp.GoodsId IS NULL
                              AND inIsLink = TRUE
                            )

      , tmpOrderLast_10 AS (SELECT tmpGoodsNotLink.GoodsId
                                 , COUNT (DISTINCT Movement.Id) AS Amount
                            FROM tmpLastOrder AS Movement 
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                 INNER JOIN tmpGoodsNotLink ON tmpGoodsNotLink.GoodsId = MovementItem.ObjectId 
                            WHERE Movement.Ord <= 10
                            GROUP BY tmpGoodsNotLink.GoodsId
                            )


       -- Результат 1
       SELECT
             tmpMI.Id                                       AS Id
           , tmpMI.GoodsId                                  AS GoodsId
           , tmpMI.GoodsCode                                AS GoodsCode
           , tmpMI.GoodsName                                AS GoodsName
           , Object_Retail.ValueData                        AS RetailName
           , tmpMI.isTOP                                    AS isTOP
           , COALESCE (Object_Price_View.isTOP, False)      AS isTOP_Price

           , tmpMI.GoodsGroupId                             AS GoodsGroupId
           , tmpMI.NDSKindId                                AS NDSKindId
           , tmpMI.NDSKindName                              AS NDSKindName
           , tmpMI.NDS                                      AS NDS
           , tmpMI.isClose                                  AS isClose
           , tmpMI.isFirst                                  AS isFirst
           , tmpMI.isSecond                                 AS isSecond
           , COALESCE (tmpGoodsMain.isSP,False) :: Boolean  AS isSP

           , CASE WHEN DATE_TRUNC ('DAY', tmpGoodsMain.LastPriceDate) = vbOperDate THEN TRUE ELSE FALSE END AS isMarketToday    --CURRENT_DATE
           , DATE_TRUNC ('DAY', tmpGoodsMain.LastPriceDate)                   ::TDateTime  AS LastPriceDate

           , CASE WHEN tmpGoodsMain.isSP = TRUE THEN 25088 --zc_Color_GreenL()
                  WHEN tmpMI.isTOP = TRUE
                    OR COALESCE (Object_Price_View.isTOP, False) = TRUE
                   THEN 16440317         --12615935                                                      --16440317  - розовый как в приходе ELSE zc_Color_White()
                  ELSE zc_Color_White() --0
             END                                            AS isTopColor
           , tmpMI.Multiplicity                             AS Multiplicity
           , tmpMI.CalcAmount                               AS CalcAmount
           , tmpMI.Amount                                   AS Amount
           , tmpMI.Summ                                     AS Summ
           , tmpMI.isErased                                 AS isErased
           , tmpMI.Price                                    AS Price
           , tmpMI.MinimumLot                               AS MinimumLot
           , tmpMI.PartionGoodsDate                         AS PartionGoodsDate
           , tmpMI.Comment                                  AS Comment
           , tmpMI.PartnerGoodsId                           AS PartnerGoodsId
           , tmpMI.PartnerGoodsCode                         AS PartnerGoodsCode
           , tmpMI.PartnerGoodsName                         AS PartnerGoodsName
           , tmpMI.JuridicalId                              AS JuridicalId
           , tmpMI.JuridicalName                            AS JuridicalName      -- ***
           , tmpMI.ContractId                               AS ContractId
           , tmpMI.ContractName                             AS ContractName
           , tmpMI.MakerName                                AS MakerName
           , tmpMI.SuperFinalPrice                          AS SuperFinalPrice
           , COALESCE (tmpGoodsMain.PriceOptSP,0)        ::TFloat     AS PriceOptSP
           , CASE WHEN tmpGoodsMain.isSP = TRUE AND (tmpMI.Price > (COALESCE (tmpGoodsMain.PriceOptSP,0))) THEN TRUE ELSE FALSE END isPriceDiff
           , COALESCE(tmpMI.isCalculated, FALSE)                      AS isCalculated
           , CASE WHEN tmpGoodsMain.isSP = TRUE THEN 25088 --zc_Color_GreenL()   --товар соц.проекта
                  WHEN tmpMI.PartionGoodsDate < vbDate180 THEN zc_Color_Blue() --456
                  WHEN (tmpMI.isTOP = TRUE OR COALESCE (Object_Price_View.isTOP, False)= TRUE) THEN 15993821 -- 16440317    -- для топ розовый шрифт
                     ELSE 0
                END AS PartionGoodsDateColor   
           , Remains.Amount                                                  AS RemainsInUnit
           , Object_Price_View.MCSValue                                      AS MCS
           , COALESCE (Object_Price_View.MCSIsClose, FALSE)                  AS MCSIsClose
           , COALESCE (Object_Price_View.MCSNotRecalc, FALSE)                AS MCSNotRecalc
           , Income.Income_Amount                                            AS Income_Amount
           , tmpMI.AmountSecond                                              AS AmountSecond
           , tmpMI.AmountAll
           , tmpMI.CalcAmountAll
           , tmpMI.SummAll
           , tmpCheck.Amount                                    ::TFloat     AS CheckAmount
           , tmpSend.Amount                                     ::TFloat     AS SendAmount

           , tmpDeferred.AmountDeferred                                      AS AmountDeferred

           , COALESCE (tmpGoodsMain.CountPrice,0)               ::TFloat AS CountPrice

           , COALESCE (SelectMinPrice_AllGoods.isOneJuridical, TRUE) :: Boolean AS isOneJuridical
           
           , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN False ELSE True END  ::Boolean AS isPromo
           , COALESCE(GoodsPromo.OperDatePromo, Null)           :: TDateTime AS OperDatePromo
           , COALESCE(GoodsPromo.InvNumberPromo, '')            :: TVarChar  AS InvNumberPromo -- ***

           , CASE WHEN COALESCE(OrderSheduleListToday.DOW,  0) = 0 THEN False ELSE TRUE END AS isZakazToday
           , CASE WHEN COALESCE(OrderSheduleListToday.DoW_D,0) = 0 THEN False ELSE TRUE END AS isDostavkaToday
           , OrderSheduleList.OperDate_Zakaz                    ::TVarChar   AS OperDate_Zakaz
           , OrderSheduleList.OperDate_Dostavka                 ::TVarChar   AS OperDate_Dostavka

           , COALESCE(tmpGoodsConditionsKeep.ConditionsKeepName, '') ::TVarChar  AS ConditionsKeepName

           , CASE WHEN COALESCE(OrderSheduleListToday.DOW,  0) <> 0 THEN 12910591      -- бледно желтый
                  WHEN COALESCE (tmpOrderLast_2days.Amount, 0)  > 1 THEN 16777134      -- цвет фона - голубой подрязд 2 дня заказ; 
                  WHEN COALESCE (tmpOrderLast_10.Amount, 0)     > 9 THEN 167472630     -- цвет фона - розовый подрязд 10 заказов нет привязки к товару поставщика; 
                  ELSE zc_Color_White()
             END  AS OrderShedule_Color  
           
           , CASE WHEN COALESCE (tmpOrderLast_2days.Amount, 0) > 1 THEN 16777134   -- цвет фона - голубой подрязд 2 дня заказ; 
                  WHEN COALESCE (tmpOrderLast_10.Amount, 0) > 9 THEN 167472630     -- цвет фона - розовый подрязд 10 заказов нет привязки к товару поставщика; 
                  ELSE  zc_Color_White()
             END  AS Fond_Color
             
           , CASE WHEN COALESCE (tmpOrderLast_2days.Amount, 0) > 1 THEN TRUE  
                  ELSE  FALSE
             END  AS isLast_2days
             
           , COALESCE (tmpRepeat.isRepeat, FALSE) AS isRepeat
           
           -- , tmpJuridicalArea.AreaId                                      AS AreaId
           -- , COALESCE (tmpJuridicalArea.AreaName, '')      :: TVarChar    AS AreaName
           -- , Object_Area.ValueData                         :: TVarChar    AS AreaName_Goods
           
           , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean     AS isDefault
       FROM tmpData AS tmpMI
            LEFT JOIN tmpPriceView AS Object_Price_View ON tmpMI.GoodsId                    = Object_Price_View.GoodsId
            LEFT JOIN tmpRemains   AS Remains           ON Remains.ObjectId                 = tmpMI.GoodsId
            LEFT JOIN tmpIncome    AS Income            ON Income.Income_GoodsId            = tmpMI.GoodsId 
            LEFT JOIN tmpGoodsConditionsKeep            ON tmpGoodsConditionsKeep.GoodsId   = tmpMI.GoodsId
            LEFT JOIN tmpGoodsMain                      ON tmpGoodsMain.GoodsId             = tmpMI.GoodsId
            LEFT JOIN OrderSheduleList                  ON OrderSheduleList.ContractId      = tmpMI.ContractId 
            LEFT JOIN OrderSheduleListToday             ON OrderSheduleListToday.ContractId = tmpMI.ContractId
            LEFT JOIN tmpCheck                          ON tmpCheck.GoodsId                 = tmpMI.GoodsId
            LEFT JOIN tmpSend                           ON tmpSend.GoodsId                  = tmpMI.GoodsId
            LEFT JOIN tmpDeferred                       ON tmpDeferred.GoodsId              = tmpMI.GoodsId

            LEFT JOIN (SELECT _tmpMI.MovementItemId, CASE WHEN COUNT (*) > 1 THEN FALSE ELSE TRUE END AS isOneJuridical
                       FROM _tmpMI
                       GROUP BY _tmpMI.MovementItemId
                      ) AS SelectMinPrice_AllGoods ON SelectMinPrice_AllGoods.MovementItemId = tmpMI.Id

            LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpMI.JuridicalId
                                AND GoodsPromo.GoodsId     = tmpMI.GoodsId

            LEFT JOIN tmpOrderLast_2days ON tmpOrderLast_2days.GoodsId = tmpMI.GoodsId 
            LEFT JOIN tmpOrderLast_10    ON tmpOrderLast_10.GoodsId    = tmpMI.GoodsId  
            LEFT JOIN tmpRepeat          ON tmpRepeat.GoodsId          = tmpMI.GoodsId     
            LEFT JOIN tmpJuridicalArea   ON tmpJuridicalArea.JuridicalId = tmpMI.JuridicalId
            
            -- торговая сеть
            LEFT JOIN  ObjectLink AS ObjectLink_Object 
                                  ON ObjectLink_Object.ObjectId = tmpMI.GoodsId
                                 AND ObjectLink_Object.DescId = zc_ObjectLink_Goods_Object()            
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Object.ChildObjectId    

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Area 
                                 ON ObjectLink_Goods_Area.ObjectId = tmpMI.PartnerGoodsId
                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId        
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
                           , MovementPromo.OperDate                AS OperDatePromo
                           , MovementPromo.InvNumber               AS InvNumberPromo -- ***
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
                                       LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = tmp.MovementId
                     )


        SELECT *
              , CASE WHEN PartionGoodsDate < vbDate180 THEN zc_Color_Blue() --456
                     ELSE 0
                END                                                          AS PartionGoodsDateColor      
              , ObjectFloat_Goods_MinimumLot.ValueData                       AS MinimumLot
              , MIFloat_Remains.ValueData                                    AS Remains

              , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN False ELSE True END  ::Boolean AS isPromo
              , COALESCE(GoodsPromo.OperDatePromo, Null)      :: TDateTime   AS OperDatePromo
              , COALESCE(GoodsPromo.InvNumberPromo, '')       :: TVarChar    AS InvNumberPromo -- ***
              , COALESCE(GoodsPromo.ChangePercent, 0)         :: TFLoat      AS ChangePercentPromo
   
              , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar     AS ConditionsKeepName

              , tmpJuridicalArea.AreaId                                      AS AreaId
              , COALESCE (tmpJuridicalArea.AreaName, '')      :: TVarChar    AS AreaName
              , Object_Area.ValueData                         :: TVarChar    AS AreaName_Goods
              , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean     AS isDefault
              
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
             -- условия хранения
             LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                  ON ObjectLink_Goods_ConditionsKeep.ObjectId = _tmpMI.GoodsId 
                                 AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
             
             LEFT JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = _tmpMI.JuridicalId
                                       AND tmpJuridicalArea.AreaId      = _tmpMI.AreaId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Area 
                                  ON ObjectLink_Goods_Area.ObjectId = _tmpMI.GoodsId
                                 AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
             LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId
;
   RETURN NEXT Cursor2;

  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.10.17         * add area
 12.09.17         *
 04.08.17         *
 09.04.17         * оптимизация
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
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 3961103, inShowAll:= TRUE, inIsErased:= FALSE, inIsLink:= FALSE, inSession:= '3'); -- FETCH ALL "<unnamed portal 6>";
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 3954371, inShowAll:= TRUE, inIsErased:= FALSE, inIsLink:= FALSE, inSession:= '3'); 
--     FETCH ALL "<unnamed portal 143>";

--- последнее 