-- Function: gpReport_Personal_Cash_sms ()
/*
 в спрв ведомости -
 новая кнопка + с правами -
 отчет по zc_ObjectBoolean_PersonalServiceList_Sms -
  открыть диалог (период)
  + потом за период  по всем ведомостям где PersonalServiceList_Sms = TRUE
  + по документам zc_Movement_Cash + zc_MI_Child -

  показать сотрудника (фио + должность + подразделение + ведоость) + + Movement.OperDate + InvNumber  + zc_MIBoolean_SMS + zc_MIDate_SMS + zc_ObjectString_Member_Phone

*/

DROP FUNCTION IF EXISTS gpReport_Personal_Cash_sms (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Personal_Cash_sms(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar
             , MovementItemId Integer, PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PositionId Integer, PositionCode Integer, PositionName TVarChar
             , PositionLevelId Integer, PositionLevelCode Integer, PositionLevelName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , Amount      TFloat
             , Date_SMS    TDateTime
             , isSms       Boolean
             , Phone       TVarChar
             , SMS_Message TVarChar
              )
AS
$BODY$
    DECLARE vbUserId    Integer;
    DECLARE vbMemberId  Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Personal_Cash_sms());

     -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);
    
    
--  inStartDate:= '01.11.2025';

--    inStartDate:= '01.10.2025';
--    inStartDate:= '08.12.2025';
--    inEndDate:=   '08.12.2025';

    -- Результат
    RETURN QUERY

    WITH
     -- Ведомости   zc_ObjectBoolean_PersonalServiceList_Sms() = TRUE
     tmpPersonalServiceList AS (SELECT Object_PersonalServiceList.Id AS Id
                                FROM Object AS Object_PersonalServiceList
                                     INNER JOIN ObjectBoolean AS ObjectBoolean_Sms
                                                              ON ObjectBoolean_Sms.ObjectId = Object_PersonalServiceList.Id
                                                             AND ObjectBoolean_Sms.DescId = zc_ObjectBoolean_PersonalServiceList_Sms()
                                                             AND ObjectBoolean_Sms.ValueData = TRUE
                                WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                  AND Object_PersonalServiceList.isErased = FALSE
                               )
     -- документы Выплата по выбранным ведомостям за период
   , tmpMovement AS (SELECT Movement.*
                          , MovementLinkObject_PersonalServiceList.ObjectId AS PersonalServiceListId
                     FROM Movement
                          INNER JOIN Movement AS Movement_PersonalService
                                              ON Movement_PersonalService.Id = Movement.ParentId
                                             AND Movement_PersonalService.StatusId = zc_Enum_Status_Complete()
                                          -- AND (Movement_PersonalService.StatusId = zc_Enum_Status_Complete() OR Movement.Id = 33003250)

                          INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                        ON MovementLinkObject_PersonalServiceList.MovementId = Movement_PersonalService.Id
                                                       AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                       AND MovementLinkObject_PersonalServiceList.ObjectId IN (SELECT DISTINCT tmp.Id FROM tmpPersonalServiceList AS tmp)

                     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                       AND Movement.DescId = zc_Movement_Cash()
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                     --AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.Id = 33003250)
                       AND Movement.ParentId > 0
                     )

   , tmpMI_Child AS (WITH
                     tmpMI AS (SELECT MovementItem.*
                               FROM MovementItem
                               WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementItem.DescId = zc_MI_Child()
                                 AND MovementItem.isErased = FALSE
                               )
                   , tmpMIBoolean AS (SELECT MovementItemBoolean.*
                                      FROM MovementItemBoolean
                                      WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                        AND MovementItemBoolean.DescId IN (zc_MIBoolean_Calculated()
                                                                         , zc_MIBoolean_SMS())
                                      )
                   , tmpMIDate AS (SELECT MovementItemDate.*
                                   FROM MovementItemDate
                                   WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                     AND MovementItemDate.DescId IN (zc_MIDate_SMS())
                                   )
                   , tmpMILO AS (SELECT MovementItemLinkObject.*
                                 FROM MovementItemLinkObject
                                 WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                   AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Unit()
                                                                       , zc_MILinkObject_Position()
                                                                        )
                                 )

                     SELECT MovementItem.Id                          AS MovementItemId
                          , MovementItem.MovementId                  AS MovementId
                          , MovementItem.ObjectId                    AS PersonalId
                          , MovementItem.Amount                      AS Amount
                          , MILinkObject_Unit.ObjectId               AS UnitId
                          , MILinkObject_Position.ObjectId           AS PositionId
                          , MIDate_SMS.ValueData      ::TDateTime    AS Date_SMS
                          , MIBoolean_SMS.ValueData   ::Boolean      AS isSms
                     FROM tmpMI AS MovementItem
                          LEFT JOIN tmpMILO AS MILinkObject_Unit
                                            ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                          LEFT JOIN tmpMILO AS MILinkObject_Position
                                            ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Position.DescId = zc_MILinkObject_Position()

                          LEFT JOIN tmpMIDate AS MIDate_SMS
                                              ON MIDate_SMS.MovementItemId = MovementItem.Id
                                             AND MIDate_SMS.DescId         = zc_MIDate_SMS()
                          LEFT JOIN tmpMIBoolean AS MIBoolean_SMS
                                                 ON MIBoolean_SMS.MovementItemId = MovementItem.Id
                                                AND MIBoolean_SMS.DescId         = zc_MIBoolean_SMS()
                    )
    -- Результат
    SELECT Movement.Id                     AS MovementId
         , Movement.OperDate               AS OperDate
         , Movement.InvNumber              AS InvNumber
         , tmpMI_Child.MovementItemId      AS MovementItemId
         , Object_Personal.Id              AS PersonalId
         , Object_Personal.ObjectCode      AS PersonalCode
         , Object_Personal.ValueData       AS PersonalName
         , Object_Position.Id              AS PositionId
         , Object_Position.ObjectCode      AS PositionCode
         , Object_Position.ValueData       AS PositionName
         , Object_PositionLevel.Id         AS PositionLevelId
         , Object_PositionLevel.ObjectCode AS PositionLevelCode
         , Object_PositionLevel.ValueData  AS PositionLevelName
         , Object_Unit.Id                  AS UnitId
         , Object_Unit.ObjectCode          AS UnitCode
         , Object_Unit.ValueData           AS UnitName
         , Object_PersonalServiceList.Id          AS PersonalServiceListId
         , Object_PersonalServiceList.ValueData   AS PersonalServiceListName

         , tmpMI_Child.Amount                            AS Amount
         , tmpMI_Child.Date_SMS              ::TDateTime AS Date_SMS
         , COALESCE (tmpMI_Child.isSms,FALSE)::Boolean   AS isSms

         , ObjectString_Phone.ValueData      :: TVarChar AS Phone
--       , '380674464560'      :: TVarChar AS Phone

         , ('*   ' || zfConvert_FloatToString (tmpMI_Child.Amount) || '   *') :: TVarChar AS SMS_Message

    FROM tmpMovement AS Movement
         LEFT JOIN tmpMI_Child ON tmpMI_Child.MovementId = Movement.Id

         LEFT JOIN Object AS Object_Personal            ON Object_Personal.Id            = tmpMI_Child.PersonalId
         LEFT JOIN Object AS Object_Position            ON Object_Position.Id            = tmpMI_Child.PositionId
         LEFT JOIN Object AS Object_Unit                ON Object_Unit.Id                = tmpMI_Child.UnitId
         LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = Movement.PersonalServiceListId

         LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                              ON ObjectLink_Personal_PositionLevel.ObjectId = tmpMI_Child.PersonalId
                             AND ObjectLink_Personal_PositionLevel.DescId   = zc_ObjectLink_Personal_PositionLevel()
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = ObjectLink_Personal_PositionLevel.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                              ON ObjectLink_Personal_Member.ObjectId = tmpMI_Child.PersonalId
                             AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

         INNER JOIN ObjectString AS ObjectString_Phone
                                 ON ObjectString_Phone.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                AND ObjectString_Phone.DescId = zc_ObjectString_Member_Phone()
                                AND LENGTH (ObjectString_Phone.ValueData) = LENGTH ('380503201234')
    -- LIMIT 1
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.06.23         *
*/


-- тест
-- SELECT * FROM gpReport_Personal_Cash_sms (inStartDate:= '20.10.2025'::TDateTime, inEndDate:= '20.10.2025'::TDateTime, inSession:= '9457'::TVarChar);
