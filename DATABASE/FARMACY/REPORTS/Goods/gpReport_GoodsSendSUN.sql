 -- Function: gpReport_GoodsSendSUN()

DROP FUNCTION IF EXISTS gpReport_GoodsSendSUN (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsSendSUN (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsSendSUN(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inGoodsId          Integer  ,  -- товар
    --IN inisSendDefSUN     Boolean,    -- Отложенное Перемещение по СУН (да / нет)
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate  TDateTime
             , InvNumber TVarChar
             , StatusCode Integer
             , FromName  TVarChar
             , ToName  TVarChar
             , PartionDateKindName TVarChar
             , GoodsCode  Integer
             , GoodsName  TVarChar
             , GoodsGroupName  TVarChar
             --, Amount TFloat
             , Amount_Def TFloat
             , Amount_Del TFloat
             , Amount_unComp TFloat
             , Amount_Comp TFloat
             , ExpirationDate      TDateTime
             , OperDate_Income     TDateTime
             , Invnumber_Income    TVarChar
             , FromName_Income     TVarChar
             , ContractName_Income TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH 
     tmpMovement AS (SELECT Movement.*
                          , MovementLinkObject_To.ObjectId              AS ToId
                          , MovementLinkObject_From.ObjectId            AS FromId
                          , MovementLinkObject_PartionDateKind.ObjectId AS PartionDateKindId
                          , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     AS isSUN
                          , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)  AS isDefSUN
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                       AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId =0)

                          LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()

                          LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                                    ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                                   AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
 
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                          LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                       ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                                      AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                          LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId
                     WHERE Movement.DescId = zc_Movement_Send()
                  -- AND Movement.StatusId = zc_Enum_Status_Complete()
                     AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                     AND (COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE OR COALESCE (MovementBoolean_DefSUN.ValueData, FALSE) = TRUE)
                     )

   , tmpMI_Master AS (SELECT MovementItem.*
                      FROM tmpMovement AS Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                                                  AND (MovementItem.ObjectId   = inGoodsId OR inGoodsId = 0)
                      )

   , tmpMI_Child AS (SELECT MovementItem.*
                     FROM tmpMI_Master
                          INNER JOIN MovementItem ON MovementItem.ParentId   = tmpMI_Master.Id
                                                 AND MovementItem.MovementId = tmpMI_Master.MovementId
                                                 AND MovementItem.DescId   = zc_MI_Child()
                                                 AND MovementItem.isErased = FALSE                       
                     )

   , tmpMIFloat_ContainerId AS (SELECT MovementItemFloat.MovementItemId
                                     , MovementItemFloat.ValueData :: Integer AS ContainerId
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Child.Id FROM tmpMI_Child WHERE tmpMI_Child.IsErased = FALSE)
                                  AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                )

   , tmpContainer AS (SELECT tmp.ContainerId
                           , tmp.MovementItemId
                           , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                           , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                      FROM tmpMIFloat_ContainerId AS tmp
                           LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                         ON ContainerLinkObject_MovementItem.Containerid = tmp.ContainerId
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
                                      
                           LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                             ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                     )
    --
   , tmpPartion AS (SELECT Movement.Id
                         , MovementDate_Branch.ValueData AS BranchDate
                         , Movement.Invnumber            AS Invnumber
                         , Object_From.ValueData         AS FromName
                         , Object_Contract.ValueData     AS ContractName
                    FROM Movement
                         LEFT JOIN MovementDate AS MovementDate_Branch
                                                ON MovementDate_Branch.MovementId = Movement.Id
                                               AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                         LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                    WHERE Movement.Id IN (SELECT DISTINCT tmpContainer.MovementId_Income FROM tmpContainer)
                    )

      SELECT Movement.OperDate
           , Movement.InvNumber
           , Object_Status.ObjectCode                       AS StatusCode

           , Object_From.ValueData                          AS FromName
           , Object_To.ValueData                            AS ToName
           , Object_PartionDateKind.ValueData               AS PartionDateKindName

           , Object_Goods.ObjectCode           :: Integer   AS GoodsCode
           , Object_Goods.ValueData                         AS GoodsName
           , Object_GoodsGroup.ValueData                    AS GoodsGroupName
           -- 1) признак DefSUN = true - значит перемещение отложено
           , CASE WHEN Movement.isDefSUN = TRUE THEN tmpMI_Master.Amount ELSE 0 END  ::TFloat AS Amount_Def
           -- 2) статус удален - значит создан
           , CASE WHEN Movement.isDefSUN = FALSE AND Movement.StatusId = zc_Enum_Status_Erased() THEN tmpMI_Master.Amount ELSE 0 END ::TFloat AS Amount_Del
           -- 3) стат не провед - значит "в работе"
           , CASE WHEN Movement.isDefSUN = FALSE AND Movement.StatusId = zc_Enum_Status_UnComplete() THEN tmpMI_Master.Amount ELSE 0 END ::TFloat AS Amount_unComp
           -- 4) стат "проведен" - знач. перемещение  прошло
           , CASE WHEN Movement.isDefSUN = FALSE AND Movement.StatusId = zc_Enum_Status_Complete() THEN tmpMI_Master.Amount ELSE 0 END ::TFloat AS Amount_Comp

           , COALESCE (tmpContainer.ExpirationDate, NULL)      :: TDateTime AS ExpirationDate
           , COALESCE (tmpPartion.BranchDate, NULL)            :: TDateTime AS OperDate_Income
           , COALESCE (tmpPartion.Invnumber, NULL)             :: TVarChar  AS Invnumber_Income
           , COALESCE (tmpPartion.FromName, NULL)              :: TVarChar  AS FromName_Income
           , COALESCE (tmpPartion.ContractName, NULL)          :: TVarChar  AS ContractName_Income
           
      FROM tmpMI_Master
           LEFT JOIN tmpMovement AS Movement          ON Movement.Id               = tmpMI_Master.MovementId
           LEFT JOIN Object AS Object_Status          ON Object_Status.Id          = Movement.StatusId
           LEFT JOIN Object AS Object_Goods           ON Object_Goods.Id           = tmpMI_Master.ObjectId
           LEFT JOIN Object AS Object_From            ON Object_From.Id            = Movement.FromId
           LEFT JOIN Object AS Object_To              ON Object_To.Id              = Movement.ToId
           LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = Movement.PartionDateKindId
              
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpMI_Master.ObjectId
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

           LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId   = tmpMI_Master.Id
                                AND tmpMI_Child.MovementId = tmpMI_Master.MovementId

           LEFT JOIN tmpMIFloat_ContainerId AS MIFloat_ContainerId
                                            ON MIFloat_ContainerId.MovementItemId = tmpMI_Child.Id
           LEFT JOIN tmpContainer ON tmpContainer.ContainerId = MIFloat_ContainerId.ContainerId
           LEFT JOIN tmpPartion ON tmpPartion.Id= tmpContainer.MovementId_Income
     ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.07.19         *
*/

-- тест
--