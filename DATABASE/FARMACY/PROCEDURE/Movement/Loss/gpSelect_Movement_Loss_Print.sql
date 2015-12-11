-- Function: gpSelect_Movement_Loss_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Loss_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Loss_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbOperDate TDateTime;
    
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= inSession;
     --Определили подразделение для розничной цены
     SELECT 
         MovementLinkObject_Unit.ObjectId
        ,Movement.OperDate 
     INTO 
         vbUnitId
        ,vbOperDate 
     from
         Movement
         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.ID
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
     WHERE Movement.Id = inMovementId;
    OPEN Cursor1 FOR

       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
           , Object_Unit.Id                                     AS UnitId
           , Object_Unit.ValueData                              AS UnitName
           , Object_ArticleLoss.Id                              AS ArticleLossId
           , Object_ArticleLoss.ValueData                       AS ArticleLossName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = MovementLinkObject_ArticleLoss.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Loss();
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
        WITH REMAINS AS ( --остатки на дату документа
                            SELECT 
                                T0.ObjectId
                               ,CASE WHEN SUM(T0.Amount) <> 0
                                    THEN SUM(T0.Summ) / SUM(T0.Amount)
                                END AS Price
                            FROM(
                                    SELECT 
                                        Container.Id 
                                       ,Container.ObjectId --Товар
                                       ,(Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0))::TFloat as Amount  --Тек. остаток - Движение после даты переучета
                                       ,(Container.Amount * COALESCE(MIFloat_Income_Price.ValueData,0) - COALESCE(SUM(MovementItemContainer.amount * COALESCE(MIFloat_Income_Price.ValueData,0)),0.0))::TFloat as Summ  --Тек. остаток - Движение после даты переучета
                                    FROM Container
                                        LEFT OUTER JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                                             AND 
                                                                             (
                                                                                date_trunc('day', MovementItemContainer.Operdate) > vbOperDate
                                                                                OR
                                                                                MovementItemContainer.MovementId = inMovementId
                                                                             )
                                        LEFT OUTER JOIN containerlinkobject AS CLI_MI 
                                                                            ON CLI_MI.containerid = Container.Id
                                                                           AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                                        LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                        LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                                                          ON MIFloat_Income_Price.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                                         AND MIFloat_Income_Price.DescId = zc_MIFloat_Price()
                                        
                                    WHERE 
                                        Container.DescID = zc_Container_Count()
                                        AND
                                        Container.WhereObjectId = vbUnitId
                                    GROUP BY 
                                        Container.Id 
                                       ,Container.ObjectId
                                       ,Container.Amount
                                       ,MIFloat_Income_Price.ValueData
                                ) as T0
                            GROUP By ObjectId
                            HAVING SUM(T0.Amount) <> 0
                        ),
                 MIContainer AS ( 
                                    SELECT
                                        MovementItemContainer.MovementItemId,
                                        CASE WHEN  SUM(-MovementItemContainer.Amount) <> 0 
                                            THEN SUM(-MovementItemContainer.Amount * MIFloat_Income_Price.ValueData)
                                                 / SUM(-MovementItemContainer.Amount)
                                        END::TFloat AS Price
                                    FROM MovementItemContainer 
                                        LEFT OUTER JOIN containerlinkobject AS CLI_MI 
                                                                            ON CLI_MI.containerid = MovementItemContainer.ContainerId
                                                                           AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                                        LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                        LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                                                              ON MIFloat_Income_Price.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                                             AND MIFloat_Income_Price.DescId = zc_MIFloat_Price()
                                    WHERE MovementItemContainer.MovementId = inMovementId
                                      AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                    GROUP BY
                                        MovementItemContainer.MovementItemId
                                )
    
       SELECT
             MovementItem.Id                    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , MovementItem.Amount                AS Amount
           , COALESCE(MIContainer.Price,REMAINS.Price)::TFloat                       AS PriceIn
           , (MovementItem.Amount*COALESCE(MIContainer.Price,REMAINS.Price))::TFloat AS SummIn
       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT OUTER JOIN REMAINS ON MovementItem.ObjectId = REMAINS.ObjectId 
            LEFT OUTER JOIN MIContainer ON MIContainer.MovementItemId = MovementItem.Id
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = False
       ORDER BY
           Object_Goods.ValueData;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Loss_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 20.07.15                                                                       *
*/

/*
 SELECT * FROM gpSelect_Movement_Loss_Print (inMovementId := 570596, inSession:= '3');
*/
