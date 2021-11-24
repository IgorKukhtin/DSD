 -- Function: gpSelect_ListDiffFormVIPSendRemain()

DROP FUNCTION IF EXISTS gpSelect_ListDiffFormVIPSendRemain (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ListDiffFormVIPSendRemain(
    IN inUnitId      Integer,       -- Аптека
    IN inGoodsId     Integer,       -- Товар
    IN inAmountDiff  TFloat,        -- Количество
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId         Integer
             , UnitCode       Integer
             , UnitName       TVarChar
             , Price          TFloat
             , Remains        TFloat
             , Reserve        TFloat
             , ReserveSend    TFloat
             , Amount         TFloat
             , MCSValue       TFloat
             , Layout         TFloat
             , AmountSend     TFloat
             , ExpirationDate TDateTime
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
      WITH tmpUnit AS (SELECT Object_Unit.Id
                       FROM Object AS Object_Unit
                            INNER JOIN ObjectBoolean AS ObjectBoolean_ParticipDistribListDiff
                                                     ON ObjectBoolean_ParticipDistribListDiff.ObjectId = Object_Unit.Id
                                                    AND ObjectBoolean_ParticipDistribListDiff.DescId = zc_ObjectBoolean_Unit_ParticipDistribListDiff()
                                                    AND ObjectBoolean_ParticipDistribListDiff.ValueData = True
                       WHERE Object_Unit.DescId = zc_Object_Unit()
                         AND Object_Unit.isErased = False
                         AND Object_Unit.Id <> inUnitId
                       ),
           tmpContainerPD AS (SELECT Container.ParentId
                                   , MIN(ObjectDate_ExpirationDate.ValueData)     AS ExpirationDate
                              FROM Container

                                   LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                                                
                                   LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                        ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                       AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()                                                                

                              WHERE Container.DescId = zc_Container_CountPartionDate()
                                AND Container.Amount <> 0
                                AND Container.ObjectId = inGoodsId
                                AND Container.WhereObjectId IN (SELECT tmpUnit.Id FROM tmpUnit)
                              GROUP BY Container.ParentId
                              HAVING SUM(Container.Amount) > 0
                             ),
           tmpContainer AS (SELECT Container.ObjectId
                                 , Container.WhereObjectId
                                 , SUM(Container.Amount)                       AS Amount
                                 , MIN(COALESCE (tmpContainerPD.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd()))::TDateTime AS ExpirationDate
                            FROM Container

                                 -- находим срок годности для партийного товара
                                 LEFT JOIN tmpContainerPD ON tmpContainerPD.ParentId = Container.Id

                                 -- находим срок годности из прихода
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
                                 LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                                 LEFT JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                             ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id) :: Integer
                                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                 LEFT JOIN Movement AS Movement_Income
                                                    ON Movement_Income.Id = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) :: Integer
                                 
                            WHERE Container.DescId = zc_Container_Count()
                              AND Container.Amount <> 0
                              AND Container.ObjectId = inGoodsId
                              AND Container.WhereObjectId IN (SELECT tmpUnit.Id FROM tmpUnit)
                              AND Movement_Income.OperDate < CURRENT_DATE - INTERVAL '30 DAY'
                            GROUP BY Container.ObjectId, Container.WhereObjectId
                            HAVING SUM(Container.Amount) > 0
                           ),
           tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                             AND ObjectFloat_Goods_Price.ValueData > 0
                                            THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                            ELSE ROUND (Price_Value.ValueData, 2)
                                       END :: TFloat                           AS Price
                                     , MCS_Value.ValueData                     AS MCSValue
                                     , Price_Goods.ChildObjectId               AS GoodsId
                                     , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                                FROM ObjectLink AS Price_Goods
                                   LEFT JOIN ObjectLink AS ObjectLink_Price_Unit
                                                        ON ObjectLink_Price_Unit.ObjectId = Price_Goods.ObjectId
                                                       AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
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
                                WHERE Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                  AND Price_Goods.ChildObjectId = inGoodsId
                                ),
           tmpLayoutMovement AS (SELECT Movement.Id                                             AS Id
                                      , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE) AS isPharmacyItem
                                 FROM Movement
                                      LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                                ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                               AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                                 WHERE Movement.DescId = zc_Movement_Layout()
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                ),
           tmpLayout AS (SELECT Movement.ID                        AS Id
                              , MovementItem.ObjectId              AS GoodsId
                              , MovementItem.Amount                AS Amount
                              , Movement.isPharmacyItem            AS isPharmacyItem
                         FROM tmpLayoutMovement AS Movement
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                                                     AND MovementItem.Amount > 0
                         WHERE MovementItem.ObjectId = inGoodsId
                        ),
          tmpLayoutUnit AS (SELECT Movement.ID                        AS Id
                                 , MovementItem.ObjectId              AS UnitId
                            FROM tmpLayoutMovement AS Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Child()
                                                        AND MovementItem.isErased = FALSE
                                                        AND MovementItem.Amount > 0
                           ),
                               
          tmpLayoutUnitCount AS (SELECT tmpLayoutUnit.ID                  AS Id
                                      , count(*)                          AS CountUnit
                                 FROM tmpLayoutUnit
                                 GROUP BY tmpLayoutUnit.ID
                                 ),
          tmpLayoutAll AS (SELECT tmpLayout.GoodsId                  AS GoodsId
                                , tmpUnit.Id                         AS UnitId
                                , MAX(tmpLayout.Amount)              AS Amount
                           FROM tmpLayout
                           
                                INNER JOIN tmpUnit ON 1 = 1
                                
                                LEFT JOIN ObjectBoolean AS Unit_PharmacyItem
                                                        ON Unit_PharmacyItem.ObjectId  = tmpUnit.Id
                                                       AND Unit_PharmacyItem.DescId    = zc_ObjectBoolean_Unit_PharmacyItem()
                                 
                                LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                       AND tmpLayoutUnit.UnitId = tmpUnit.Id

                                LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id
                                 
                           WHERE (tmpLayoutUnit.UnitId = tmpUnit.Id OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) = 0)
                             AND (COALESCE (Unit_PharmacyItem.ValueData, False) = False OR tmpLayout.isPharmacyItem = True)
                           GROUP BY tmpLayout.GoodsId
                                  , tmpUnit.Id 
                           )
          -- Отложенные перемещения
         , tmpMovementID AS (SELECT
                                  Movement.Id
                                , Movement.DescId
                           FROM Movement
                           WHERE Movement.DescId IN (zc_Movement_Send(), zc_Movement_Check())
                            AND Movement.StatusId = zc_Enum_Status_UnComplete()
                            AND Movement.OperDate >= CURRENT_DATE - INTERVAL '1 MONTH'
                         )
         , tmpMovementSend AS (SELECT
                                    Movement.Id
                                  , MovementLinkObject_From.ObjectId AS UnitId
                             FROM tmpMovementID AS Movement

                                  INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                  LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                             ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

                             WHERE Movement.DescId = zc_Movement_Send()
                               AND COALESCE(MovementBoolean_Deferred.ValueData, FALSE) = FALSE

                             )
         , tmpSend AS (SELECT
                                    Movement.UnitId
                                  , SUM(MovementItem.Amount) AS Amount
                             FROM tmpMovementSend AS Movement

                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId = zc_MI_Master()
                                                         AND MovementItem.isErased = FALSE
                                                         AND MovementItem.ObjectId = inGoodsId

                             GROUP BY Movement.UnitId
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
                                 ,  MovementLinkObject_Unit.ObjectId AS UnitId
                             FROM tmpMovReserveAll AS Movement
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                             )
       , tmpReserve AS (SELECT Movement.UnitId
                             , SUM(MovementItem.Amount)  AS Amount
                        FROM tmpMovReserveId AS Movement

                             INNER JOIN MovementItem AS MovementItem
                                                     ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                                                    AND MovementItem.ObjectId   = inGoodsId

                        GROUP BY Movement.UnitId
                        )
                           
        SELECT Container.WhereObjectId                               AS UnitId
             , Object_Unit.ObjectCode                                AS UnitCode
             , Object_Unit.ValueData                                 AS UnitName

             , COALESCE(tmpObject_Price.Price,0)::TFloat             AS Price
             , Container.Amount::TFloat                              AS Remains
             , tmpReserve.Amount::TFloat                             AS Reserve
             , tmpSend.Amount::TFloat                                AS ReserveSend
             
             , FLOOR(Container.Amount - 
                COALESCE (tmpObject_Price.MCSValue, 0) - 
                COALESCE (tmpLayoutAll.Amount, 0) - 
                COALESCE (tmpReserve.Amount, 0) - 
                COALESCE (tmpSend.Amount, 0))::TFloat          AS Amount
                
             , tmpObject_Price.MCSValue                              AS MCSValue 
             , tmpLayoutAll.Amount::TFloat                           AS Layout 
             
             , CASE WHEN FLOOR(Container.Amount - COALESCE (tmpObject_Price.MCSValue, 0) - 
                         COALESCE (tmpLayoutAll.Amount, 0) - 
                         COALESCE (tmpReserve.Amount, 0) - 
                         COALESCE (tmpSend.Amount, 0)) > inAmountDiff 
                    THEN inAmountDiff
                    ELSE FLOOR(Container.Amount - COALESCE (tmpObject_Price.MCSValue, 0) - 
                         COALESCE (tmpLayoutAll.Amount, 0) - 
                         COALESCE (tmpReserve.Amount, 0) - 
                         COALESCE (tmpSend.Amount, 0)) END::TFloat AS AmountSend
                         
             , Container.ExpirationDate

        FROM tmpContainer AS Container

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Container.WhereObjectId

            LEFT JOIN tmpObject_Price ON tmpObject_Price.UnitId = Container.WhereObjectId
            
            LEFT JOIN tmpLayoutAll ON tmpLayoutAll.UnitId = Container.WhereObjectId
            
            LEFT JOIN tmpReserve ON tmpReserve.UnitId = Container.WhereObjectId
            
            LEFT JOIN tmpSend ON tmpSend.UnitId = Container.WhereObjectId
            
        WHERE FLOOR(Container.Amount - 
                    COALESCE (tmpObject_Price.MCSValue, 0) - 
                    COALESCE (tmpLayoutAll.Amount, 0) - 
                    COALESCE (tmpReserve.Amount, 0) - 
                    COALESCE (tmpSend.Amount, 0)) > 0

         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 28.07.21                                                      *
*/

--ТЕСТ
-- select * from gpSelect_ListDiffFormVIPSendRemain(inUnitId := 16001195 , inGoodsId := 40999 , inAmountDiff := 1 ,  inSession := '3');
-- select * from gpSelect_ListDiffFormVIPSendRemain(inUnitId := 8393158 , inGoodsId := 8563 , inAmountDiff := 1 ,  inSession := '3');

select * from gpSelect_ListDiffFormVIPSendRemain(inUnitId := 377595 , inGoodsId := 48355 , inAmountDiff := 1 ,  inSession := '3');