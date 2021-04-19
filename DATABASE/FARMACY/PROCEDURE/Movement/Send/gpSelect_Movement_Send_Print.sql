-- Function: gpSelect_Movement_Send_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Send_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Send_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitFromId Integer;
    DECLARE vbisDeferred Boolean;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= inSession;
     
    -- определяется подразделение
    SELECT MovementLinkObject_From.ObjectId
         , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean
  INTO vbUnitFromId
     , vbisDeferred
    FROM MovementLinkObject AS MovementLinkObject_From
        LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                  ON MovementBoolean_Deferred.MovementId = inMovementId
                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
    WHERE MovementLinkObject_From.MovementId = inMovementId
      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();

    OPEN Cursor1 FOR
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , Object_From.Id                                     AS FromId
           , Object_From.ValueData                              AS FromName
           , Object_To.Id                                       AS ToId
           , Object_To.ValueData                                AS ToName
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Send()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    WITH

           MovementItem_Send AS (SELECT MovementItem.Id
                                      , MovementItem.ObjectId
                                      , MovementItem.ParentId
                                 FROM MovementItem   
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND MovementItem.isErased = FALSE
                                )

         , tmpContainer AS (SELECT Container.Id
                                 , Container.ObjectId    AS GoodsId
                                 , Object_PartionMovementItem.ObjectCode ::Integer AS MI_Id
                            FROM (SELECT DISTINCT MovementItem_Send.ObjectId
                                  FROM MovementItem_Send) AS MovementItem_Send
                                   
                                INNER JOIN Container ON Container.ObjectId = MovementItem_Send.ObjectId
                                                    AND Container.DescId = zc_Container_Count()
                                                    AND Container.Amount <> 0
                                INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                               ON Container.Id = ContainerLinkObject_Unit.ContainerId 
                                                              AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit() 
                                                              AND ContainerLinkObject_Unit.ObjectId = vbUnitFromId
 
                                INNER JOIN ContainerLinkObject AS CLI_MI 
                                                               ON CLI_MI.ContainerId = Container.Id
                                                              AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                INNER JOIN OBJECT AS Object_PartionMovementItem 
                                                  ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                            GROUP BY Container.ObjectId
                                   , Object_PartionMovementItem.ObjectCode, Container.Id
                            )

         , tmpMinExpirationDate AS (SELECT tmpContainer.GoodsId
                                         , MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
                                    FROM tmpContainer
                                         INNER JOIN MovementItem ON MovementItem.Id = tmpContainer.MI_Id
                                         LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                                           ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                         -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                         LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                         -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                         LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                         LEFT JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MovementItem.Id) 
                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                     GROUP BY tmpContainer.GoodsId
                                    )

         , tmpMIContainerSend AS (SELECT COALESCE(MISend.ParentID, MIContainer_Count.MovementItemId) AS MovementItemId
                                       , COALESCE (MI_Income_find.Id,MovementItem.Id) AS MIIncomeId
                                  FROM MovementItemContainer AS MIContainer_Count
                                 
                                        -- элемент прихода
                                        LEFT OUTER JOIN MovementItem AS MISend
                                                                     ON MISend.Id = MIContainer_Count.MovementItemID
                                                                      
                                        LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                     ON CLI_MI.ContainerId = MIContainer_Count.ContainerId
                                                    AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                        LEFT OUTER JOIN Object AS Object_PartionMovementItem 
                                                     ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                        -- элемент прихода
                                        LEFT OUTER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode

                                        -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                        LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                               ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                              AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                        -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                        LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
       
                                  WHERE MIContainer_Count.MovementId = inMovementId 
                                    AND MIContainer_Count.DescId = zc_Container_Count()
                                    AND MIContainer_Count.isActive = NOT vbisDeferred
                                  )   

         , tmpMIContainer AS (SELECT MIContainer_Count.MovementItemId           AS MovementItemId
                                   , MIN (COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
                              FROM tmpMIContainerSend AS MIContainer_Count
                                   LEFT JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                               ON MIDate_ExpirationDate.MovementItemId = MIContainer_Count.MIIncomeId 
                                                              AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               GROUP BY MIContainer_Count.MovementItemId
                              )
                                 
      , tmpMI_Child AS (SELECT MI_Child.ParentId
                             , MIN(COALESCE (MI_Child.ExpirationDate, zc_DateEnd()))  AS ExpirationDate
                        FROM gpSelect_MovementItem_Send_Child(inMovementId := inMovementId,  inSession := inSession) AS MI_Child
                        GROUP BY MI_Child.ParentId
                       )

       SELECT
             MovementItem.Id                    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , Object_Measure.ValueData           AS MeasureName
           , MovementItem.Amount                AS Amount
           , Object_Accommodation.ValueData     AS AccommodationName
           , COALESCE (tmpMI_Child.ExpirationDate, tmpMIContainer.MinExpirationDate, tmpMinExpirationDate.MinExpirationDate, zc_DateEnd() )::TDateTime AS MinExpirationDate
       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT OUTER JOIN AccommodationLincGoods AS Accommodation
                                                   ON Accommodation.UnitId = vbUnitFromId
                                                  AND Accommodation.GoodsId = Object_Goods.Id
                                                  AND Accommodation.isErased = False
            -- Размещение товара
            LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = Accommodation.AccommodationId
            
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
            LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = MovementItem.Id
            LEFT JOIN tmpMinExpirationDate ON tmpMinExpirationDate.GoodsId = MovementItem.ObjectId
            
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
         AND MovementItem.Amount <> 0 
       ORDER BY Object_Goods.ValueData
        ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Send_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А
 22.01.20         *
 29.07.15                                                                       *
*/

-- SELECT * FROM gpSelect_Movement_Send_Print (inMovementId := 570596, inSession:= '5');