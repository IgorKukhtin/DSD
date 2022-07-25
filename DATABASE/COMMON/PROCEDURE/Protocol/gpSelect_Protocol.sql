-- Function: gpSelect_Protocol()

DROP FUNCTION IF EXISTS gpSelect_Protocol (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Protocol (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Protocol(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inUserId        Integer,    -- пользователь  
    IN inObjectDescId  Integer,    -- тип объекта
    IN inObjectId      Integer,    -- объект
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, ProtocolData TBlob
             , UserName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionName TVarChar             
             , ObjectName TVarChar, ObjectTypeName TVarChar
             , isInsert Boolean)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());
   vbUserId:= lpGetUserBySession (inSession);

  -- проверка
  IF COALESCE (inObjectId, 0) = 0 THEN
     RAISE EXCEPTION 'Ошибка.Просмотр протокола недоступен.';
  END IF;


  IF inObjectId <> 0 
  THEN

  RETURN QUERY 
   WITH tmpPersonal AS (SELECT lfSelect.MemberId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                        FROM lfSelect_Object_Member_findPersonal(inSession) AS lfSelect
                       )
                       
  SELECT 
     ObjectProtocol.OperDate      AS OperDate,
     ObjectProtocol.ProtocolData  AS ProtocolData,
     Object_User.ValueData        AS UserName,

     Object_Unit.ObjectCode       AS UnitCode,
     Object_Unit.ValueData        AS UnitName,
     Object_Position.ValueData    AS PositionName,

     Object.ValueData             AS ObjectName, 
     ObjectDesc.ItemName          AS ObjectTypeName,
     ObjectProtocol.isInsert      AS isInsert
  FROM ObjectProtocol 
       LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectProtocol.UserId 
       LEFT JOIN Object ON Object.Id = ObjectProtocol.ObjectId 
       LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
       
 WHERE Object.Id = inObjectId
 ORDER BY ObjectProtocol.Id DESC
 LIMIT CASE WHEN inObjectId = 5 AND vbUserId = 5 THEN 100 ELSE 10000 END
;

  ELSE

  RETURN QUERY 
   WITH tmpPersonal AS (SELECT lfSelect.MemberId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                        FROM lfSelect_Object_Member_findPersonal(inSession) AS lfSelect
                       )
                       
  SELECT 
     ObjectProtocol.OperDate      AS OperDate,
     ObjectProtocol.ProtocolData  AS ProtocolData,
     Object_User.ValueData        AS UserName,

     Object_Unit.ObjectCode       AS UnitCode,
     Object_Unit.ValueData        AS UnitName,
     Object_Position.ValueData    AS PositionName,
     
     Object.ValueData             AS ObjectName, 
     ObjectDesc.ItemName          AS ObjectTypeName,
     ObjectProtocol.isInsert      AS isInsert
  FROM ObjectProtocol 
       LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectProtocol.UserId 
       LEFT JOIN Object ON Object.Id = ObjectProtocol.ObjectId 
       LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
       
 WHERE ObjectProtocol.OperDate BETWEEN inStartDate AND inEndDate
   AND (ObjectProtocol.UserId = inUserId OR 0 = inUserId)
   AND (Object.Id = inObjectId OR 0 = inObjectId)
   AND (Object.DescId = inObjectDescId OR inObjectDescId = 0)
   AND ((inObjectId + inUserId + inObjectDescId) <> 0 );

  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Protocol (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.17         *
 04.11.13                        *  add inObjectId
 01.11.13                        * 
*/

-- тест
-- SELECT * FROM gpSelect_Protocol (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inUserId:= null, inObjectDescId:= null, inObjectId:= 1, inSession:= '2'); 
