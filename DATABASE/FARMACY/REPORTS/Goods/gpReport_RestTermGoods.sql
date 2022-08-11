-- Function: gpReport_StockTiming_Remainder()

DROP FUNCTION IF EXISTS gpReport_RestTermGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_RestTermGoods(
    IN inUnitID       Integer,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE ( PartionDateKindCode        Integer      --Производитель
              , PartionDateKindName        TVarChar     --Наименование производителя
              , UnitCode                   Integer      --Код подразделение откуда
              , UnitName                   TVarChar     --Наименование подразделение откуда
              , GoodsCode                  Integer      --Код товара
              , GoodsName                  TVarChar     --Наименование товара
              , Price                      TFloat
              , Amount                     TFloat
              , Summa                      TFloat
              , ExpirationDate             TDateTime    --Срок годности
              )

AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- значения для разделения по срокам
     SELECT Date_6, Date_3, Date_1, Date_0
     INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
     FROM lpSelect_PartionDateKind_SetDate ();

     RETURN QUERY
     WITH
          tmpUnit AS (SELECT DISTINCT MovementLinkObject_Unit.ObjectId   AS UnitId
                      FROM Movement

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    

                      WHERE Movement.DescId         = zc_Movement_Check()
                        AND Movement.OperDate > CURRENT_DATE - INTERVAL '14 DAY')

      , tmpContainerAll AS (SELECT Container.Id                                                AS ContainerId,
                                   Container.ParentId                                          AS ParentId,
                                   Container.WhereObjectId                                     AS UnitId,
                                   Container.ObjectId                                          AS GoodsId,
                                   Container.Amount                                            AS Amount
                            FROM Container
                            
                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND (Container.WhereObjectId  = inUnitID OR COALESCE(inUnitID, 0) = 0)
                              AND Container.WhereObjectId in (SELECT tmpUnit.UnitId FROM tmpUnit)
                              AND Container.Amount > 0
                           )
      , tmpContainer AS (SELECT Container.ContainerId                    AS ContainerId,
                                Container.ParentId                       AS ParentId, 
                                Container.UnitId                         AS UnitId,
                                Container.GoodsId                        AS GoodsId,
                                Container.Amount                         AS Amount,
                                ObjectDate_ExpirationDate.ValueData      AS ExpirationDate,
                                CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                          COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                           THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                     WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                     WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                     WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 1 месяца
                                     WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                     ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен с просрочки
                         FROM tmpContainerAll AS Container

                              INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.ContainerId
                                                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                                          
                              INNER JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                    ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId    
                                                   AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                              LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                      ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId 
                                                     AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()
                                                     
                         )
      ,   tmpMovementItemSum AS (SELECT Container.UnitId,
                                        Container.GoodsId,
                                        SUM(Container.Amount)                                                  AS Amount,
                                        Container.PartionDateKindId,
                                        Container.ExpirationDate                                               AS ExpirationDate
                                 FROM tmpContainer AS Container
                                 GROUP BY Container.UnitId,
                                          Container.GoodsId,
                                          Container.PartionDateKindId,
                                          Container.ExpirationDate 
                                 )
      , tmpPrice AS (SELECT DISTINCT
                            CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                  AND ObjectFloat_Goods_Price.ValueData > 0
                                 THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                 ELSE ROUND (Price_Value.ValueData, 2)
                            END :: TFloat                           AS Price
                          , GoodsData.GoodsId                       AS GoodsId
                          , GoodsData.UnitId                        AS UnitId
                     FROM (SELECT DISTINCT tmpMovementItemSum.UnitId, tmpMovementItemSum.GoodsId FROM tmpMovementItemSum) AS GoodsData

                        INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                              ON ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                             AND ObjectLink_Price_Unit.ChildObjectId = GoodsData.UnitId
                        INNER JOIN ObjectLink AS Price_Goods
                                              ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                             AND Price_Goods.ChildObjectId = GoodsData.GoodsId

                        LEFT JOIN ObjectFloat AS Price_Value
                                              ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND Price_Value.DescId = zc_ObjectFloat_Price_Value()

                        -- Фикс цена для всей Сети
                        LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                               ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                              AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                               AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                     )
      , tmpContainerOk AS (SELECT Container.WhereObjectId                     AS UnitId,
                                  Container.ObjectId                          AS GoodsId,
                                  Sum(Container.Amount) - ContainerPD.Amount  AS Amount
                           FROM (SELECT tmpMovementItemSum.UnitId, tmpMovementItemSum.GoodsId, Sum(tmpMovementItemSum.Amount) AS Amount 
                                 FROM tmpMovementItemSum
                                 GROUP BY tmpMovementItemSum.UnitId, tmpMovementItemSum.GoodsId) AS ContainerPD

                                INNER JOIN Container ON Container.WhereObjectId = ContainerPD.UnitId 
                                                    AND Container.ObjectId = ContainerPD.GoodsId 
                                                    AND Container.DescId = zc_Container_Count()
                                                    AND Container.Amount > 0
                                                       
                           GROUP BY Container.WhereObjectId,
                                    Container.ObjectId,
                                    ContainerPD.Amount  
                           HAVING Sum(Container.Amount) - ContainerPD.Amount  > 0                                                        
                           )

     SELECT

           Object_PartionDateKind.ObjectCode,
           Object_PartionDateKind.ValueData,
           Object_Unit.ObjectCode,
           Object_Unit.ValueData,
           Object_Goods.ObjectCode,
           Object_Goods.ValueData,

           Round(tmpPrice.Price, 2)::TFloat ,

           Movement.Amount::TFloat,
           ROUND(tmpPrice.Price * Movement.Amount , 2)::TFloat ,

           DATE_TRUNC ('DAY', Movement.ExpirationDate)::TDateTime

     FROM tmpMovementItemSum AS Movement

          LEFT JOIN Object AS Object_Unit
                           ON Object_Unit.ID = Movement.UnitId

          LEFT JOIN Object AS Object_Goods
                           ON Object_Goods.ID = Movement.GoodsId

          LEFT JOIN Object AS Object_PartionDateKind
                           ON Object_PartionDateKind.ID = Movement.PartionDateKindId
                           
          LEFT JOIN tmpPrice ON tmpPrice.UnitId = Movement.UnitId
                            AND tmpPrice.GoodsId = Movement.GoodsId
     UNION ALL
     SELECT

           Null::Integer,
           Null::TVarChar,
           Object_Unit.ObjectCode,
           Object_Unit.ValueData,
           Object_Goods.ObjectCode,
           Object_Goods.ValueData,

           Round(tmpPrice.Price, 2)::TFloat ,

           Movement.Amount::TFloat,
           ROUND(tmpPrice.Price * Movement.Amount , 2)::TFloat ,

           Null::TDateTime

     FROM tmpContainerOk AS Movement

          LEFT JOIN Object AS Object_Unit
                           ON Object_Unit.ID = Movement.UnitId

          LEFT JOIN Object AS Object_Goods
                           ON Object_Goods.ID = Movement.GoodsId

          LEFT JOIN tmpPrice ON tmpPrice.UnitId = Movement.UnitId
                            AND tmpPrice.GoodsId = Movement.GoodsId
     ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.08.22                                                       *
*/

-- тест

select * from gpReport_RestTermGoods(inUnitId := 375627 ,  inSession := '3');