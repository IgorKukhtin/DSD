-- Function: gpSelect_Protocol() 

DROP FUNCTION IF EXISTS gpSelect_MovementProtocol (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementProtocol(
    IN inStartDate       TDateTime , -- 
    IN inEndDate         TDateTime , --
    IN inUserId          Integer,    -- пользователь  
    IN inMovementDescId  Integer,    -- тип объекта
    IN inMovementId      Integer,    -- объект
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, ProtocolData Text, UserName TVarChar 
             , UnitCode Integer, UnitName TVarChar
             , PositionName TVarChar
             , InvNumber TVarChar, MovementOperDate TDateTime, MovementDescName TVarChar
             , isInsert Boolean)
AS
$BODY$
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  -- проверка
  IF COALESCE (inMovementId, 0) = 0 THEN
     RAISE EXCEPTION 'Ошибка.Просмотр протокола недоступен.';
  END IF;


  IF inMovementId <> 0 AND EXISTS (SELECT Id FROM Movement WHERE Id = inMovementId AND DescId IN (zc_Movement_Cash(), zc_Movement_PersonalReport(), zc_Movement_BankAccount(), zc_Movement_ProfitLossService(), zc_Movement_Service(), zc_Movement_Currency()))
  THEN
  RETURN QUERY 
   WITH tmpPersonal AS (SELECT lfSelect.MemberId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                        FROM lfSelect_Object_Member_findPersonal(inSession) AS lfSelect
                       )
  -- real-1
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,
     
     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,
       
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName,
     MovementProtocol.isInsert
  FROM MovementProtocol 
  JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
  JOIN Movement ON Movement.Id = MovementProtocol.MovementId AND Movement.Id = inMovementId
  JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
  
  LEFT JOIN ObjectLink AS ObjectLink_User_Member
                       ON ObjectLink_User_Member.ObjectId = Object_User.Id
                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
  LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
  LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
  
 UNION ALL
  -- real-2
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::Text,
     Object_User.ValueData,
     
     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,
     
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementItemDesc.ItemName AS MovementDescName,
     MovementItemProtocol.isInsert
  FROM MovementItemProtocol
       JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
       JOIN MovementItem ON MovementItem.Id = MovementItemProtocol.MovementItemId AND MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()
       JOIN MovementItemDesc ON MovementItemDesc.Id = MovementItem.DescId
       JOIN Movement ON Movement.Id = MovementItem.MovementId
       
       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
  
 UNION ALL
  -- arc-1
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,

     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,
     
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName,
     MovementProtocol.isInsert
  FROM MovementProtocol_arc AS MovementProtocol 
       JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
       JOIN Movement ON Movement.Id = MovementProtocol.MovementId AND Movement.Id = inMovementId
       JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
       
       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
  -- WHERE 1=0       
 UNION ALL
  -- arc-2
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::Text,
     Object_User.ValueData,

     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,

     Movement.InvNumber, 
     Movement.OperDate, 
     MovementItemDesc.ItemName AS MovementDescName,
     MovementItemProtocol.isInsert
  FROM MovementItemProtocol_arc AS MovementItemProtocol
       JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
       JOIN MovementItem ON MovementItem.Id = MovementItemProtocol.MovementItemId AND MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()
       JOIN MovementItemDesc ON MovementItemDesc.Id = MovementItem.DescId
       JOIN Movement ON Movement.Id = MovementItem.MovementId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
  -- WHERE 1=0


 UNION ALL
  -- arc-arc-1
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,

     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,
     
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName,
     MovementProtocol.isInsert
  FROM MovementProtocol_arc_arc AS MovementProtocol 
       JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
       JOIN Movement ON Movement.Id = MovementProtocol.MovementId AND Movement.Id = inMovementId
       JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
       
       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
  -- WHERE 1=0       
 UNION ALL
  -- arc-arc-2
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::Text,
     Object_User.ValueData,

     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,

     Movement.InvNumber, 
     Movement.OperDate, 
     MovementItemDesc.ItemName AS MovementDescName,
     MovementItemProtocol.isInsert
  FROM MovementItemProtocol_arc_arc AS MovementItemProtocol
       JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
       JOIN MovementItem ON MovementItem.Id = MovementItemProtocol.MovementItemId AND MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()
       JOIN MovementItemDesc ON MovementItemDesc.Id = MovementItem.DescId
       JOIN Movement ON Movement.Id = MovementItem.MovementId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
  -- WHERE 1=0
  ;

  ELSE
  
  IF inMovementId <> 0 
  THEN
  -- real-1
  RETURN QUERY 
   WITH tmpPersonal AS (SELECT lfSelect.MemberId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                        FROM lfSelect_Object_Member_findPersonal(inSession) AS lfSelect
                       )
                       
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,

     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,
     
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName,
     MovementProtocol.isInsert
  FROM MovementProtocol 
       JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
       JOIN Movement ON Movement.Id = MovementProtocol.MovementId AND Movement.Id = inMovementId
       JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
  
       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId

 UNION ALL
  -- arc-1
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,

     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,
     
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName,
     MovementProtocol.isInsert
  FROM MovementProtocol_arc AS MovementProtocol
       JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
       JOIN Movement ON Movement.Id = MovementProtocol.MovementId AND Movement.Id = inMovementId
       JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
  -- WHERE 1=0

 UNION ALL
  -- arc-2
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,

     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,
     
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName,
     MovementProtocol.isInsert
  FROM MovementProtocol_arc_arc AS MovementProtocol
       JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
       JOIN Movement ON Movement.Id = MovementProtocol.MovementId AND Movement.Id = inMovementId
       JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
  -- WHERE 1=0
  ;

  ELSE
     RAISE EXCEPTION 'Ошибка.Просмотр протокола недоступен.';

  END IF;
  END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.17         *
 27.01.15         *
 14.02.14                         *  

*/

-- тест
-- SELECT * FROM gpSelect_MovementProtocol (inStartDate:= NULL, inEndDate:= NULL, inUserId:= 0, inMovementDescId:= 0, inMovementId:=  354233, inSession := '5');
