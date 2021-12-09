-- Function: gpSelect_Movement_PersonalGroup_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalGroup_Print (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalGroup_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;

    DECLARE vbStoreKeeperName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate                  AS OperDate
       INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId
    ;

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) = zc_Enum_Status_Erased()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- это уже странная ошибка
        RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;

     --
    OPEN Cursor1 FOR
        SELECT
             Movement.Id                         AS Id
           , Movement.InvNumber                  AS InvNumber
           , Movement.OperDate                   AS OperDate
           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ValueData               AS UnitName
           , Object_PersonalGroup.Id             AS PersonalGroupId
           , Object_PersonalGroup.ValueData      AS PersonalGroupName
           , Object_PairDay.Id                   AS PairDayId
           , Object_PairDay.ValueData            AS PairDayName
        FROM Movement 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                         ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PairDay
                                         ON MovementLinkObject_PairDay.MovementId = Movement.Id
                                        AND MovementLinkObject_PairDay.DescId = zc_MovementLinkObject_PairDay()
            LEFT JOIN Object AS Object_PairDay ON Object_PairDay.Id = MovementLinkObject_PairDay.ObjectId

     WHERE Movement.Id = inMovementId
       AND Movement.StatusId <> zc_Enum_Status_Erased()
       AND Movement.DescId = zc_Movement_PersonalGroup()
    ;
    RETURN NEXT Cursor1;


     OPEN Cursor2 FOR
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.Amount
                           , MovementItem.ObjectId
                           , MovementItem.isErased
                      FROM MovementItem
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId = zc_MI_Master()
                        AND MovementItem.isErased = FALSE
                        AND MovementItem.ObjectId <> 0
                     )
            
       -- Результат
       SELECT MovementItem.Id
            , View_Personal.MemberId
            , View_Personal.PersonalId
            , View_Personal.PersonalCode
            , View_Personal.PersonalName

            , Object_Position.Id             AS PositionId
            , Object_Position.ValueData      AS PositionName
            , Object_PositionLevel.Id        AS PositionLevelId
            , Object_PositionLevel.ValueData AS PositionLevelName
            , Object_PersonalGroup.Id        AS PersonalGroupId
            , Object_PersonalGroup.ValueData AS PersonalGroupName

            , View_Personal.UnitName         AS UnitName_inf
            , View_Personal.PositionName     AS PositionName_inf

            , MovementItem.Amount :: TFloat  AS Amount

       FROM tmpMI AS MovementItem
            LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                             ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
            LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = MILinkObject_PositionLevel.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                 ON ObjectLink_Personal_PersonalGroup.ObjectId = View_Personal.PersonalId
                                AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
            ;
      

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.12.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalGroup_Print (inMovementId := 21646619 , inSession:= zfCalc_UserAdmin());
-- FETCH ALL "<unnamed portal 14>";
