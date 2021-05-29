-- Function: gpReport_SalesGoods_SUA()

DROP FUNCTION IF EXISTS gpReport_SalesGoods_SUA (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SalesGoods_SUA(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Двта конца
    IN inUnitId           Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer
             , UnitName TVarChar
             , GoodsCode Integer
             , GoodsName TVarChar

             , AmountSend TFloat
             , AmountIncome TFloat

             , AmountCheck TFloat
             , SummaCheck TFloat

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
    WITH tmpMovementSend AS (SELECT Movement.id
                                  , Movement.OperDate
                                  , MovementLinkObject_To.ObjectId  AS UnitID
                             FROM Movement
                                  INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                             ON MovementBoolean_SUN.MovementId = Movement.Id
                                                            AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                            AND MovementBoolean_SUN.ValueData = True

                                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                               AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId = 0)

                                  LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                                            ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                                           AND MovementBoolean_SUN_v2.DescId = zc_MovementBoolean_SUN_v2()
                                  LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                                            ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                                           AND MovementBoolean_SUN_v3.DescId = zc_MovementBoolean_SUN_v3()

                                  LEFT JOIN MovementString AS MovementString_Comment
                                                           ON MovementString_Comment.MovementId = Movement.Id
                                                          AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                                          
                             WHERE Movement.DescId = zc_Movement_Send()
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = FALSE
                               AND COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE) = FALSE
                               AND MovementLinkObject_To.ObjectId <> 11299914
                               AND COALESCE (MovementString_Comment.ValueData,'') = 'Товар по СУА')

         , tmpMovementContainerSendAll  AS (SELECT Movement.UnitId
                                                 , Movement.OperDate
                                                 , Container.ObjectId                     AS GoodsId
                                                 , MovementItemContainer.ContainerID
                                                 , Sum(MovementItemContainer.Amount)     AS Amount
                                            FROM tmpMovementSend AS Movement

                                                 INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.ID
                                                                                 AND MovementItemContainer.isActive = True

                                                 INNER JOIN Container ON  Container.DescId = zc_Container_Count()
                                                                     AND  Container.ID = MovementItemContainer.ContainerID

                                                 LEFT JOIN MovementItemContainer AS MIIncome
                                                                                 ON MIIncome.ContainerID = MovementItemContainer.ContainerID
                                                                                 AND MIIncome.MovementDescId = zc_Movement_Income()
                                            WHERE COALESCE (MIIncome.Id, 0) = 0
                                            GROUP BY Movement.UnitId
                                                   , Movement.OperDate
                                                   , Container.ObjectId
                                                   , MovementItemContainer.ContainerID)

         , tmpMovementContainerSend  AS (SELECT Movement.UnitId
                                              , Movement.OperDate
                                              , Movement.GoodsId  
                                              , Sum(Movement.Amount)         AS Amount
                                         FROM tmpMovementContainerSendAll AS Movement
                                         GROUP BY Movement.UnitId
                                                , Movement.OperDate
                                                , Movement.GoodsId
                                         )

            -- приходы
           , tmpFinalSUA AS (SELECT Movement.id
                                 , MovementDate_Calculation.ValueData AS OperDate
                            FROM Movement
                                 INNER JOIN MovementDate AS MovementDate_Calculation
                                                         ON MovementDate_Calculation.MovementId = Movement.Id
                                                        AND MovementDate_Calculation.DescId = zc_MovementDate_Calculation()
                            WHERE Movement.DescId = zc_Movement_FinalSUA()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           )
           , tmpMIFinalSUA AS (SELECT tmpFinalSUA.Id
                                    , tmpFinalSUA.OperDate
                                    , MILinkObject_Unit.ObjectId              AS UnitId
                                    , MovementItem.MovementID                 AS MovementID
                                    , MovementItem.ObjectId                   AS GoodsId
                               FROM MovementItem
                                     
                                    INNER JOIN tmpFinalSUA ON tmpFinalSUA.Id = MovementItem.MovementId 

                                    INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                      ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                     AND (MILinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)

                                    LEFT JOIN MovementItemFloat AS MIFloat_SendSUN
                                                                ON MIFloat_SendSUN.MovementItemId = MovementItem.Id
                                                               AND MIFloat_SendSUN.DescId = zc_MIFloat_SendSUN()

                               WHERE MovementItem.MovementId in (SELECT tmpFinalSUA.Id FROM tmpFinalSUA)
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.isErased = False
                                 AND MovementItem.Amount - COALESCE(MIFloat_SendSUN.ValueData, 0) > 0
                               )
           , tmpMovementOI AS (SELECT Movement.id
                                    , Movement.OperDate
                                    , MovementLinkObject_Unit.ObjectId AS UnitId
                                    , MLM_Master.MovementId            AS MovementOEId
                               FROM (SELECT DISTINCT tmpMIFinalSUA.OperDate, tmpMIFinalSUA.UnitId  FROM tmpMIFinalSUA) AS tmpMIFinalSUA 
                                     
                                    INNER JOIN Movement ON Movement.OperDate = tmpMIFinalSUA.OperDate
                                                       AND Movement.DescId = zc_Movement_OrderInternal() 
                                                       AND Movement.StatusId = zc_Enum_Status_Complete() 
                                          
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                 AND  MovementLinkObject_Unit.ObjectId = tmpMIFinalSUA.UnitId
                                                                       
                                    INNER JOIN MovementLinkMovement AS MLM_Master
                                                                    ON MLM_Master.MovementChildId = Movement.Id
                                                                   AND MLM_Master.DescId = zc_MovementLinkMovement_Master()

                               WHERE Movement.OperDate >= '01.02.2021'
                                 AND Movement.DescId = zc_Movement_OrderInternal() 
                                 AND Movement.StatusId = zc_Enum_Status_Complete() 
                               )
          , tmpMovementItemOI AS (SELECT Movement.id
                                       , Movement.UnitId
                                       , Movement.MovementOEId
                                       , MLM_Order.MovementId         AS MovementIncomeID
                                       , MovementItem.Id              AS MovementItemId 
                                       , MovementItem.ObjectId        AS GoodsId
                                       , MovementItemFloat.ValueData  AS AmountSUA 
                                  FROM tmpMovementOI AS Movement
                                               
                                       INNER JOIN tmpMIFinalSUA ON tmpMIFinalSUA.UnitId = Movement.UnitId
                                                               AND tmpMIFinalSUA.OperDate = Movement.OperDate
                                                                      
                                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.ID
                                                              AND MovementItem.DescId = zc_MI_Master()
                                                              AND MovementItem.isErased   = FALSE
                                                              AND MovementItem.ObjectId = tmpMIFinalSUA.GoodsId 
                                                              AND MovementItem.Amount > 0
                                               
                                       INNER JOIN MovementLinkMovement AS MLM_Order
                                                                       ON MLM_Order.MovementChildId = Movement.MovementOEId
                                                                      AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                                                                            
                                       INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = Movement.Id
                                                                   AND MovementItemFloat.DescId = zc_MIFloat_AmountSUA()
                                   )
         , tmpMovementContainerIncomeAll AS (SELECT Movement.UnitId
                                                  , Movement.MovementIncomeID
                                                  , MovementItem.ObjectId                  AS GoodsId
                                                  , MovementItemContainer.ContainerID
                                                  , MovementItemContainer.Amount           AS Amount
                                                  , Movement.AmountSUA
                                                  
                                             FROM tmpMovementItemOI AS Movement

                                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.MovementIncomeID
                                                                         AND MovementItem.ObjectId   = Movement.GoodsId 

                                                  LEFT JOIN MovementItemContainer ON MovementItemContainer.MovementId     = Movement.MovementIncomeID
                                                                                  AND MovementItemContainer.MovementItemId = MovementItem.ID
                                                                                  AND MovementItemContainer.DescId         = zc_MIContainer_Count()

                                             )
         , tmpMovementContainerIncome AS (SELECT Movement.UnitId
                                               , Movement.GoodsId 
                                               , Sum(Movement.Amount)             AS Amount                                                  
                                          FROM tmpMovementContainerIncomeAll AS Movement
                                          GROUP BY Movement.UnitId
                                                 , Movement.GoodsId   

                                             )
         -- Итоги 
         , tmpMovementContainer  AS (SELECT DISTINCT COALESCE(Movement.ContainerID, tmpMovementContainerIncomeAll.ContainerID) AS ContainerID
                                     FROM tmpMovementContainerSendAll AS Movement
                                     
                                          FULL JOIN tmpMovementContainerIncomeAll ON tmpMovementContainerIncomeAll.ContainerID = Movement.ContainerID
                                     )

         , tmpContainerCheckAll  AS (SELECT MovementItemContainer.ContainerId
                                        , MovementItemContainer.WhereObjectId_Analyzer AS UnitId
                                        , MovementItemContainer.ObjectId_Analyzer       AS GoodsId
                                        , (-1 * MovementItemContainer.Amount)::TFloat                                         AS AmountCheck
                                        , ROUND(-1 * MovementItemContainer.Amount * MovementItemContainer.Price, 2)::TFloat   AS SummaCheck

                                   FROM tmpMovementContainer AS Container

                                        INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.ContainerID
                                                                        AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                                                                        AND MovementItemContainer.Amount <> 0
                                                                        AND MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                                                        AND MovementItemContainer.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                                   )
                                       
       , tmpContainerCheck  AS (SELECT Container.UnitId
                                     , Container.GoodsId
                                     , Sum(Container.AmountCheck)::TFloat      AS AmountCheck
                                     , Sum(Container.SummaCheck)::TFloat       AS SummaCheck

                                FROM tmpContainerCheckAll AS Container

                                GROUP BY Container.UnitId
                                       , Container.GoodsId)
                                       


    SELECT Object_Unit.Id                                                      AS Id
         , Object_Unit.ValueData                                               AS UnitName
         , Object_Goods.ObjectCode
         , Object_Goods.ValueData

         , tmpMovementContainerSend.Amount::TFloat                             AS AmountSend
         , tmpMovementContainerIncome.Amount::TFloat                           AS AmountIncome

         , tmpContainerCheck.AmountCheck::TFloat                               AS AmountCheck
         , tmpContainerCheck.SummaCheck::TFloat                                AS SummaCheck

    FROM tmpContainerCheck 
    
         LEFT JOIN tmpMovementContainerSend ON tmpMovementContainerSend.UnitId = tmpContainerCheck.UnitId
                                           AND tmpMovementContainerSend.GoodsId = tmpContainerCheck.GoodsId

         LEFT JOIN tmpMovementContainerIncome ON tmpMovementContainerIncome.UnitId = tmpContainerCheck.UnitId
                                             AND tmpMovementContainerIncome.GoodsId = tmpContainerCheck.GoodsId

         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpContainerCheck.GoodsId
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpContainerCheck.UnitId

    WHERE COALESCE(tmpContainerCheck.AmountCheck, 0) <> 0 
    ORDER BY Object_Unit.ValueData, Object_Goods.objectcode
    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.05.21                                                       *
*/

-- тест 

select * from gpReport_SalesGoods_SUA(inStartDate := ('01.05.2021')::TDateTime , inEndDate := ('31.05.2021')::TDateTime , inUnitId := 0  ,  inSession := '3');