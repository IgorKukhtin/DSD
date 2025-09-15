-- По документу Штатное расписание изменение
-- Function: gpReport_StaffListMovement ()

DROP FUNCTION IF EXISTS gpReport_StaffListMovement (TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_StaffListMovement (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_StaffListMovement (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_StaffListMovement(
    IN inStartDate      TDateTime , --
    IN inUnitId         Integer,   --подразделение
    IN inDepartmentId   Integer,   --Департамент
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
              DepartmentId                   Integer
            , DepartmentName                 TVarChar
            , UnitId                         Integer
            , UnitName                       TVarChar
            , PositionId                     Integer
            , PositionName                   TVarChar
            , PositionLevelId                Integer
            , PositionLevelName              TVarChar
            , PositionPropertyName           TVarChar  --Классификатор должности 
            , PersonalId                     Integer   --Менеджер по персоналу 
            , PersonalName                   TVarChar  -- 
            , StaffHoursDayName              TVarChar  -- График работы
            , StaffHoursName                 TVarChar  --Години роботи
            , AmountPlan                     TFloat    --План ШР (по классификатору)
            , AmountFact                     TFloat    --Факт ШР
            , Amount_diff                    TFloat    --Дельта 
            , Persent_diff                   TFloat    -- % комлектації
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY

    WITH
    tmpMovement AS (SELECT tmp.*
                    FROM (SELECT Movement.* 
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                               , ObjectLink_Unit_Department.ChildObjectId AS DepartmentId
                               , ROW_NUMBER() OVER (PARTITION BY MovementLinkObject_Unit.ObjectId, MovementLinkObject_Unit.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Department
                                                    ON ObjectLink_Unit_Department.ObjectId = MovementLinkObject_Unit.ObjectId
                                                   AND ObjectLink_Unit_Department.DescId = zc_ObjectLink_Unit_Department()
                          WHERE Movement.DescId = zc_Movement_StaffList()
                            AND Movement.OperDate <= inStartDate --AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.StatusId <> zc_Enum_Status_Erased() 
                            AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                            AND (ObjectLink_Unit_Department.ChildObjectId = inDepartmentId OR inDepartmentId = 0)
                         ) AS tmp
                    WHERE tmp.Ord = 1
                    )
  , tmpMI AS (SELECT MovementItem.*
              FROM MovementItem
              WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE
              )  

  , tmpMILinkObject AS (SELECT MovementItemLinkObject.*
                        FROM MovementItemLinkObject
                        WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                          AND MovementItemLinkObject.DescId IN (zc_MILinkObject_PositionLevel()
                                                              , zc_MILinkObject_Personal()
                                                              , zc_MILinkObject_StaffHours()
                                                              , zc_MILinkObject_StaffHoursDay()
                                                              )
                       )

  , tmpMIFloat AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                      AND MovementItemFloat.DescId = zc_MIFloat_AmountReport()
                   )
  --факт шт.ед по спр. Сотрудников
  , tmpFact AS (SELECT COUNT (*) AS Amount
                   , ObjectLink_Personal_Unit.ChildObjectId           AS UnitId
                   , ObjectLink_Personal_Position.ChildObjectId       AS PositionId
                   , COALESCE (ObjectLink_Personal_PositionLevel.ChildObjectId, 0) AS PositionLevelId
                  
                FROM ObjectLink AS ObjectLink_Personal_Member
                   INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                         ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Member.ObjectId
                                        AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
                                        AND ObjectLink_Personal_Unit.ChildObjectId IN (SELECT DISTINCT tmpMovement.UnitId FROM tmpMovement)
                                   
                   LEFT JOIN ObjectDate AS ObjectDate_DateIn
                                        ON ObjectDate_DateIn.ObjectId = ObjectLink_Personal_Member.ObjectId
                                       AND ObjectDate_DateIn.DescId   = zc_ObjectDate_Personal_In()
                                       
                   LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                        ON ObjectDate_DateOut.ObjectId = ObjectLink_Personal_Member.ObjectId
                                       AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()

                   INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                            ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                           AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()
                                           AND COALESCE (ObjectBoolean_Main.ValueData, FALSE) = TRUE

                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                        ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Member.ObjectId
                                       AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()

                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                        ON ObjectLink_Personal_PositionLevel.ObjectId = ObjectLink_Personal_Member.ObjectId
                                       AND ObjectLink_Personal_PositionLevel.DescId   = zc_ObjectLink_Personal_PositionLevel()

                WHERE ObjectLink_Personal_Member.ChildObjectId > 0
                  AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                  AND COALESCE (ObjectDate_DateIn.ValueData, zc_DateEnd()) <= inStartDate
                  AND COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) >= inStartDate
                GROUP BY ObjectLink_Personal_Unit.ChildObjectId
                       , ObjectLink_Personal_Position.ChildObjectId 
                       , COALESCE (ObjectLink_Personal_PositionLevel.ChildObjectId,0) 
                )  
  , tmpData AS (SELECT Movement.DepartmentId
                     , Movement.UnitId
                     , MovementItem.Id       AS MovementItemId
                     , MovementItem.ObjectId AS PositionId
                     , COALESCE (MILinkObject_PositionLevel.ObjectId,0) AS PositionLevelId
                     , ROW_NUMBER() OVER (PARTITION BY Movement.DepartmentId, Movement.UnitId, MovementItem.ObjectId, COALESCE (MILinkObject_PositionLevel.ObjectId,0)) AS Ord
                FROM tmpMovement AS Movement
                     LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId
                     LEFT JOIN Object AS Object_Department ON Object_Department.Id = Movement.DepartmentId
                    
                     LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
            
                     LEFT JOIN tmpMILinkObject AS MILinkObject_PositionLevel
                                               ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                              AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                     )
  -- результат
    SELECT Object_Department.Id                          AS DepartmentId
         , Object_Department.ValueData       ::TVarChar  AS DepartmentName      
         , Object_Unit.Id                    ::Integer   AS UnitId              
         , Object_Unit.ValueData             ::TVarChar  AS UnitName            
         , Object_Position.Id                ::Integer   AS PositionId          
         , Object_Position.ValueData         ::TVarChar  AS PositionName        
         , Object_PositionLevel.Id           ::Integer   AS PositionLevelId     
         , Object_PositionLevel.ValueData    ::TVarChar  AS PositionLevelName   
         , Object_PositionProperty.ValueData ::TVarChar  AS PositionPropertyName
         , Object_Personal.Id                ::Integer   AS PersonalId
         , Object_Personal.ValueData         ::TVarChar  AS PersonalName        
         , Object_StaffHoursDay.ValueData    ::TVarChar  AS StaffHoursDayName   
         , Object_StaffHours.ValueData       ::TVarChar  AS StaffHoursName      
         , COALESCE (MIFloat_AmountReport.ValueData, 0) ::TFloat AS AmountPlan         -- ШР для отчета из документа     
         , tmpFact.Amount  ::TFloat    AS AmountFact         -- шт.ед. из спр. Сотрудники - основное место работы = Да, дата приема/увольнения считаем как раб. день, т.е. эту шт. ед. считаем в кол.факт 
         , (COALESCE (MIFloat_AmountReport.ValueData, 0) - COALESCE (tmpFact.Amount,0))  ::TFloat    AS Amount_diff
         , CAST (CASE WHEN COALESCE (MIFloat_AmountReport.ValueData, 0) <> 0 
                      THEN (COALESCE (tmpFact.Amount,0)/COALESCE (MIFloat_AmountReport.ValueData, 0) * 100)
                      ELSE 0
                 END
                 AS NUMERIC (16,0))   ::TFloat    AS Persent_diff 
    FROM tmpData AS Movement
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId
         LEFT JOIN Object AS Object_Department ON Object_Department.Id = Movement.DepartmentId
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = Movement.PositionId
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = Movement.PositionLevelId

         LEFT JOIN tmpMILinkObject AS MILinkObject_StaffHoursDay
                                   ON MILinkObject_StaffHoursDay.MovementItemId = Movement.MovementItemId
                                  AND MILinkObject_StaffHoursDay.DescId = zc_MILinkObject_StaffHoursDay()
         LEFT JOIN Object AS Object_StaffHoursDay ON Object_StaffHoursDay.Id = MILinkObject_StaffHoursDay.ObjectId

         LEFT JOIN tmpMILinkObject AS MILinkObject_StaffHours
                                   ON MILinkObject_StaffHours.MovementItemId = Movement.MovementItemId
                                  AND MILinkObject_StaffHours.DescId = zc_MILinkObject_StaffHours()
         LEFT JOIN Object AS Object_StaffHours ON Object_StaffHours.Id = MILinkObject_StaffHours.ObjectId

         LEFT JOIN tmpMILinkObject AS MILinkObject_Personal
                                   ON MILinkObject_Personal.MovementItemId = Movement.MovementItemId
                                  AND MILinkObject_Personal.DescId = zc_MILinkObject_Personal()
         LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MILinkObject_Personal.ObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Position_PositionProperty
                              ON ObjectLink_Position_PositionProperty.ObjectId = Object_Position.Id
                             AND ObjectLink_Position_PositionProperty.DescId = zc_ObjectLink_Position_PositionProperty()
         LEFT JOIN Object AS Object_PositionProperty ON Object_PositionProperty.Id = ObjectLink_Position_PositionProperty.ChildObjectId

         LEFT JOIN tmpMIFloat AS MIFloat_AmountReport                                                                                    
                              ON MIFloat_AmountReport.MovementItemId = Movement.MovementItemId
                             AND MIFloat_AmountReport.DescId = zc_MIFloat_AmountReport()   
         LEFT JOIN tmpFact ON tmpFact.UnitId = Movement.UnitId
                          AND tmpFact.PositionId = Movement.PositionId
                          AND COALESCE (tmpFact.PositionLevelId,0) = COALESCE (Movement.PositionLevelId,0)
                          AND Movement.Ord = 1
    ORDER BY Object_Department.ValueData
           , Object_Unit.ValueData  
           , Object_Position.ValueData
           , Object_PositionLevel.ValueData
    ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.25         *
*/
-- тест
-- select * from gpReport_StaffListMovement (inStartDate:= '26.07.2025'::TDateTime, inUnitId := 0 , inDepartmentId := 0 , inSession := '5');