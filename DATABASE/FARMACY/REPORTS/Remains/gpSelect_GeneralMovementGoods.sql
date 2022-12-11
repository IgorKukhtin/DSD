-- Function: gpSelect_GeneralMovementGoods()

--DROP FUNCTION IF EXISTS gpSelect_GeneralMovementGoods (TDateTime, TDateTime, Integer, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_GeneralMovementGoods (TDateTime, TDateTime, Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GeneralMovementGoods (TDateTime, TDateTime, Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GeneralMovementGoods(
    IN inDateStart         TDateTime,  -- Дата начала
    IN inDateFinal         TDateTime,  -- Двта конца
    IN inUnitID            Integer,    -- Подразделение
    IN inGoodsID           Integer,    -- Товар
    IN inCodeSearch        TVarChar,   -- поиск товаров по коду
    IN inGoodsSearch       TVarChar,   -- поиск товаров
    IN inisNeBoley         Boolean,    -- наш сайт
    IN inisMobile          Boolean,    -- приложение
    IN inisTabletki        Boolean,    -- таблетки 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (
               UnitID          Integer
             , UnitCode        Integer
             , UnitName        TVarChar
             , GoodsID         Integer
             , GoodsCode       Integer
             , GoodsName       TVarChar
             , SummaSale       TFloat
             , AmountSale      TFloat
             , SummChangePercent TFloat
             , SummaIncome     TFloat
             , AmountIncome    TFloat
             , SummaProfit     TFloat
             , Remains         TFloat
             , RemainsSum      TFloat
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       AND (vbUserId <> 8037524)
    THEN
        RAISE EXCEPTION 'Ошибка. Запуск отчета разрешен только директору.';
    END IF;

    CREATE TEMP TABLE _tmpGoods ON COMMIT DROP AS
    SELECT  Goods_Retail.Id, Goods_Main.ObjectCode, Goods_Main.Name
    FROM Object_Goods_Main AS Goods_Main
         INNER JOIN Object_Goods_Retail AS Goods_Retail
                                        ON Goods_Main.Id  = Goods_Retail.GoodsMainId
                                       AND Goods_Retail.RetailId = vbObjectId
    WHERE Goods_Retail.ID = COALESCE(inGoodsID, 0)
       OR (position(','||CAST(Goods_Main.ObjectCode AS TVarChar)||',' IN ','||inCodeSearch||',') > 0 AND inCodeSearch <> '' AND COALESCE(inGoodsID, 0) = 0)
       OR (upper(Goods_Main.Name) ILIKE UPPER('%'||inGoodsSearch||'%')  AND inGoodsSearch <> '' AND inCodeSearch = '' AND COALESCE(inGoodsID, 0) = 0);

    -- Результат
   RETURN QUERY
        WITH tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                         FROM ObjectLink AS ObjectLink_Unit_Juridical

                              INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                    ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                   AND (ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId OR vbObjectId = 0)

                          WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                            AND (inUnitID = 0 OR inUnitID = ObjectLink_Unit_Juridical.ObjectId)
                         )
             -- Остатки
           , tmpContainerAll AS (SELECT Container.Id                             AS ID
                                      , Container.WhereObjectId                  AS UnitID
                                      , Container.ObjectId                       AS GoodsId
                                      , SUM (Container.Amount)                   AS Amount
                                 FROM Container
                                      INNER JOIN _tmpGoods ON _tmpGoods.ID = Container.ObjectId
                                      INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                 WHERE Container.DescId = zc_Container_Count()
                                 GROUP BY Container.Id
                                        , Container.WhereObjectId
                                        , Container.ObjectId
                              )
             -- Остатки на конец
           , tmpContainerEnd AS (SELECT Container.UnitID                                                      AS UnitID
                                      , Container.GoodsId                                                     AS GoodsId
                                      , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                 FROM tmpContainerAll as Container
                                      LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.ID
                                                                           AND MovementItemContainer.OperDate >= inDateFinal + INTERVAL '1 DAY'
                                 GROUP BY Container.Id
                                        , Container.UnitID
                                        , Container.GoodsId
                                        , Container.Amount
                                 HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) <> 0
                              )
           , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                              AND ObjectFloat_Goods_Price.ValueData > 0
                                             THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                             ELSE ROUND (Price_Value.ValueData, 2)
                                             END :: TFloat                           AS Price
                                       , Price_Goods.ChildObjectId                   AS GoodsId
                                       , ObjectLink_Price_Unit.ChildObjectId         AS UnitId
                                 FROM ObjectLink AS ObjectLink_Price_Unit
                                      INNER JOIN tmpUnit ON tmpUnit.UnitId = ObjectLink_Price_Unit.ChildObjectId
                                      INNER JOIN ObjectLink AS Price_Goods
                                                            ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                           AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                      INNER JOIN _tmpGoods ON _tmpGoods.ID = Price_Goods.ChildObjectId
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
                                  )
             -- Остаток по одразделениям
           , tmpRemains AS (SELECT tmpContainerEnd.UnitID
                                 , tmpContainerEnd.GoodsId
                                 , Sum(tmpContainerEnd.Amount) AS Saldo
                                 , Sum(tmpContainerEnd.Amount * tmpObject_Price.Price) AS SaldoSum
                            FROM tmpContainerEnd
                                 LEFT JOIN tmpObject_Price ON tmpObject_Price.UnitID  = tmpContainerEnd.UnitID
                                                          AND tmpObject_Price.GoodsId = tmpContainerEnd.GoodsId
                            GROUP BY tmpContainerEnd.UnitID
                                   , tmpContainerEnd.GoodsId)
             -- Реализация за период
           , tmpRealization AS (SELECT Container.UnitID                                                                   AS UnitID
                                     , Container.GoodsId                                                                  AS GoodsId
                                     , SUM (-1.0 * MovementItemContainer.Amount)                                          AS AmountSale
                                     , SUM (-1.0 * Round(MovementItemContainer.Amount *  MovementItemContainer.Price, 2)) AS SummaSale
                                     , SUM (MIFloat_SummChangePercent.ValueData)                                          AS SummChangePercent
                                FROM tmpContainerAll as Container
                                     INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.ID
                                                                     AND MovementItemContainer.OperDate >= inDateStart
                                                                     AND MovementItemContainer.OperDate < inDateFinal + INTERVAL '1 DAY'
                                                                     AND MovementItemContainer.MovementDescId IN (zc_Movement_Check(), zc_Movement_Sale())
                                                                     
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                                                  ON MovementLinkObject_CheckSourceKind.MovementId = MovementItemContainer.MovementId
                                                                 AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
                                                               
                                     LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                              ON MovementString_InvNumberOrder.MovementId = MovementItemContainer.MovementId
                                                             AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                                     LEFT JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                                               ON MovementBoolean_MobileApplication.MovementId = MovementItemContainer.MovementId
                                                              AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()
                                                               
                                     LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                                 ON MIFloat_SummChangePercent.MovementItemId = MovementItemContainer.MovementItemId
                                                                AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
                                                                    
                                WHERE inisNeBoley = False AND inisMobile = False AND inisTabletki = False
                                   OR inisNeBoley = True AND COALESCE (MovementBoolean_MobileApplication.ValueData, False) = False AND 
                                                             COALESCE (MovementString_InvNumberOrder.ValueData, '') <> ''
                                   OR inisMobile = True AND COALESCE (MovementBoolean_MobileApplication.ValueData, False) = True
                                   OR inisTabletki = True AND COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Tabletki()

                                GROUP BY Container.UnitID
                                       , Container.GoodsId
                                HAVING SUM (MovementItemContainer.Amount) <> 0)
             -- Приходы за период
           , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                 , ObjectFloat_NDSKind_NDS.ValueData
                           FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                           WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                          )
           , tmpIncomeAll AS (SELECT Container.ID                                                                AS ID
                                   , Container.UnitID                                                            AS UnitID
                                   , Container.GoodsId                                                                  AS GoodsId
                                   , MovementItemContainer.Amount                                                AS AmountIncome
                              FROM tmpContainerAll as Container
                                   INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.ID
                                                                        AND MovementItemContainer.OperDate >= inDateStart
                                                                        AND MovementItemContainer.OperDate < inDateFinal + INTERVAL '1 DAY'
                                                                        AND MovementItemContainer.MovementDescId IN (zc_movement_Income())
                              WHERE MovementItemContainer.Amount <> 0)
           , tmpIncomeId AS (SELECT Container.UnitID                                                            AS UnitID
                                  , Container.GoodsId                                                                  AS GoodsId
                                  , Container.AmountIncome                                                      AS AmountIncome
                                  , COALESCE (MI_Income_find.Id,MI_Income.Id)                                   AS MI_Income
                                  , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)                   AS Movement_Income
                           FROM tmpIncomeAll as Container

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

                           )
           , tmpIncome AS (SELECT Container.UnitID                                                            AS UnitID
                                , Container.GoodsId                                                                  AS GoodsId
                                , SUM (Container.AmountIncome)                                          AS AmountIncome
                                , SUM (Round(Container.AmountIncome *
                                             CASE WHEN MovementBoolean_PriceWithVAT.ValueData THEN MIFloat_Price.ValueData
                                             ELSE (MIFloat_Price.ValueData * (1 + ObjectFloat_NDSKind_NDS.ValueData / 100)) END, 2)) AS SummaIncome
                           FROM tmpIncomeId as Container

                                 -- закупочная цена
                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = Container.MI_Income
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                          ON MovementBoolean_PriceWithVAT.MovementId = Container.Movement_Income
                                                         AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()



                                LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                             ON MovementLinkObject_NDSKind.MovementId = Container.Movement_Income
                                                            AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                     ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                           GROUP BY Container.UnitID
                                  , Container.GoodsId
                           HAVING SUM (Container.AmountIncome) <> 0)
                           
        SELECT tmpUnit.UnitId                                                    AS UnitID
             , Object_Unit.ObjectCode                                            AS UnitCode
             , Object_Unit.ValueData                                             AS UnitName
             , _tmpGoods.ID                                                      AS GoodsID
             , _tmpGoods.ObjectCode                                              AS GoodsCode
             , _tmpGoods.Name                                                    AS GoodsName
             , tmpRealization.SummaSale ::TFloat                                 AS SummaSale
             , tmpRealization.AmountSale ::TFloat                                AS AmountSale
             , tmpRealization.SummChangePercent ::TFloat                         AS SummChangePercent
             , tmpIncome.SummaIncome ::TFloat                                    AS SummaIncome
             , tmpIncome.AmountIncome ::TFloat                                   AS AmountIncome

             , (COALESCE(tmpRealization.SummaSale, 0) - COALESCE(tmpIncome.SummaIncome, 0)) ::TFloat AS SummaProfit

             , tmpRemains.Saldo::TFloat                                          AS Remains
             , tmpRemains.SaldoSum::TFloat                                       AS RemainsSum

        FROM tmpUnit

             INNER JOIN _tmpGoods ON 1 = 1

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.UnitId

             LEFT JOIN tmpRealization ON tmpRealization.UnitID = Object_Unit.Id
                                     AND tmpRealization.GoodsID = _tmpGoods.Id

             LEFT JOIN tmpIncome ON tmpIncome.UnitID = Object_Unit.Id
                                 AND tmpIncome.GoodsID = _tmpGoods.Id

             LEFT JOIN tmpRemains ON tmpRemains.UnitID = Object_Unit.Id
                                 AND tmpRemains.GoodsID = _tmpGoods.Id

        WHERE tmpRealization.AmountSale <> 0
           OR tmpIncome.AmountIncome <> 0
           OR tmpRemains.Saldo <> 0
        ORDER BY tmpUnit.UnitId;

--     raise notice 'Value 05: %', (SELECT Count(*) FROM _tmpGoods);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 22.03.20                                                      *
*/

-- тест
-- select * from gpSelect_GeneralMovementGoods(inDateStart := ('01.03.2020')::TDateTime , inDateFinal := ('23.03.2020')::TDateTime , inUnitID := 377610 , inGoodsID := 13736002, inCodeSearch := '' , inGoodsSearch := 'маска защи' ,  inSession := '3');

select * from gpSelect_GeneralMovementGoods(('01.11.2022')::TDateTime , ('08.12.2022')::TDateTime , 0 , 19456 , '' , '' , False, False, False,  '3');