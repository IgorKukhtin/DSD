--  gpSelect_Movement_Check_UnComplete()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_UnComplete (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_UnComplete(
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inUnitId          Integer,    -- Подразделение
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (ID Integer, OperDate TDateTime, UserName TVarChar
             , UnitID Integer, UnitCode Integer, UnitName TVarChar
             , PositionName TVarChar
             , InvNumber TVarChar, MovementOperDate TDateTime, StatusCode Integer
             , CashRegisterName TVarChar
             , TotalSumm TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
   vbUserId:= lpGetUserBySession (inSession);

     -- Результат
   RETURN QUERY
   WITH tmpPersonal AS (SELECT lfSelect.MemberId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                        FROM lfSelect_Object_Member_findPersonal('3') AS lfSelect
                       ),
        tmpMovement AS (SELECT
                           MovementProtocol.MovementId
                        FROM Movement
                             INNER JOIN MovementProtocol ON Movement.Id = MovementProtocol.MovementId
                                                AND Movement.DescId = zc_Movement_Check()
                                                AND Movement.StatusId <> zc_Enum_Status_Complete()
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         AND (inUnitId= 0 OR MovementLinkObject_Unit.ObjectId = inUnitId)
                        WHERE MovementProtocol.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                          AND MovementProtocol.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                          AND CASE WHEN MovementProtocol.ProtocolData LIKE '%"Статус" FieldValue = "Проведен"%' THEN 1 ELSE 0 END = 0
                          AND MovementProtocol.isInsert = False),
        tmpProtocol AS (SELECT
                           ROW_NUMBER() OVER (PARTITION BY tmpMovement.MovementId ORDER BY MovementProtocol.OperDate) AS Ord,
                           tmpMovement.MovementId,
                           MovementProtocol.OperDate,
                           MovementProtocol.UserID,
                           MovementProtocol.isInsert,
                           case when MovementProtocol.ProtocolData like '%"Статус" FieldValue = "Проведен"%' THEN 1 ELSE 0 END AS Status
                        FROM tmpMovement
                             INNER JOIN MovementProtocol ON tmpMovement.MovementId = MovementProtocol.MovementId),
        tmpProtocolPrev AS (SELECT
                           tmpProtocol.MovementId,
                           Max(tmpProtocol.Ord) AS Ord
                        FROM tmpProtocol
                        WHERE tmpProtocol.Status = 1
                        GROUP BY tmpProtocol.MovementId)


  SELECT
     Movement.Id,
     MovementProtocol.OperDate,
     Object_User.ValueData,

     Object_Unit.ID            AS UnitID,
     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,

     Movement.InvNumber,
     Movement.OperDate,
     Object_Status.ObjectCode                           AS StatusCode,
     Object_CashRegister.ValueData                      AS CashRegisterName,
     MovementFloat_TotalSumm.ValueData                  AS TotalSumm
  FROM tmpProtocol AS MovementProtocol
       INNER JOIN Movement ON Movement.Id = MovementProtocol.MovementId
       INNER JOIN tmpProtocolPrev AS MovementProtocolPrev
                                 ON MovementProtocolPrev.MovementId = MovementProtocol.MovementId
                                AND MovementProtocolPrev.Ord = MovementProtocol.Ord - 1

       LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

       LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

       LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                               ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                              AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

       LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                    ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                   AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
       LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

       JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
  WHERE MovementProtocol.Status = 0
    AND MovementProtocol.isInsert = False
  ORDER BY MovementProtocol.OperDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 23.11.18                                                                                    *
*/

-- тест
-- select * from gpSelect_Movement_Check_UnComplete(inStartDate := ('01.10.2018')::TDateTime , inEndDate := ('01.12.2018')::TDateTime , inUnitId := 0, inSession := '3');