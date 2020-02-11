-- Function: gpReport_SendSUNDelay()

DROP FUNCTION IF EXISTS gpReport_SendSUNDelay (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SendSUNDelay(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Двта конца
    IN inUnitId           Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (FromName TVarChar
             , ToName TVarChar
             , GoodsCode Integer
             , GoodsName TVarChar
             , Price TFloat
             , Amount TFloat
             , Summa TFloat

             , AmountSend TFloat
             , SummaSend TFloat
             , AmountDeferred TFloat
             , SummaDeferred TFloat
             , AmountComplete TFloat
             , SummaComplete TFloat
             , AmountLoss TFloat
             , SummaLoss TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH tmpMovement AS (SELECT Movement.id
                              , MovementLinkObject_From.ObjectId  AS UnitID
                         FROM Movement
                              INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                         ON MovementBoolean_SUN.MovementId = Movement.Id
                                                        AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                        AND MovementBoolean_SUN.ValueData = True

                               INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                            AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId = 0)
                         WHERE Movement.DescId = zc_Movement_Send()
                           AND Movement.StatusId = zc_Enum_Status_Complete())

       , tmpMovementDelay AS (SELECT Movement.id
                                   , MovementLinkObject_From.ObjectId  AS UnitID
                                   , Movement.StatusId
                                   , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean  AS isDeferred
                              FROM Movement

                                   INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                                 ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                                                AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                                                AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

                                   INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                   INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement.Id
                                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                AND MovementLinkObject_To.ObjectId = 11299914

                                   LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                             ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

                              WHERE Movement.DescId = zc_Movement_Send()
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
                                AND Movement.OperDate >= inStartDate
                                AND Movement.OperDate <= inEndDate)

       , tmpContainerDelay AS (SELECT Container.ParentId                         AS ContainerId
                                    , Sum(MovementItem_Child.Amount)             AS Amount
                                    , Sum(CASE WHEN Movement.StatusId <> zc_Enum_Status_Complete()
                                                AND Movement.isDeferred = True THEN MovementItem_Child.Amount END)                    AS AmountDeferred
                                    , Sum(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN MovementItem_Child.Amount END) AS AmountComplete
                               FROM tmpMovementDelay AS Movement

                                    INNER JOIN movementitem ON movementitem.movementid = Movement.Id
                                                           AND movementitem.amount > 0
                                                           AND MovementItem.DescId = zc_MI_Master()
                                                           AND movementitem.iserased = False

                                    INNER JOIN movementitem AS movementitem_Child
                                                            ON movementitem_Child.movementid = Movement.Id
                                                           AND movementitem_Child.parentid = movementitem.id
                                                           AND movementitem_Child.amount > 0
                                                           AND movementitem_Child.DescId = zc_MI_Child()
                                                           AND movementitem_Child.iserased = False

                                    INNER JOIN MovementItemFloat ON MovementItemFloat.movementitemid =  movementitem_Child.ID
                                                                AND MovementItemFloat.descid = zc_MIFloat_ContainerId()

                                    INNER JOIN Container ON  Container.Id = MovementItemFloat.ValueData::Integer

                               GROUP BY Container.ParentId)

       , tmpMovementContainer  AS (SELECT Movement.UnitId
                                        , MovementLinkObject_To.ObjectId     AS UnitToId
                                        , Container.ObjectId
                                        , MovementItemContainer.ContainerID
                                        , Sum(MovementItemContainer.Amount)  AS Amount
                                   FROM tmpMovement AS Movement

                                        INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.ID
                                                                        AND MovementItemContainer.isActive = True
                                        INNER JOIN Container ON  Container.DescId = zc_Container_Count()
                                                            AND  Container.ID = MovementItemContainer.ContainerID

                                         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                    GROUP BY Movement.UnitId
                                           , MovementLinkObject_To.ObjectId
                                           , Container.ObjectId
                                           , MovementItemContainer.ContainerID)

       , tmpContainerLoss  AS (SELECT MovementItemContainer.ContainerId
                                     , Sum(-1 * MovementItemContainer.Amount)::TFloat                                 AS AmountLoss

                                FROM tmpMovementContainer

                                     INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = tmpMovementContainer.ContainerID
                                                                     AND MovementItemContainer.MovementDescId = zc_Movement_Loss()
                                                                     AND MovementItemContainer.Amount <> 0
                                                                     AND MovementItemContainer.OperDate >= inStartDate
                                                                     AND MovementItemContainer.OperDate <= inEndDate
                                                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                                  ON MovementLinkObject_ArticleLoss.MovementId =  MovementItemContainer.MovementId
                                                                 AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()

                                GROUP BY MovementItemContainer.ContainerId)

       , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , Price_Goods.ChildObjectId               AS GoodsId
                             , ObjectLink_Price_Unit.ChildObjectId     AS UnitID
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
                          AND ObjectLink_Price_Unit.ChildObjectId in (SELECT DISTINCT tmpMovement.UnitId FROM tmpMovement)
                        )

    SELECT Object_From.ValueData                  AS FromName
         , Object_To.ValueData                    AS ToName
         , Object_Goods.objectcode
         , Object_Goods.valuedata
         , tmpObject_Price.Price
         , tmpMovementContainer.Amount::TFloat                                            AS Amount
         , Round(tmpMovementContainer.Amount * tmpObject_Price.Price, 2)::TFloat          AS Summa

         , tmpContainerDelay.Amount::TFloat                                               AS AmountSend
         , Round(tmpContainerDelay.Amount * tmpObject_Price.Price, 2)::TFloat             AS SummaSend
         , tmpContainerDelay.AmountDeferred::TFloat                                       AS AmountDeferred
         , Round(tmpContainerDelay.AmountDeferred * tmpObject_Price.Price, 2)::TFloat     AS SummaDeferred
         , tmpContainerDelay.AmountComplete::TFloat                                       AS AmountComplete
         , Round(tmpContainerDelay.AmountComplete * tmpObject_Price.Price, 2)::TFloat     AS SummaComplete

         , tmpContainerLoss.AmountLoss                                                    AS AmountLoss
         , Round(tmpContainerLoss.AmountLoss * tmpObject_Price.Price, 2)::TFloat          AS SummaLoss
    FROM tmpMovementContainer

         LEFT JOIN tmpContainerDelay ON tmpContainerDelay.ContainerId = tmpMovementContainer.ContainerID
         LEFT JOIN tmpContainerLoss ON tmpContainerLoss.ContainerId = tmpMovementContainer.ContainerID

         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMovementContainer.ObjectId
         LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovementContainer.UnitId
         LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMovementContainer.UnitToId

         LEFT JOIN tmpObject_Price ON tmpObject_Price.GoodsId = Object_Goods.Id
                                  AND tmpObject_Price.UnitId = tmpMovementContainer.UnitId
    WHERE COALESCE(tmpContainerDelay.Amount, 0) <> 0 OR COALESCE(tmpContainerLoss.AmountLoss, 0) <> 0
    ORDER BY Object_To.ValueData, Object_Goods.objectcode;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.02.20                                                       *
*/

-- тест select * from gpReport_SendSUNDelay(inStartDate := ('01.12.2015')::TDateTime , inEndDate := ('11.02.2020')::TDateTime , inUnitId := 0 ,  inSession := '3');