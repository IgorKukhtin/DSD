-- Function: gpSelect_Protocol()

DROP FUNCTION IF EXISTS gpSelect_MovementItemProtocolSWT (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemProtocolSWT(
    IN inStartDate           TDateTime , -- 
    IN inEndDate             TDateTime , --
    IN inUserId              Integer,    -- пользователь  
    IN inMemberId            Integer   , -- Ключ физ. лицо
    IN inPositionId          Integer   , -- Должность
    IN inPositionLevelId     Integer   , -- Разряд
    IN inUnitId              Integer   , -- Подразделение
    IN inPersonalGroupId     Integer   , -- Группировка Сотрудника
    IN inStorageLineId       Integer   , -- линия произ-ва
    IN inOperDate            TDateTime , -- дата
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, ProtocolData Text
             , UserName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionName TVarChar
             , MovementItemId Integer
             , OperDate_swt TDateTime)
AS
$BODY$
  DECLARE vbStartDate TDateTime;
  DECLARE vbEndDate   TDateTime;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  -- проверка
/*  IF COALESCE (inMovementItemId, 0) = 0 THEN
     RAISE EXCEPTION 'Ошибка.Просмотр протокола недоступен.';
  END IF;
*/

     vbStartDate := DATE_TRUNC ('MONTH', inOperDate);
     vbEndDate   := DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
     
  RETURN QUERY 
   WITH tmpPersonal AS (SELECT lfSelect.MemberId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                        FROM lfSelect_Object_Member_findPersonal(inSession) AS lfSelect
                       )
      , tmpMI AS (SELECT MI_SheetWorkTime.Id
                       , Movement_SheetWorkTime.OperDate
                  FROM Movement AS Movement_SheetWorkTime
                       JOIN MovementLinkObject AS MovementLinkObject_Unit 
                                               ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                              AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
                                              AND MovementLinkObject_Unit.ObjectId = inUnitId
                       LEFT OUTER JOIN MovementItem AS MI_SheetWorkTime
                                                    ON MI_SheetWorkTime.MovementId = Movement_SheetWorkTime.Id
                                                   AND MI_SheetWorkTime.ObjectId   = inMemberId
        
                       LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                              ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                             AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                       LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                              ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                                             AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
                       LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                              ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                             AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                       LEFT OUTER JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                              ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id 
                                                             AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine() 
                  WHERE Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime()
                    AND Movement_SheetWorkTime.OperDate BETWEEN vbStartDate AND vbEndDate 
                    AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inPositionId, 0)
                    AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
                    AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                    AND COALESCE (MIObject_StorageLine.ObjectId, 0)   = COALESCE (inStorageLineId, 0)
                  )

                     
  -- real-1
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::Text,
     Object_User.ValueData     AS UserName,

     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,

     MovementItemProtocol.MovementItemId, 
     tmpMI.OperDate            AS OperDate_swt
  FROM tmpMI
       INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = tmpMI.Id
       JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
       
       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId

 UNION ALL
  -- arc-1
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::Text,
     Object_User.ValueData     AS UserName,

     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,
     Object_Position.ValueData AS PositionName,

     MovementItemProtocol.MovementItemId, 
     tmpMI.OperDate            AS OperDate_swt
  FROM tmpMI
       INNER JOIN MovementItemProtocol_arc AS MovementItemProtocol ON MovementItemProtocol.MovementItemId = tmpMI.Id
       JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
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

     MovementItemProtocol.MovementItemId, 
     tmpMI.OperDate            AS OperDate_swt
  FROM tmpMI
       INNER JOIN MovementItemProtocol_arc_arc AS MovementItemProtocol ON MovementItemProtocol.MovementItemId = tmpMI.Id
       JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
    -- AND 1=0
  ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.02.23         *
*/

-- тест
--