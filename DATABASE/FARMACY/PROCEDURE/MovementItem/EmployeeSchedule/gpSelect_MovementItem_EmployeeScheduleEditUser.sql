-- Function: gpSelect_MovementItem_EmployeeScheduleEditUser()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_EmployeeScheduleEditUser(Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_EmployeeScheduleEditUser(
    IN inId          Integer      , -- ключ строка Документа
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS TABLE (ID Integer, Day Integer,
                 UnitID Integer, UnitCode Integer, UnitName TVarChar, isSubstitution Boolean,
                 PayrollTypeID Integer, PayrollTypeCode Integer, PayrollTypeName TVarChar, ShortName TVarChar,
                 TimeStart TVarChar, TimeEnd TVarChar, DateStart TDateTime, DateEnd TDateTime,
                 Color_CalcUser Integer
                )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

     SELECT Movement.OperDate, COALESCE(ObjectLink_Member_Unit.ChildObjectId, MILinkObject_Unit.ObjectId)
     INTO vbOperDate, vbUnitId
     FROM Movement

          LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.ID
                                AND MovementItem.Id = inId

          LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

          LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                               ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                              AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

     WHERE Movement.Id =  inMovementId;


     RETURN QUERY
     SELECT MovementItem.ID
          , MovementItem.Amount::Integer                AS Day

          , Object_Unit.ID                              AS UnitID
          , Object_Unit.ObjectCode                      AS UnitCode
          , Object_Unit.ValueData                       AS UnitName

          , CASE WHEN  Object_Unit.ID = vbUnitId
                 THEN False
                 ELSE True END::Boolean                 AS isSubstitution

          , Object_PayrollType.ID                       AS PayrollTypeID
          , Object_PayrollType.ObjectCode               AS PayrollTypeCode

          , CASE WHEN COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = FALSE
            THEN Object_PayrollType.ValueData ELSE 'Служебный выход' END::TVarChar                 AS PayrollTypeName
          , CASE WHEN COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = FALSE
            THEN PayrollType_ShortName.ValueData ELSE 'СВ' END::TVarChar                           AS ShortName

          , CASE WHEN COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = FALSE
            THEN TO_CHAR(MIDate_Start.ValueData, 'HH24:mi')  ELSE '' END::TVarChar                 AS TimeStart
          , CASE WHEN COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = FALSE
            THEN TO_CHAR(MIDate_End.ValueData, 'HH24:mi')  ELSE '' END::TVarChar                   AS TimeEnd

          , MIDate_Start.ValueData                                AS DataStart
          , MIDate_End.ValueData                                  AS DataEnd

          , CASE WHEN  Object_Unit.ID = vbUnitId THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser
     FROM MovementItem

          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId

          LEFT JOIN MovementItemLinkObject AS MILinkObject_PayrollType
                                           ON MILinkObject_PayrollType.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PayrollType.DescId = zc_MILinkObject_PayrollType()
          LEFT JOIN Object AS Object_PayrollType ON Object_PayrollType.Id = MILinkObject_PayrollType.ObjectId

          LEFT JOIN ObjectString AS PayrollType_ShortName
                                 ON PayrollType_ShortName.ObjectId = MILinkObject_PayrollType.ObjectId
                                AND PayrollType_ShortName.DescId = zc_ObjectString_PayrollType_ShortName()

          LEFT JOIN MovementItemDate AS MIDate_Start
                                     ON MIDate_Start.MovementItemId = MovementItem.Id
                                    AND MIDate_Start.DescId = zc_MIDate_Start()

          LEFT JOIN MovementItemDate AS MIDate_End
                                     ON MIDate_End.MovementItemId = MovementItem.Id
                                    AND MIDate_End.DescId = zc_MIDate_End()

          LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                        ON MIBoolean_ServiceExit.MovementItemId = MovementItem.Id
                                       AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()

     WHERE MovementItem.ParentId = inID
       AND MovementItem.MovementId = inMovementId
       AND (MovementItem.IsErased = FALSE OR inIsErased = TRUE)
     ORDER BY MovementItem.Amount
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_EmployeeScheduleEditUser (Integer, Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.09.19                                                       *
*/

-- тест
-- select * from gpSelect_MovementItem_EmployeeScheduleEditUser(inId := 275217437, inMovementId := 15463866 ,  inShowAll := FALSE, inIsErased := False, inSession := '4183126');