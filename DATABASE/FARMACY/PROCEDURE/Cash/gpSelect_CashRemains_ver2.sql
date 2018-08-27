-- Function: gpSelect_CashRemains_ver2()

DROP FUNCTION IF EXISTS gpSelect_CashRemains_ver2 (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_ver2(
    IN inMovementId    Integer,    -- Текущая накладная
    IN inCashSessionId TVarChar,   -- Сессия кассового места
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId_main Integer, GoodsGroupName TVarChar, GoodsName TVarChar, GoodsCode Integer,
               Remains TFloat, Price TFloat, PriceSP TFloat, PriceSaleSP TFloat, DiffSP1 TFloat, DiffSP2 TFloat, Reserved TFloat, MCSValue TFloat,
               AlternativeGroupId Integer, NDS TFloat,
               isFirst boolean, isSecond boolean, Color_calc Integer,
               isPromo boolean,
               isSP boolean,
               IntenalSPName TVarChar,
               MinExpirationDate TDateTime,
               Color_ExpirationDate Integer,
               ConditionsKeepName TVarChar,
               AmountIncome TFloat, PriceSaleIncome TFloat,
               MorionCode Integer, BarCode TVarChar,
               MCSValueOld TFloat,
               StartDateMCSAuto TDateTime, EndDateMCSAuto TDateTime,
               isMCSAuto Boolean, isMCSNotRecalcOld Boolean,
               AccommodationId Integer, AccommodationName TVarChar,
               PriceChange TFloat
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
BEGIN
-- if inSession = '3' then return; end if;

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    -- для Теста
    -- IF inSession = '3' then vbUnitId:= 1781716; END IF;

    vbObjectId := COALESCE(lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

    -- Объявили новую сессию кассового места / обновили дату последнего обращения
    PERFORM lpInsertUpdate_CashSession (inCashSessionId := inCashSessionId
                                      , inDateConnect   := CURRENT_TIMESTAMP :: TDateTime
                                      , inUserId        := vbUserId
                                       );

    --Очистили содержимое снапшета сессии
    DELETE FROM CashSessionSnapShot
    WHERE CashSessionId = inCashSessionId;

    -- Данные
    WITH tmpContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.Amount <> 0
                         )
       , tmpCLO AS (SELECT CLO.*
                    FROM ContainerlinkObject AS CLO
                    WHERE CLO.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                      AND CLO.DescId = zc_ContainerLinkObject_PartionMovementItem()
                   )
       , tmpObject AS (SELECT Object.* FROM Object WHERE Object.Id IN (SELECT DISTINCT tmpCLO.ObjectId FROM tmpCLO))

       , tmpMIDate AS (SELECT MovementItemDate.*
                       FROM MovementItemDate
                       WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpObject.ObjectCode FROM tmpObject)
                         AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                      )

       , tmpExpirationDate AS (SELECT tmpCLO.ContainerId, MIDate_ExpirationDate.ValueData
                               FROM tmpCLO
                                    INNER JOIN tmpObject ON tmpObject.Id = tmpCLO.ObjectId
                                    INNER JOIN tmpMIDate AS MIDate_ExpirationDate
                                                         ON MIDate_ExpirationDate.MovementItemId = tmpObject.ObjectCode
                                                        -- AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               )
       , GoodsRemains AS
    (SELECT Container.ObjectId
          , SUM (Container.Amount) AS Remains
          , MIN (COALESCE (tmpExpirationDate.ValueData, zc_DateEnd())) :: TDateTime AS MinExpirationDate -- Срок годности
     FROM tmpContainer AS Container
          -- находим партию
          LEFT JOIN tmpExpirationDate ON tmpExpirationDate.Containerid = Container.Id
          /*
          -- находим партию
          LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                        ON ContainerLinkObject_MovementItem.Containerid =  Container.Id
                                       AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
          LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
          -- элемент прихода
          LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
          -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
          LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                      ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                     AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
          -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
          LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

          LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                           ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                          AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()*/
        GROUP BY Container.ObjectId
      )

    , tmpMov AS (
        SELECT Movement.Id
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
  , RESERVE
    AS
    (
        SELECT MovementItem.ObjectId            AS GoodsId
             , Sum(MovementItem.Amount)::TFloat AS Amount
        FROM tmpMov
                     INNER JOIN MovementItem ON MovementItem.MovementId = tmpMov.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
        GROUP BY MovementItem.ObjectId
    )


    --залили снапшот
    INSERT INTO CashSessionSnapShot(CashSessionId,ObjectId,Price,Remains,MCSValue,Reserved,MinExpirationDate,AccommodationId)
    WITH
    tmpObject_Price AS (SELECT ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , Price_Goods.ChildObjectId               AS GoodsId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                        WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                        )
    SELECT
        inCashSessionId                             AS CashSession
       ,GoodsRemains.ObjectId                       AS GoodsId
       ,COALESCE(tmpObject_Price.Price,0)           AS Price
       ,(GoodsRemains.Remains
            - COALESCE(Reserve.Amount,0))::TFloat   AS Remains
       ,tmpObject_Price.MCSValue                    AS MCSValue
       ,Reserve.Amount::TFloat                      AS Reserved
       ,GoodsRemains.MinExpirationDate              AS MinExpirationDate
       ,Accommodation.AccommodationId               AS AccommodationId

    FROM
        GoodsRemains
        LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = GoodsRemains.ObjectId
        LEFT OUTER JOIN RESERVE ON RESERVE.GoodsId = GoodsRemains.ObjectId
        LEFT OUTER JOIN AccommodationLincGoods AS Accommodation
                                               ON Accommodation.UnitId = vbUnitId
                                              AND Accommodation.GoodsId = GoodsRemains.ObjectId;

    RETURN QUERY
      -- Маркетинговый контракт
      WITH GoodsPromo AS (SELECT DISTINCT ObjectLink_Child_retail.ChildObjectId AS GoodsId  -- здесь товар "сети"
                         --   , tmp.ChangePercent
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
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
                -- товар в пути - непроведенные приходы сегодня
                , tmpIncome AS (SELECT MI_Income.ObjectId                      AS GoodsId
                                     , SUM(COALESCE (MI_Income.Amount, 0))     AS AmountIncome
                                     , SUM(COALESCE (MI_Income.Amount, 0) * COALESCE(MIFloat_PriceSale.ValueData,0))  AS SummSale
                                FROM Movement AS Movement_Income
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = vbUnitId

                                     LEFT JOIN MovementItem AS MI_Income
                                                            ON MI_Income.MovementId = Movement_Income.Id
                                                           AND MI_Income.isErased   = False

                                     LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                                 ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                                                                AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                                 WHERE Movement_Income.DescId = zc_Movement_Income()
                                   AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                                   AND date_trunc('day', Movement_Income.OperDate) = CURRENT_DATE
	                                 GROUP BY MI_Income.ObjectId
                                        , MovementLinkObject_To.ObjectId
                              )
           -- Коды Мориона
         , tmpGoodsMorion AS (SELECT ObjectLink_Main_Morion.ChildObjectId  AS GoodsMainId
                                   , MAX (Object_Goods_Morion.ObjectCode)  AS MorionCode
                              FROM ObjectLink AS ObjectLink_Main_Morion
                                   JOIN ObjectLink AS ObjectLink_Child_Morion
                                                   ON ObjectLink_Child_Morion.ObjectId = ObjectLink_Main_Morion.ObjectId
                                                  AND ObjectLink_Child_Morion.DescId = zc_ObjectLink_LinkGoods_Goods()
                                   JOIN ObjectLink AS ObjectLink_Goods_Object_Morion
                                                   ON ObjectLink_Goods_Object_Morion.ObjectId = ObjectLink_Child_Morion.ChildObjectId
                                                  AND ObjectLink_Goods_Object_Morion.DescId = zc_ObjectLink_Goods_Object()
                                                  AND ObjectLink_Goods_Object_Morion.ChildObjectId = zc_Enum_GlobalConst_Marion()
                                   LEFT JOIN Object AS Object_Goods_Morion ON Object_Goods_Morion.Id = ObjectLink_Goods_Object_Morion.ObjectId
                              WHERE ObjectLink_Main_Morion.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                AND ObjectLink_Main_Morion.ChildObjectId > 0
                              GROUP BY ObjectLink_Main_Morion.ChildObjectId
                             )
           -- Штрих-коды производителя
         , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId AS GoodsMainId
                                 -- , MAX (Object_Goods_BarCode.ValueData)  AS BarCode
                                    , Object_Goods_BarCode.ValueData        AS BarCode
                               FROM ObjectLink AS ObjectLink_Main_BarCode
                                    JOIN ObjectLink AS ObjectLink_Child_BarCode
                                                    ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                                   AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                                    JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                                    ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                                   AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                                   AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                                    LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
                               WHERE ObjectLink_Main_BarCode.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                 AND ObjectLink_Main_BarCode.ChildObjectId > 0
                                 AND TRIM (Object_Goods_BarCode.ValueData) <> ''
                               -- GROUP BY ObjectLink_Main_BarCode.ChildObjectId
                              )
              -- данные из прайса
              , tmpObject_Price AS (SELECT ObjectLink_Price_Unit.ObjectId                                AS Id
                                         , Price_Goods.ChildObjectId                                     AS GoodsId
                                         , COALESCE(Price_MCSValueOld.ValueData,0)          ::TFloat     AS MCSValueOld
                                         , MCS_StartDateMCSAuto.ValueData                                AS StartDateMCSAuto
                                         , MCS_EndDateMCSAuto.ValueData                                  AS EndDateMCSAuto
                                         , COALESCE(Price_MCSAuto.ValueData,False)          :: Boolean   AS isMCSAuto
                                         , COALESCE(Price_MCSNotRecalcOld.ValueData,False)  :: Boolean   AS isMCSNotRecalcOld
                                    FROM ObjectLink AS ObjectLink_Price_Unit
                                         INNER JOIN ObjectLink AS Price_Goods
                                                               ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                              AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                         LEFT JOIN ObjectFloat AS Price_MCSValueOld
                                                               ON Price_MCSValueOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                              AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()
                                         LEFT JOIN ObjectDate AS MCS_StartDateMCSAuto
                                                              ON MCS_StartDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                             AND MCS_StartDateMCSAuto.DescId = zc_ObjectDate_Price_StartDateMCSAuto()
                                         LEFT JOIN ObjectDate AS MCS_EndDateMCSAuto
                                                              ON MCS_EndDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                             AND MCS_EndDateMCSAuto.DescId = zc_ObjectDate_Price_EndDateMCSAuto()
                                         LEFT JOIN ObjectBoolean AS Price_MCSAuto
                                                                 ON Price_MCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
                                         LEFT JOIN ObjectBoolean AS Price_MCSNotRecalcOld
                                                                 ON Price_MCSNotRecalcOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                AND Price_MCSNotRecalcOld.DescId = zc_ObjectBoolean_Price_MCSNotRecalcOld()
                                    WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                      AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                    )
                -- MCS - Auto
              , tmpMCSAuto AS (SELECT CashSessionSnapShot.ObjectId
                                    , tmpObject_Price.MCSValueOld
                                    , tmpObject_Price.StartDateMCSAuto
                                    , tmpObject_Price.EndDateMCSAuto
                                    , tmpObject_Price.isMCSAuto
                                    , tmpObject_Price.isMCSNotRecalcOld
                               FROM CashSessionSnapShot
                                    INNER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = CashSessionSnapShot.ObjectId
                               WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
                              )
                -- Цена со скидкой            
              , tmpPriceChange AS (SELECT PriceChange_Goods.ChildObjectId                 AS GoodsId
                                        , ROUND(PriceChange_Value.ValueData,2)  ::TFloat  AS PriceChange 
                                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                           
                                       INNER JOIN ObjectLink AS ObjectLink_PriceChange_Retail
                                                             ON ObjectLink_PriceChange_Retail.ChildObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                            AND ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()

                                       INNER JOIN ObjectLink AS PriceChange_Goods
                                                             ON PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                            AND PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                                       INNER JOIN ObjectFloat AS PriceChange_Value
                                                              ON PriceChange_Value.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                             AND PriceChange_Value.DescId = zc_ObjectFloat_PriceChange_Value()
                                                             AND ROUND(PriceChange_Value.ValueData,2) > 0
                                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical())

        -- Результат
        SELECT
            Goods.Id,
            ObjectLink_Main.ChildObjectId AS GoodsId_main,
            Object_GoodsGroup.ValueData  AS GoodsGroupName,
            Goods.ValueData,
            Goods.ObjectCode,
            CashSessionSnapShot.Remains,
            CashSessionSnapShot.Price,

            --
            -- Цена со скидкой для СП
            --
            CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)
                 --      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"

            END :: TFloat AS PriceSP,


            --
            -- Цена без скидки для СП
            --
            CASE WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена возмещения

                 /*WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена возмещения + цена доплаты "округлили в меньшую"

                 ELSE COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)           -- иначе всегда цена возмещения
                    + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- плюс цена доплаты "округлили в меньшую"
*/
                 ELSE

            CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)
                 --      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"

            END
          + COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)

            END :: TFloat AS PriceSaleSP,

            -- временно для проверки1
           (CASE WHEN COALESCE (ObjectBoolean_Goods_SP.ValueData, FALSE) = FALSE THEN 0 ELSE
            COALESCE (CashSessionSnapShot.Price, 0)
          - CASE WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена возмещения

                 ELSE
            CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)
                 --      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"

            END
          + COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)


            END
            END
            -- COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - CashSessionSnapShot.Price
            ) :: TFloat AS DiffSP1,

            -- временно для проверки2
           (CASE WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена возмещения

                 ELSE

            CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)
                 --      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"

            END
          + COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)

            END

          - CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)
                 --      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN CashSessionSnapShot.Price < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"

            END
           ) :: TFloat AS DiffSP2,

            NULLIF (CashSessionSnapShot.Reserved, 0) :: TFloat AS Reserved,
            CashSessionSnapShot.MCSValue,
            Link_Goods_AlternativeGroup.ChildObjectId as AlternativeGroupId,
            ObjectFloat_NDSKind_NDS.ValueData AS NDS,
            COALESCE(ObjectBoolean_First.ValueData, False)          AS isFirst,
            COALESCE(ObjectBoolean_Second.ValueData, False)         AS isSecond,
            CASE WHEN COALESCE(ObjectBoolean_Second.ValueData, False) = TRUE THEN 16440317 WHEN COALESCE(ObjectBoolean_First.ValueData, False) = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc,
            CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo,
            COALESCE (ObjectBoolean_Goods_SP.ValueData, FALSE) :: Boolean  AS isSP,
            Object_IntenalSP.ValueData AS IntenalSPName,
            CashSessionSnapShot.MinExpirationDate,
            CASE WHEN CashSessionSnapShot.MinExpirationDate < CURRENT_DATE + zc_Interval_ExpirationDate() THEN zc_Color_Blue() ELSE zc_Color_Black() END AS Color_ExpirationDate,                --vbAVGDateEnd
            COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName,

            COALESCE(tmpIncome.AmountIncome,0)            :: TFloat   AS AmountIncome,
            CASE WHEN COALESCE(tmpIncome.AmountIncome,0) <> 0 THEN COALESCE(tmpIncome.SummSale,0) / COALESCE(tmpIncome.AmountIncome,0) ELSE 0 END  :: TFloat AS PriceSaleIncome,
            COALESCE (tmpGoodsMorion.MorionCode, 0) :: Integer  AS MorionCode,
            COALESCE (tmpGoodsBarCode.BarCode, '')  :: TVarChar AS BarCode

          , tmpMCSAuto.MCSValueOld
          , tmpMCSAuto.StartDateMCSAuto
          , tmpMCSAuto.EndDateMCSAuto
          , tmpMCSAuto.isMCSAuto
          , tmpMCSAuto.isMCSNotRecalcOld
          , CashSessionSnapShot.AccommodationId
          , Object_Accommodation.ValueData AS AccommodationName
          , tmpPriceChange.PriceChange

         FROM
            CashSessionSnapShot
            INNER JOIN Object AS Goods ON Goods.Id = CashSessionSnapShot.ObjectId
            LEFT JOIN tmpMCSAuto ON tmpMCSAuto.ObjectId = CashSessionSnapShot.ObjectId
            LEFT OUTER JOIN ObjectLink AS Link_Goods_AlternativeGroup
                                       ON Link_Goods_AlternativeGroup.ObjectId = Goods.Id
                                      AND Link_Goods_AlternativeGroup.DescId = zc_ObjectLink_Goods_AlternativeGroup()
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                       ON ObjectLink_Goods_NDSKind.ObjectId = Goods.Id
                                      AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
            LEFT OUTER JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                        ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                    ON ObjectBoolean_First.ObjectId = Goods.Id
                                   AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                    ON ObjectBoolean_Second.ObjectId = Goods.Id
                                   AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second()

            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Goods.Id
            LEFT JOIN tmpIncome ON tmpIncome.GoodsId = Goods.Id

            -- получается GoodsMainId
            LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Goods.Id
                                                     AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                    AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            -- Соц Проект
            LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP
                                     ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId
                                    AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()
            -- Соц Проект
            LEFT JOIN  ObjectLink AS ObjectLink_Goods_IntenalSP
                                  ON ObjectLink_Goods_IntenalSP.ObjectId = ObjectLink_Main.ChildObjectId
                                 AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()
                                 AND ObjectBoolean_Goods_SP.Valuedata = TRUE
            LEFT JOIN  Object AS Object_IntenalSP ON Object_IntenalSP.Id = ObjectLink_Goods_IntenalSP.ChildobjectId

            -- Розмір відшкодування за упаковку (Соц. проект) - (15)
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceSP
                                  ON ObjectFloat_Goods_PriceSP.ObjectId = ObjectLink_Main.ChildObjectId
                                 AND ObjectFloat_Goods_PriceSP.DescId = zc_ObjectFloat_Goods_PriceSP()
                                 AND ObjectBoolean_Goods_SP.Valuedata = TRUE
            -- Сума доплати за упаковку, грн (Соц. проект) - 16)
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PaymentSP
                                  ON ObjectFloat_Goods_PaymentSP.ObjectId = ObjectLink_Main.ChildObjectId
                                 AND ObjectFloat_Goods_PaymentSP.DescId = zc_ObjectFloat_Goods_PaymentSP()
                                 AND ObjectBoolean_Goods_SP.Valuedata = TRUE

            -- условия хранения
            LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep
                                 ON ObjectLink_Goods_ConditionsKeep.ObjectId = Goods.Id
                                AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
            LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
            --
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
            -- штрих-код производителя
            LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = ObjectLink_Main.ChildObjectId
            -- код Мориона
            LEFT JOIN tmpGoodsMorion ON tmpGoodsMorion.GoodsMainId = ObjectLink_Main.ChildObjectId
            -- Размещение товара
            LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = CashSessionSnapShot.AccommodationId
            -- Цена со скидкой            
            LEFT JOIN tmpPriceChange ON tmpPriceChange.GoodsId = Goods.Id

        WHERE
            CashSessionSnapShot.CashSessionId = inCashSessionId
        ORDER BY
            Goods.Id;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_ver2 (Integer, TVarChar, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.  Ярошенко Р.Ф.
 21.06.17         *
 09.06.17         *
 24.05.17                                                                                      * MorionCode
 23.05.17                                                                                      * BarCode
 25.01.16         *
 24.01.17         * add ConditionsKeepName
 06.09.16         *
 12.04.16         *
 02.11.15                                                                       *NDS
 10.09.15                                                                       *CashSessionSnapShot
 22.08.15                                                                       *разделение вип и отложеных
 19.08.15                                                                       *CurrentMovement
 05.05.15                        *

*/

-- тест
-- SELECT * FROM gpSelect_CashRemains (inSession:= '308120')
-- SELECT * FROM gpSelect_CashRemains_ver2(inMovementId := 0 , inCashSessionId := '{1590AD6F-681A-4B34-992A-87AEABB4D33F}' ,  inSession := '308120');
