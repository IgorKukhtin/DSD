-- Function: gpSelect_MovementItem_CheckDeferred_Child()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_CheckDeferred_Child (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_CheckDeferred_Child(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , ContainerId TFloat
             , ExpirationDate      TDateTime
             , OperDate_Income     TDateTime
             , Invnumber_Income    TVarChar
             , FromName_Income     TVarChar
             , ContractName_Income TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUnitKey TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        vbUnitKey := '0';
    END IF;
    vbUnitId := CASE WHEN vbUserId = 3 THEN 0 ELSE vbUnitKey::Integer END;

    RETURN QUERY
        WITH
           tmpMov AS (SELECT Movement.Id
                           , Movement.StatusId
                           , MovementLinkObject_Unit.ObjectId           AS UnitId
                           , MovementLinkObject_ConfirmedKind.ObjectId  AS ConfirmedKindId
                           , MovementString_CommentError.ValueData      AS CommentError
                      FROM MovementBoolean AS MovementBoolean_Deferred
                        INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                           AND Movement.DescId = zc_Movement_Check()
                                           AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                           -- AND Movement.OperDate > CURRENT_DATE - INTERVAL '31 DAY'
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                     AND (MovementLinkObject_Unit.ObjectId = vbUnitId OR vbUnitId = 0)
                                                     -- AND MovementLinkObject_Unit.ObjectId = vbUnitId
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                     ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                    AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                        LEFT JOIN MovementString AS MovementString_CommentError
                                                 ON MovementString_CommentError.MovementId = Movement.Id
                                                AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
                      WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                        AND MovementBoolean_Deferred.ValueData = TRUE
                     UNION
                      SELECT Movement.Id
                           , Movement.StatusId
                           , MovementLinkObject_Unit.ObjectId           AS UnitId
                           , MovementLinkObject_ConfirmedKind.ObjectId  AS ConfirmedKindId
                           , MovementString_CommentError.ValueData      AS CommentError
                      FROM MovementString AS MovementString_CommentError
                        INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                           AND Movement.DescId = zc_Movement_Check()
                                           AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                           -- AND Movement.OperDate > CURRENT_DATE - INTERVAL '31 DAY'
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                     AND (MovementLinkObject_Unit.ObjectId = vbUnitId OR vbUnitId = 0)
                                                     -- AND MovementLinkObject_Unit.ObjectId = vbUnitId
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                     ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                    AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                      WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                        AND MovementString_CommentError.ValueData <> ''
                     )
   , tmpMI_Child AS (SELECT MovementItem.*
                     FROM MovementItem
                     WHERE MovementItem.MovementId in (SELECT tmpMov.ID FROM tmpMov)
                        AND MovementItem.DescId = zc_MI_Child()
                     )
   , tmpMIFloat_ContainerId AS (SELECT MovementItemFloat.MovementItemId
                                     , MovementItemFloat.ValueData :: Integer AS ContainerId
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Child.Id FROM tmpMI_Child WHERE tmpMI_Child.IsErased = FALSE)
                                  AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                )
    --
   , tmpContainer AS (SELECT tmp.ContainerId
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

       SELECT
             MovementItem.Id
           , MovementItem.ParentId  
           , Object_Goods.Id            AS GoodsId
           , Object_Goods.ObjectCode    AS GoodsCode
           , Object_Goods.ValueData     AS GoodsName
           , MovementItem.Amount

           , MIFloat_ContainerId.ContainerId                   :: TFloat    AS ContainerId
           , COALESCE (tmpContainer.ExpirationDate, NULL)      :: TDateTime AS ExpirationDate
           , COALESCE (tmpPartion.BranchDate, NULL)            :: TDateTime AS OperDate_Income
           , COALESCE (tmpPartion.Invnumber, NULL)             :: TVarChar  AS Invnumber_Income
           , COALESCE (tmpPartion.FromName, NULL)              :: TVarChar  AS FromName_Income
           , COALESCE (tmpPartion.ContractName, NULL)          :: TVarChar  AS ContractName_Income

       FROM tmpMI_Child AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN tmpMIFloat_ContainerId AS MIFloat_ContainerId
                                             ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
            LEFT JOIN tmpContainer ON tmpContainer.ContainerId = MIFloat_ContainerId.ContainerId
            LEFT JOIN tmpPartion ON tmpPartion.Id= tmpContainer.MovementId_Income
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_CheckDeferred_Child (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А   Шаблий О.В.
 09.07.19                                                                                   *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_CheckDeferred_Child ('3')
