-- Function: gpSelect_MovementItem_EmployeeScheduleVIP()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_EmployeeScheduleVIP(Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_EmployeeScheduleVIP(
    IN inMovementId  Integer      , -- ключ Документа
    IN inDate        TDateTime    ,
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE cur1 refcursor;
  DECLARE cur2 refcursor;
  DECLARE vbCurrDay Integer;
  DECLARE vbDate TDateTime;
  DECLARE i Integer;
  DECLARE vbQueryText Text;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

     inDate := DATE_TRUNC ('MONTH', inDate);

     -- Дни месяца
     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inDate), DATE_TRUNC ('MONTH', inDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;

     -- Заполняем сотрудников согласно графика
     CREATE TEMP TABLE tmpResult (Id Integer, UserId Integer, UserCode Integer, UserName TVarChar, Name0 TVarChar, Name1 TVarChar, Name2 TVarChar, IsErased Boolean) ON COMMIT DROP;

     WITH tmpMain AS (SELECT MovementItem.ID
                           , MovementItem.ObjectId      AS UserId
                           , MovementItem.IsErased
                      FROM Movement

                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                                  AND MovementItem.DescId = zc_MI_Master()

                      WHERE Movement.ID = inMovementId
                        AND (MovementItem.IsErased = FALSE OR inIsErased = TRUE OR COALESCE (inShowAll, False) = True)),
          tmpUseRole AS (SELECT ObjectUser.Id         AS UserId 
                         FROM ObjectLink AS ObjectLink_UserRole_Role
                         
                              INNER JOIN ObjectLink AS ObjectLink_UserRole_User 
                                                    ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
                                                   AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()

                              INNER JOIN Object AS ObjectUser 
                                                ON ObjectUser.Id = ObjectLink_UserRole_User.ChildObjectId
                                               AND ObjectUser.isErased = False

                         WHERE ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                           AND ObjectLink_UserRole_Role.ChildObjectId = zc_Enum_Role_VIPManager()
                           AND ObjectUser.Id NOT IN (SELECT tmpMain.UserId FROM tmpMain)
                           AND COALESCE (inShowAll, False) = True
                         )
           


     INSERT INTO tmpResult (Id, UserId, UserCode, UserName, Name0, Name1, Name2, IsErased)
     SELECT tmpMain.Id
          , tmpMain.UserId
          , Object_Member.ObjectCode
          , Object_Member.ValueData
          , 'Тип дня'::TVarChar                                     AS Name0
          , 'Приход'::TVarChar                                      AS Name1
          , 'Уход'::TVarChar                                        AS Name2    
          , COALESCE (tmpMain.IsErased, False)                      AS IsErased
     FROM tmpMain
          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ObjectId = tmpMain.UserId
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
     UNION ALL
     SELECT 0                         AS Id
          , tmpUseRole.UserId
          , Object_Member.ObjectCode
          , Object_Member.ValueData
          , 'Тип дня'::TVarChar                                     AS Name0
          , 'Приход'::TVarChar                                      AS Name1
          , 'Уход'::TVarChar                                        AS Name2        
          , False                                                   AS IsErased
     FROM tmpUseRole
          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ObjectId = tmpUseRole.UserId
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
     ;
     
     
     -- Заполняем данные
     I := 1;
     WHILE I <= date_part('DAY', inDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
     LOOP
       vbQueryText := 'ALTER TABLE tmpResult ADD COLUMN ChildID' || I::Text || ' Integer NOT NULL DEFAULT 0 ' ||
                                         ' , ADD COLUMN Value' || I::Text || ' TVarChar' ||
                                         ' , ADD COLUMN ValueStart' || I::Text || ' TVarChar' ||
                                         ' , ADD COLUMN ValueEnd' || I::Text || ' TVarChar' ||
                                         ' , ADD COLUMN TypeId' || I::Text || ' Integer NOT NULL DEFAULT '|| I::Text ||' ' ||
                                         ' , ADD COLUMN Color_CalcUser' || I::Text || ' Integer NOT NULL DEFAULT '|| zc_Color_White()::Text;

       EXECUTE vbQueryText;

       vbQueryText := 'UPDATE tmpResult SET ChildID'||I::Text||' = MI_Child.ChildID
                                          , Value'||I::Text||' = MI_Child.ShortName
                                          , ValueStart'||I::Text||' = MI_Child.Date_Start
                                          , ValueEnd'||I::Text||' = MI_Child.Date_End
                                          , Color_CalcUser'||I::Text||' = zc_Color_White()
                       FROM (SELECT
                                    MovementItem.Id                                AS Id
                                  , MovementItemChild.Id                           AS ChildID
                                  , MovementItemChild.ObjectId                     AS UnitId
                                  , PayrollTypeVIP_ShortName.ValueData             AS ShortName
                                  , TO_CHAR(MIDate_Start.ValueData, ''HH24:mi'')   AS Date_Start
                                  , TO_CHAR(MIDate_End.ValueData, ''HH24:mi'')     AS Date_End
                             FROM MovementItem

                                  INNER JOIN MovementItem AS MovementItemChild
                                                          ON MovementItemChild.MovementId = '||inMovementId::Text||'
                                                         AND MovementItemChild.Amount = '||I::Text||'
                                                         AND MovementItemChild.DescId = zc_MI_Child()
                                                         AND MovementItemChild.ParentId = MovementItem.ID

                                  LEFT JOIN ObjectString AS PayrollTypeVIP_ShortName
                                                         ON PayrollTypeVIP_ShortName.ObjectId = MovementItemChild.ObjectId
                                                        AND PayrollTypeVIP_ShortName.DescId = zc_ObjectString_PayrollTypeVIP_ShortName()

                                  LEFT JOIN MovementItemDate AS MIDate_Start
                                                             ON MIDate_Start.MovementItemId = MovementItemChild.Id
                                                            AND MIDate_Start.DescId = zc_MIDate_Start()

                                  LEFT JOIN MovementItemDate AS MIDate_End
                                                             ON MIDate_End.MovementItemId = MovementItemChild.Id
                                                            AND MIDate_End.DescId = zc_MIDate_End()
                                                            
                             WHERE MovementItem.MovementId = '||inMovementId::Text||'
                               AND MovementItem.DescId = zc_MI_Master()) AS MI_Child
                       WHERE tmpResult.Id = MI_Child.Id';

       EXECUTE vbQueryText;
       I := I + 1;
     END LOOP;
     
     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime,
                          ((EXTRACT(DAY FROM tmpOperDate.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField,
                          EXTRACT(DAY FROM tmpOperDate.OperDate)::TVarChar   AS ValueFieldUser
               FROM tmpOperDate
                   LEFT JOIN zfCalc_DayOfWeekName (tmpOperDate.OperDate) AS tmpWeekDay ON 1=1
                   LEFT JOIN gpSelect_Object_Calendar(tmpOperDate.OperDate,tmpOperDate.OperDate,inSession) tmpCalendar ON 1=1

      ;
     RETURN NEXT cur1;

     OPEN cur2 FOR
     SELECT *
     FROM tmpResult;

     RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_EmployeeScheduleVIP (Integer, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.09.21                                                       *
*/

-- тест
-- 
select * from gpSelect_MovementItem_EmployeeScheduleVIP(inMovementId := 24861838 , inDate := ('01.09.2021')::TDateTime , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');