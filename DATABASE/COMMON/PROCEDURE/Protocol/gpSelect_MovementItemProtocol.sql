-- Function: gpSelect_Protocol()

DROP FUNCTION IF EXISTS gpSelect_MovementItemProtocol (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItemProtocol (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItemProtocol (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemProtocol(
    IN inStartDate           TDateTime , -- 
    IN inEndDate             TDateTime , --
    IN inUserId              Integer,    -- пользователь  
    IN inMovementItemId      Integer,    -- Документ  
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, ProtocolData Text
             , UserName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionName TVarChar
             , MovementItemId Integer)
AS
$BODY$
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  -- проверка
  IF COALESCE (inMovementItemId, 0) = 0 THEN
     RAISE EXCEPTION 'Ошибка.Просмотр протокола недоступен.';
  END IF;


  IF inMovementItemId <> 0 
  THEN

  RETURN QUERY 
   WITH tmpPersonal AS (SELECT lfSelect.MemberId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                        FROM lfSelect_Object_Member_findPersonal(inSession) AS lfSelect
                       )
  -- real-1
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::Text,
     Object_User.ValueData     AS UserName,

     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,

     MovementItemProtocol.MovementItemId
  FROM MovementItemProtocol
       JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
       
       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
       
  WHERE MovementItemProtocol.MovementItemId = inMovementItemId

 UNION ALL
  -- arc-1
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::Text,
     Object_User.ValueData     AS UserName,

     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,

     MovementItemProtocol.MovementItemId
  FROM MovementItemProtocol_arc AS MovementItemProtocol
       JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
  
  WHERE MovementItemProtocol.MovementItemId = inMovementItemId
    -- AND 1=0

 UNION ALL
  -- arc-2
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::Text,
     Object_User.ValueData     AS UserName,

     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,

     MovementItemProtocol.MovementItemId
  FROM MovementItemProtocol_arc_arc AS MovementItemProtocol
       JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
  
  WHERE MovementItemProtocol.MovementItemId = inMovementItemId
    -- AND 1=0
  ;

  ELSE
     RAISE EXCEPTION 'Ошибка.Просмотр протокола недоступен.';
  END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.17         *
 28.01.15         *              
 14.02.14                         *  
*/

-- тест
-- SELECT * FROM gpSelect_MovementItemProtocol (inStartDate:= NULL, inEndDate:= NULL, inUserId:= NULL, inMovementItemId:= 1, inSession:= '5');
