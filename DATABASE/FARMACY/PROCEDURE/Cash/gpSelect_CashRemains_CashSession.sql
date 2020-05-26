-- Function: gpSelect_CashRemains_CashSession()

DROP FUNCTION IF EXISTS gpSelect_CashRemains_CashSession (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_CashSession(
    IN inSession       TVarChar    -- сессия пользователя
)

RETURNS TABLE (GoodsId             Integer,    -- Товар
               PartionDateKindId   Integer,    -- Типы срок/не срок
               NDSKindId           Integer,    -- Ставка НДС
               Price               TFloat,     -- цена
               Remains             TFloat,     -- Остаток
               MCSValue            TFloat,     -- неснижаемый товарный остаток
               Reserved            TFloat,     -- в резерве
               DeferredSend        TFloat,     -- в отложенных перемещениях
               MinExpirationDate   TDateTime,  -- Срок годн. ост.
               AccommodationId     Integer,    -- Размещение товара
               PartionDateDiscount TFloat,     -- Скидка на партионный товар
               PriceWithVAT        TFloat     -- Цена последней закупки
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbAreaId   Integer;

   DECLARE vbDay_6  Integer;
   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;

   DECLARE vbDividePartionDate   boolean;
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

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    -- для Теста
    -- IF inSession = '3' then vbUnitId:= 1781716; END IF;

    -- сеть пользователя
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');
    -- проверяем регион пользователя
    vbAreaId:= (SELECT outAreaId FROM gpGet_Area_byUser (inSession));
    --
    IF COALESCE (vbAreaId, 0) = 0
    THEN
        vbAreaId:= (SELECT AreaId FROM gpGet_User_AreaId (inSession));
    END IF;


    -- значения для разделения по срокам
    -- дата + 6 месяцев
    SELECT CURRENT_DATE + tmp.Date_6, tmp.Day_6
           INTO vbDate_6, vbDay_6
    FROM (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                            , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                       FROM Object  AS Object_PartionDateKind
                            LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                  ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                 AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                  ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                 AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                       WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6()
                      )
          SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL AS Date_6
               , tmp.Value AS Day_6
          FROM tmp
         ) AS tmp;
    -- дата + 1 месяц
    vbDate_1:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );
    -- дата + 0 месяцев
    vbDate_0:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );


    IF EXISTS(SELECT 1 FROM ObjectBoolean AS ObjectBoolean_DividePartionDate
              WHERE ObjectBoolean_DividePartionDate.ObjectId = vbUnitId
                AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate())
    THEN

      SELECT COALESCE (ObjectBoolean_DividePartionDate.ValueData, FALSE)
      INTO vbDividePartionDate
      FROM ObjectBoolean AS ObjectBoolean_DividePartionDate
      WHERE ObjectBoolean_DividePartionDate.ObjectId = vbUnitId
        AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate();

    ELSE
      vbDividePartionDate := False;
    END IF;


    RETURN QUERY
    WITH
          -- Отложенные перемещения
         tmpMovementID AS (SELECT
                                  Movement.Id
                                , Movement.DescId
                           FROM Movement
                           WHERE Movement.DescId IN (zc_Movement_Send(), zc_Movement_Check())
                            AND Movement.StatusId = zc_Enum_Status_UnComplete()
                         )
         , tmpMovementSend AS (SELECT
                                    Movement.Id
                             FROM tmpMovementID AS Movement

                                  INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                             ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                            AND MovementBoolean_Deferred.ValueData = TRUE

                                  INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                               AND MovementLinkObject_From.ObjectId = vbUnitId
                             WHERE  Movement.DescId = zc_Movement_Send()

                             )
         , tmpDeferredSendAll AS (SELECT
                                    Container.Id
                                  , Container.ParentId
                                  , SUM(- MovementItemContainer.Amount) AS Amount
                             FROM tmpMovementSend AS Movement

                                  INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                                  AND MovementItemContainer.DescId IN (zc_Container_Count(), zc_Container_CountPartionDate())

                                  INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId

                             GROUP BY Container.Id
                                    , Container.ParentId
                              )
         , tmpDeferredSendParrent  AS (SELECT tmpDeferredSendAll.ParentId
                                            , SUM(tmpDeferredSendAll.Amount) AS Amount
                                       FROM tmpDeferredSendAll
                                       GROUP BY tmpDeferredSendAll.ParentId
                                       )
         , tmpDeferredSendID  AS (SELECT tmpDeferredSendAll.Id
                                       , SUM(tmpDeferredSendAll.Amount) AS Amount
                                  FROM tmpDeferredSendAll
                                  GROUP BY tmpDeferredSendAll.Id
                                  )
         , tmpDeferredSend  AS (SELECT tmpDeferredSendID.Id
                                     , tmpDeferredSendID.Amount - COALESCE(tmpDeferredSendParrent.Amount, 0) AS Amount
                                FROM tmpDeferredSendID
                                     LEFT OUTER JOIN tmpDeferredSendParrent ON tmpDeferredSendParrent.ParentId = tmpDeferredSendID.Id
                                WHERE tmpDeferredSendID.Amount - COALESCE(tmpDeferredSendParrent.Amount, 0) <> 0
                                )
         , tmpDeferredSendNDSKindId AS (SELECT Movement.ParentId
                                             , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                                       OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                                     THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId
                                         FROM (SELECT DISTINCT tmpDeferredSendAll.ParentId FROM tmpDeferredSendAll) AS Movement

                                              INNER JOIN Container ON Container.Id = Movement.ParentId

                                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                            ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                              -- элемент прихода
                                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                              -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                                              LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.ObjectId
                                              LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

                                              LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                                              ON MovementBoolean_UseNDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                                             AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                                              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                           ON MovementLinkObject_NDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                                          AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                          )
         -- Отложенные чеки
       , tmpMovementCheck AS (SELECT Movement.Id
                              FROM tmpMovementID AS Movement
                              WHERE Movement.DescId = zc_Movement_Check())
       , tmpMovReserveAll AS (
                             SELECT Movement.Id
                             FROM MovementBoolean AS MovementBoolean_Deferred
                                  INNER JOIN tmpMovementCheck AS Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                             WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                               AND MovementBoolean_Deferred.ValueData = TRUE
                             UNION ALL
                             SELECT Movement.Id
                             FROM MovementString AS MovementString_CommentError
                                  INNER JOIN tmpMovementCheck AS Movement ON Movement.Id     = MovementString_CommentError.MovementId
                             WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                               AND MovementString_CommentError.ValueData <> ''
                             )
       , tmpMovReserveId AS (SELECT DISTINCT Movement.Id
                             FROM tmpMovReserveAll AS Movement
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                AND MovementLinkObject_Unit.ObjectId = vbUnitId
                             )
       , tmpReserve AS (SELECT MovementItemMaster.ObjectId                                          AS GoodsId
                             , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId)     AS NDSKindId
                             , SUM(COALESCE (MovementItemChild.Amount, MovementItemMaster.Amount))  AS Amount
                             , MIFloat_ContainerId.ValueData::Integer                               AS ContainerId
                        FROM tmpMovReserveId AS Movement

                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                          AND MovementLinkObject_Unit.ObjectId = vbUnitId

                             INNER JOIN MovementItem AS MovementItemMaster
                                                     ON MovementItemMaster.MovementId = Movement.Id
                                                    AND MovementItemMaster.DescId     = zc_MI_Master()
                                                    AND MovementItemMaster.isErased   = FALSE

                             LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItemMaster.ObjectId
                             LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                                              ON MILinkObject_NDSKind.MovementItemId = MovementItemMaster.Id
                                                             AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()

                             LEFT JOIN MovementItem AS MovementItemChild
                                                    ON MovementItemChild.MovementId = Movement.Id
                                                   AND MovementItemChild.ParentId = MovementItemMaster.Id
                                                   AND MovementItemChild.DescId     = zc_MI_Child()
                                                   AND MovementItemChild.Amount     > 0
                                                   AND MovementItemChild.isErased   = FALSE

                             LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                         ON MIFloat_ContainerId.MovementItemId = MovementItemChild.Id
                                                        AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                        GROUP BY MovementItemMaster.ObjectId
                               , MIFloat_ContainerId.ValueData
                               , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId)
                        )
       , tmpContainerAll AS (SELECT Container.DescId
                                  , Container.Id
                                  , Container.ParentId
                                  , Container.ObjectId
                                  , Container.Amount + COALESCE (tmpDeferredSend.Amount, 0)           AS Amount
                                  , tmpDeferredSend.Amount                                            AS DeferredSend
                                  , ContainerLinkObject.ObjectId                                      AS PartionGoodsId
                             FROM Container

                                  LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                  LEFT JOIN tmpDeferredSend ON tmpDeferredSend.ID = Container.ID

                             WHERE Container.DescId  IN (zc_Container_Count(), zc_Container_CountPartionDate())
                               AND (Container.Amount <> 0 OR COALESCE (tmpDeferredSend.Amount, 0) <> 0)
                               AND Container.WhereObjectId = vbUnitId
                            )


       , tmpContainerPD AS (SELECT Container.Id
                                 , Container.ParentId
                                 , Container.ObjectId
                                 , Container.Amount
                                 , Container.DeferredSend
                                 , Reserve.Amount                                                AS Reserve
                                 , COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                                 , COALESCE (ObjectFloat_PartionGoods_ValueMin.ValueData, 0)     AS PercentMin
                                 , COALESCE (ObjectFloat_PartionGoods_Value.ValueData, 0)        AS Percent
                                 , COALESCE (ObjectFloat_PartionGoods_PriceWithVAT.ValueData, 0) AS PriceWithVAT
                                 , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                        ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен с просрочки
                            FROM tmpContainerAll AS Container
                                 LEFT JOIN (SELECT tmpReserve.ContainerId, SUM(tmpReserve.Amount) AS Amount FROM tmpReserve GROUP BY tmpReserve.ContainerId) AS Reserve
                                                      ON Reserve.ContainerId = Container.ID
                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = Container.PartionGoodsId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueMin
                                                       ON ObjectFloat_PartionGoods_ValueMin.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_ValueMin.DescId = zc_ObjectFloat_PartionGoods_ValueMin()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Value
                                                       ON ObjectFloat_PartionGoods_Value.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_Value.DescId = zc_ObjectFloat_PartionGoods_Value()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_PriceWithVAT
                                                       ON ObjectFloat_PartionGoods_PriceWithVAT.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_PriceWithVAT.DescId = zc_ObjectFloat_PartionGoods_PriceWithVAT()
                            WHERE Container.DescId = zc_Container_CountPartionDate()
                             )
       , tmpContainerPDAll AS (SELECT tmpContainerPD.ParentId
                                      , SUM(tmpContainerPD.Amount - COALESCE (tmpContainerPD.DeferredSend, 0)) AS Amount
                                 FROM tmpContainerPD
                                 GROUP BY tmpContainerPD.ParentId
                                 )
       , tmpGoods_PD AS (SELECT DISTINCT tmpContainerPD.ObjectId AS GoodsId
                         FROM tmpContainerPD
                         WHERE tmpContainerPD.PriceWithVAT <= 15
                           AND tmpContainerPD.PartionDateKindId = zc_Enum_PartionDateKind_6())
         -- спец-цены
--     , tmpCashGoodsPriceWithVAT AS (SELECT * FROM gpSelect_CashGoodsPriceWithVAT('3'))
--     , tmpCashGoodsPriceWithVAT AS (SELECT 0 :: Integer AS Id, 0 :: TFloat AS PriceWithVAT WHERE 1=0)
       , tmpCashGoodsPriceWithVAT AS (WITH
                                 DD AS (SELECT DISTINCT Object_MarginCategoryItem_View.MarginPercent,
                                                        Object_MarginCategoryItem_View.MinPrice,
                                                        Object_MarginCategoryItem_View.MarginCategoryId,
                                                        ROW_NUMBER() OVER (PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId
                                                                           ORDER BY Object_MarginCategoryItem_View.MinPrice) AS ORD
                                        FROM Object_MarginCategoryItem_View
                                             INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id       = Object_MarginCategoryItem_View.Id
                                                                                           AND Object_MarginCategoryItem.isErased = FALSE
                                       )
                  , MarginCondition AS (SELECT
                                            D1.MarginCategoryId,
                                            D1.MarginPercent,
                                            D1.MinPrice,
                                            COALESCE(D2.MinPrice, 1000000) AS MaxPrice
                                        FROM DD AS D1
                                            LEFT OUTER JOIN DD AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1
                                       )

                         -- Список цены + ТОП
                      /*, GoodsPrice AS (SELECT ObjectLink_Price_Goods.ChildObjectId              AS GoodsId
                                             , COALESCE (ObjectBoolean_Top.ValueData, FALSE)     AS isTOP
                                             , COALESCE (ObjectFloat_PercentMarkup.ValueData, 0) AS PercentMarkup
                                        FROM ObjectLink AS ObjectLink_Price_Unit
                                             INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                                                   ON ObjectLink_Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                  AND ObjectLink_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                                             -- !!!ограничили только этим списком!!!
                                             INNER JOIN tmpGoods_PD ON tmpGoods_PD.GoodsId = ObjectLink_Price_Goods.ChildObjectId

                                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                                                     ON ObjectBoolean_Top.ObjectId  = ObjectLink_Price_Unit.ObjectId
                                                                    AND ObjectBoolean_Top.DescId    = zc_ObjectBoolean_Price_Top()
                                             LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                                                   ON ObjectFloat_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                  AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                                        WHERE ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                          AND ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                       -- AND (ObjectBoolean_Top.ValueData = TRUE OR ObjectFloat_PercentMarkup.ValueData <> 0)
                                       )*/
                , JuridicalSettings AS (SELECT DISTINCT JuridicalId, ContractId, isPriceCloseOrder
                                        FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS JuridicalSettings
                                             LEFT JOIN Object AS Object_ContractSettings ON Object_ContractSettings.Id = JuridicalSettings.MainJuridicalId
                                        WHERE COALESCE (Object_ContractSettings.isErased, FALSE) = FALSE
                                         AND JuridicalSettings.MainJuridicalId <> 5603474
                                       )
                     -- !!!товары из списка tmpGoods_PD!!!
                   , tmpGoodsPartner AS (SELECT tmpGoods_PD.GoodsId                               AS GoodsId_retail -- товар сети
                                              , ObjectLink_LinkGoods_Main.ChildObjectId           AS GoodsId_main   -- товар главный
                                              , ObjectLink_LinkGoods_jur.ChildObjectId            AS GoodsId_jur    -- товар поставщика
                                           -- , Object_Goods_jur.ObjectCode                       AS GoodsCode_jur  -- товар поставщика
                                              , ObjectString_Goods_Code.ValueData                 AS GoodsCode_jur  -- товар поставщика
                                              , ObjectLink_Goods_Object_jur.ChildObjectId         AS JuridicalId    -- поставщик
                                              , COALESCE (ObjectBoolean_Top.ValueData, FALSE)     AS isTOP          -- топ у тов. сети
                                              , COALESCE (ObjectFloat_PercentMarkup.ValueData, 0) AS PercentMarkup  -- % нац. у тов. сети
                                              , COALESCE (ObjectFloat_Goods_Price.ValueData, 0)   AS Price_retail   -- фиксированная цена у тов. сети
                                              , COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)   AS NDS            -- NDS у тов. главный
                                         FROM tmpGoods_PD
                                              -- объект - линк
                                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods
                                                                    ON ObjectLink_LinkGoods.ChildObjectId = tmpGoods_PD.GoodsId
                                                                   AND ObjectLink_LinkGoods.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                              -- главный товар - для товаров сети
                                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Main
                                                                    ON ObjectLink_LinkGoods_Main.ObjectId = ObjectLink_LinkGoods.ObjectId
                                                                   AND ObjectLink_LinkGoods_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                              -- главный товар - все у кого он "такой же" - среди них будет и товар поставщика
                                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Main_jur
                                                                    ON ObjectLink_LinkGoods_Main_jur.ChildObjectId = ObjectLink_LinkGoods_Main.ChildObjectId
                                                                   AND ObjectLink_LinkGoods_Main_jur.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                              -- все объекты - линк - среди них будет и для товаров поставщика
                                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_jur
                                                                    ON ObjectLink_LinkGoods_jur.ObjectId = ObjectLink_LinkGoods_Main_jur.ObjectId
                                                                   AND ObjectLink_LinkGoods_jur.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                              -- товар поставщика, нужен его GoodsCode_int
                                              -- INNER JOIN Object AS Object_Goods_jur ON Object_Goods_jur.Id = ObjectLink_LinkGoods_jur.ChildObjectId
                                              -- товар поставщика, нужен его GoodsCode_str
                                              LEFT JOIN ObjectString AS ObjectString_Goods_Code
                                                                     ON ObjectString_Goods_Code.ObjectId = ObjectLink_LinkGoods_jur.ChildObjectId
                                                                    AND ObjectString_Goods_Code.DescId   = zc_ObjectString_Goods_Code()
                                              -- у товара поставщика - его Поставщик
                                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object_jur
                                                                    ON ObjectLink_Goods_Object_jur.ObjectId = ObjectLink_LinkGoods_jur.ChildObjectId
                                                                   AND ObjectLink_Goods_Object_jur.DescId   = zc_ObjectLink_Goods_Object()
                                              -- !!!ограничили что это Юр Лица!!!
                                              INNER JOIN Object AS Object_Juridical ON Object_Juridical.Id     = ObjectLink_Goods_Object_jur.ChildObjectId
                                                                                   AND Object_Juridical.DescId = zc_Object_Juridical()
                                              -- Список цены + ТОП + PercentMarkup для тов. сети
                                              LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Price
                                                                    ON ObjectFloat_Goods_Price.ObjectId = tmpGoods_PD.GoodsId
                                                                   AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                                              INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                                                    ON ObjectLink_Price_Goods.ChildObjectId = tmpGoods_PD.GoodsId
                                                                   AND ObjectLink_Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                              INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                                    ON ObjectLink_Price_Unit.ObjectId      = ObjectLink_Price_Goods.ObjectId
                                                                   AND ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                                   AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                              LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                                                      ON ObjectBoolean_Top.ObjectId  = ObjectLink_Price_Unit.ObjectId
                                                                     AND ObjectBoolean_Top.DescId    = zc_ObjectBoolean_Price_Top()
                                              LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                                                    ON ObjectFloat_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                   AND ObjectFloat_PercentMarkup.DescId   = zc_ObjectFloat_Price_PercentMarkup()
                                              -- для тов. главный
                                              LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                                                   ON ObjectLink_Goods_NDSKind.ObjectId = ObjectLink_LinkGoods_Main.ChildObjectId
                                                                  AND ObjectLink_Goods_NDSKind.DescId   = zc_ObjectLink_Goods_NDSKind()
                                              LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                                    ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                                                   AND ObjectFloat_NDSKind_NDS.DescId   = zc_ObjectFloat_NDSKind_NDS()
                                        )

                   , _GoodsPriceAll AS (SELECT -- LinkGoodsObject.GoodsId             AS GoodsId,
                                               tmpGoodsPartner.GoodsId_retail         AS GoodsId, -- товар сети
                                             /*zfCalc_SalePrice((LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100),                         -- Цена С НДС
                                                                 CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                                                          THEN MarginCondition.MarginPercent + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0)
                                                                      ELSE MarginCondition.MarginPercent + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0)
                                                                 END,                                                                             -- % наценки в КАТЕГОРИИ
                                                                 COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), ObjectGoodsView.isTop),              -- ТОП позиция
                                                                 COALESCE (NULLIF (GoodsPrice.PercentMarkup, 0), ObjectGoodsView.PercentMarkup),  -- % наценки у товара
                                                                 0.0, --ObjectFloat_Juridical_Percent.ValueData,                                  -- % корректировки у Юр Лица для ТОПа
                                                                 ObjectGoodsView.Price                                                            -- Цена у товара (фиксированная)
                                                               )         :: TFloat AS Price,
                                               LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100 AS PriceWithVAT*/
                                               zfCalc_SalePrice ((LoadPriceListItem.Price * (100 + tmpGoodsPartner.NDS) / 100),                         -- Цена С НДС
                                                                 CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                                                          THEN MarginCondition.MarginPercent + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0)
                                                                      ELSE MarginCondition.MarginPercent + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0)
                                                                 END,                                                                             -- % наценки в КАТЕГОРИИ
                                                                 COALESCE (tmpGoodsPartner.isTOP, FALSE),                                         -- ТОП позиция
                                                                 COALESCE (tmpGoodsPartner.PercentMarkup, 0),                                     -- % наценки у товара
                                                                 0.0, --ObjectFloat_Juridical_Percent.ValueData,                                  -- % корректировки у Юр Лица для ТОПа
                                                                 tmpGoodsPartner.Price_retail                                                            -- Цена у товара (фиксированная)
                                                               )         :: TFloat AS Price,
                                               LoadPriceListItem.Price * (100 + tmpGoodsPartner.NDS)/100 AS PriceWithVAT

                                        FROM LoadPriceListItem

                                             INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId

                                             LEFT JOIN JuridicalSettings
                                                     ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId
                                                    AND JuridicalSettings.ContractId  = LoadPriceList.ContractId

                                             -- !!!ограничили только этим списком!!!
                                             INNER JOIN tmpGoodsPartner ON tmpGoodsPartner.JuridicalId   = LoadPriceList.JuridicalId
                                                                       AND tmpGoodsPartner.GoodsId_main  = LoadPriceListItem.GoodsId
                                                                       AND tmpGoodsPartner.GoodsCode_jur = LoadPriceListItem.GoodsCode

                                             LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                                                   ON ObjectFloat_Juridical_Percent.ObjectId = LoadPriceList.JuridicalId
                                                                  AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

                                             LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                                                   ON ObjectFloat_Contract_Percent.ObjectId = LoadPriceList.ContractId
                                                                  AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

                                             LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink
                                                                                      ON Object_MarginCategoryLink.UnitId = vbUnitId
                                                                                     AND Object_MarginCategoryLink.JuridicalId = LoadPriceList.JuridicalId

                                             LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_all
                                                                                      ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                                                     AND Object_MarginCategoryLink_all.JuridicalId = LoadPriceList.JuridicalId
                                                                                     AND Object_MarginCategoryLink_all.isErased    = FALSE
                                                                                     AND Object_MarginCategoryLink.JuridicalId IS NULL

                                             LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                                                  -- AND (LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice
                                                                     AND (LoadPriceListItem.Price * (100 + tmpGoodsPartner.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice

                                             -- 1.главный товар
                                             /*LEFT JOIN Object_Goods_Main_View AS Object_Goods ON Object_Goods.Id = LoadPriceListItem.GoodsId

                                             -- 2.товар поставщика
                                             LEFT JOIN Object_Goods_View AS PartnerGoods ON PartnerGoods.ObjectId  = LoadPriceList.JuridicalId
                                                                                        AND PartnerGoods.GoodsCode = LoadPriceListItem.GoodsCode
                                             -- совместили 1и2
                                             LEFT JOIN Object_LinkGoods_View AS LinkGoods ON LinkGoods.GoodsMainId = Object_Goods.Id
                                                                                         AND LinkGoods.GoodsId     = PartnerGoods.Id

                                             -- нашли товар сети
                                             LEFT JOIN Object_LinkGoods_View AS LinkGoodsObject ON LinkGoodsObject.GoodsMainId = Object_Goods.Id
                                                                                               AND LinkGoodsObject.ObjectId    = vbObjectId
                                             -- св-ва товара сети
                                             LEFT JOIN Object_Goods_View AS ObjectGoodsView ON ObjectGoodsView.Id = LinkGoodsObject.GoodsId

                                             -- !!!ограничили только этим списком!!!
                                             INNER JOIN tmpGoods_PD ON tmpGoods_PD.GoodsId = LinkGoodsObject.GoodsId

                                             LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = LinkGoodsObject.GoodsId*/

                                        WHERE COALESCE(JuridicalSettings.isPriceCloseOrder, TRUE)  = FALSE
                                          AND (LoadPriceList.AreaId = 0 OR COALESCE (LoadPriceList.AreaId, 0) = vbAreaId OR COALESCE(vbAreaId, 0) = 0
                                            OR COALESCE (LoadPriceList.AreaId, 0) = zc_Area_Basis()
                                              )
                                       )
                              , GoodsPriceAll AS (SELECT
                                                       ROW_NUMBER() OVER (PARTITION BY _GoodsPriceAll.GoodsId ORDER BY _GoodsPriceAll.Price)::Integer AS Ord,
                                                       _GoodsPriceAll.GoodsId           AS GoodsId,
                                                       _GoodsPriceAll.PriceWithVAT      AS PriceWithVAT
                                                  FROM _GoodsPriceAll
                                                 )
                            -- Результат - спец-цены
                            SELECT GoodsPriceAll.GoodsId      AS Id,
                                   GoodsPriceAll.PriceWithVAT AS PriceWithVAT
                            FROM GoodsPriceAll
                            WHERE Ord = 1
                           )
       , tmpPDPriceWithVAT AS (SELECT ROW_NUMBER()OVER(PARTITION BY Container.ObjectId, Container.PartionDateKindId ORDER BY Container.Id DESC) as ORD
                                    , Container.ObjectId
                                    , Container.PartionDateKindId
                                    , CASE WHEN Container.PriceWithVAT <= 15
                                           THEN COALESCE (tmpCashGoodsPriceWithVAT.PriceWithVAT, Container.PriceWithVAT)
                                           ELSE Container.PriceWithVAT END       AS PriceWithVAT
                               FROM tmpContainerPD AS Container
                                    LEFT JOIN tmpCashGoodsPriceWithVAT ON tmpCashGoodsPriceWithVAT.ID = Container.ObjectId
                               )

       , tmpContainerIncome AS (SELECT Container.Id
                                     , Container.ObjectId
                                     , Container.Amount - COALESCE (tmpContainerPDAll.Amount, 0)       AS Amount
                                     , Container.DeferredSend
                                     , COALESCE (MI_Income_find.Id,MI_Income.Id)                       AS MI_IncomeId
                                     , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)       AS M_IncomeId
                                FROM tmpContainerAll AS Container
                                     LEFT JOIN  tmpContainerPDAll on tmpContainerPDAll.ParentId = Container.Id
                                     LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                   ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                                  AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                     LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                     -- элемент прихода
                                     LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                     -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                 ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                     -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                     LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                          -- AND 1=0
                                WHERE Container.DescId = zc_Container_Count()
                                )
       , tmpContainer AS (SELECT Container.Id
                               , Container.ObjectId
                               , Container.Amount
                               , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                        OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                 THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId
                               , Container.DeferredSend
                               , MIDate_ExpirationDate.ValueData                                           AS ExpirationDate
                          FROM tmpContainerIncome AS Container
                               LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.ObjectId
                               LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                               LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                                ON MIDate_ExpirationDate.MovementItemId = Container.MI_IncomeId
                                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                               ON MovementBoolean_UseNDSKind.MovementId = Container.M_IncomeId
                                                              AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                            ON MovementLinkObject_NDSKind.MovementId = Container.M_IncomeId
                                                           AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                         )
       , tmpGoodsRemains AS (SELECT Container.ObjectId
                                  , Container.NDSKindId
                                  , SUM(Container.Amount)                                   AS Remains
                                  , SUM(Container.DeferredSend)                             AS DeferredSend
                                  , MIN(COALESCE (Container.ExpirationDate, zc_DateEnd()))  AS MinExpirationDate
                             FROM tmpContainer AS Container
                             WHERE Container.Amount <> 0
                             GROUP BY Container.ObjectId
                                    , Container.NDSKindId
                             HAVING SUM(Container.Amount) <> 0 OR SUM(Container.DeferredSend) <> 0
                             )
       , tmpPDGoodsRemains AS (SELECT Container.ObjectId
                                    , COALESCE(tmpContainer.NDSKindId, tmpDeferredSendNDSKindId.NDSKindId, 
                                                                                  Object_Goods.NDSKindId) AS NDSKindId
                                    , Container.PartionDateKindId                                          AS PartionDateKindId
                                    , SUM (Container.Amount)                                               AS Remains
                                    , SUM (Container.Reserve)                                              AS Reserve
                                    , SUM (Container.DeferredSend)                                         AS DeferredSend
                                    , MIN (Container.ExpirationDate)::TDateTime                            AS MinExpirationDate
                                    , MAX (tmpPDPriceWithVAT.PriceWithVAT)                                 AS PriceWithVAT

                                    , MIN (CASE WHEN Container.PartionDateKindId = zc_Enum_PartionDateKind_Good()
                                                THEN 0
                                                WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_6(), zc_Enum_PartionDateKind_Cat_5())
                                                THEN Container.Percent
                                                ELSE Container.PercentMin END)::TFloat                  AS PartionDateDiscount
                               FROM tmpContainerPD AS Container

                                    LEFT JOIN tmpContainer ON tmpContainer.Id = Container.ParentId

                                    LEFT JOIN tmpDeferredSendNDSKindId ON tmpDeferredSendNDSKindId.ParentId = Container.ParentId

                                    LEFT JOIN tmpPDPriceWithVAT ON tmpPDPriceWithVAT.ObjectId = Container.ObjectId
                                                               AND tmpPDPriceWithVAT.PartionDateKindId = Container.PartionDateKindId
                                                               AND tmpPDPriceWithVAT.Ord = 1

                                    LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.ObjectId
                                    LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

                               GROUP BY Container.ObjectId
                                      , COALESCE(tmpContainer.NDSKindId, tmpDeferredSendNDSKindId.NDSKindId, Object_Goods.NDSKindId)
                                      , Container.PartionDateKindId
                               )
          -- Непосредственно остатки
       , GoodsRemains AS (SELECT Container.ObjectId
                               , Container.NDSKindId
                               , Container.Remains - COALESCE(Reserve.Amount, 0) -
                                            COALESCE(Container.DeferredSend, 0)    AS Remains
                               , Reserve.Amount                                    AS Reserve
                               , Container.DeferredSend
                               , Container.MinExpirationDate
                               , NULL::Integer                                     AS PartionDateKindId
                               , NULL::TFloat                                      AS PartionDateDiscount
                               , NULL::TFloat                                      AS PriceWithVAT
                          FROM tmpGoodsRemains AS Container
                               LEFT JOIN tmpReserve AS Reserve
                                                    ON Reserve.GoodsId = Container.ObjectId
                                                   AND Reserve.NDSKindId = Container.NDSKindId
                                                   AND COALESCE (Reserve.ContainerId, 0 ) = 0
                          UNION ALL
                          SELECT Container.ObjectId
                               , Container.NDSKindId
                               , Container.Remains - COALESCE(Container.Reserve, 0) -
                                                     COALESCE(Container.DeferredSend, 0)
                               , Container.Reserve
                               , Container.DeferredSend
                               , Container.MinExpirationDate
                               , Container.PartionDateKindId
                               , NULLIF (Container.PartionDateDiscount, 0)
                               , Container.PriceWithVAT
                          FROM tmpPDGoodsRemains AS Container
                          UNION ALL
                          SELECT Reserve.GoodsId                                                       AS GoodsId
                               , Reserve.NDSKindId                                                     AS NDSKindId
                               , -Reserve.Amount                                                       AS Remains
                               , Reserve.Amount                                                        AS Reserved
                               , NULL                                                                  AS DeferredSend
                               , Null::TDateTime                                                       AS MinExpirationDate
                               , NULL                                                                  AS PartionDateKindId
                               , NULL                                                                  AS PartionDateDiscount
                               , NULL                                                                  AS PriceWithVAT
                          FROM tmpReserve AS Reserve
                             LEFT OUTER JOIN tmpGoodsRemains ON Reserve.GoodsId = tmpGoodsRemains.ObjectId
                                                            AND Reserve.NDSKindId = tmpGoodsRemains.NDSKindId
                          WHERE COALESCE(tmpGoodsRemains.ObjectId, 0) = 0
                            AND COALESCE (Reserve.ContainerId, 0 ) = 0
                            AND Reserve.Amount <> 0
                          )
       , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
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
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                        )

    SELECT GoodsRemains.ObjectId                                             AS GoodsId
         , COALESCE (GoodsRemains.PartionDateKindId, 0)                      AS PartionDateKindId
         , GoodsRemains.NDSKindId                                            AS NDSKindId
         , COALESCE(tmpObject_Price.Price,0)::TFloat                         AS Price
         , GoodsRemains.Remains::TFloat                                      AS Remains
         , tmpObject_Price.MCSValue                                          AS MCSValue
         , NULLIF (GoodsRemains.Reserve, 0)::TFloat                          AS Reserved
         , NULLIF (GoodsRemains.DeferredSend, 0)::TFloat                     AS DeferredSend
         , GoodsRemains.MinExpirationDate::TDateTime                         AS MinExpirationDate
         , Accommodation.AccommodationId                                     AS AccommodationId
         , CASE WHEN COALESCE (GoodsRemains.PartionDateKindId, 0) <> 0
                THEN GoodsRemains.PartionDateDiscount ELSE NULL END::TFloat  AS PartionDateDiscount
         , GoodsRemains.PriceWithVAT::TFloat                                 AS PriceWithVAT
    FROM
        GoodsRemains
        LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = GoodsRemains.ObjectId

        LEFT OUTER JOIN AccommodationLincGoods AS Accommodation
                                               ON Accommodation.UnitId = vbUnitId
                                              AND Accommodation.GoodsId = GoodsRemains.ObjectId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_CashSession (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.  Ярошенко Р.Ф.  Шаблий О.В.
 13.03.20                                                                                                    * Оптимизация
 15.07.19                                                                                                    *
 28.05.19                                                                                                    * PartionDateKindId
 13.05.19                                                                                                    *
 24.04.19                                                                                                    * Helsi
 04.04.19                                                                                                    * GoodsAnalog
 06.03.19                                                                                                    * DoesNotShare
 11.02.19                                                                                                    *
 30.10.18                                                                                                    *
 01.10.18         * tmpPriceChange - учет скидки подразделения
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

--тест
-- SELECT * FROM gpSelect_CashRemains_CashSession ('3')
