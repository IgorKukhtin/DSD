-- Function: gpSelect_MovementItem_OrderInternal()

--   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--
--   Процедура разбита на две gpSelect_MovementItem_OrderInternal_Master и gpSelect_MovementItem_OrderInternal_Child
--
--   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

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

  DECLARE vbAreaId_find Integer;

  DECLARE vbAVGDateStart TDateTime; --Дата нач. расчета ср. цены
  DECLARE vbAVGDateEnd TDateTime;   --Дата окон. расчета ср. цены 

  DECLARE vbCostCredit TFloat;
  
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternal());
    vbUserId := inSession;

-- if inSession <> '3'
-- then
--     RAISE EXCEPTION 'Повторите действие через 15 мин.';
-- end if;

     -- получаем значение константы
     vbCostCredit := COALESCE ((SELECT COALESCE (ObjectFloat_SiteDiscount.ValueData, 0)          :: TFloat    AS SiteDiscount
                                FROM Object AS Object_GlobalConst
                                     INNER JOIN ObjectBoolean AS ObjectBoolean_SiteDiscount
                                                              ON ObjectBoolean_SiteDiscount.ObjectId = Object_GlobalConst.Id
                                                             AND ObjectBoolean_SiteDiscount.DescId = zc_ObjectBoolean_GlobalConst_SiteDiscount()
                                                             AND ObjectBoolean_SiteDiscount.ValueData = TRUE
                                     INNER JOIN ObjectFloat AS ObjectFloat_SiteDiscount
                                                           ON ObjectFloat_SiteDiscount.ObjectId = Object_GlobalConst.Id
                                                          AND ObjectFloat_SiteDiscount.DescId = zc_ObjectFloat_GlobalConst_SiteDiscount()
                                                          AND COALESCE (ObjectFloat_SiteDiscount.ValueData, 0) <> 0
                                WHERE Object_GlobalConst.DescId = zc_Object_GlobalConst()
                                  AND Object_GlobalConst.Id =zc_Enum_GlobalConst_CostCredit()
                                )
                                , 0)  :: TFloat;

    vbCURRENT_DOW := CASE WHEN EXTRACT (DOW FROM CURRENT_DATE) = 0 THEN 7 ELSE EXTRACT (DOW FROM CURRENT_DATE) END ; -- день недели сегодня

    --
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    SELECT COALESCE(MB_Document.ValueData, FALSE) :: Boolean AS isDocument
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
    SELECT date_trunc('day', Movement.OperDate)  
    INTO vbOperDate
    FROM Movement
    WHERE Movement.Id = inMovementId;

    vbOperDateEnd := vbOperDate + INTERVAL '1 DAY';
    vbDate180 := CURRENT_DATE + zc_Interval_ExpirationDate()+ zc_Interval_ExpirationDate();   -- нужен 1 год (функция =6 мес.)
    --vbDate180 := CURRENT_DATE + INTERVAL '180 DAY';
    

    vbAVGDateStart := vbOperDate - INTERVAL '30 day';
    vbAVGDateEnd   := vbOperDate;

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


--  raise notice 'Value: %', -1;

    -- !!!Только для таких документов - 1-ая ВЕТКА (ВСЕГО = 3)!!!
    IF vbisDocument = TRUE AND vbStatusId = zc_Enum_Status_Complete() /*AND inSession <> '3'*/ AND inMovementId <> 10804217 AND inMovementId <> 10795784 
    AND (inShowAll = FALSE OR inSession <> '3')
 -- AND inSession <> '3'
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

--raise notice 'Value: %', 0;

--     OPEN Cursor1 FOR
     CREATE TEMP TABLE _tmpRes1 ON COMMIT DROP AS
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
                            , COALESCE(MovementPromo.OperDate, NULL)  :: TDateTime   AS OperDatePromo
                            , COALESCE(MovementPromo.InvNumber, '') ::  TVarChar     AS InvNumberPromo -- ***
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= vbOperDate) AS tmp   --CURRENT_DATE
                            INNER JOIN ObjectLink AS ObjectLink_Child
                                                  ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                 AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                            INNER JOIN  ObjectLink AS ObjectLink_Main
                                                   ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                  AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                            INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                  ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                 AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                            INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                  ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                 AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                            INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                  ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                 AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                            LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = tmp.MovementId
                       )

        -- Список цены + ТОП
      , GoodsPrice AS (SELECT Price_Goods.ChildObjectId           AS GoodsId
                            , COALESCE(Price_Top.ValueData,FALSE) AS isTop
                       FROM ObjectLink AS ObjectLink_Price_Unit
                            INNER JOIN ObjectBoolean AS Price_Top
                                                  ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                                                 AND Price_Top.ValueData = TRUE
                            LEFT JOIN ObjectLink AS Price_Goods
                                                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                       WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                       )
      -- данные из ассорт. матрицы
      , tmpGoodsCategory AS (SELECT ObjectLink_Child_retail.ChildObjectId AS GoodsId
                                  , ObjectFloat_Value.ValueData                  AS Value
                             FROM Object AS Object_GoodsCategory
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                       ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                                      AND ObjectLink_GoodsCategory_Unit.ChildObjectId = vbUnitId
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                       ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                 INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                                        ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                       AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                                       AND COALESCE (ObjectFloat_Value.ValueData,0) <> 0
                            -- выходим на товар сети
                            INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                  ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                                 AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                            INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                  ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                 AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                            INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                  ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                 AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                                                 
                             WHERE Object_GoodsCategory.DescId = zc_Object_GoodsCategory()
                               AND Object_GoodsCategory.isErased = FALSE
                             )

      , tmpMI_Child AS (SELECT MI_Child.ParentId AS MIMasterId
                             , MI_Child.Id       AS MIId
                        FROM MovementItem AS MI_Child
                        WHERE MI_Child.MovementId = inMovementId
                          AND MI_Child.DescId     = zc_MI_Child()
                          AND MI_Child.isErased   = FALSE
                        )

        -- Товары соц-проект (документ)
      , tmpGoodsSP AS (SELECT tmp.GoodsId
                            , TRUE AS isSP
                            , MIN(MIFloat_PriceOptSP.ValueData) AS PriceOptSP
                       FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= vbOperDate, inEndDate:= vbOperDate, inUnitId := vbUnitId) AS tmp
                                                LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                     ON MIFloat_PriceOptSP.MovementItemId = tmp.MovementItemId
                                                    AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                       GROUP BY tmp.GoodsId
                       )


      , tmpGoodsMain AS (SELECT tmpMI.GoodsId
                              , COALESCE (tmpGoodsSP.isSP, False)           ::Boolean AS isSP
                              , COALESCE (ObjectBoolean_Resolution_224.ValueData, FALSE) :: Boolean AS isResolution_224
                              , CAST ( (COALESCE (tmpGoodsSP.PriceOptSP,0) * 1.1) AS NUMERIC (16,2))    :: TFloat   AS PriceOptSP
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

                                LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                                     ON ObjectDate_LastPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()
                                LEFT JOIN ObjectFloat AS ObjectFloat_CountPrice
                                                      ON ObjectFloat_CountPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                     AND ObjectFloat_CountPrice.DescId = zc_ObjectFloat_Goods_CountPrice()
                                LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId

                                LEFT JOIN ObjectBoolean AS ObjectBoolean_Resolution_224
                                                        ON ObjectBoolean_Resolution_224.ObjectId = ObjectLink_Main.ChildObjectId
                                                       AND ObjectBoolean_Resolution_224.DescId = zc_ObjectBoolean_Goods_Resolution_224()
                                
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

                       , CEIL (tmpMI.Amount / COALESCE(ObjectFloat_Goods_MinimumLot.ValueData, 1)) * COALESCE(ObjectFloat_Goods_MinimumLot.ValueData, 1) ::TFloat  AS CalcAmount
                       , COALESCE(Object_ConditionsKeep.ValueData, '')      :: TVarChar AS ConditionsKeepName
                       , tmpGoodsMain.isSP
                       , tmpGoodsMain.isResolution_224
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
                                              AND ObjectFloat_Goods_MinimumLot.ValueData <> 0
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

      , tmpMIF_DefermentPrice AS (SELECT tmpMIF.*
                                  FROM tmpMIF
                                  WHERE tmpMIF.DescId = zc_MIFloat_DefermentPrice()
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
/*      , tmpLastOrder AS (SELECT Movement.Id
                              , ROW_NUMBER() OVER (ORDER BY Movement.Id DESC, Movement.Operdate DESC) AS Ord
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MLO_Unit
                                                            ON MLO_Unit.MovementId = Movement.Id
                                                           AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                           AND MLO_Unit.ObjectId   = vbUnitId
                         WHERE Movement.DescId = zc_Movement_OrderInternal()
                           AND Movement.Operdate >= vbOperDate - INTERVAL '30 DAY' AND Movement.Operdate < vbOperDate
                           AND 1=0
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
*/
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

      , tmpOneJuridical AS (SELECT tmpMI.MIMasterId, CASE WHEN COUNT (*) > 1 THEN FALSE ELSE TRUE END AS isOneJuridical
                            FROM tmpMI_Child AS tmpMI
                            GROUP BY tmpMI.MIMasterId
                            )

      --средняя цена по заказам за месяц
      /*, AVGOrder AS (SELECT MovementItem.ObjectId
                          , AVG(MIFloat_Price.ValueData) ::TFloat AS AVGPrice
                     FROM Movement
                          JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                           AND MovementItem.DescId = zc_MI_Master()
                                           AND MovementItem.isErased = FALSE
                                           AND MovementItem.Amount > 0
                          JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                     WHERE Movement.DescId = zc_Movement_OrderInternal()
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                       AND Movement.Id <> inMovementId
                       AND Movement.OperDate >= vbAVGDateStart
                       AND Movement.OperDate <= vbAVGDateEnd
                     GROUP BY MovementItem.ObjectId
                    )*/
          , AVGIncome AS (SELECT MI_Income.ObjectId
                               , AVG(CASE WHEN MovementBoolean_PriceWithVAT.ValueData  = TRUE
                                          THEN (MIFloat_Price.ValueData * 100 / (100 + ObjectFloat_NDSKind_NDS.ValueData))
                                          ELSE MIFloat_Price.ValueData
                                     END)                               ::TFloat AS AVGIncomePrice
                          FROM Movement AS Movement_Income
                              JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                   ON MovementBoolean_PriceWithVAT.MovementId =  Movement_Income.Id
                                                  AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                              JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                      ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                                     AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                              JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                               ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                              AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                              JOIN MovementItem AS MI_Income
                                                ON MI_Income.MovementId = Movement_Income.Id
                                               AND MI_Income.DescId = zc_MI_Master()
                                               AND MI_Income.isErased = FALSE
                                               AND MI_Income.Amount > 0
                              JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          WHERE Movement_Income.DescId = zc_Movement_Income()
                            AND Movement_Income.StatusId = zc_Enum_Status_Complete()
                            AND Movement_Income.OperDate >= vbAVGDateStart
                            AND Movement_Income.OperDate <= vbAVGDateEnd
                          GROUP BY MI_Income.ObjectId
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
           , tmpMI.isResolution_224

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
           , COALESCE (MIFloat_DefermentPrice.ValueData,0) ::TFloat AS SuperFinalPrice_Deferment

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
                  WHEN tmpMI.PartionGoodsDate < vbDate180 THEN zc_Color_Red() --456
                  WHEN tmpMI.isTOP = TRUE OR tmpMI.isUnitTOP = TRUE  THEN zc_Color_Blue()--15993821 -- 16440317    -- для топ розовый шрифт
                     ELSE 0
                END                                                 AS PartionGoodsDateColor
           , tmpMI.Remains                                          AS RemainsInUnit
           , tmpMI.Reserved
           , CASE WHEN (COALESCE (tmpMI.Remains,0) - COALESCE (tmpMI.Reserved,0)) < 0 THEN (COALESCE (tmpMI.Remains,0) - COALESCE (tmpMI.Reserved,0)) ELSE 0 END :: TFLoat AS Remains_Diff   --не хватает с учетом отлож. чеком
           , tmpMI.MCS
           , tmpGoodsCategory.Value AS MCS_GoodsCategory

           , tmpMI.MCSIsClose
           , tmpMI.MCSNotRecalc
           , tmpMI.Income                                           AS Income_Amount
           , MIFloat_AmountSecond.ValueData                         AS AmountSecond

           , tmpMI.Amount + COALESCE (MIFloat_AmountSecond.ValueData,0) ::TFloat  AS AmountAll
           , NULLIF (COALESCE (-- Количество, установленное вручную
                               MIFloat_AmountManual.ValueData
                               -- округлили ВВЕРХ AllLot
                             , CEIL ((                       -- Спецзаказ    -- Количество дополнительное                            -- кол-во отказов
                                    CASE WHEN (COALESCE (tmpMI.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)) >= COALESCE (tmpMI.ListDiffAmount, 0)
                                          THEN (COALESCE (tmpMI.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))         -- Спецзаказ + Количество дополнительное
                                          ELSE COALESCE (tmpMI.ListDiffAmount, 0)                                                   -- кол-во отказов
                                     END
                                     ) / COALESCE (tmpMI.MinimumLot, 1)
                                    ) * COALESCE (tmpMI.MinimumLot, 1)     
                              ), 0) :: TFloat AS CalcAmountAll
                              
           , (COALESCE (MIFloat_Price.ValueData, 0)
                      * COALESCE (-- Количество, установленное вручную
                                  MIFloat_AmountManual.ValueData
                                  -- округлили ВВЕРХ AllLot
                                , CEIL ((-- Спецзаказ
                                         tmpMI.Amount
                                         -- Количество дополнительное
                                       + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                         -- кол-во отказов
                                       + COALESCE (tmpMI.ListDiffAmount, 0)
                                        ) / COALESCE (tmpMI.MinimumLot, 1)
                                       ) * COALESCE (tmpMI.MinimumLot, 1)     
                                 )
             )                                          ::TFloat    AS SummAll

           , tmpMI.CheckAmount                                      AS CheckAmount
           , tmpMI.SendAmount                                       AS SendAmount
           , tmpMI.AmountDeferred                                   AS AmountDeferred
           , tmpMI.ListDiffAmount                       ::TFloat    AS ListDiffAmount

           , tmpMI.AmountReal                           ::TFloat    AS AmountReal
           , tmpMI.SendSUNAmount                        ::TFloat    AS SendSUNAmount
           , tmpMI.SendDefSUNAmount                     ::TFloat    AS SendDefSUNAmount
           , tmpMI.RemainsSUN                           ::TFloat    AS RemainsSUN

           , tmpMI.CountPrice
           , COALESCE (tmpOneJuridical.isOneJuridical, TRUE) :: Boolean AS isOneJuridical

           , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0    THEN FALSE ELSE TRUE END  ::Boolean AS isPromo
           , CASE WHEN COALESCE (GoodsPromoAll.GoodsId, 0) = 0 THEN FALSE ELSE TRUE END  ::Boolean AS isPromoAll
           , COALESCE(GoodsPromo.OperDatePromo, NULL)  :: TDateTime   AS OperDatePromo
           , COALESCE(GoodsPromo.InvNumberPromo, '')   ::  TVarChar   AS InvNumberPromo -- ***

           , CASE WHEN COALESCE(OrderSheduleListToday.DOW,  0) = 0 THEN FALSE ELSE TRUE END AS isZakazToday
           , CASE WHEN COALESCE(OrderSheduleListToday.DoW_D,0) = 0 THEN FALSE ELSE TRUE END AS isDostavkaToday
           , OrderSheduleList.OperDate_Zakaz    ::TVarChar AS OperDate_Zakaz
           , OrderSheduleList.OperDate_Dostavka ::TVarChar AS OperDate_Dostavka

           , tmpMI.ConditionsKeepName

           , CASE 
                  --WHEN COALESCE (tmpOrderLast_2days.Amount, 0)  > 1 THEN 16777134      -- цвет фона - голубой подрязд 2 дня заказ;
                  --WHEN COALESCE (tmpOrderLast_10.Amount, 0)     > 9 THEN 167472630     -- цвет фона - розовый подрязд 10 заказов нет привязки к товару поставщика;
                   -- отклонение по цене  светло - салатовая- цена подешевела, светло-розовая - подорожала
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0)) > 0.10 THEN 12319924    --светло - салатовая- цена подешевела
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0)) < - 0.10 THEN 14211071 --11315967--15781886 --16296444  ----светло красная -- светло-розовая - подорожала
                  WHEN COALESCE(OrderSheduleListToday.DOW,  0) <> 0 THEN 12910591      -- бледно желтый
                  ELSE zc_Color_White()
             END  AS OrderShedule_Color

           , AVGIncome.AVGIncomePrice    AS AVGPrice
/*           , CASE WHEN (ABS(AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0)) > 0.10
                     THEN TRUE
                  ELSE FALSE
             END AS AVGPriceWarning   */
           , CASE WHEN (AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0) > 0.10 THEN (-1)*((AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0)) * 100
                  WHEN (AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0) < -0.10 THEN (-1)*((AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0)) * 100
                  WHEN COALESCE (AVGIncome.AVGIncomePrice, 0) = 0 THEN 0.1--5000
                  ELSE 0
             END AS AVGPriceWarning

           /*
           , CASE WHEN COALESCE (tmpOrderLast_2days.Amount, 0) > 1 THEN 16777134   -- цвет фона - голубой подрязд 2 дня заказ;
                  WHEN COALESCE (tmpOrderLast_10.Amount, 0) > 9 THEN 167472630     -- цвет фона - розовый подрязд 10 заказов нет привязки к товару поставщика;
                  ELSE  zc_Color_White()
             END  AS Fond_Color

           , CASE WHEN COALESCE (tmpOrderLast_2days.Amount, 0) > 1 THEN TRUE ELSE FALSE END  AS isLast_2days
           , COALESCE (tmpRepeat.isRepeat, FALSE) AS isRepeat
           */

           -- , tmpJuridicalArea.AreaId                                      AS AreaId
           -- , COALESCE (tmpJuridicalArea.AreaName, '')      :: TVarChar    AS AreaName

           -- , Object_Area.ValueData                         :: TVarChar    AS AreaName_Goods

--           , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean     AS isDefault

       FROM tmpMI        --_tmpOrderInternal_MI AS
            LEFT JOIN tmpOneJuridical ON tmpOneJuridical.MIMasterId = tmpMI.MovementItemId

            LEFT JOIN Object AS Object_PartnerGoods ON Object_PartnerGoods.Id = tmpMI.PartnerGoodsId
            LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpMI.JuridicalId
                                AND GoodsPromo.GoodsId = tmpMI.GoodsId

            -- показываем не зависимо от поставщ. явл. ли товар маркетинговым 
            LEFT JOIN (SELECT DISTINCT GoodsPromo.GoodsId FROM GoodsPromo) AS GoodsPromoAll ON GoodsPromoAll.GoodsId = tmpMI.GoodsId

            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = tmpMI.RetailId

            LEFT JOIN OrderSheduleList ON OrderSheduleList.ContractId = tmpMI.ContractId
            LEFT JOIN OrderSheduleListToday ON OrderSheduleListToday.ContractId = tmpMI.ContractId

            LEFT JOIN tmpMIBoolean_Calculated AS MIBoolean_Calculated ON MIBoolean_Calculated.MovementItemId = tmpMI.MovementItemId

            LEFT JOIN tmpMIF_Price          AS MIFloat_Price          ON MIFloat_Price.MovementItemId          = tmpMI.MovementItemId
            LEFT JOIN tmpMIF_JuridicalPrice AS MIFloat_JuridicalPrice ON MIFloat_JuridicalPrice.MovementItemId = tmpMI.MovementItemId
            LEFT JOIN tmpMIF_DefermentPrice AS MIFloat_DefermentPrice ON MIFloat_DefermentPrice.MovementItemId = tmpMI.MovementItemId
            LEFT JOIN tmpMIF_Summ           AS MIFloat_Summ           ON MIFloat_Summ.MovementItemId           = tmpMI.MovementItemId
            LEFT JOIN tmpMIF_AmountSecond   AS MIFloat_AmountSecond   ON MIFloat_AmountSecond.MovementItemId   = tmpMI.MovementItemId
            LEFT JOIN tmpMIF_AmountManual   AS MIFloat_AmountManual   ON MIFloat_AmountManual.MovementItemId   = tmpMI.MovementItemId

            LEFT JOIN tmpMIString_Comment AS MIString_Comment ON MIString_Comment.MovementItemId = tmpMI.MovementItemId

            --LEFT JOIN tmpOrderLast_2days ON tmpOrderLast_2days.GoodsId   = tmpMI.GoodsId
            --LEFT JOIN tmpOrderLast_10    ON tmpOrderLast_10.GoodsId      = tmpMI.GoodsId
            --LEFT JOIN tmpRepeat          ON tmpRepeat.GoodsId            = tmpMI.GoodsId

            LEFT JOIN tmpJuridicalArea   ON tmpJuridicalArea.JuridicalId = tmpMI.JuridicalId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                 ON ObjectLink_Goods_Area.ObjectId = tmpMI.PartnerGoodsId
                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId
            
            LEFT JOIN AVGIncome ON AVGIncome.ObjectId = tmpMI.GoodsId
            LEFT JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpMI.GoodsId
           ;


--     RETURN NEXT Cursor1;

--     OPEN Cursor2 FOR
     CREATE TEMP TABLE _tmpRes2 ON COMMIT DROP AS
     WITH
        PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (vbUserId::TVarChar))
      , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (vbUserId::TVarChar))

      , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS T WHERE T.MainJuridicalId = vbMainJuridicalId)

        -- элементы установок юр.лиц (границы цен для бонуса)
      , tmpJuridicalSettingsItem AS (SELECT tmp.JuridicalSettingsId
                                          , tmp.Bonus
                                          , tmp.PriceLimit_min
                                          , tmp.PriceLimit
                                     FROM JuridicalSettings
                                          INNER JOIN gpSelect_Object_JuridicalSettingsItem (JuridicalSettings.JuridicalSettingsId, inSession) AS tmp ON tmp.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                     WHERE COALESCE (JuridicalSettings.isBonusClose, FALSE) = FALSE
                                     )
       -- Маркетинговый контракт
      , GoodsPromo AS (SELECT tmp.JuridicalId
                            , ObjectLink_Child_retail.ChildObjectId AS GoodsId        -- здесь товар "сети"
                            , tmp.MovementId
                            , tmp.ChangePercent
                            , COALESCE(MovementPromo.OperDate, NULL)  :: TDateTime   AS OperDatePromo
                            , COALESCE(MovementPromo.InvNumber, '') ::  TVarChar     AS InvNumberPromo -- ***
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= vbOperDate) AS tmp   --CURRENT_DATE
                                        INNER JOIN ObjectLink AS ObjectLink_Child
                                                              ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                             AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                        INNER JOIN  ObjectLink AS ObjectLink_Main
                                                               ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                              AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                        INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                              ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                             AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                        INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                              ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
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
                          AND (MI_Child.IsErased = inIsErased OR inIsErased = TRUE)
                        )
--
      , tmpMIDate_PartionGoods AS (SELECT MIDate_PartionGoods.*
                                   FROM MovementItemDate AS MIDate_PartionGoods
                                   WHERE MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                     AND MIDate_PartionGoods.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                         )
      , tmpMIF AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId  IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                     AND MovementItemFloat.DescId IN (zc_MIFloat_Price()
                                                    , zc_MIFloat_JuridicalPrice())
                    )
      , tmpMIFloat_Price AS (SELECT tmpMIF.*
                             FROM tmpMIF
                             WHERE tmpMIF.DescId = zc_MIFloat_Price()
                         )
      , tmpMIFloat_JuridicalPrice AS (SELECT tmpMIF.*
                                      FROM tmpMIF
                                      WHERE tmpMIF.DescId = zc_MIFloat_JuridicalPrice()
                                      )
      , tmpMIFloat_DefermentPrice AS (SELECT MovementItemFloat.*
                                      FROM MovementItemFloat
                                      WHERE MovementItemFloat.MovementItemId  IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                                        AND MovementItemFloat.DescId = zc_MIFloat_DefermentPrice()
                                      )
      , tmpMIString_Maker AS (SELECT MIString_Maker.*
                              FROM MovementItemString AS MIString_Maker
                              WHERE MIString_Maker.DescId = zc_MIString_Maker()
                                AND MIString_Maker.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                              )
      , tmpJuridical AS (SELECT MILinkObject_Juridical.MovementItemId
                              , Object_Juridical.Id                 AS JuridicalId
                              , Object_Juridical.ValueData          AS JuridicalName
                         FROM MovementItemLinkObject AS MILinkObject_Juridical
                              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILinkObject_Juridical.ObjectId
                         WHERE MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()     ------and 1=0
                           AND MILinkObject_Juridical.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                        )
      --
      , tmpContract_ AS (SELECT MILinkObject_Contract.MovementItemId
                              , MILinkObject_Contract.ObjectId      AS ContractId
                        FROM MovementItemLinkObject AS MILinkObject_Contract
                        WHERE MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                          AND MILinkObject_Contract.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                        )
      , tmpOF_Deferment AS (SELECT ObjectFloat_Deferment.*
                            FROM ObjectFloat AS ObjectFloat_Deferment
                            WHERE ObjectFloat_Deferment.ObjectId IN (SELECT DISTINCT tmpContract_.ContractId FROM tmpContract_)
                              AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
                           )
      , tmpContract AS (SELECT tmpContract_.MovementItemId
                             , Object_Contract.Id                 AS ContractId
                             , Object_Contract.ValueData          AS ContractName
                             , ObjectFloat_Deferment.ValueData    AS Deferment
                        FROM tmpContract_
                             LEFT JOIN tmpOF_Deferment AS ObjectFloat_Deferment
                                                       ON ObjectFloat_Deferment.ObjectId = tmpContract_.ContractId
                                                      AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
                             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpContract_.ContractId
                        )
        ---
      , tmpOF_MinimumLot AS (SELECT ObjectFloat_Goods_MinimumLot.*
                             FROM ObjectFloat AS ObjectFloat_Goods_MinimumLot
                             WHERE ObjectFloat_Goods_MinimumLot.ObjectId IN (SELECT DISTINCT tmpMI_Child.ObjectId FROM tmpMI_Child)
                               AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                             )
      , tmpOL_ConditionsKeep AS (SELECT ObjectLink.*
                                 FROM ObjectLink
                                 WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpMI_Child.ObjectId FROM tmpMI_Child)
                                   AND ObjectLink.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                                 )
      , tmpGoods AS (SELECT tmpMI_Child.ObjectId             AS GoodsId
                          , Object_Goods.ObjectCode          AS GoodsCode
                          , Object_Goods.ValueData           AS GoodsName
                          , ObjectFloat_Goods_MinimumLot.ValueData    AS MinimumLot
                          , Object_ConditionsKeep.ValueData           AS ConditionsKeepName
                     FROM tmpMI_Child
                          -- условия хранения
                          LEFT JOIN tmpOL_ConditionsKeep AS ObjectLink_Goods_ConditionsKeep
                                                         ON ObjectLink_Goods_ConditionsKeep.ObjectId = tmpMI_Child.ObjectId
                                                        --AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                          LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

                          LEFT JOIN tmpOF_MinimumLot AS ObjectFloat_Goods_MinimumLot
                                                     ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI_Child.ObjectId
                                               --AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()

                          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Child.ObjectId
                    )

      -- данные по % кредитных средств из справочника
      , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := vbObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inSession) AS tmp)


        SELECT tmpMI.MovementItemId                           AS MovementItemId
             , MI_Child.Id
             , tmpGoods.GoodsCode
             , tmpGoods.GoodsName --_tmpMI.GoodsName
             , COALESCE(JuridicalSettings.Bonus, 0)::TFloat   AS Bonus
             , COALESCE (tmpContract.Deferment, 0)::Integer   AS Deferment
---
/*             , CASE WHEN COALESCE (tmpContract.Deferment, 0) = 0
                         THEN 0
                    WHEN tmpMI.isTOP = TRUE
                         THEN COALESCE (PriceSettingsTOP.Percent, 0)
                    ELSE PriceSettings.Percent
               END :: TFloat AS Percent
*/
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
              , COALESCE(MIDate_PartionGoods.ValueData, NULL) ::TDateTime AS PartionGoodsDate
              , CASE WHEN MIDate_PartionGoods.ValueData < vbDate180 THEN zc_Color_Red() --zc_Color_Blue() --456
                     ELSE 0
                END                                           AS PartionGoodsDateColor
              , tmpGoods.MinimumLot                 ::TFLoat  AS MinimumLot
              , MI_Child.Amount                     ::TFLoat  AS Remains
              
              , MIFloat_Price.ValueData             ::TFLoat  AS Price
              , MIFloat_JuridicalPrice.ValueData    ::TFLoat  AS SuperFinalPrice
              , MIFloat_DefermentPrice.ValueData    ::TFloat  AS SuperFinalPrice_Deferment
              , (tmpContract.Deferment * COALESCE (tmpCostCredit.Percent, vbCostCredit) ) ::TFloat  AS Persent_Deferment

              , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN FALSE ELSE TRUE END  ::Boolean AS isPromo
              
              , COALESCE(GoodsPromo.OperDatePromo, NULL)   :: TDateTime  AS OperDatePromo
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
          -- LEFT JOIN tmpMIFloat_DefermentPrice AS MIFloat_DefermentPrice ON MIFloat_JuridicalPrice.MovementItemId = MI_Child.Id
             LEFT JOIN MovementItemFloat AS MIFloat_DefermentPrice
                                         ON MIFloat_DefermentPrice.MovementItemId = MI_Child.Id
                                        AND MIFloat_DefermentPrice.DescId = zc_MIFloat_DefermentPrice()             
             LEFT JOIN tmpMIString_Maker         AS MIString_Maker         ON MIString_Maker.MovementItemId         = MI_Child.Id
             LEFT JOIN tmpJuridical                                        ON tmpJuridical.MovementItemId           = MI_Child.Id
             LEFT JOIN tmpContract                                         ON tmpContract.MovementItemId            = MI_Child.Id

             LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId = tmpJuridical.JuridicalId --MovementItemLastPriceList_View.JuridicalId
                                        AND JuridicalSettings.ContractId  = tmpContract.ContractId     --MovementItemLastPriceList_View.ContractId
             LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                               AND MIFloat_Price.ValueData >= tmpJuridicalSettingsItem.PriceLimit_min
                                               AND MIFloat_Price.ValueData <= tmpJuridicalSettingsItem.PriceLimit

             LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpJuridical.JuridicalId
                                 AND GoodsPromo.GoodsId     = tmpMI.GoodsId            --             ----and 1=0

             LEFT JOIN PriceSettings    ON MIFloat_Price.ValueData BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice  -- ----and 1=0
             LEFT JOIN PriceSettingsTOP ON MIFloat_Price.ValueData BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice  -- ----and 1=0

             --LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = GoodsPromo.MovementId
             LEFT JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = tmpJuridical.JuridicalId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                 ON ObjectLink_Goods_Area.ObjectId = tmpMI.PartnerGoodsId
                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId

            LEFT JOIN tmpCostCredit ON MIFloat_Price.ValueData BETWEEN tmpCostCredit.MinPrice  AND tmpCostCredit.PriceLimit

          ;

--     RETURN NEXT Cursor2;

       OPEN Cursor1 FOR SELECT * FROM _tmpRes1;
       RETURN NEXT Cursor1;

       OPEN Cursor2 FOR SELECT * FROM _tmpRes2;
       RETURN NEXT Cursor2;


    -- !!!Только для ДРУГИХ документов + inShowAll = FALSE - 2-ая ВЕТКА (ВСЕГО = 3)!!!
    ELSEIF inShowAll = FALSE
    THEN


--raise notice 'Value: % % % %', inMovementId, vbObjectId, 0, vbUserId;

--    PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, 0, vbUserId);

     -- ПАРАМЕТРЫ
     SELECT ObjectLink_Unit_Juridical.ChildObjectId, MovementLinkObject.ObjectId, COALESCE (ObjectLink_Unit_Area.ChildObjectId, zc_Area_Basis())
            INTO vbMainJuridicalId, vbUnitId, vbAreaId_find
         FROM MovementLinkObject
              --INNER JOIN Object_Unit_View ON Object_Unit_View.Id = MovementLinkObject.ObjectId
              INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject.ObjectId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

              LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                   ON ObjectLink_Unit_Area.ObjectId = MovementLinkObject.ObjectId
                                  AND ObjectLink_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
     WHERE MovementLinkObject.MovementId = inMovementId
       AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();


     -- таблица Регион поставщика
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpJuridicalArea'))
     THEN
         CREATE TEMP TABLE tmpJuridicalArea (UnitId Integer, JuridicalId Integer, AreaId Integer, AreaName TVarChar, isDefault Boolean) ON COMMIT DROP;
         INSERT INTO tmpJuridicalArea (UnitId, JuridicalId, AreaId, AreaName, isDefault)
            SELECT DISTINCT
                   tmp.UnitId                   AS UnitId
                 , tmp.JuridicalId              AS JuridicalId
                 , tmp.AreaId_Juridical         AS AreaId
                 , tmp.AreaName_Juridical       AS AreaName
                 , tmp.isDefault_JuridicalArea  AS isDefault
            FROM lpSelect_Object_JuridicalArea_byUnit (vbUnitId, 0) AS tmp;
     END IF;


     -- ДАННЫЕ
     CREATE TEMP TABLE _tmpMI (Id integer
                             , MovementItemId Integer
                             , PriceListMovementItemId Integer
                             , Price TFloat
                             , PartionGoodsDate TDateTime
                             , GoodsId Integer
                             , GoodsCode TVarChar
                             , GoodsName TVarChar
                             , MainGoodsName TVarChar
                             , JuridicalId Integer
                             , JuridicalName TVarChar
                             , MakerName TVarChar
                             , ContractId Integer
                             , ContractName TVarChar
                             , AreaId Integer
                             , AreaName TVarChar
                             , isDefault Boolean
                             , Deferment Integer
                             , Bonus TFloat
                             , Percent TFloat
                             , SuperFinalPrice TFloat
                             , SuperFinalPrice_Deferment TFloat) ON COMMIT DROP;


      -- Сохраниели данные
      INSERT INTO _tmpMI

           WITH -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту) !!!внутри проц определяется ObjectId!!!
                PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (vbUserId::TVarChar))
              , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (vbUserId::TVarChar))

              , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS T WHERE T.MainJuridicalId = vbMainJuridicalId)

                -- элементы установок юр.лиц (границы цен для бонуса)
              , tmpJuridicalSettingsItem AS (SELECT tmp.JuridicalSettingsId
                                                  , tmp.Bonus
                                                  , tmp.PriceLimit_min
                                                  , tmp.PriceLimit
                                             FROM JuridicalSettings
                                                  INNER JOIN gpSelect_Object_JuridicalSettingsItem (JuridicalSettings.JuridicalSettingsId, inSession) AS tmp ON tmp.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                             WHERE COALESCE (JuridicalSettings.isBonusClose, FALSE) = FALSE
                                             )

              , JuridicalArea AS (SELECT DISTINCT ObjectLink_JuridicalArea_Juridical.ChildObjectId AS JuridicalId
                                  FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                       INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                                AND Object_JuridicalArea.isErased = FALSE
                                       INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                             ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                            AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                            AND ObjectLink_JuridicalArea_Area.ChildObjectId = vbAreaId_find
                                       -- Уникальный код поставщика ТОЛЬКО для Региона
                                       INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                                                ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id
                                                               AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                                               AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
                                  WHERE ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                 )

              , MovementItemOrder AS (SELECT MovementItem.*
                                           , ObjectLink_Main.ChildObjectId AS GoodsMainId, ObjectLink_LinkGoods_Goods.ChildObjectId AS GoodsId
                                      FROM MovementItem
                                       --  INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = MovementItem.ObjectId -- Связь товара сети с общим
                                       -- получаем GoodsMainId
                                           INNER JOIN  ObjectLink AS ObjectLink_Child
                                                                  ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
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
                                                               AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                                                ON ObjectLink_Goods_Area.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                               AND ObjectLink_Goods_Area.DescId   = zc_ObjectLink_Goods_Area()
                                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                                                ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                               AND ObjectLink_Goods_Object.DescId   = zc_ObjectLink_Goods_Object()
                                           LEFT JOIN JuridicalArea ON JuridicalArea.JuridicalId = ObjectLink_Goods_Object.ChildObjectId

                                      WHERE MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND (ObjectLink_Goods_Area.ChildObjectId = vbAreaId_find OR JuridicalArea.JuridicalId IS NULL)
                                  )
                -- Маркетинговый контракт
              , tmpOperDate AS (SELECT date_trunc ('day', Movement.OperDate) AS OperDate FROM Movement WHERE Movement.Id = inMovementId)
              , GoodsPromo AS (SELECT tmp.JuridicalId
                                    , tmp.GoodsId        -- здесь товар "сети"
                                    , tmp.ChangePercent
                               FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                       ) AS tmp
                              )
              , LastPriceList_View AS (SELECT * FROM lpSelect_LastPriceList_View_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                                       , inUnitId  := vbUnitId
                                                                                       , inUserId  := vbUserId) AS tmp
                                      )
                -- Список цены + ТОП
              , GoodsPrice AS (SELECT MovementItemOrder.ObjectId AS GoodsId, ObjectBoolean_Top.ValueData AS isTOP
                               FROM MovementItemOrder
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                                          ON ObjectLink_Price_Goods.ChildObjectId = MovementItemOrder.ObjectId
                                                         AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                          ON ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                                         AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                                         AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                    INNER JOIN ObjectBoolean AS ObjectBoolean_Top
                                                             ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                                            AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                                                            AND ObjectBoolean_Top.ValueData = TRUE
                              )

              , tmpLoadPriceList AS (SELECT DISTINCT LoadPriceList.JuridicalId
                                          , LoadPriceList.ContractId
                                          , LoadPriceList.AreaId
                                     FROM LoadPriceList
                                     )

      -- данные по % кредитных средств из справочника
      , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := vbObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inSession) AS tmp)


       -- Результат
       SELECT row_number() OVER ()
            , ddd.Id AS MovementItemId
            , ddd.PriceListMovementItemId
            , ddd.Price
            , ddd.PartionGoodsDate
            , ddd.GoodsId
            , ddd.GoodsCode
            , ddd.GoodsName
            , ddd.MainGoodsName
            , ddd.JuridicalId
            , ddd.JuridicalName
            , ddd.MakerName
            , ddd.ContractId
            , ddd.ContractName
            , ddd.AreaId
            , ddd.AreaName
            , ddd.isDefault
            , ddd.Deferment
            , ddd.Bonus
/* * /
            , CASE WHEN ddd.Deferment = 0
                        THEN 0
                   WHEN ddd.isTOP = TRUE
                        THEN COALESCE (PriceSettingsTOP.Percent, 0)
                   ELSE PriceSettings.Percent
              END :: TFloat AS Percent
            , CASE WHEN ddd.Deferment = 0
                        THEN FinalPrice
                   WHEN ddd.Deferment = 0 OR ddd.isTOP = TRUE
                        THEN FinalPrice * (100 - COALESCE (PriceSettingsTOP.Percent, 0)) / 100
                   ELSE FinalPrice * (100 - PriceSettings.Percent) / 100
              END :: TFloat AS SuperFinalPrice
/ */
            , CASE WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                        THEN COALESCE (PriceSettingsTOP.Percent, 0)
                   WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                        THEN COALESCE (PriceSettings.Percent, 0)
                   ELSE 0
              END :: TFloat AS Percent
              
            , CASE WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                        THEN FinalPrice * (100 + COALESCE (PriceSettingsTOP.Percent, 0)) / 100
                   WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                        THEN FinalPrice * (100 + COALESCE (PriceSettings.Percent, 0)) / 100
                   ELSE FinalPrice
              END :: TFloat AS SuperFinalPrice
              
            , (ddd.FinalPrice - ddd.FinalPrice * ((ddd.Deferment) * COALESCE (tmpCostCredit.Percent, vbCostCredit) ) / 100) :: TFloat AS SuperFinalPrice_Deferment
/**/
       FROM
             (SELECT DISTINCT MovementItemOrder.Id
                  , MovementItemLastPriceList_View.Price AS Price
                  , MovementItemLastPriceList_View.MovementItemId AS PriceListMovementItemId
                  , MovementItemLastPriceList_View.PartionGoodsDate
                  , MIN (MovementItemLastPriceList_View.Price) OVER (PARTITION BY MovementItemOrder.Id ORDER BY MovementItemLastPriceList_View.PartionGoodsDate DESC) AS MinPrice
                  , CASE
                      -- -- если Цена поставщика не попадает в ценовые промежутки (до какой цены учитывать бонус при расчете миним. цены)
                      WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                           THEN MovementItemLastPriceList_View.Price
                               -- И учитывается % бонуса из Маркетинговый контракт
                             * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)

                      ELSE -- иначе учитывается бонус - для ТОП-позиции или НЕ ТОП-позиции
                           (MovementItemLastPriceList_View.Price * (100 - COALESCE(tmpJuridicalSettingsItem.Bonus, 0)) / 100) :: TFloat
                            -- И учитывается % бонуса из Маркетинговый контракт
                          * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
                    END AS FinalPrice
                  , CASE WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL 
                              THEN 0
                         ELSE COALESCE(tmpJuridicalSettingsItem.Bonus, 0)
                    END :: TFloat AS Bonus

                  , MovementItemLastPriceList_View.GoodsId
                  , MovementItemLastPriceList_View.GoodsCode
                  , MovementItemLastPriceList_View.GoodsName
                  , MovementItemLastPriceList_View.MakerName
                  , MainGoods.valuedata                       AS MainGoodsName
                  , Juridical.ID                              AS JuridicalId
                  , Juridical.ValueData                       AS JuridicalName
                  , Contract.Id                               AS ContractId
                  , Contract.ValueData                        AS ContractName
                  , COALESCE (ObjectFloat_Deferment.ValueData, 0)::Integer AS Deferment
                  , COALESCE (GoodsPrice.isTOP, COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)) AS isTOP

                  , tmpJuridicalArea.AreaId
                  , tmpJuridicalArea.AreaName
                  , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean AS isDefault

               FROM MovementItemOrder
                    LEFT OUTER JOIN MovementItemLastPriceList_View ON MovementItemLastPriceList_View.GoodsId = MovementItemOrder.GoodsId
                                                                  AND MovementItemLastPriceList_View.isErased = False

                    JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                         AND tmpJuridicalArea.AreaId      = MovementItemLastPriceList_View.AreaId

                    INNER JOIN tmpLoadPriceList ON tmpLoadPriceList.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                               AND tmpLoadPriceList.ContractId  = MovementItemLastPriceList_View.ContractId
                                               AND (tmpLoadPriceList.AreaId = MovementItemLastPriceList_View.AreaId OR COALESCE (tmpLoadPriceList.AreaId, 0) = 0)


                    LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                               AND JuridicalSettings.ContractId  = MovementItemLastPriceList_View.ContractId
                    LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                                      AND MovementItemLastPriceList_View.Price >= tmpJuridicalSettingsItem.PriceLimit_min
                                                      AND MovementItemLastPriceList_View.Price <= tmpJuridicalSettingsItem.PriceLimit

                    -- товар "поставщика", если он есть в прайсах !!!а он есть!!!
                             --LEFT JOIN Object AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
                    --LEFT JOIN ObjectString AS ObjectString_GoodsCode ON ObjectString_GoodsCode.ObjectId = MILinkObject_Goods.ObjectId
                    --                      AND ObjectString_GoodsCode.DescId = zc_ObjectString_Goods_Code()
                    --LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                    --                           ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId
                    --                          AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()

                    JOIN OBJECT AS Juridical ON Juridical.Id = MovementItemLastPriceList_View.JuridicalId

                    LEFT JOIN OBJECT AS Contract ON Contract.Id = MovementItemLastPriceList_View.ContractId

                    LEFT JOIN ObjectFloat AS ObjectFloat_Deferment
                                          ON ObjectFloat_Deferment.ObjectId = Contract.Id
                                         AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()

                    LEFT JOIN OBJECT AS MainGoods ON MainGoods.Id = MovementItemOrder.GoodsMainId

                    LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                            ON ObjectBoolean_Goods_TOP.ObjectId = MovementItemOrder.ObjectId
                                           AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
                    LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = MovementItemOrder.ObjectId

                    --   LEFT JOIN Object_Goods_View AS Goods  -- Элемент документа заявка
                    --     ON Goods.Id = MovementItemOrder.ObjectId

                    -- % бонуса из Маркетинговый контракт
                    LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = MovementItemOrder.ObjectId
                                        AND GoodsPromo.JuridicalId = MovementItemLastPriceList_View.JuridicalId


               WHERE  COALESCE(JuridicalSettings.isPriceCloseOrder, FALSE) <> TRUE                                        -- 
       ) AS ddd

       LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
       LEFT JOIN PriceSettingsTOP ON ddd.MinPrice BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
       LEFT JOIN tmpCostCredit    ON ddd.MinPrice BETWEEN tmpCostCredit.MinPrice  AND tmpCostCredit.PriceLimit
  ;

-- lpCreateTempTable_OrderInternal Конец процедуры

   --RAISE EXCEPTION 'Ошибка.';
--raise notice 'Value: %', 2;
     -- OPEN Cursor1 FOR
     -- OPEN Cursor1 FOR
     CREATE TEMP TABLE _tmpRes1 ON COMMIT DROP AS
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
                        WHERE MLM_Order.MovementId is NULL
                        GROUP BY Movement_OrderExternal.GoodsId
                        HAVING SUM (Movement_OrderExternal.Amount) <> 0
                       )

        -- Маркетинговый контракт
      , GoodsPromo AS (WITH tmpPromo AS (SELECT * FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= vbOperDate) AS tmp) -- CURRENT_DATE
                          , tmpList AS (SELECT ObjectLink_Child.ChildObjectId        AS GoodsId
                                             , ObjectLink_Child_retail.ChildObjectId AS GoodsId_retail -- здесь товар "сети"
                                        FROM ObjectLink AS ObjectLink_Child
                                              INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                                       AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                              INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                             AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                              INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                              AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                                    ON ObjectLink_Goods_Object.ObjectId      = ObjectLink_Child_retail.ChildObjectId
                                                                   AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                                                   AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                                        WHERE ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                          -- AND vbObjectId <> 3
                                       )
                       SELECT tmp.JuridicalId
                            , COALESCE (tmpList.GoodsId_retail, tmp.GoodsId) AS GoodsId -- здесь товар "сети"
                            , tmp.MovementId
                            , tmp.ChangePercent
                            , MovementPromo.OperDate                AS OperDatePromo
                            , MovementPromo.InvNumber               AS InvNumberPromo -- ***
                       FROM tmpPromo AS tmp   --CURRENT_DATE
                            INNER JOIN tmpList ON tmpList.GoodsId = tmp.GoodsId
                            LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = tmp.MovementId
                      )
        -- Список цены + ТОП
      , GoodsPrice AS (SELECT Price_Goods.ChildObjectId           AS GoodsId
                            , COALESCE(Price_Top.ValueData,FALSE) AS isTop
                       FROM ObjectLink AS ObjectLink_Price_Unit
                            INNER JOIN ObjectBoolean     AS Price_Top
                                    ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                                   AND Price_Top.ValueData = TRUE
                            LEFT JOIN ObjectLink       AS Price_Goods
                                   ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                       WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                       )

      -- данные из ассорт. матрицы
      , tmpGoodsCategory AS (SELECT ObjectLink_Child_retail.ChildObjectId AS GoodsId
                                  , ObjectFloat_Value.ValueData                  AS Value
                             FROM Object AS Object_GoodsCategory
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                       ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                                      AND ObjectLink_GoodsCategory_Unit.ChildObjectId = vbUnitId
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                       ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                 INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                                        ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                       AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                                       AND COALESCE (ObjectFloat_Value.ValueData,0) <> 0
                                 -- выходим на товар сети
                                 INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                       ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                                      AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                 INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                       ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                      AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                 INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                       ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                      AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                      AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                                                 
                             WHERE Object_GoodsCategory.DescId = zc_Object_GoodsCategory()
                               AND Object_GoodsCategory.isErased = FALSE
                             )


      , tmpMI_All AS (SELECT MovementItem.*
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                         )
        -- 2.1
      , tmpOF_Goods_MinimumLot AS (SELECT *
                                   FROM ObjectFloat
                                   WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                     AND ObjectFloat.ValueData <> 0
                                     AND ObjectFloat.ObjectId  IN (SELECT DISTINCT tmpMI_All.ObjectId FROM tmpMI_All)
                       )
      , tmpMI_Master AS (SELECT tmpMI.*
                              , CEIL(tmpMI.Amount / COALESCE(ObjectFloat_Goods_MinimumLot.ValueData , 1))
                                * COALESCE(ObjectFloat_Goods_MinimumLot.ValueData , 1)                       AS CalcAmount
                              , ObjectFloat_Goods_MinimumLot.ValueData                                       AS MinimumLot
                              , COALESCE (GoodsPrice.isTOP, FALSE)                                           AS Price_isTOP
                         FROM tmpMI_All AS tmpMI
                               LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = tmpMI.ObjectId
                               LEFT JOIN tmpOF_Goods_MinimumLot AS ObjectFloat_Goods_MinimumLot
                                                                ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI.ObjectId
                                                              -- AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                         )

  , tmpGoods_all AS (SELECT ObjectLink_Goods_Object.ObjectId                       AS GoodsId
                          , Object_Goods.ObjectCode                                AS GoodsCode
                          , Object_Goods.ValueData                                 AS GoodsName
                          , ObjectLink_Goods_GoodsGroup.ChildObjectId              AS GoodsGroupId
                          , ObjectLink_Goods_NDSKind.ChildObjectId                 AS NDSKindId
                          , Object_NDSKind.ValueData                               AS NDSKindName
                          , ObjectFloat_NDSKind_NDS.ValueData                      AS NDS
                          -- , ObjectFloat_Goods_MinimumLot.ValueData                 AS Multiplicity
                          , COALESCE(ObjectBoolean_Goods_Close.ValueData, FALSE)   AS isClose
                          , COALESCE(ObjectBoolean_Goods_TOP.ValueData, FALSE)     AS Goods_isTOP
                          , COALESCE (GoodsPrice.isTop, FALSE)                     AS Price_isTOP
                          , COALESCE(ObjectBoolean_First.ValueData, FALSE)         AS isFirst
                          , COALESCE(ObjectBoolean_Second.ValueData, FALSE)        AS isSecond

                          , ObjectLink_Goods_Object.ObjectId                       AS GoodsId_MinLot

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

                          -- LEFT JOIN tmpOF_Goods_MinimumLot  AS ObjectFloat_Goods_MinimumLot
                          --                       ON ObjectFloat_Goods_MinimumLot.ObjectId = ObjectLink_Goods_Object.ObjectId
                                           --     AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                     -- WHERE (inShowAll = TRUE OR tmpMI_Master.Id is not NULL)
                     WHERE tmpMI_Master.Id IS NOT NULL
                       AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                       AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                    )

        -- 2.2
      , tmpOF_MinimumLot_Goods AS (SELECT *
                                   FROM ObjectFloat
                                   WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                     AND ObjectFloat.ValueData <> 0
                                     AND ObjectFloat.ObjectId  IN (SELECT DISTINCT tmpGoods_all.GoodsId_MinLot FROM tmpGoods_all)
                       )

      , tmpGoods AS (SELECT tmpGoods_all.GoodsId
                          , tmpGoods_all.GoodsCode
                          , tmpGoods_all.GoodsName
                          , tmpGoods_all.GoodsGroupId
                          , tmpGoods_all.NDSKindId
                          , tmpGoods_all.NDSKindName
                          , tmpGoods_all.NDS
                          , ObjectFloat_Goods_MinimumLot.ValueData AS Multiplicity
                          , tmpGoods_all.isClose
                          , tmpGoods_all.Goods_isTOP
                          , tmpGoods_all.Price_isTOP
                          , tmpGoods_all.isFirst
                          , tmpGoods_all.isSecond

                     FROM tmpGoods_all
                          LEFT JOIN tmpOF_MinimumLot_Goods AS ObjectFloat_Goods_MinimumLot
                                                           ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpGoods_all.GoodsId_MinLot
                                           --     AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                    )

      , tmpMIF AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                     INNER JOIN (SELECT tmpMI_Master.Id FROM tmpMI_Master) AS test ON test.ID = MovementItemFloat.MovementItemId
--                   WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Master.Id FROM tmpMI_Master)
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
      , tmpMIF_ListDiff AS (SELECT tmpMIF.*
                            FROM tmpMIF
                            WHERE tmpMIF.DescId = zc_MIFloat_ListDiff()
                           )
        , tmpMIF_AmountReal AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_AmountReal()
                               )
        , tmpMIF_SendSUN AS (SELECT tmpMIF.*
                             FROM tmpMIF
                             WHERE tmpMIF.DescId = zc_MIFloat_SendSUN()
                            )
        , tmpMIF_SendDefSUN AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_SendDefSUN()
                               )
        , tmpMIF_RemainsSUN AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_RemainsSUN()
                               )
      , tmpMILinkObject AS (SELECT MILinkObject.*
                            FROM MovementItemLinkObject AS MILinkObject
--                              INNER JOIN  (SELECT tmpMI_Master.Id from tmpMI_Master) AS test ON test.ID = MILinkObject.MovementItemId
                            WHERE MILinkObject.DescId IN ( zc_MILinkObject_Juridical()
                                                         , zc_MILinkObject_Contract()
                                                         , zc_MILinkObject_Goods())
                              AND MILinkObject.MovementItemId in (SELECT tmpMI_Master.Id from tmpMI_Master)
                            )

      , tmpMIString_Comment AS (SELECT MIString_Comment.*
                                FROM MovementItemString AS MIString_Comment
--                                  INNER JOIN  (SELECT tmpMI_Master.Id from tmpMI_Master) AS test ON test.ID = MIString_Comment.MovementItemId
                                WHERE MIString_Comment.DescId = zc_MIString_Comment()
                                  AND MIString_Comment.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                )

      , tmpMIBoolean_Calculated AS (SELECT MIBoolean_Calculated.*
                                    FROM MovementItemBoolean AS MIBoolean_Calculated
--                                      INNER JOIN  (SELECT tmpMI_Master.Id from tmpMI_Master) AS test ON test.ID = MIBoolean_Calculated.MovementItemId
                                    WHERE MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                      AND MIBoolean_Calculated.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                   )


      , tmpMinPrice AS (SELECT DISTINCT DDD.MovementItemId
                             , DDD.GoodsId
                             , DDD.GoodsCode
                             , DDD.GoodsName
                             , DDD.JuridicalId
                             , DDD.JuridicalName
                             , DDD.ContractId
                             , DDD.ContractName
                             , DDD.MakerName
                             , DDD.PartionGoodsDate
                             , DDD.SuperFinalPrice
                             , DDD.SuperFinalPrice_Deferment
                             , DDD.Price
                             , DDD.MinId
                        FROM (SELECT *, MIN(Id) OVER (PARTITION BY MovementItemId) AS MinId
                              FROM (SELECT *
                                         -- , MIN (SuperFinalPrice) OVER (PARTITION BY MovementItemId) AS MinSuperFinalPrice
                                         , ROW_NUMBER() OVER (PARTITION BY _tmpMI.MovementItemId ORDER BY (CASE WHEN _tmpMI.PartionGoodsDate < vbDate180 THEN _tmpMI.SuperFinalPrice_Deferment + 100 ELSE _tmpMI.SuperFinalPrice_Deferment END) ASC, _tmpMI.PartionGoodsDate DESC, _tmpMI.Deferment DESC) AS Ord
                                    FROM _tmpMI
                                   ) AS DDD
                              -- WHERE DDD.SuperFinalPrice = DDD.MinSuperFinalPrice
                              WHERE DDD.Ord = 1
                             ) AS DDD
                        WHERE Id = MinId
                       )
        -- чтоб не двоило данные , выбираем  группируем данных с макс датой отгрузки
      , tmpMI_PriceList AS (SELECT *
                            FROM (SELECT _tmpMI.*
                                       , ROW_NUMBER() OVER (PARTITION BY _tmpMI.MovementItemId, _tmpMI.JuridicalId, _tmpMI.GoodsId, _tmpMI.ContractId ORDER BY _tmpMI.Price ASC, _tmpMI.PartionGoodsDate DESC) AS Ord
                                  FROM _tmpMI
                                 ) AS DDD
                            WHERE DDD.Ord = 1
                            )

, tmpMI_all_MinLot AS (SELECT MovementItem.Id
                            , MovementItem.ObjectId                                            AS GoodsId
                            , MovementItem.Amount                                              AS Amount
                            , MovementItem.CalcAmount
                            , MIFloat_Summ.ValueData                                           AS Summ
                            , MovementItem.MinimumLot                                          AS Multiplicity
                            , MIString_Comment.ValueData                                       AS Comment
                            , COALESCE(PriceList.MakerName, MinPrice.MakerName)                AS MakerName
                            , MIBoolean_Calculated.ValueData                                   AS isCalculated
                            -- , ObjectFloat_Goods_MinimumLot.valuedata                           AS MinimumLot
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
                            , COALESCE(PriceList.SuperFinalPrice_Deferment, MinPrice.SuperFinalPrice_Deferment) AS SuperFinalPrice_Deferment
                            --, MovementItem.Goods_isTOP
                            , MovementItem.Price_isTOP
                            , MIFloat_AmountSecond.ValueData                                   AS AmountSecond
                            , MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) AS AmountAll
                              -- округлили ВВЕРХ AllLot
                            /*, CEIL ((-- Спецзаказ
                                     MovementItem.Amount
                                     -- Количество дополнительное
                                   + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                     -- кол-во отказов
                                   + COALESCE (MIFloat_ListDiff.ValueData, 0)
                                    ) / COALESCE (MovementItem.MinimumLot, 1)
                                   ) * COALESCE(MovementItem.MinimumLot, 1)                    AS CalcAmountAll
                            */
                        --27.01.2020 Люба просит чтоб в расчет ложилась не сумма а большее из "Спец + Авто" и "Отказы" - поскольку сумма этих колонок приводит к затоварке аптек
                            , CEIL ((                                -- Спецзаказ + Количество дополнительное                        -- кол-во отказов
                                     CASE WHEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)) >= COALESCE (MIFloat_ListDiff.ValueData, 0)
                                          THEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))         -- Спецзаказ + Количество дополнительное
                                          ELSE COALESCE (MIFloat_ListDiff.ValueData, 0)                                                   -- кол-во отказов
                                     END
                                    ) / COALESCE (MovementItem.MinimumLot, 1)
                                   ) * COALESCE (MovementItem.MinimumLot, 1)                   AS CalcAmountAll

                            , MIFloat_AmountManual.ValueData                                   AS AmountManual
                            , MIFloat_ListDiff.ValueData                                       AS ListDiffAmount

                            , MIFloat_AmountReal.ValueData :: TFloat  AS AmountReal
                            , MIFloat_SendSUN.ValueData    :: TFloat  AS SendSUNAmount
                            , MIFloat_SendDefSUN.ValueData :: TFloat  AS SendDefSUNAmount
                            , MIFloat_RemainsSUN.ValueData :: TFloat  AS RemainsSUN

                            , MovementItem.isErased
                            , COALESCE (PriceList.GoodsId, MinPrice.GoodsId)                   AS GoodsId_MinLot
                       FROM tmpMI_Master AS MovementItem
     
                            LEFT JOIN tmpMILinkObject AS MILinkObject_Juridical
                                                      ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
     
                            LEFT JOIN tmpMILinkObject AS MILinkObject_Contract
                                                      ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
     
                            LEFT JOIN tmpMILinkObject AS MILinkObject_Goods
                                                      ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
     
                            LEFT JOIN tmpMIBoolean_Calculated AS MIBoolean_Calculated ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
     
                            LEFT JOIN tmpMIString_Comment AS MIString_Comment ON MIString_Comment.MovementItemId = MovementItem.Id
     
                            LEFT JOIN tmpMI_PriceList AS PriceList ON COALESCE (PriceList.ContractId, 0) = COALESCE (MILinkObject_Contract.ObjectId, 0)
                                                     AND PriceList.JuridicalId = MILinkObject_Juridical.ObjectId
                                                     AND PriceList.GoodsId = MILinkObject_Goods.ObjectId
                                                     AND PriceList.MovementItemId = MovementItem.Id
     
                            LEFT JOIN tmpMinPrice AS MinPrice ON MinPrice.MovementItemId = MovementItem.Id
     
                            -- LEFT JOIN tmpOF_Goods_MinimumLot AS ObjectFloat_Goods_MinimumLot
                            --                                  ON ObjectFloat_Goods_MinimumLot.ObjectId = COALESCE (PriceList.GoodsId, MinPrice.GoodsId)
                                                 --- AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
     
                            LEFT JOIN tmpMIF_Summ AS MIFloat_Summ ON MIFloat_Summ.MovementItemId = MovementItem.Id
                            LEFT JOIN tmpMIF_AmountSecond AS MIFloat_AmountSecond ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                            LEFT JOIN tmpMIF_AmountManual AS MIFloat_AmountManual ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                            LEFT JOIN tmpMIF_ListDiff     AS MIFloat_ListDiff     ON MIFloat_ListDiff.MovementItemId    = MovementItem.Id
                            LEFT JOIN tmpMIF_AmountReal     AS MIFloat_AmountReal     ON MIFloat_AmountReal.MovementItemId     = MovementItem.Id
                            LEFT JOIN tmpMIF_SendSUN        AS MIFloat_SendSUN        ON MIFloat_SendSUN.MovementItemId        = MovementItem.Id
                            LEFT JOIN tmpMIF_SendDefSUN     AS MIFloat_SendDefSUN     ON MIFloat_SendDefSUN.MovementItemId     = MovementItem.Id
                            LEFT JOIN tmpMIF_RemainsSUN     AS MIFloat_RemainsSUN     ON MIFloat_RemainsSUN.MovementItemId     = MovementItem.Id
     --LIMIT 2
                       )

        -- 2.3
      , tmpOF_MinimumLot_mi AS (SELECT *
                                FROM ObjectFloat
                                WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                  AND ObjectFloat.ValueData <> 0
                                  AND ObjectFloat.ObjectId  IN (SELECT DISTINCT tmpMI_all_MinLot.GoodsId_MinLot FROM tmpMI_all_MinLot)
                                )

      , tmpMI AS (SELECT tmpMI_all_MinLot.Id
                       , tmpMI_all_MinLot.GoodsId
                       , tmpMI_all_MinLot.Amount
                       , tmpMI_all_MinLot.CalcAmount
                       , tmpMI_all_MinLot.Summ
                       , tmpMI_all_MinLot.Multiplicity
                       , tmpMI_all_MinLot.Comment
                       , tmpMI_all_MinLot.MakerName
                       , tmpMI_all_MinLot.isCalculated
                       , ObjectFloat_Goods_MinimumLot.ValueData AS MinimumLot
                       , tmpMI_all_MinLot.Price
                       , tmpMI_all_MinLot.PartionGoodsDate
                       , tmpMI_all_MinLot.PartnerGoodsId
                       , tmpMI_all_MinLot.PartnerGoodsCode
                       , tmpMI_all_MinLot.PartnerGoodsName
                       , tmpMI_all_MinLot.JuridicalId
                       , tmpMI_all_MinLot.JuridicalName
                       , tmpMI_all_MinLot.ContractId
                       , tmpMI_all_MinLot.ContractName
                       , tmpMI_all_MinLot.SuperFinalPrice
                       , tmpMI_all_MinLot.SuperFinalPrice_Deferment
                       , tmpMI_all_MinLot.Price_isTOP
                       , tmpMI_all_MinLot.AmountSecond
                       , tmpMI_all_MinLot.AmountAll
                       , tmpMI_all_MinLot.CalcAmountAll
                       , tmpMI_all_MinLot.AmountManual
                       , tmpMI_all_MinLot.ListDiffAmount
                       , tmpMI_all_MinLot.AmountReal
                       , tmpMI_all_MinLot.SendSUNAmount
                       , tmpMI_all_MinLot.SendDefSUNAmount
                       , tmpMI_all_MinLot.RemainsSUN
                       , tmpMI_all_MinLot.isErased
                  FROM tmpMI_all_MinLot

                       LEFT JOIN tmpOF_MinimumLot_mi AS ObjectFloat_Goods_MinimumLot
                                                     ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI_all_MinLot.GoodsId_MinLot
                  )

      , tmpPriceView AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                              , MCS_Value.ValueData                     AS MCSValue
                              , Price_Goods.ChildObjectId               AS GoodsId
                              , COALESCE(MCS_isClose.ValueData,FALSE)   AS MCSIsClose
                              , COALESCE(MCS_NotRecalc.ValueData,FALSE) AS MCSNotRecalc
                              , COALESCE(Price_Top.ValueData,FALSE)     AS isTop
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
                           AND (inShowAll = TRUE OR tmpMI_Master.Id is not NULL)
                      )

      , tmpGoodsId AS (SELECT COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)           AS GoodsId
                    FROM tmpGoods
                         FULL JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                    GROUP BY COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)
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
                         , tmpMI.SuperFinalPrice_Deferment
                         , COALESCE (tmpMI.isCalculated, FALSE)                             AS isCalculated
                         , tmpMI.AmountSecond                                               AS AmountSecond
                         , NULLIF (tmpMI.AmountAll, 0)                                      AS AmountAll
                         , NULLIF (COALESCE (tmpMI.AmountManual, tmpMI.CalcAmountAll), 0)   AS CalcAmountAll
                         , tmpMI.Price * COALESCE (tmpMI.AmountManual, tmpMI.CalcAmountAll) AS SummAll
                         , tmpMI.ListDiffAmount
                         , tmpMI.AmountReal
                         , tmpMI.SendSUNAmount
                         , tmpMI.SendDefSUNAmount
                         , tmpMI.RemainsSUN
                    FROM tmpGoods
                         FULL JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                   )
      -- считаем остатки
      , tmpRemains AS (SELECT Container.ObjectId
                            , SUM (Container.Amount) AS Amount
                       FROM Container
                            INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                           ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                          AND ContainerLinkObject_Unit.ObjectId = vbUnitId
                            INNER JOIN tmpGoodsId AS tmp
                                                  ON tmp.GoodsId = Container.ObjectId
                       WHERE Container.DescId = zc_Container_Count()
                         AND Container.Amount<>0
--                         AND Container.ObjectId in (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                       GROUP BY Container.ObjectId
                      )
      -- приход
      , tmpIncome AS (SELECT MovementItem_Income.ObjectId               AS Income_GoodsId
                           , SUM (MovementItem_Income.Amount) :: TFloat AS Income_Amount
                      FROM Movement AS Movement_Income
                           INNER JOIN MovementItem AS MovementItem_Income
                                                   ON Movement_Income.Id = MovementItem_Income.MovementId
                                                  AND MovementItem_Income.DescId = zc_MI_Master()
                                                  AND MovementItem_Income.isErased = FALSE
                                                  AND MovementItem_Income.Amount > 0
--                                                  AND MovementItem_Income.ObjectId in (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                           INNER JOIN tmpGoodsId AS tmp
                                                 ON tmp.GoodsId = MovementItem_Income.ObjectId
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                        AND MovementLinkObject_To.ObjectId = vbUnitId
                           INNER JOIN MovementDate AS MovementDate_Branch
                                                   ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                  AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                       WHERE Movement_Income.DescId = zc_Movement_Income()
                         AND MovementDate_Branch.ValueData BETWEEN CURRENT_DATE - INTERVAL '31 DAY' AND CURRENT_DATE + INTERVAL '7 DAY'
                         AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                       GROUP BY MovementItem_Income.ObjectId
                     )

        -- Товары соц-проект (документ)
      , tmpGoodsSP AS (SELECT tmp.GoodsId
                            , TRUE AS isSP
                            , MIN(MIFloat_PriceOptSP.ValueData) AS PriceOptSP
                       FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= vbOperDate, inEndDate:= vbOperDate, inUnitId := vbUnitId) AS tmp
                                                LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                     ON MIFloat_PriceOptSP.MovementItemId = tmp.MovementItemId
                                                    AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                       GROUP BY tmp.GoodsId
                       )

      , tmpGoodsMain AS (SELECT tmpMI.GoodsId                                                           AS GoodsId
                              , COALESCE (tmpGoodsSP.isSP, False)                             ::Boolean AS isSP
                              , COALESCE (ObjectBoolean_Resolution_224.ValueData, FALSE)      ::Boolean AS isResolution_224
                              , CAST ( (COALESCE (tmpGoodsSP.PriceOptSP,0) * 1.1) AS NUMERIC (16,2)) :: TFloat   AS PriceOptSP
                              , CASE WHEN DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData) = vbOperDate THEN TRUE ELSE FALSE END  AS isMarketToday
                              , DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData)          ::TDateTime AS LastPriceDate
                              , COALESCE (ObjectFloat_CountPrice.ValueData,0)               ::TFloat    AS CountPrice
                         FROM tmpGoodsId AS tmpMI
                                -- получаем GoodsMainId
                                LEFT JOIN ObjectLink AS ObjectLink_Child
                                                     ON ObjectLink_Child.ChildObjectId = tmpMI.GoodsId
                                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                LEFT JOIN ObjectLink AS ObjectLink_Main
                                                     ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                    AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                                LEFT JOIN ObjectFloat AS ObjectFloat_CountPrice
                                                     ON ObjectFloat_CountPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectFloat_CountPrice.DescId = zc_ObjectFloat_Goods_CountPrice()

                                LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                                     ON ObjectDate_LastPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()

                                LEFT JOIN ObjectBoolean AS ObjectBoolean_Resolution_224
                                                        ON ObjectBoolean_Resolution_224.ObjectId = ObjectLink_Main.ChildObjectId
                                                       AND ObjectBoolean_Resolution_224.DescId = zc_ObjectBoolean_Goods_Resolution_224()

                                LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId
                         )

      -- условия хранения
      , tmpGoodsConditionsKeepList AS (SELECT ObjectLink_Goods_ConditionsKeep.ObjectId              AS GoodsId
                                            , ObjectLink_Goods_ConditionsKeep.ChildObjectId         AS ChildObjectId
                                   FROM ObjectLink AS ObjectLink_Goods_ConditionsKeep
                                        INNER JOIN tmpGoodsId AS tmp ON tmp.GoodsId = ObjectLink_Goods_ConditionsKeep.ObjectId
                                   WHERE ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
--                                     AND ObjectLink_Goods_ConditionsKeep.ObjectId IN (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                                  )

      , tmpGoodsConditionsKeep AS (SELECT ObjectLink_Goods_ConditionsKeep.GoodsId                   AS GoodsId
                                        , Object_ConditionsKeep.ValueData                           AS ConditionsKeepName
                                   FROM tmpGoodsConditionsKeepList AS ObjectLink_Goods_ConditionsKeep
--                                        INNER JOIN tmpGoodsId AS tmp ON tmp.GoodsId = ObjectLink_Goods_ConditionsKeep.GoodsId
                                        INNER JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
--                                     AND ObjectLink_Goods_ConditionsKeep.GoodsId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
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
                            /*LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                      ON MovementBoolean_Deferred.MovementId = Movement_Send.Id
                                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()*/
                            -- закомментил - пусть будут все перемещения, не только Авто
                            /*INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                       ON MovementBoolean_isAuto.MovementId = Movement_Send.Id
                                                      AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                      AND MovementBoolean_isAuto.ValueData  = TRUE*/
                            INNER JOIN MovementItem AS MI_Send
                                                    ON MI_Send.MovementId = Movement_Send.Id
                                                   AND MI_Send.DescId = zc_MI_Master()
                                                   AND MI_Send.isErased = FALSE
--                                                   AND MI_Send.ObjectId in (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                            INNER JOIN tmpGoodsId AS tmp
                                                  ON tmp.GoodsId = MI_Send.ObjectId
                     -- WHERE Movement_Send.OperDate >= vbOperDate - interval '30 DAY'
                     WHERE Movement_Send.OperDate BETWEEN CURRENT_DATE - INTERVAL '91 DAY' AND CURRENT_DATE + INTERVAL '30 DAY'   -- 27.01.2020  - 91 день, до этого было 31 - по просьбе Любы Пелиной
                       AND Movement_Send.OperDate < vbOperDateEnd
                       AND Movement_Send.DescId = zc_Movement_Send()
                       AND Movement_Send.StatusId = zc_Enum_Status_UnComplete()
                       --AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                     GROUP BY MI_Send.ObjectId
                     HAVING SUM (MI_Send.Amount) <> 0
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
/*
      , tmpLastOrder AS (SELECT Movement.Id
                              , ROW_NUMBER() OVER (ORDER BY Movement.Id DESC, Movement.Operdate DESC) AS Ord
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MLO_Unit
                                                            ON MLO_Unit.MovementId = Movement.Id
                                                           AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                           AND MLO_Unit.ObjectId   = vbUnitId
                         WHERE Movement.DescId = zc_Movement_OrderInternal()
                           AND Movement.Operdate >= vbOperDate - INTERVAL '30 DAY' AND Movement.Operdate < vbOperDate
                           AND 1=0
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
*/

      -- нет привязки по поставщику в последних 10 внутренних заказах
      -- товары без привязки к поставщику
      -- расчет через кнопку, т.к. отрабатывает не быстро
/*      , tmpGoodsNotLink AS (SELECT DISTINCT tmpGoodsList.GoodsId
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
*/
      , SelectMinPrice_AllGoods AS (SELECT _tmpMI.MovementItemId, CASE WHEN COUNT (*) > 1 THEN FALSE ELSE TRUE END AS isOneJuridical
                                    FROM _tmpMI
                                    GROUP BY _tmpMI.MovementItemId

                                   )

      , tmpObjectLink_Area AS (SELECT ObjectLink.*
                               FROM ObjectLink
                                 INNER JOIN (SELECT DISTINCT PartnerGoodsId FROM tmpMI) AS tmp
                                                                                      ON tmp.PartnerGoodsId = ObjectLink.ObjectId
                               WHERE ObjectLink.DescId = zc_ObjectLink_Goods_Area()
--                                    AND ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.PartnerGoodsId FROM tmpData)
                               )

      , tmpObjectLink_Object AS (SELECT ObjectLink.*
                                 FROM ObjectLink
                                   INNER JOIN (SELECT DISTINCT Id FROM tmpMI) AS tmp
                                                                                   ON tmp.Id = ObjectLink.ObjectId
                                 WHERE ObjectLink.DescId = zc_ObjectLink_Goods_Object()
--                                      AND ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.Id FROM tmpData)
                                 )


   -- выбираем отложенные Чеки (как в кассе колонка VIP)
   , tmpMovementChek AS (SELECT Movement.Id
                         FROM MovementBoolean AS MovementBoolean_Deferred
                              INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = vbUnitId
                         WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                           AND MovementBoolean_Deferred.ValueData = TRUE
                        UNION
                         SELECT Movement.Id
                         FROM MovementString AS MovementString_CommentError
                              INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = vbUnitId
                        WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                          AND MovementString_CommentError.ValueData <> ''
                        )
   , tmpReserve AS (SELECT MovementItem.ObjectId             AS GoodsId
                         , SUM (MovementItem.Amount)::TFloat AS Amount
                    FROM tmpMovementChek
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                         LEFT JOIN MovementBoolean AS MovementBoolean_NotMCS
                                                   ON MovementBoolean_NotMCS.MovementId = tmpMovementChek.Id
                                                  AND MovementBoolean_NotMCS.DescId     = zc_MovementBoolean_NotMCS()
                    WHERE COALESCE (MovementBoolean_NotMCS.ValueData, False) = False
                    GROUP BY MovementItem.ObjectId
                    )

   --средняя цена по приходам за месяц
   , AVGIncome AS (SELECT MI_Income.ObjectId
                        , AVG(CASE WHEN MovementBoolean_PriceWithVAT.ValueData  = TRUE
                                   THEN (MIFloat_Price.ValueData * 100 / (100 + ObjectFloat_NDSKind_NDS.ValueData))
                                   ELSE MIFloat_Price.ValueData
                              END)                               ::TFloat AS AVGIncomePrice
                   FROM Movement AS Movement_Income
                       JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                            ON MovementBoolean_PriceWithVAT.MovementId =  Movement_Income.Id
                                           AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                       JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                               ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                              AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                       JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                        ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                       AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                       JOIN MovementItem AS MI_Income
                                         ON MI_Income.MovementId = Movement_Income.Id
                                        AND MI_Income.DescId = zc_MI_Master()
                                        AND MI_Income.isErased = FALSE
                                        AND MI_Income.Amount > 0
                       JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MI_Income.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   WHERE Movement_Income.DescId = zc_Movement_Income()
                     AND Movement_Income.StatusId = zc_Enum_Status_Complete()
                     AND Movement_Income.OperDate >= vbAVGDateStart
                     AND Movement_Income.OperDate <= vbAVGDateEnd
                   GROUP BY MI_Income.ObjectId
                  )

       -- Результат 1
       SELECT
             tmpMI.Id                                       AS Id
           , tmpMI.GoodsId                                  AS GoodsId
           , tmpMI.GoodsCode                                AS GoodsCode
           , tmpMI.GoodsName                                AS GoodsName
           , Object_Retail.ValueData                        AS RetailName
           , tmpMI.isTOP                                    AS isTOP
           , COALESCE (Object_Price_View.isTOP, FALSE)      AS isTOP_Price

           , tmpMI.GoodsGroupId                             AS GoodsGroupId
           , tmpMI.NDSKindId                                AS NDSKindId
           , tmpMI.NDSKindName                              AS NDSKindName
           , tmpMI.NDS                                      AS NDS
           , tmpMI.isClose                                  AS isClose
           , tmpMI.isFirst                                  AS isFirst
           , tmpMI.isSecond                                 AS isSecond
           , COALESCE (tmpGoodsMain.isSP,FALSE) :: Boolean  AS isSP
           , COALESCE (tmpGoodsMain.isResolution_224,FALSE) :: Boolean  AS isResolution_224

           , CASE WHEN DATE_TRUNC ('DAY', tmpGoodsMain.LastPriceDate) = vbOperDate THEN TRUE ELSE FALSE END AS isMarketToday    --CURRENT_DATE
           , DATE_TRUNC ('DAY', tmpGoodsMain.LastPriceDate)                   ::TDateTime  AS LastPriceDate

           , CASE WHEN tmpGoodsMain.isSP = TRUE THEN 25088 --zc_Color_GreenL()
                  WHEN tmpMI.isTOP = TRUE
                    OR COALESCE (Object_Price_View.isTOP, FALSE) = TRUE
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
           , tmpMI.SuperFinalPrice_Deferment                AS SuperFinalPrice_Deferment
           , COALESCE (tmpGoodsMain.PriceOptSP,0)        ::TFloat     AS PriceOptSP
           , CASE WHEN tmpGoodsMain.isSP = TRUE AND (tmpMI.Price > (COALESCE (tmpGoodsMain.PriceOptSP,0))) THEN TRUE ELSE FALSE END isPriceDiff
           , COALESCE(tmpMI.isCalculated, FALSE)                      AS isCalculated
           , CASE WHEN tmpGoodsMain.isSP = TRUE THEN 25088 --zc_Color_GreenL()   --товар соц.проекта
                  WHEN tmpMI.PartionGoodsDate < vbDate180 THEN zc_Color_Red() --456
                  WHEN (tmpMI.isTOP = TRUE OR COALESCE (Object_Price_View.isTOP, FALSE)= TRUE) THEN zc_Color_Blue()--15993821 -- 16440317    -- для топ розовый шрифт
                     ELSE 0
                END AS PartionGoodsDateColor
           , Remains.Amount                                                  AS RemainsInUnit
           , COALESCE (tmpReserve.Amount, 0)                       :: TFloat AS Reserved           -- кол-во в отложенных чеках
           , CASE WHEN (COALESCE (Remains.Amount,0) - COALESCE (tmpReserve.Amount, 0)) < 0 THEN (COALESCE (Remains.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) ELSE 0 END :: TFLoat AS Remains_Diff  --не хватает с учетом отлож. чеком
           , Object_Price_View.MCSValue                                      AS MCS
           , tmpGoodsCategory.Value                                          AS MCS_GoodsCategory
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
           , tmpMI.ListDiffAmount                               ::TFloat     AS ListDiffAmount

           , tmpMI.AmountReal                           ::TFloat    AS AmountReal
           , tmpMI.SendSUNAmount                        ::TFloat    AS SendSUNAmount
           , tmpMI.SendDefSUNAmount                     ::TFloat    AS SendDefSUNAmount
           , tmpMI.RemainsSUN                           ::TFloat    AS RemainsSUN

           , COALESCE (tmpGoodsMain.CountPrice,0)               ::TFloat     AS CountPrice

           , COALESCE (SelectMinPrice_AllGoods.isOneJuridical, TRUE) :: Boolean AS isOneJuridical

           , CASE WHEN COALESCE (GoodsPromo.GoodsId, 0) = 0    THEN FALSE ELSE TRUE END  ::Boolean AS isPromo
           , CASE WHEN COALESCE (GoodsPromoAll.GoodsId, 0) = 0 THEN FALSE ELSE TRUE END  ::Boolean AS isPromoAll
           , COALESCE(GoodsPromo.OperDatePromo, NULL)           :: TDateTime AS OperDatePromo
           , COALESCE(GoodsPromo.InvNumberPromo, '')            :: TVarChar  AS InvNumberPromo -- ***

           , CASE WHEN COALESCE(OrderSheduleListToday.DOW,  0) = 0 THEN FALSE ELSE TRUE END AS isZakazToday
           , CASE WHEN COALESCE(OrderSheduleListToday.DoW_D,0) = 0 THEN FALSE ELSE TRUE END AS isDostavkaToday
           , OrderSheduleList.OperDate_Zakaz                    ::TVarChar   AS OperDate_Zakaz
           , OrderSheduleList.OperDate_Dostavka                 ::TVarChar   AS OperDate_Dostavka

           , COALESCE(tmpGoodsConditionsKeep.ConditionsKeepName, '') ::TVarChar  AS ConditionsKeepName

           , CASE 
                  --WHEN COALESCE (tmpOrderLast_2days.Amount, 0)  > 1 THEN 16777134      -- цвет фона - голубой подрязд 2 дня заказ;
                  --WHEN COALESCE (tmpOrderLast_10.Amount, 0)     > 9 THEN 167472630     -- цвет фона - розовый подрязд 10 заказов нет привязки к товару поставщика;
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) > 0.10 THEN 12319924    --светло - салатовая- цена подешевела
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) < - 0.10 THEN 14211071 --11315967--15781886 --16296444  --светло красная -- светло-розовая - подорожала
                  WHEN COALESCE(OrderSheduleListToday.DOW,  0) <> 0 THEN 12910591      -- бледно желтый
                  ELSE zc_Color_White()
             END  AS OrderShedule_Color
             
           , AVGIncome.AVGIncomePrice    AS AVGPrice

           , CASE WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) > 0.10 THEN (-1)*((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) * 100
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) < -0.10 THEN (-1)*((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) * 100
                  WHEN COALESCE (AVGIncome.AVGIncomePrice, 0) = 0 THEN 0.1--5000
                  ELSE 0
             END AS AVGPriceWarning

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
            LEFT JOIN tmpReserve                        ON tmpReserve.GoodsId               = tmpMI.GoodsId
            LEFT JOIN SelectMinPrice_AllGoods ON SelectMinPrice_AllGoods.MovementItemId = tmpMI.Id

            LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpMI.JuridicalId
                                AND GoodsPromo.GoodsId     = tmpMI.GoodsId
            -- показываем не зависимо от поставщ. явл. ли товар маркетинговым 
            LEFT JOIN (SELECT DISTINCT GoodsPromo.GoodsId FROM GoodsPromo) AS GoodsPromoAll ON GoodsPromoAll.GoodsId = tmpMI.GoodsId


            --LEFT JOIN tmpOrderLast_2days ON tmpOrderLast_2days.GoodsId = tmpMI.GoodsId
            --LEFT JOIN tmpOrderLast_10    ON tmpOrderLast_10.GoodsId    = tmpMI.GoodsId
            --LEFT JOIN tmpRepeat          ON tmpRepeat.GoodsId          = tmpMI.GoodsId
            LEFT JOIN tmpJuridicalArea   ON tmpJuridicalArea.JuridicalId = tmpMI.JuridicalId

            -- торговая сеть
            LEFT JOIN tmpObjectLink_Object AS ObjectLink_Object
                                  ON ObjectLink_Object.ObjectId = tmpMI.GoodsId
                                 AND ObjectLink_Object.DescId = zc_ObjectLink_Goods_Object()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Object.ChildObjectId
            --средняя цена
            LEFT JOIN AVGIncome ON AVGIncome.ObjectId = tmpMI.GoodsId
            LEFT JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpMI.GoodsId
            
/*            LEFT JOIN tmpObjectLink_Area AS ObjectLink_Goods_Area
                                 ON ObjectLink_Goods_Area.ObjectId = tmpMI.PartnerGoodsId
                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId    */

           ;

     -- OPEN Cursor1 FOR SELECT * FROM _tmpRes1;
     -- RETURN NEXT Cursor1;

     -- Результат 2
     -- OPEN Cursor2 FOR
     CREATE TEMP TABLE _tmpRes2 ON COMMIT DROP AS
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
   , tmpObjectLink AS (SELECT ObjectLink.*
                       FROM ObjectLink
                       WHERE ObjectLink.DescId IN ( zc_ObjectLink_Goods_Area(), zc_ObjectLink_Goods_ConditionsKeep())
                         AND ObjectLink.ObjectId IN (SELECT DISTINCT _tmpMI.GoodsId FROM _tmpMI)
                        )
   , tmpObjectFloat AS (SELECT ObjectFloat.*
                        FROM ObjectFloat
                        WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                             AND ObjectFloat.ObjectId IN (SELECT DISTINCT _tmpMI.GoodsId FROM _tmpMI)
                        )
   , tmpMIFloat AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.DescId = zc_MIFloat_Remains()
                      AND MovementItemFloat.MovementItemId IN (SELECT DISTINCT _tmpMI.PriceListMovementItemId FROM _tmpMI)
                    )
   , tmpMovementItem AS (SELECT MovementItem.*
                         FROM MovementItem
                         WHERE MovementItem.Id IN (SELECT DISTINCT _tmpMI.MovementItemId FROM _tmpMI)
                         )

   -- данные по % кредитных средств из справочника
   , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := vbObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inSession) AS tmp)


        ---
        SELECT _tmpMI.*
              , CASE WHEN PartionGoodsDate < vbDate180 THEN zc_Color_Red() -- zc_Color_Blue() --456
                     ELSE 0
                END                                                          AS PartionGoodsDateColor
              , ObjectFloat_Goods_MinimumLot.ValueData                       AS MinimumLot
              , MIFloat_Remains.ValueData                                    AS Remains
              
              , (_tmpMI.Deferment * COALESCE (tmpCostCredit.Percent, vbCostCredit))             :: TFloat      AS Persent_Deferment

              , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN FALSE ELSE TRUE END  ::Boolean AS isPromo
              , COALESCE(GoodsPromo.OperDatePromo, NULL)      :: TDateTime   AS OperDatePromo
              , COALESCE(GoodsPromo.InvNumberPromo, '')       :: TVarChar    AS InvNumberPromo -- ***
              , COALESCE(GoodsPromo.ChangePercent, 0)         :: TFLoat      AS ChangePercentPromo

              , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar     AS ConditionsKeepName
              , Object_Area.ValueData                         :: TVarChar    AS AreaName_Goods

        FROM _tmpMI
             LEFT JOIN tmpObjectFloat AS ObjectFloat_Goods_MinimumLot
                                      ON ObjectFloat_Goods_MinimumLot.ObjectId = _tmpMI.GoodsId
                            --      AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
             LEFT JOIN tmpMIFloat AS MIFloat_Remains
                                  ON MIFloat_Remains.MovementItemId = _tmpMI.PriceListMovementItemId
                                 AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
             LEFT JOIN tmpMovementItem AS MovementItem ON MovementItem.Id = _tmpMI.MovementItemId
             LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = _tmpMI.JuridicalId
                                 AND GoodsPromo.GoodsId = MovementItem.ObjectId
             -- условия хранения
             LEFT JOIN tmpObjectLink AS ObjectLink_Goods_ConditionsKeep
                                     ON ObjectLink_Goods_ConditionsKeep.ObjectId = _tmpMI.GoodsId
                                    AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

             LEFT JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = _tmpMI.JuridicalId
                                       AND tmpJuridicalArea.AreaId      = _tmpMI.AreaId

             LEFT JOIN tmpObjectLink AS ObjectLink_Goods_Area
                                     ON ObjectLink_Goods_Area.ObjectId = _tmpMI.GoodsId
                                    AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
             LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId
             
             LEFT JOIN tmpCostCredit ON _tmpMI.Price BETWEEN tmpCostCredit.MinPrice  AND tmpCostCredit.PriceLimit
;


   OPEN Cursor1 FOR SELECT * FROM _tmpRes1
                    /*WHERE inSession <> '7670317' OR _tmpRes1.Id > 0 OR _tmpRes1.Income_Amount <> 0 OR _tmpRes1.AmountSecond <> 0
                       OR _tmpRes1.CheckAmount <> 0 OR _tmpRes1.SendAmount <> 0 OR _tmpRes1.AmountDeferred <> 0
                   UNION ALL
                    SELECT * FROM 
                   (SELECT * FROM _tmpRes1
                    WHERE inSession = '7670317' AND COALESCE (_tmpRes1.Id, 0) = 0 AND COALESCE (_tmpRes1.Income_Amount, 0) = 0 AND COALESCE (_tmpRes1.AmountSecond, 0) = 0
                     AND COALESCE (_tmpRes1.CheckAmount, 0) = 0 AND COALESCE (_tmpRes1.SendAmount, 0) = 0 AND COALESCE (_tmpRes1.AmountDeferred, 0) = 0
                    LIMIT 15000
                   ) AS tmp*/
                    ;
  RETURN NEXT Cursor1;

   OPEN Cursor2 FOR SELECT * FROM _tmpRes2;
   RETURN NEXT Cursor2;



    -- !!!Только для ДРУГИХ документов + inShowAll = TRUE - 3-ья ВЕТКА (ВСЕГО = 3)!!!
    ELSEIF inShowAll = TRUE
    THEN


--raise notice 'Value: % % % %', inMovementId, vbObjectId, 0, vbUserId;

--    PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, 0, vbUserId);

     -- ПАРАМЕТРЫ
     SELECT ObjectLink_Unit_Juridical.ChildObjectId, MovementLinkObject.ObjectId, COALESCE (ObjectLink_Unit_Area.ChildObjectId, zc_Area_Basis())
            INTO vbMainJuridicalId, vbUnitId, vbAreaId_find
         FROM MovementLinkObject
              --INNER JOIN Object_Unit_View ON Object_Unit_View.Id = MovementLinkObject.ObjectId
              INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject.ObjectId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

              LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                   ON ObjectLink_Unit_Area.ObjectId = MovementLinkObject.ObjectId
                                  AND ObjectLink_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
     WHERE MovementLinkObject.MovementId = inMovementId
       AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();


     -- таблица Регион поставщика
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpJuridicalArea'))
     THEN
         CREATE TEMP TABLE tmpJuridicalArea (UnitId Integer, JuridicalId Integer, AreaId Integer, AreaName TVarChar, isDefault Boolean) ON COMMIT DROP;
         INSERT INTO tmpJuridicalArea (UnitId, JuridicalId, AreaId, AreaName, isDefault)
            SELECT DISTINCT
                   tmp.UnitId                   AS UnitId
                 , tmp.JuridicalId              AS JuridicalId
                 , tmp.AreaId_Juridical         AS AreaId
                 , tmp.AreaName_Juridical       AS AreaName
                 , tmp.isDefault_JuridicalArea  AS isDefault
            FROM lpSelect_Object_JuridicalArea_byUnit (vbUnitId, 0) AS tmp;
     END IF;


     -- ДАННЫЕ
     CREATE TEMP TABLE _tmpMI (Id integer
                             , MovementItemId Integer
                             , PriceListMovementItemId Integer
                             , Price TFloat
                             , PartionGoodsDate TDateTime
                             , GoodsId Integer
                             , GoodsCode TVarChar
                             , GoodsName TVarChar
                             , MainGoodsName TVarChar
                             , JuridicalId Integer
                             , JuridicalName TVarChar
                             , MakerName TVarChar
                             , ContractId Integer
                             , ContractName TVarChar
                             , AreaId Integer
                             , AreaName TVarChar
                             , isDefault Boolean
                             , Deferment Integer
                             , Bonus TFloat
                             , Percent TFloat
                             , SuperFinalPrice TFloat
                             , SuperFinalPrice_Deferment TFloat) ON COMMIT DROP;


      -- Сохраниели данные
      INSERT INTO _tmpMI

           WITH -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту) !!!внутри проц определяется ObjectId!!!
                PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (vbUserId::TVarChar))
              , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (vbUserId::TVarChar))

              , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS T WHERE T.MainJuridicalId = vbMainJuridicalId)

                -- элементы установок юр.лиц (границы цен для бонуса)
              , tmpJuridicalSettingsItem AS (SELECT tmp.JuridicalSettingsId
                                                  , tmp.Bonus
                                                  , tmp.PriceLimit_min
                                                  , tmp.PriceLimit
                                             FROM JuridicalSettings
                                                  INNER JOIN gpSelect_Object_JuridicalSettingsItem (JuridicalSettings.JuridicalSettingsId, inSession) AS tmp ON tmp.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                             WHERE COALESCE (JuridicalSettings.isBonusClose, FALSE) = FALSE
                                             )

              , JuridicalArea AS (SELECT DISTINCT ObjectLink_JuridicalArea_Juridical.ChildObjectId AS JuridicalId
                                  FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                       INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                                AND Object_JuridicalArea.isErased = FALSE
                                       INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                             ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                            AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                            AND ObjectLink_JuridicalArea_Area.ChildObjectId = vbAreaId_find
                                       -- Уникальный код поставщика ТОЛЬКО для Региона
                                       INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                                                ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id
                                                               AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                                               AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
                                  WHERE ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                 )

              , MovementItemOrder AS (SELECT MovementItem.*
                                           , ObjectLink_Main.ChildObjectId AS GoodsMainId, ObjectLink_LinkGoods_Goods.ChildObjectId AS GoodsId
                                      FROM MovementItem
                                       --  INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = MovementItem.ObjectId -- Связь товара сети с общим
                                       -- получаем GoodsMainId
                                           INNER JOIN  ObjectLink AS ObjectLink_Child
                                                                  ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
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
                                                               AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                                                ON ObjectLink_Goods_Area.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                               AND ObjectLink_Goods_Area.DescId   = zc_ObjectLink_Goods_Area()
                                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                                                ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                               AND ObjectLink_Goods_Object.DescId   = zc_ObjectLink_Goods_Object()
                                           LEFT JOIN JuridicalArea ON JuridicalArea.JuridicalId = ObjectLink_Goods_Object.ChildObjectId

                                      WHERE MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND (ObjectLink_Goods_Area.ChildObjectId = vbAreaId_find OR JuridicalArea.JuridicalId IS NULL)
                                  )
                -- Маркетинговый контракт
              , tmpOperDate AS (SELECT date_trunc ('day', Movement.OperDate) AS OperDate FROM Movement WHERE Movement.Id = inMovementId)
              , GoodsPromo AS (SELECT tmp.JuridicalId
                                    , tmp.GoodsId        -- здесь товар "сети"
                                    , tmp.ChangePercent
                               FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                       ) AS tmp
                              )
              , LastPriceList_View AS (SELECT * FROM lpSelect_LastPriceList_View_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                                       , inUnitId  := vbUnitId
                                                                                       , inUserId  := vbUserId) AS tmp
                                      )
                -- Список цены + ТОП
              , GoodsPrice AS (SELECT MovementItemOrder.ObjectId AS GoodsId, ObjectBoolean_Top.ValueData AS isTOP
                               FROM MovementItemOrder
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                                          ON ObjectLink_Price_Goods.ChildObjectId = MovementItemOrder.ObjectId
                                                         AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                          ON ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                                         AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                                         AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                    INNER JOIN ObjectBoolean AS ObjectBoolean_Top
                                                             ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                                            AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                                                            AND ObjectBoolean_Top.ValueData = TRUE
                              )

              , tmpLoadPriceList AS (SELECT DISTINCT LoadPriceList.JuridicalId
                                          , LoadPriceList.ContractId
                                          , LoadPriceList.AreaId
                                     FROM LoadPriceList
                                     )

      -- данные по % кредитных средств из справочника
      , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := vbObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inSession) AS tmp)


       -- Результат
       SELECT row_number() OVER ()
            , ddd.Id AS MovementItemId
            , ddd.PriceListMovementItemId
            , ddd.Price
            , ddd.PartionGoodsDate
            , ddd.GoodsId
            , ddd.GoodsCode
            , ddd.GoodsName
            , ddd.MainGoodsName
            , ddd.JuridicalId
            , ddd.JuridicalName
            , ddd.MakerName
            , ddd.ContractId
            , ddd.ContractName
            , ddd.AreaId
            , ddd.AreaName
            , ddd.isDefault
            , ddd.Deferment
            , ddd.Bonus
/* * /
            , CASE WHEN ddd.Deferment = 0
                        THEN 0
                   WHEN ddd.isTOP = TRUE
                        THEN COALESCE (PriceSettingsTOP.Percent, 0)
                   ELSE PriceSettings.Percent
              END :: TFloat AS Percent
            , CASE WHEN ddd.Deferment = 0
                        THEN FinalPrice
                   WHEN ddd.Deferment = 0 OR ddd.isTOP = TRUE
                        THEN FinalPrice * (100 - COALESCE (PriceSettingsTOP.Percent, 0)) / 100
                   ELSE FinalPrice * (100 - PriceSettings.Percent) / 100
              END :: TFloat AS SuperFinalPrice
/ */
            , CASE WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                        THEN COALESCE (PriceSettingsTOP.Percent, 0)
                   WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                        THEN COALESCE (PriceSettings.Percent, 0)
                   ELSE 0
              END :: TFloat AS Percent
              
            , CASE WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                        THEN FinalPrice * (100 + COALESCE (PriceSettingsTOP.Percent, 0)) / 100
                   WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                        THEN FinalPrice * (100 + COALESCE (PriceSettings.Percent, 0)) / 100
                   ELSE FinalPrice
              END :: TFloat AS SuperFinalPrice
              
            , (ddd.FinalPrice - ddd.FinalPrice * ((ddd.Deferment) * COALESCE (tmpCostCredit.Percent, vbCostCredit) ) / 100) :: TFloat AS SuperFinalPrice_Deferment
/**/
       FROM
             (SELECT DISTINCT MovementItemOrder.Id
                  , MovementItemLastPriceList_View.Price AS Price
                  , MovementItemLastPriceList_View.MovementItemId AS PriceListMovementItemId
                  , MovementItemLastPriceList_View.PartionGoodsDate
                  , MIN (MovementItemLastPriceList_View.Price) OVER (PARTITION BY MovementItemOrder.Id ORDER BY MovementItemLastPriceList_View.PartionGoodsDate DESC) AS MinPrice
                  , CASE
                      -- -- если Цена поставщика не попадает в ценовые промежутки (до какой цены учитывать бонус при расчете миним. цены)
                      WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                           THEN MovementItemLastPriceList_View.Price
                               -- И учитывается % бонуса из Маркетинговый контракт
                             * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)

                      ELSE -- иначе учитывается бонус - для ТОП-позиции или НЕ ТОП-позиции
                           (MovementItemLastPriceList_View.Price * (100 - COALESCE(tmpJuridicalSettingsItem.Bonus, 0)) / 100) :: TFloat
                            -- И учитывается % бонуса из Маркетинговый контракт
                          * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
                    END AS FinalPrice
                  , CASE WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL 
                              THEN 0
                         ELSE COALESCE(tmpJuridicalSettingsItem.Bonus, 0)
                    END :: TFloat AS Bonus

                  , MovementItemLastPriceList_View.GoodsId
                  , MovementItemLastPriceList_View.GoodsCode
                  , MovementItemLastPriceList_View.GoodsName
                  , MovementItemLastPriceList_View.MakerName
                  , MainGoods.valuedata                       AS MainGoodsName
                  , Juridical.ID                              AS JuridicalId
                  , Juridical.ValueData                       AS JuridicalName
                  , Contract.Id                               AS ContractId
                  , Contract.ValueData                        AS ContractName
                  , COALESCE (ObjectFloat_Deferment.ValueData, 0)::Integer AS Deferment
                  , COALESCE (GoodsPrice.isTOP, COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)) AS isTOP

                  , tmpJuridicalArea.AreaId
                  , tmpJuridicalArea.AreaName
                  , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean AS isDefault

               FROM MovementItemOrder
                    LEFT OUTER JOIN MovementItemLastPriceList_View ON MovementItemLastPriceList_View.GoodsId = MovementItemOrder.GoodsId
                                                                  AND MovementItemLastPriceList_View.isErased = False

                    JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                         AND tmpJuridicalArea.AreaId      = MovementItemLastPriceList_View.AreaId

                    INNER JOIN tmpLoadPriceList ON tmpLoadPriceList.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                               AND tmpLoadPriceList.ContractId  = MovementItemLastPriceList_View.ContractId
                                               AND (tmpLoadPriceList.AreaId = MovementItemLastPriceList_View.AreaId OR COALESCE (tmpLoadPriceList.AreaId, 0) = 0)


                    LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                               AND JuridicalSettings.ContractId  = MovementItemLastPriceList_View.ContractId
                    LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                                      AND MovementItemLastPriceList_View.Price >= tmpJuridicalSettingsItem.PriceLimit_min
                                                      AND MovementItemLastPriceList_View.Price <= tmpJuridicalSettingsItem.PriceLimit

                    -- товар "поставщика", если он есть в прайсах !!!а он есть!!!
                             --LEFT JOIN Object AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
                    --LEFT JOIN ObjectString AS ObjectString_GoodsCode ON ObjectString_GoodsCode.ObjectId = MILinkObject_Goods.ObjectId
                    --                      AND ObjectString_GoodsCode.DescId = zc_ObjectString_Goods_Code()
                    --LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                    --                           ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId
                    --                          AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()

                    JOIN OBJECT AS Juridical ON Juridical.Id = MovementItemLastPriceList_View.JuridicalId

                    LEFT JOIN OBJECT AS Contract ON Contract.Id = MovementItemLastPriceList_View.ContractId

                    LEFT JOIN ObjectFloat AS ObjectFloat_Deferment
                                          ON ObjectFloat_Deferment.ObjectId = Contract.Id
                                         AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()

                    LEFT JOIN OBJECT AS MainGoods ON MainGoods.Id = MovementItemOrder.GoodsMainId

                    LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                            ON ObjectBoolean_Goods_TOP.ObjectId = MovementItemOrder.ObjectId
                                           AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
                    LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = MovementItemOrder.ObjectId

                    --   LEFT JOIN Object_Goods_View AS Goods  -- Элемент документа заявка
                    --     ON Goods.Id = MovementItemOrder.ObjectId

                    -- % бонуса из Маркетинговый контракт
                    LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = MovementItemOrder.ObjectId
                                        AND GoodsPromo.JuridicalId = MovementItemLastPriceList_View.JuridicalId


               WHERE  COALESCE(JuridicalSettings.isPriceCloseOrder, FALSE) <> TRUE                                        -- 
       ) AS ddd

       LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
       LEFT JOIN PriceSettingsTOP ON ddd.MinPrice BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
       LEFT JOIN tmpCostCredit    ON ddd.MinPrice BETWEEN tmpCostCredit.MinPrice  AND tmpCostCredit.PriceLimit
  ;

-- lpCreateTempTable_OrderInternal Конец процедуры

   --RAISE EXCEPTION 'Ошибка.';
--raise notice 'Value: %', 2;
     -- OPEN Cursor1 FOR
     -- OPEN Cursor1 FOR
     CREATE TEMP TABLE _tmpRes1 ON COMMIT DROP AS
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
                        WHERE MLM_Order.MovementId is NULL
                        GROUP BY Movement_OrderExternal.GoodsId
                        HAVING SUM (Movement_OrderExternal.Amount) <> 0
                       )

        -- Маркетинговый контракт
      , GoodsPromo AS (WITH tmpPromo AS (SELECT * FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= vbOperDate) AS tmp) -- CURRENT_DATE
                          , tmpList AS (SELECT ObjectLink_Child.ChildObjectId        AS GoodsId
                                             , ObjectLink_Child_retail.ChildObjectId AS GoodsId_retail -- здесь товар "сети"
                                        FROM ObjectLink AS ObjectLink_Child
                                              INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                                       AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                              INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                             AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                              INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                              AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                                    ON ObjectLink_Goods_Object.ObjectId      = ObjectLink_Child_retail.ChildObjectId
                                                                   AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                                                   AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                                        WHERE ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                          -- AND vbObjectId <> 3
                                       )
                       SELECT tmp.JuridicalId
                            , COALESCE (tmpList.GoodsId_retail, tmp.GoodsId) AS GoodsId -- здесь товар "сети"
                            , tmp.MovementId
                            , tmp.ChangePercent
                            , MovementPromo.OperDate                AS OperDatePromo
                            , MovementPromo.InvNumber               AS InvNumberPromo -- ***
                       FROM tmpPromo AS tmp   --CURRENT_DATE
                            INNER JOIN tmpList ON tmpList.GoodsId = tmp.GoodsId
                            LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = tmp.MovementId
                      )
        -- Список цены + ТОП
      , GoodsPrice AS (SELECT Price_Goods.ChildObjectId           AS GoodsId
                            , COALESCE(Price_Top.ValueData,FALSE) AS isTop
                       FROM ObjectLink AS ObjectLink_Price_Unit
                            INNER JOIN ObjectBoolean     AS Price_Top
                                    ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                                   AND Price_Top.ValueData = TRUE
                            LEFT JOIN ObjectLink       AS Price_Goods
                                   ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                       WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                       )

      -- данные из ассорт. матрицы
      , tmpGoodsCategory AS (SELECT ObjectLink_Child_retail.ChildObjectId AS GoodsId
                                  , ObjectFloat_Value.ValueData                  AS Value
                             FROM Object AS Object_GoodsCategory
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                       ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                                      AND ObjectLink_GoodsCategory_Unit.ChildObjectId = vbUnitId
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                       ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                 INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                                        ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                       AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                                       AND COALESCE (ObjectFloat_Value.ValueData,0) <> 0
                                 -- выходим на товар сети
                                 INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                       ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                                      AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                 INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                       ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                      AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                 INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                       ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                      AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                      AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                                                 
                             WHERE Object_GoodsCategory.DescId = zc_Object_GoodsCategory()
                               AND Object_GoodsCategory.isErased = FALSE
                             )


      , tmpMI_All AS (SELECT MovementItem.*
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                         )
        -- 2.1
      , tmpOF_Goods_MinimumLot AS (SELECT *
                                   FROM ObjectFloat
                                   WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                     AND ObjectFloat.ValueData <> 0
                                     AND ObjectFloat.ObjectId  IN (SELECT DISTINCT tmpMI_All.ObjectId FROM tmpMI_All)
                       )
      , tmpMI_Master AS (SELECT tmpMI.*
                              , CEIL(tmpMI.Amount / COALESCE(ObjectFloat_Goods_MinimumLot.ValueData , 1))
                                * COALESCE(ObjectFloat_Goods_MinimumLot.ValueData , 1)                       AS CalcAmount
                              , ObjectFloat_Goods_MinimumLot.ValueData                                       AS MinimumLot
                              , COALESCE (GoodsPrice.isTOP, FALSE)                                           AS Price_isTOP
                         FROM tmpMI_All AS tmpMI
                               LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = tmpMI.ObjectId
                               LEFT JOIN tmpOF_Goods_MinimumLot AS ObjectFloat_Goods_MinimumLot
                                                                ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI.ObjectId
                                                              -- AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                         )

  , tmpGoods_all AS (SELECT ObjectLink_Goods_Object.ObjectId                       AS GoodsId
                          , Object_Goods.ObjectCode                                AS GoodsCode
                          , Object_Goods.ValueData                                 AS GoodsName
                          , ObjectLink_Goods_GoodsGroup.ChildObjectId              AS GoodsGroupId
                          , ObjectLink_Goods_NDSKind.ChildObjectId                 AS NDSKindId
                          , Object_NDSKind.ValueData                               AS NDSKindName
                          , ObjectFloat_NDSKind_NDS.ValueData                      AS NDS
                          -- , ObjectFloat_Goods_MinimumLot.ValueData                 AS Multiplicity
                          , COALESCE(ObjectBoolean_Goods_Close.ValueData, FALSE)   AS isClose
                          , COALESCE(ObjectBoolean_Goods_TOP.ValueData, FALSE)     AS Goods_isTOP
                          , COALESCE (GoodsPrice.isTop, FALSE)                     AS Price_isTOP
                          , COALESCE(ObjectBoolean_First.ValueData, FALSE)         AS isFirst
                          , COALESCE(ObjectBoolean_Second.ValueData, FALSE)        AS isSecond

                          , ObjectLink_Goods_Object.ObjectId                       AS GoodsId_MinLot

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

                          -- LEFT JOIN tmpOF_Goods_MinimumLot  AS ObjectFloat_Goods_MinimumLot
                          --                       ON ObjectFloat_Goods_MinimumLot.ObjectId = ObjectLink_Goods_Object.ObjectId
                                           --     AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                     WHERE (inShowAll = TRUE OR tmpMI_Master.Id is not NULL)
                       AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                       AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                    )

        -- 2.2
      , tmpOF_MinimumLot_Goods AS (SELECT *
                                   FROM ObjectFloat
                                   WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                     AND ObjectFloat.ValueData <> 0
                                     AND ObjectFloat.ObjectId  IN (SELECT DISTINCT tmpGoods_all.GoodsId_MinLot FROM tmpGoods_all)
                       )

      , tmpGoods AS (SELECT tmpGoods_all.GoodsId
                          , tmpGoods_all.GoodsCode
                          , tmpGoods_all.GoodsName
                          , tmpGoods_all.GoodsGroupId
                          , tmpGoods_all.NDSKindId
                          , tmpGoods_all.NDSKindName
                          , tmpGoods_all.NDS
                          , ObjectFloat_Goods_MinimumLot.ValueData AS Multiplicity
                          , tmpGoods_all.isClose
                          , tmpGoods_all.Goods_isTOP
                          , tmpGoods_all.Price_isTOP
                          , tmpGoods_all.isFirst
                          , tmpGoods_all.isSecond

                     FROM tmpGoods_all
                          LEFT JOIN tmpOF_MinimumLot_Goods AS ObjectFloat_Goods_MinimumLot
                                                           ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpGoods_all.GoodsId_MinLot
                                           --     AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                    )

      , tmpMIF AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                     INNER JOIN (SELECT tmpMI_Master.Id FROM tmpMI_Master) AS test ON test.ID = MovementItemFloat.MovementItemId
--                   WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Master.Id FROM tmpMI_Master)
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
      , tmpMIF_ListDiff AS (SELECT tmpMIF.*
                            FROM tmpMIF
                            WHERE tmpMIF.DescId = zc_MIFloat_ListDiff()
                           )
      , tmpMILinkObject AS (SELECT MILinkObject.*
                            FROM MovementItemLinkObject AS MILinkObject
--                              INNER JOIN  (SELECT tmpMI_Master.Id from tmpMI_Master) AS test ON test.ID = MILinkObject.MovementItemId
                            WHERE MILinkObject.DescId IN ( zc_MILinkObject_Juridical()
                                                         , zc_MILinkObject_Contract()
                                                         , zc_MILinkObject_Goods())
                              AND MILinkObject.MovementItemId in (SELECT tmpMI_Master.Id from tmpMI_Master)
                            )

      , tmpMIString_Comment AS (SELECT MIString_Comment.*
                                FROM MovementItemString AS MIString_Comment
--                                  INNER JOIN  (SELECT tmpMI_Master.Id from tmpMI_Master) AS test ON test.ID = MIString_Comment.MovementItemId
                                WHERE MIString_Comment.DescId = zc_MIString_Comment()
                                  AND MIString_Comment.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                )

      , tmpMIBoolean_Calculated AS (SELECT MIBoolean_Calculated.*
                                    FROM MovementItemBoolean AS MIBoolean_Calculated
--                                      INNER JOIN  (SELECT tmpMI_Master.Id from tmpMI_Master) AS test ON test.ID = MIBoolean_Calculated.MovementItemId
                                    WHERE MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                      AND MIBoolean_Calculated.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                   )


      , tmpMinPrice AS (SELECT DISTINCT DDD.MovementItemId
                             , DDD.GoodsId
                             , DDD.GoodsCode
                             , DDD.GoodsName
                             , DDD.JuridicalId
                             , DDD.JuridicalName
                             , DDD.ContractId
                             , DDD.ContractName
                             , DDD.MakerName
                             , DDD.PartionGoodsDate
                             , DDD.SuperFinalPrice
                             , DDD.SuperFinalPrice_Deferment
                             , DDD.Price
                             , DDD.MinId
                        FROM (SELECT *, MIN(Id) OVER (PARTITION BY MovementItemId) AS MinId
                              FROM (SELECT *
                                         -- , MIN (SuperFinalPrice) OVER (PARTITION BY MovementItemId) AS MinSuperFinalPrice
                                         --, ROW_NUMBER() OVER (PARTITION BY _tmpMI.MovementItemId ORDER BY _tmpMI.SuperFinalPrice_Deferment ASC, _tmpMI.PartionGoodsDate DESC, _tmpMI.Deferment DESC) AS Ord
                                         
                                         -- если есть товары с хорошим сроком то брать их , товары со сроком менее года только если другихх нет
                                         , ROW_NUMBER() OVER (PARTITION BY _tmpMI.MovementItemId ORDER BY (CASE WHEN _tmpMI.PartionGoodsDate < vbDate180 THEN _tmpMI.SuperFinalPrice_Deferment + 100 ELSE _tmpMI.SuperFinalPrice_Deferment END) ASC, _tmpMI.PartionGoodsDate DESC, _tmpMI.Deferment DESC) AS Ord
                                    FROM _tmpMI
                                   ) AS DDD
                              -- WHERE DDD.SuperFinalPrice = DDD.MinSuperFinalPrice
                              WHERE DDD.Ord = 1
                             ) AS DDD
                        WHERE Id = MinId
                       )
        -- чтоб не двоило данные , выбираем  группируем данных с макс датой отгрузки
      , tmpMI_PriceList AS (SELECT *
                            FROM (SELECT _tmpMI.*
                                       , ROW_NUMBER() OVER (PARTITION BY _tmpMI.MovementItemId, _tmpMI.JuridicalId, _tmpMI.GoodsId, _tmpMI.ContractId ORDER BY _tmpMI.Price ASC, _tmpMI.PartionGoodsDate DESC) AS Ord
                                  FROM _tmpMI
                                 ) AS DDD
                            WHERE DDD.Ord = 1
                            )

, tmpMI_all_MinLot AS (SELECT MovementItem.Id
                            , MovementItem.ObjectId                                            AS GoodsId
                            , MovementItem.Amount                                              AS Amount
                            , MovementItem.CalcAmount
                            , MIFloat_Summ.ValueData                                           AS Summ
                            , MovementItem.MinimumLot                                          AS Multiplicity
                            , MIString_Comment.ValueData                                       AS Comment
                            , COALESCE(PriceList.MakerName, MinPrice.MakerName)                AS MakerName
                            , MIBoolean_Calculated.ValueData                                   AS isCalculated
                            -- , ObjectFloat_Goods_MinimumLot.valuedata                           AS MinimumLot
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
                            , COALESCE(PriceList.SuperFinalPrice_Deferment, MinPrice.SuperFinalPrice_Deferment) AS SuperFinalPrice_Deferment
                            --, MovementItem.Goods_isTOP
                            , MovementItem.Price_isTOP
                            , MIFloat_AmountSecond.ValueData                                   AS AmountSecond
                            , MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) AS AmountAll
                              -- округлили ВВЕРХ AllLot
                            /*, CEIL ((-- Спецзаказ
                                     MovementItem.Amount
                                     -- Количество дополнительное
                                   + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                     -- кол-во отказов
                                   + COALESCE (MIFloat_ListDiff.ValueData, 0)
                                    ) / COALESCE (MovementItem.MinimumLot, 1)
                                   ) * COALESCE (MovementItem.MinimumLot, 1)                   AS CalcAmountAll
                             */
                             
                   --27.01.2020 Люба просит чтоб в расчет ложилась не сумма а большее из "Спец + Авто" и "Отказы" - поскольку сумма этих колонок приводит к затоварке аптек
                            , CEIL ((                                -- Спецзаказ + Количество дополнительное                        -- кол-во отказов
                                     CASE WHEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)) >= COALESCE (MIFloat_ListDiff.ValueData, 0)
                                          THEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))         -- Спецзаказ + Количество дополнительное
                                          ELSE COALESCE (MIFloat_ListDiff.ValueData, 0)                                                   -- кол-во отказов
                                     END
                                    ) / COALESCE (MovementItem.MinimumLot, 1)
                                   ) * COALESCE (MovementItem.MinimumLot, 1)                   AS CalcAmountAll

                            , MIFloat_AmountManual.ValueData                                   AS AmountManual
                            , MIFloat_ListDiff.ValueData                                       AS ListDiffAmount
                            , MovementItem.isErased
                            , COALESCE (PriceList.GoodsId, MinPrice.GoodsId)                   AS GoodsId_MinLot
                       FROM tmpMI_Master AS MovementItem
     
                            LEFT JOIN tmpMILinkObject AS MILinkObject_Juridical
                                                      ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
     
                            LEFT JOIN tmpMILinkObject AS MILinkObject_Contract
                                                      ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
     
                            LEFT JOIN tmpMILinkObject AS MILinkObject_Goods
                                                      ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
     
                            LEFT JOIN tmpMIBoolean_Calculated AS MIBoolean_Calculated ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
     
                            LEFT JOIN tmpMIString_Comment AS MIString_Comment ON MIString_Comment.MovementItemId = MovementItem.Id
     
                            LEFT JOIN tmpMI_PriceList AS PriceList ON COALESCE (PriceList.ContractId, 0) = COALESCE (MILinkObject_Contract.ObjectId, 0)
                                                     AND PriceList.JuridicalId = MILinkObject_Juridical.ObjectId
                                                     AND PriceList.GoodsId = MILinkObject_Goods.ObjectId
                                                     AND PriceList.MovementItemId = MovementItem.Id
     
                            LEFT JOIN tmpMinPrice AS MinPrice ON MinPrice.MovementItemId = MovementItem.Id
     
                            -- LEFT JOIN tmpOF_Goods_MinimumLot AS ObjectFloat_Goods_MinimumLot
                            --                                  ON ObjectFloat_Goods_MinimumLot.ObjectId = COALESCE (PriceList.GoodsId, MinPrice.GoodsId)
                                                 --- AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
     
                            LEFT JOIN tmpMIF_Summ AS MIFloat_Summ ON MIFloat_Summ.MovementItemId = MovementItem.Id
                            LEFT JOIN tmpMIF_AmountSecond AS MIFloat_AmountSecond ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                            LEFT JOIN tmpMIF_AmountManual AS MIFloat_AmountManual ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                            LEFT JOIN tmpMIF_ListDiff     AS MIFloat_ListDiff     ON MIFloat_ListDiff.MovementItemId    = MovementItem.Id
     --LIMIT 2
                       )

        -- 2.3
      , tmpOF_MinimumLot_mi AS (SELECT *
                                FROM ObjectFloat
                                WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                  AND ObjectFloat.ValueData <> 0
                                  AND ObjectFloat.ObjectId  IN (SELECT DISTINCT tmpMI_all_MinLot.GoodsId_MinLot FROM tmpMI_all_MinLot)
                                )

      , tmpMI AS (SELECT tmpMI_all_MinLot.Id
                       , tmpMI_all_MinLot.GoodsId
                       , tmpMI_all_MinLot.Amount
                       , tmpMI_all_MinLot.CalcAmount
                       , tmpMI_all_MinLot.Summ
                       , tmpMI_all_MinLot.Multiplicity
                       , tmpMI_all_MinLot.Comment
                       , tmpMI_all_MinLot.MakerName
                       , tmpMI_all_MinLot.isCalculated
                       , ObjectFloat_Goods_MinimumLot.ValueData AS MinimumLot
                       , tmpMI_all_MinLot.Price
                       , tmpMI_all_MinLot.PartionGoodsDate
                       , tmpMI_all_MinLot.PartnerGoodsId
                       , tmpMI_all_MinLot.PartnerGoodsCode
                       , tmpMI_all_MinLot.PartnerGoodsName
                       , tmpMI_all_MinLot.JuridicalId
                       , tmpMI_all_MinLot.JuridicalName
                       , tmpMI_all_MinLot.ContractId
                       , tmpMI_all_MinLot.ContractName
                       , tmpMI_all_MinLot.SuperFinalPrice
                       , tmpMI_all_MinLot.SuperFinalPrice_Deferment
                       , tmpMI_all_MinLot.Price_isTOP
                       , tmpMI_all_MinLot.AmountSecond
                       , tmpMI_all_MinLot.AmountAll
                       , tmpMI_all_MinLot.CalcAmountAll
                       , tmpMI_all_MinLot.AmountManual
                       , tmpMI_all_MinLot.ListDiffAmount
                       , tmpMI_all_MinLot.isErased
                  FROM tmpMI_all_MinLot

                       LEFT JOIN tmpOF_MinimumLot_mi AS ObjectFloat_Goods_MinimumLot
                                                     ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI_all_MinLot.GoodsId_MinLot
                  )

      , tmpPriceView AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                              , MCS_Value.ValueData                     AS MCSValue
                              , Price_Goods.ChildObjectId               AS GoodsId
                              , COALESCE(MCS_isClose.ValueData,FALSE)   AS MCSIsClose
                              , COALESCE(MCS_NotRecalc.ValueData,FALSE) AS MCSNotRecalc
                              , COALESCE(Price_Top.ValueData,FALSE)     AS isTop
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
                           AND (inShowAll = TRUE OR tmpMI_Master.Id is not NULL)
                      )

      , tmpGoodsId AS (SELECT COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)           AS GoodsId
                    FROM tmpGoods
                         FULL JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                    GROUP BY COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)
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
                         , tmpMI.SuperFinalPrice_Deferment
                         , COALESCE (tmpMI.isCalculated, FALSE)                             AS isCalculated
                         , tmpMI.AmountSecond                                               AS AmountSecond
                         , NULLIF (tmpMI.AmountAll, 0)                                      AS AmountAll
                         , NULLIF (COALESCE (tmpMI.AmountManual, tmpMI.CalcAmountAll), 0)   AS CalcAmountAll
                         , tmpMI.Price * COALESCE (tmpMI.AmountManual, tmpMI.CalcAmountAll) AS SummAll
                         , tmpMI.ListDiffAmount
                    FROM tmpGoods
                         FULL JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                   )
      -- считаем остатки
      , tmpRemains AS (SELECT Container.ObjectId
                            , SUM (Container.Amount) AS Amount
                       FROM Container
                            INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                           ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                          AND ContainerLinkObject_Unit.ObjectId = vbUnitId
                            INNER JOIN tmpGoodsId AS tmp
                                                  ON tmp.GoodsId = Container.ObjectId
                       WHERE Container.DescId = zc_Container_Count()
                         AND Container.Amount<>0
--                         AND Container.ObjectId in (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                       GROUP BY Container.ObjectId
                      )
      -- приход
      , tmpIncome AS (SELECT MovementItem_Income.ObjectId               AS Income_GoodsId
                           , SUM (MovementItem_Income.Amount) :: TFloat AS Income_Amount
                      FROM Movement AS Movement_Income
                           INNER JOIN MovementItem AS MovementItem_Income
                                                   ON Movement_Income.Id = MovementItem_Income.MovementId
                                                  AND MovementItem_Income.DescId = zc_MI_Master()
                                                  AND MovementItem_Income.isErased = FALSE
                                                  AND MovementItem_Income.Amount > 0
--                                                  AND MovementItem_Income.ObjectId in (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                           INNER JOIN tmpGoodsId AS tmp
                                                 ON tmp.GoodsId = MovementItem_Income.ObjectId
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                        AND MovementLinkObject_To.ObjectId = vbUnitId
                           INNER JOIN MovementDate AS MovementDate_Branch
                                                   ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                  AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                       WHERE Movement_Income.DescId = zc_Movement_Income()
                         AND MovementDate_Branch.ValueData BETWEEN CURRENT_DATE - INTERVAL '31 DAY' AND CURRENT_DATE + INTERVAL '7 DAY'
                         AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                       GROUP BY MovementItem_Income.ObjectId
                     )

        -- Товары соц-проект (документ)
      , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                            , MIFloat_PriceOptSP.ValueData AS PriceOptSP
                       FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= vbOperDate, inEndDate:= vbOperDate, inUnitId := vbUnitId) AS tmp
                                                LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                     ON MIFloat_PriceOptSP.MovementItemId = tmp.MovementItemId
                                                    AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                       )

      , tmpGoodsMain AS (SELECT tmpMI.GoodsId                                                           AS GoodsId
                              , COALESCE (tmpGoodsSP.isSP, False)                             ::Boolean AS isSP
                              , COALESCE (ObjectBoolean_Resolution_224.ValueData, False)      ::Boolean AS isResolution_224
                              , CAST ( (COALESCE (tmpGoodsSP.PriceOptSP,0) * 1.1) AS NUMERIC (16,2)) :: TFloat   AS PriceOptSP
                              , CASE WHEN DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData) = vbOperDate THEN TRUE ELSE FALSE END  AS isMarketToday
                              , DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData)          ::TDateTime AS LastPriceDate
                              , COALESCE (ObjectFloat_CountPrice.ValueData,0)               ::TFloat    AS CountPrice
                         FROM tmpGoodsId AS tmpMI
                                -- получаем GoodsMainId
                                LEFT JOIN ObjectLink AS ObjectLink_Child
                                                     ON ObjectLink_Child.ChildObjectId = tmpMI.GoodsId
                                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                LEFT JOIN ObjectLink AS ObjectLink_Main
                                                     ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                    AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                                LEFT JOIN ObjectFloat AS ObjectFloat_CountPrice
                                                     ON ObjectFloat_CountPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectFloat_CountPrice.DescId = zc_ObjectFloat_Goods_CountPrice()

                                LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                                     ON ObjectDate_LastPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()

                                LEFT JOIN ObjectBoolean AS ObjectBoolean_Resolution_224
                                                        ON ObjectBoolean_Resolution_224.ObjectId = ObjectLink_Main.ChildObjectId
                                                       AND ObjectBoolean_Resolution_224.DescId = zc_ObjectBoolean_Goods_Resolution_224()

                                LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId
                         )

      -- условия хранения
      , tmpGoodsConditionsKeepList AS (SELECT ObjectLink_Goods_ConditionsKeep.ObjectId              AS GoodsId
                                            , ObjectLink_Goods_ConditionsKeep.ChildObjectId         AS ChildObjectId
                                   FROM ObjectLink AS ObjectLink_Goods_ConditionsKeep
                                        INNER JOIN tmpGoodsId AS tmp ON tmp.GoodsId = ObjectLink_Goods_ConditionsKeep.ObjectId
                                   WHERE ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
--                                     AND ObjectLink_Goods_ConditionsKeep.ObjectId IN (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                                  )

      , tmpGoodsConditionsKeep AS (SELECT ObjectLink_Goods_ConditionsKeep.GoodsId                   AS GoodsId
                                        , Object_ConditionsKeep.ValueData                           AS ConditionsKeepName
                                   FROM tmpGoodsConditionsKeepList AS ObjectLink_Goods_ConditionsKeep
--                                        INNER JOIN tmpGoodsId AS tmp ON tmp.GoodsId = ObjectLink_Goods_ConditionsKeep.GoodsId
                                        INNER JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
--                                     AND ObjectLink_Goods_ConditionsKeep.GoodsId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
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
                            /*LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                      ON MovementBoolean_Deferred.MovementId = Movement_Send.Id
                                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()*/
                            -- закомментил - пусть будут все перемещения, не только Авто
                            /*INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                       ON MovementBoolean_isAuto.MovementId = Movement_Send.Id
                                                      AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                      AND MovementBoolean_isAuto.ValueData  = TRUE*/
                            INNER JOIN MovementItem AS MI_Send
                                                    ON MI_Send.MovementId = Movement_Send.Id
                                                   AND MI_Send.DescId = zc_MI_Master()
                                                   AND MI_Send.isErased = FALSE
--                                                   AND MI_Send.ObjectId in (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                            INNER JOIN tmpGoodsId AS tmp
                                                  ON tmp.GoodsId = MI_Send.ObjectId
                     -- WHERE Movement_Send.OperDate >= vbOperDate - interval '30 DAY'
                     WHERE Movement_Send.OperDate BETWEEN CURRENT_DATE - INTERVAL '91 DAY' AND CURRENT_DATE + INTERVAL '30 DAY'
                       AND Movement_Send.OperDate < vbOperDateEnd
                       AND Movement_Send.DescId = zc_Movement_Send()
                       AND Movement_Send.StatusId = zc_Enum_Status_UnComplete()
                       --AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                     GROUP BY MI_Send.ObjectId
                     HAVING SUM (MI_Send.Amount) <> 0
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
/*
      , tmpLastOrder AS (SELECT Movement.Id
                              , ROW_NUMBER() OVER (ORDER BY Movement.Id DESC, Movement.Operdate DESC) AS Ord
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MLO_Unit
                                                            ON MLO_Unit.MovementId = Movement.Id
                                                           AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                           AND MLO_Unit.ObjectId   = vbUnitId
                         WHERE Movement.DescId = zc_Movement_OrderInternal()
                           AND Movement.Operdate >= vbOperDate - INTERVAL '30 DAY' AND Movement.Operdate < vbOperDate
                           AND 1=0
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
*/

      -- нет привязки по поставщику в последних 10 внутренних заказах
      -- товары без привязки к поставщику
      -- расчет через кнопку, т.к. отрабатывает не быстро
/*      , tmpGoodsNotLink AS (SELECT DISTINCT tmpGoodsList.GoodsId
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
*/
      , SelectMinPrice_AllGoods AS (SELECT _tmpMI.MovementItemId, CASE WHEN COUNT (*) > 1 THEN FALSE ELSE TRUE END AS isOneJuridical
                                    FROM _tmpMI
                                    GROUP BY _tmpMI.MovementItemId

                                   )

      , tmpObjectLink_Area AS (SELECT ObjectLink.*
                               FROM ObjectLink
                                 INNER JOIN (SELECT DISTINCT PartnerGoodsId FROM tmpMI) AS tmp
                                                                                      ON tmp.PartnerGoodsId = ObjectLink.ObjectId
                               WHERE ObjectLink.DescId = zc_ObjectLink_Goods_Area()
--                                    AND ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.PartnerGoodsId FROM tmpData)
                               )

      , tmpObjectLink_Object AS (SELECT ObjectLink.*
                                 FROM ObjectLink
                                   INNER JOIN (SELECT DISTINCT Id FROM tmpMI) AS tmp
                                                                                   ON tmp.Id = ObjectLink.ObjectId
                                 WHERE ObjectLink.DescId = zc_ObjectLink_Goods_Object()
--                                      AND ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.Id FROM tmpData)
                                 )


   -- выбираем отложенные Чеки (как в кассе колонка VIP)
   , tmpMovementChek AS (SELECT Movement.Id
                         FROM MovementBoolean AS MovementBoolean_Deferred
                              INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = vbUnitId
                         WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                           AND MovementBoolean_Deferred.ValueData = TRUE
                        UNION
                         SELECT Movement.Id
                         FROM MovementString AS MovementString_CommentError
                              INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = vbUnitId
                        WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                          AND MovementString_CommentError.ValueData <> ''
                        )
   , tmpReserve AS (SELECT MovementItem.ObjectId             AS GoodsId
                         , SUM (MovementItem.Amount)::TFloat AS Amount
                    FROM tmpMovementChek
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                         LEFT JOIN MovementBoolean AS MovementBoolean_NotMCS
                                                   ON MovementBoolean_NotMCS.MovementId = tmpMovementChek.Id
                                                  AND MovementBoolean_NotMCS.DescId     = zc_MovementBoolean_NotMCS()
                    WHERE COALESCE (MovementBoolean_NotMCS.ValueData, False) = False
                    GROUP BY MovementItem.ObjectId
                    )

   --средняя цена по приходам за месяц
   , AVGIncome AS (SELECT MI_Income.ObjectId
                        , AVG(CASE WHEN MovementBoolean_PriceWithVAT.ValueData  = TRUE
                                   THEN (MIFloat_Price.ValueData * 100 / (100 + ObjectFloat_NDSKind_NDS.ValueData))
                                   ELSE MIFloat_Price.ValueData
                              END)                               ::TFloat AS AVGIncomePrice
                   FROM Movement AS Movement_Income
                       JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                            ON MovementBoolean_PriceWithVAT.MovementId =  Movement_Income.Id
                                           AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                       JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                               ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                              AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                       JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                        ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                       AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                       JOIN MovementItem AS MI_Income
                                         ON MI_Income.MovementId = Movement_Income.Id
                                        AND MI_Income.DescId = zc_MI_Master()
                                        AND MI_Income.isErased = FALSE
                                        AND MI_Income.Amount > 0
                       JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MI_Income.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   WHERE Movement_Income.DescId = zc_Movement_Income()
                     AND Movement_Income.StatusId = zc_Enum_Status_Complete()
                     AND Movement_Income.OperDate >= vbAVGDateStart
                     AND Movement_Income.OperDate <= vbAVGDateEnd
                   GROUP BY MI_Income.ObjectId
                  )

       -- Результат 1
       SELECT
             tmpMI.Id                                       AS Id
           , tmpMI.GoodsId                                  AS GoodsId
           , tmpMI.GoodsCode                                AS GoodsCode
           , tmpMI.GoodsName                                AS GoodsName
           , Object_Retail.ValueData                        AS RetailName
           , tmpMI.isTOP                                    AS isTOP
           , COALESCE (Object_Price_View.isTOP, FALSE)      AS isTOP_Price

           , tmpMI.GoodsGroupId                             AS GoodsGroupId
           , tmpMI.NDSKindId                                AS NDSKindId
           , tmpMI.NDSKindName                              AS NDSKindName
           , tmpMI.NDS                                      AS NDS
           , tmpMI.isClose                                  AS isClose
           , tmpMI.isFirst                                  AS isFirst
           , tmpMI.isSecond                                 AS isSecond
           , COALESCE (tmpGoodsMain.isSP,FALSE) :: Boolean  AS isSP
           , COALESCE (tmpGoodsMain.isResolution_224, FALSE) :: Boolean AS isResolution_224

           , CASE WHEN DATE_TRUNC ('DAY', tmpGoodsMain.LastPriceDate) = vbOperDate THEN TRUE ELSE FALSE END AS isMarketToday    --CURRENT_DATE
           , DATE_TRUNC ('DAY', tmpGoodsMain.LastPriceDate)                   ::TDateTime  AS LastPriceDate

           , CASE WHEN tmpGoodsMain.isSP = TRUE THEN 25088 --zc_Color_GreenL()
                  WHEN tmpMI.isTOP = TRUE
                    OR COALESCE (Object_Price_View.isTOP, FALSE) = TRUE
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
           , tmpMI.SuperFinalPrice_Deferment                AS SuperFinalPrice_Deferment
           , COALESCE (tmpGoodsMain.PriceOptSP,0)        ::TFloat     AS PriceOptSP
           , CASE WHEN tmpGoodsMain.isSP = TRUE AND (tmpMI.Price > (COALESCE (tmpGoodsMain.PriceOptSP,0))) THEN TRUE ELSE FALSE END isPriceDiff
           , COALESCE(tmpMI.isCalculated, FALSE)                      AS isCalculated
           , CASE WHEN tmpGoodsMain.isSP = TRUE THEN 25088 --zc_Color_GreenL()   --товар соц.проекта
                  WHEN tmpMI.PartionGoodsDate < vbDate180 THEN zc_Color_Red() --456
                  WHEN (tmpMI.isTOP = TRUE OR COALESCE (Object_Price_View.isTOP, FALSE)= TRUE) THEN zc_Color_Blue()--15993821 -- 16440317    -- для топ розовый шрифт
                     ELSE 0
                END AS PartionGoodsDateColor
           , Remains.Amount                                                  AS RemainsInUnit
             -- кол-во в отложенных чеках
           , COALESCE (tmpReserve.Amount, 0)                       :: TFloat AS Reserved
           , CASE WHEN (COALESCE (Remains.Amount,0) - COALESCE (tmpReserve.Amount, 0)) < 0 THEN (COALESCE (Remains.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) ELSE 0 END :: TFLoat AS Remains_Diff  --не хватает с учетом отлож. чеком
           , Object_Price_View.MCSValue                                      AS MCS
           , tmpGoodsCategory.Value                                          AS MCS_GoodsCategory
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
           , tmpMI.ListDiffAmount                               ::TFloat     AS ListDiffAmount

--           , 0                            ::TFloat    AS AmountReal
--           , 0                            ::TFloat    AS SendSUNAmount
--           , 0                            ::TFloat    AS RemainsSUN

           , COALESCE (tmpGoodsMain.CountPrice,0)               ::TFloat     AS CountPrice

           , COALESCE (SelectMinPrice_AllGoods.isOneJuridical, TRUE) :: Boolean AS isOneJuridical

           , CASE WHEN COALESCE (GoodsPromo.GoodsId, 0) = 0    THEN FALSE ELSE TRUE END  ::Boolean AS isPromo
           , CASE WHEN COALESCE (GoodsPromoAll.GoodsId, 0) = 0 THEN FALSE ELSE TRUE END  ::Boolean AS isPromoAll
           , COALESCE(GoodsPromo.OperDatePromo, NULL)           :: TDateTime AS OperDatePromo
           , COALESCE(GoodsPromo.InvNumberPromo, '')            :: TVarChar  AS InvNumberPromo -- ***

           , CASE WHEN COALESCE(OrderSheduleListToday.DOW,  0) = 0 THEN FALSE ELSE TRUE END AS isZakazToday
           , CASE WHEN COALESCE(OrderSheduleListToday.DoW_D,0) = 0 THEN FALSE ELSE TRUE END AS isDostavkaToday
           , OrderSheduleList.OperDate_Zakaz                    ::TVarChar   AS OperDate_Zakaz
           , OrderSheduleList.OperDate_Dostavka                 ::TVarChar   AS OperDate_Dostavka

           , COALESCE(tmpGoodsConditionsKeep.ConditionsKeepName, '') ::TVarChar  AS ConditionsKeepName

           , CASE 
                  --WHEN COALESCE (tmpOrderLast_2days.Amount, 0)  > 1 THEN 16777134      -- цвет фона - голубой подрязд 2 дня заказ;
                  --WHEN COALESCE (tmpOrderLast_10.Amount, 0)     > 9 THEN 167472630     -- цвет фона - розовый подрязд 10 заказов нет привязки к товару поставщика;
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) > 0.10 THEN 12319924    --светло - салатовая- цена подешевела
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) < - 0.10 THEN 14211071 --11315967--15781886 --16296444  --светло красная -- светло-розовая - подорожала
                  WHEN COALESCE(OrderSheduleListToday.DOW,  0) <> 0 THEN 12910591      -- бледно желтый
                  ELSE zc_Color_White()
             END  AS OrderShedule_Color
             
           , AVGIncome.AVGIncomePrice    AS AVGPrice

           , CASE WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) > 0.10 THEN (-1)*((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) * 100
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) < -0.10 THEN (-1)*((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) * 100
                  WHEN COALESCE (AVGIncome.AVGIncomePrice, 0) = 0 THEN 0.1--5000
                  ELSE 0
             END AS AVGPriceWarning

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
            LEFT JOIN tmpReserve                        ON tmpReserve.GoodsId               = tmpMI.GoodsId
            LEFT JOIN SelectMinPrice_AllGoods ON SelectMinPrice_AllGoods.MovementItemId = tmpMI.Id

            LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpMI.JuridicalId
                                AND GoodsPromo.GoodsId     = tmpMI.GoodsId
            -- показываем не зависимо от поставщ. явл. ли товар маркетинговым 
            LEFT JOIN (SELECT DISTINCT GoodsPromo.GoodsId FROM GoodsPromo) AS GoodsPromoAll ON GoodsPromoAll.GoodsId = tmpMI.GoodsId


            --LEFT JOIN tmpOrderLast_2days ON tmpOrderLast_2days.GoodsId = tmpMI.GoodsId
            --LEFT JOIN tmpOrderLast_10    ON tmpOrderLast_10.GoodsId    = tmpMI.GoodsId
            --LEFT JOIN tmpRepeat          ON tmpRepeat.GoodsId          = tmpMI.GoodsId
            LEFT JOIN tmpJuridicalArea   ON tmpJuridicalArea.JuridicalId = tmpMI.JuridicalId

            -- торговая сеть
            LEFT JOIN tmpObjectLink_Object AS ObjectLink_Object
                                  ON ObjectLink_Object.ObjectId = tmpMI.GoodsId
                                 AND ObjectLink_Object.DescId = zc_ObjectLink_Goods_Object()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Object.ChildObjectId
            --средняя цена
            LEFT JOIN AVGIncome ON AVGIncome.ObjectId = tmpMI.GoodsId
            LEFT JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpMI.GoodsId
            
/*            LEFT JOIN tmpObjectLink_Area AS ObjectLink_Goods_Area
                                 ON ObjectLink_Goods_Area.ObjectId = tmpMI.PartnerGoodsId
                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId    */

           ;

     -- OPEN Cursor1 FOR SELECT * FROM _tmpRes1;
     -- RETURN NEXT Cursor1;

     -- Результат 2
     -- OPEN Cursor2 FOR
     CREATE TEMP TABLE _tmpRes2 ON COMMIT DROP AS
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
   , tmpObjectLink AS (SELECT ObjectLink.*
                       FROM ObjectLink
                       WHERE ObjectLink.DescId IN ( zc_ObjectLink_Goods_Area(), zc_ObjectLink_Goods_ConditionsKeep())
                         AND ObjectLink.ObjectId IN (SELECT DISTINCT _tmpMI.GoodsId FROM _tmpMI)
                        )
   , tmpObjectFloat AS (SELECT ObjectFloat.*
                        FROM ObjectFloat
                        WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                             AND ObjectFloat.ObjectId IN (SELECT DISTINCT _tmpMI.GoodsId FROM _tmpMI)
                        )
   , tmpMIFloat AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.DescId = zc_MIFloat_Remains()
                      AND MovementItemFloat.MovementItemId IN (SELECT DISTINCT _tmpMI.PriceListMovementItemId FROM _tmpMI)
                    )
   , tmpMovementItem AS (SELECT MovementItem.*
                         FROM MovementItem
                         WHERE MovementItem.Id IN (SELECT DISTINCT _tmpMI.MovementItemId FROM _tmpMI)
                         )

   -- данные по % кредитных средств из справочника
   , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := vbObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inSession) AS tmp)


        ---
        SELECT _tmpMI.*
              , CASE WHEN PartionGoodsDate < vbDate180 THEN zc_Color_Red() -- zc_Color_Blue() --456
                     ELSE 0
                END                                                          AS PartionGoodsDateColor
              , ObjectFloat_Goods_MinimumLot.ValueData                       AS MinimumLot
              , MIFloat_Remains.ValueData                                    AS Remains
              
              , (_tmpMI.Deferment * COALESCE (tmpCostCredit.Percent, vbCostCredit))             :: TFloat      AS Persent_Deferment

              , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN FALSE ELSE TRUE END  ::Boolean AS isPromo
              , COALESCE(GoodsPromo.OperDatePromo, NULL)      :: TDateTime   AS OperDatePromo
              , COALESCE(GoodsPromo.InvNumberPromo, '')       :: TVarChar    AS InvNumberPromo -- ***
              , COALESCE(GoodsPromo.ChangePercent, 0)         :: TFLoat      AS ChangePercentPromo

              , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar     AS ConditionsKeepName
              , Object_Area.ValueData                         :: TVarChar    AS AreaName_Goods

        FROM _tmpMI
             LEFT JOIN tmpObjectFloat AS ObjectFloat_Goods_MinimumLot
                                      ON ObjectFloat_Goods_MinimumLot.ObjectId = _tmpMI.GoodsId
                            --      AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
             LEFT JOIN tmpMIFloat AS MIFloat_Remains
                                  ON MIFloat_Remains.MovementItemId = _tmpMI.PriceListMovementItemId
                                 AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
             LEFT JOIN tmpMovementItem AS MovementItem ON MovementItem.Id = _tmpMI.MovementItemId
             LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = _tmpMI.JuridicalId
                                 AND GoodsPromo.GoodsId = MovementItem.ObjectId
             -- условия хранения
             LEFT JOIN tmpObjectLink AS ObjectLink_Goods_ConditionsKeep
                                     ON ObjectLink_Goods_ConditionsKeep.ObjectId = _tmpMI.GoodsId
                                    AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

             LEFT JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = _tmpMI.JuridicalId
                                       AND tmpJuridicalArea.AreaId      = _tmpMI.AreaId

             LEFT JOIN tmpObjectLink AS ObjectLink_Goods_Area
                                     ON ObjectLink_Goods_Area.ObjectId = _tmpMI.GoodsId
                                    AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
             LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId
             
             LEFT JOIN tmpCostCredit ON _tmpMI.Price BETWEEN tmpCostCredit.MinPrice  AND tmpCostCredit.PriceLimit
;


   OPEN Cursor1 FOR SELECT * FROM _tmpRes1
                    /*WHERE inSession <> '7670317' OR _tmpRes1.Id > 0 OR _tmpRes1.Income_Amount <> 0 OR _tmpRes1.AmountSecond <> 0
                       OR _tmpRes1.CheckAmount <> 0 OR _tmpRes1.SendAmount <> 0 OR _tmpRes1.AmountDeferred <> 0
                   UNION ALL
                    SELECT * FROM 
                   (SELECT * FROM _tmpRes1
                    WHERE inSession = '7670317' AND COALESCE (_tmpRes1.Id, 0) = 0 AND COALESCE (_tmpRes1.Income_Amount, 0) = 0 AND COALESCE (_tmpRes1.AmountSecond, 0) = 0
                     AND COALESCE (_tmpRes1.CheckAmount, 0) = 0 AND COALESCE (_tmpRes1.SendAmount, 0) = 0 AND COALESCE (_tmpRes1.AmountDeferred, 0) = 0
                    LIMIT 15000
                   ) AS tmp*/
                    ;
  RETURN NEXT Cursor1;

   OPEN Cursor2 FOR SELECT * FROM _tmpRes2;
   RETURN NEXT Cursor2;

  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 24.04.19         *
 16.04.18                                                                    * оптимизация
 11.02.19         * признак Товары соц-проект берем и документа
 07.02.19         * если isBonusClose = true бонусы не учитываем
 02.11.18         *
 19.10.18         * isPriceClose замена на isPriceCloseOrder
 10.09.18         * add Remains_Diff --не хватает с учетом отлож. чеков
 31.08.18         * add Reserved               
 09.04.18                                                                    * оптимизация
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

--select * from gpSelect_MovementItem_OrderInternalOl(inMovementId := 8943040 , inShowAll := 'FALSE' , inIsErased := 'FALSE' , inIsLink := 'FALSE' ,  inSession := '3');
--select * from gpSelect_MovementItem_OrderInternal(inMovementId := 8963178 , inShowAll := 'TRUE' , inIsErased := 'FALSE' , inIsLink := 'FALSE' ,  inSession := '3');

--- последнее
-- select * from gpSelect_MovementItem_OrderInternal(inMovementId := 9495891 , inShowAll := 'FALSE' , inIsErased := 'FALSE' , inIsLink := 'FALSE' ,  inSession := '3')
select * from gpSelect_MovementItem_OrderInternal(inMovementId := 15668431 , inShowAll := 'True' , inIsErased := 'False' , inIsLink := 'FALSE' ,  inSession := '7564573');