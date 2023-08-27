-- Function: gpSelect_Movement_InventoryCheck()

DROP FUNCTION IF EXISTS gpSelect_Movement_InventoryCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_InventoryCheck(
    IN inMovementId  Integer   , -- Ключ объекта <Документ Инвентаризации>
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , GoodsId Integer
             , UserId Integer
             , MovementId Integer
             , Amount TFloat
             )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbOperDate   TDateTime;
   DECLARE vbFullInvent Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

    --определяем подразделение и дату документа
    SELECT DATE_TRUNC ('DAY', Movement.OperDate)
         , MLO_Unit.ObjectId
         , COALESCE(MovementBoolean_FullInvent.ValueData,False) AS FullInvent
    INTO vbOperDate
       , vbUnitId
       , vbFullInvent
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT OUTER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                         ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                        AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
    WHERE Movement.Id = inMovementId;    

    IF COALESCE (vbFullInvent, False) <> True
    THEN 
      RAISE EXCEPTION 'Ошибка. Предназначено для полных инвентаризаций.';     
    END IF;     
    
    RETURN QUERY   
    WITH tmpMICheck AS (SELECT MovementItemContainer.MovementId
                             , MovementItemContainer.OperDate
                             , MovementItemContainer.ObjectId_Analyzer  AS  GoodsId
                             , COALESCE(MLO_Insert.ObjectId, MLO_UserConfirmedKind.ObjectId) AS UserId          
                             , sum(MovementItemContainer.Amount)        AS Amount 
                        FROM MovementItemContainer
                          
                            LEFT JOIN MovementLinkObject AS MLO_Insert
                                                         ON MLO_Insert.MovementId = MovementItemContainer.MovementId
                                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                                                          
                            LEFT JOIN MovementLinkObject AS MLO_UserConfirmedKind
                                                         ON MLO_UserConfirmedKind.MovementId = MovementItemContainer.MovementId
                                                        AND MLO_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()
                          
                        WHERE MovementItemContainer.OperDate >= vbOperDate
                          AND MovementItemContainer.OperDate < vbOperDate + INTERVAL '2 DAY'
                          AND MovementItemContainer.WhereObjectId_Analyzer = vbUnitId 
                          AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                          AND MovementItemContainer.DescId = zc_MIContainer_Count()
                        GROUP BY MovementItemContainer.MovementId
                               , MovementItemContainer.OperDate
                               , MovementItemContainer.ObjectId_Analyzer 
                               , COALESCE(MLO_Insert.ObjectId, MLO_UserConfirmedKind.ObjectId)),
         tmpMI_Child AS (SELECT MovementItem.Id            AS Id
                              , MovementItem.ObjectId      AS UserId
                              , MI_Master.ObjectId         AS GoodsId
                              , MovementItem.Amount        AS Amount
                              , MIDate_Insert.ValueData    AS Date_Insert
                              , MIFloat_MovementId.ValueData::Integer AS MovementCheckId
                          FROM MovementItem
                               LEFT JOIN MovementItemDate AS MIDate_Insert
                                                          ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                         AND MIDate_Insert.DescId = zc_MIDate_Insert()
                               LEFT JOIN MovementItem AS MI_Master
                                                      ON MI_Master.ID = MovementItem.ParentId
                               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                          AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()                                                      
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Child()
                            AND MovementItem.isErased   = False
                         )
                           
                           
    SELECT tmpMICheck.OperDate
         , tmpMICheck.GoodsId
         , COALESCE(tmpMICheck.UserId, vbUserId) AS UserId
         , tmpMICheck.MovementId
         , CASE WHEN DATE_TRUNC ('DAY', tmpMICheck.OperDate) = vbOperDate THEN tmpMICheck.Amount ELSE - tmpMICheck.Amount END::TFloat
    FROM tmpMICheck
    WHERE NOT EXISTS(SELECT * 
                     FROM tmpMI_Child 
                     WHERE tmpMI_Child.GoodsId = tmpMICheck.GoodsId 
                       AND tmpMI_Child.MovementCheckId = tmpMICheck.MovementId)
      AND (EXISTS(SELECT * 
                 FROM tmpMI_Child 
                 WHERE tmpMI_Child.GoodsId = tmpMICheck.GoodsId 
                   AND tmpMI_Child.Date_Insert <= tmpMICheck.OperDate
                   AND COALESCE(tmpMI_Child.MovementCheckId, 0) = 0)
      AND DATE_TRUNC ('DAY', tmpMICheck.OperDate) = vbOperDate           
       OR NOT EXISTS(SELECT * 
                     FROM tmpMI_Child 
                     WHERE tmpMI_Child.GoodsId = tmpMICheck.GoodsId 
                       AND tmpMI_Child.Date_Insert <= tmpMICheck.OperDate
                       AND COALESCE(tmpMI_Child.MovementCheckId, 0) = 0)
      AND DATE_TRUNC ('DAY', tmpMICheck.OperDate) > vbOperDate);
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.06.23                                                       *
*/

-- тест

--

select * from gpSelect_Movement_InventoryCheck(inMovementId := 33155033   , inSession := '3') left join Object ON Object.Id = GoodsId;
    