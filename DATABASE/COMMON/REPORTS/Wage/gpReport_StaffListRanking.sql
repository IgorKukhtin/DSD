-- По документу Штатное расписание
-- Function: gpReport_StaffListRanking ()

DROP FUNCTION IF EXISTS gpReport_StaffListRanking (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_StaffListRanking (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_StaffListRanking(
    IN inStartDate      TDateTime , --
    IN inUnitId         Integer,   --подразделение
    IN inDepartmentId   Integer,   --Департамент
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
              DepartmentId         Integer
            , DepartmentName       TVarChar
            , UnitId               Integer
            , UnitName             TVarChar
            , PositionId           Integer
            , PositionName         TVarChar
            , PositionLevelId      Integer
            , PositionLevelName    TVarChar
            , PositionPropertyName TVarChar  --Классификатор должности
            , PersonalId           Integer   --Менеджер по персоналу
            , PersonalName         TVarChar  --

            , StaffHoursDayName    TVarChar  --График работы
            , StaffHoursName       TVarChar  --Години роботи
            , AmountPlan           TFloat    --План ШР (по классификатору)
            , AmountFact           TFloat    --Факт ШР
            , AmountFact_add       TFloat    --факт совместительство
            , Amount_diff          TFloat    --Дельта
            , Persent_diff         TFloat    --% комлектації
            , MemberName           Text
            , MemberName_add       Text
            , Vacancy              TVarChar  --произнак есть ли вакансия  на должности

              -- Цвет Вакансия - если есть
            , Color_vacancy        Integer
              -- Цвет Дельта, красным если < 0
            , Color_diff           Integer
            , ColorFon_unit        Integer
            , Color_unit           Integer
            , BoldRecord_unit      Boolean

            , TotalPlan            TFloat
            , TotalFact            TFloat
            , Total_diff           TFloat
            , isTotal              Boolean  --строки с итогами
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
    -- Штатное план
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
                               -- Исключить из ШР
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Unit_notStaffList
                                                       ON ObjectBoolean_Unit_notStaffList.ObjectId  = MovementLinkObject_Unit.ObjectId
                                                      AND ObjectBoolean_Unit_notStaffList.DescId    = zc_ObjectBoolean_Unit_notStaffList()
                                                      AND ObjectBoolean_Unit_notStaffList.ValueData = TRUE
                                                   
                          WHERE Movement.DescId = zc_Movement_StaffList()
                            AND Movement.OperDate <= inStartDate --AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                            AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                            AND (ObjectLink_Unit_Department.ChildObjectId = inDepartmentId OR inDepartmentId = 0)
                            -- Исключить из ШР
                            AND ObjectBoolean_Unit_notStaffList.ObjectId IS NULL
                         ) AS tmp
                    WHERE tmp.Ord = 1
                    )
    -- Штатное строки план
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
  /*, tmpFact AS (SELECT COUNT (*) AS Amount

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
                )*/

    -- Штатное факт
  , tmpFact AS (WITH
               --все документы
                tmpMovement_all AS (SELECT *
                                       
                                    FROM Movement
                                                                    
                                    WHERE Movement.DescId = zc_Movement_StaffListMember()
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                      AND Movement.OperDate <= inStartDate
                                    )
           
              , tmpMovementBoolean AS (SELECT MovementBoolean.*
                                       FROM MovementBoolean
                                       WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all) 
                                         AND MovementBoolean.DescId IN (zc_MovementBoolean_Main())
                                       )       
           
              , tmpMLO AS (SELECT MovementLinkObject.*
                           FROM MovementLinkObject
                           WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all) 
                             AND MovementLinkObject.DescId IN (zc_MovementLinkObject_StaffListKind() 
                                                             , zc_MovementLinkObject_Member()
                                                             , zc_MovementLinkObject_Position()
                                                             , zc_MovementLinkObject_PositionLevel()
                                                             , zc_MovementLinkObject_Unit()
                                                              )
                           )
               --все докум. т.к. могут быть перводы и увольнения
              , tmpMovement AS (SELECT tmpMovement_all.*
                                     , MovementLinkObject_Member.ObjectId        AS MemberId
                                     , MovementLinkObject_StaffListKind.ObjectId AS StaffListKindId               
                                     , COALESCE (MovementBoolean_Main.ValueData, FALSE)     ::Boolean  AS isMain
                                     , MovementLinkObject_Position.ObjectId      AS PositionId
                                     , MovementLinkObject_PositionLevel.ObjectId AS PositionLevelId
                                     , MovementLinkObject_Unit.ObjectId          AS UnitId
                                FROM tmpMovement_all 

                                     LEFT JOIN tmpMovementBoolean AS MovementBoolean_Main
                                                                  ON MovementBoolean_Main.MovementId = tmpMovement_all.Id
                                                                 AND MovementBoolean_Main.DescId = zc_MovementBoolean_Main()  

                                     LEFT JOIN tmpMLO AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = tmpMovement_all.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                    
                                     LEFT JOIN tmpMLO AS MovementLinkObject_Member
                                                      ON MovementLinkObject_Member.MovementId = tmpMovement_all.Id
                                                     AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member() 
                                                      
                                                   
                                     LEFT JOIN tmpMLO AS MovementLinkObject_StaffListKind
                                                      ON MovementLinkObject_StaffListKind.MovementId = tmpMovement_all.Id
                                                     AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind()-- and 1=0
           
                                     LEFT JOIN tmpMLO AS MovementLinkObject_Position
                                                      ON MovementLinkObject_Position.MovementId = tmpMovement_all.Id
                                                     AND MovementLinkObject_Position.DescId = zc_MovementLinkObject_Position()-- and 1=0
           
                                     LEFT JOIN tmpMLO AS MovementLinkObject_PositionLevel
                                                      ON MovementLinkObject_PositionLevel.MovementId = tmpMovement_all.Id
                                                     AND MovementLinkObject_PositionLevel.DescId = zc_MovementLinkObject_PositionLevel()
                                )

  
             --выбираем для isMain=True последний документ приема (для понимания когда принят на работу) 
              , tmpMovement_main_in AS (SELECT * 
                                        FROM (SELECT *
                                                   , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                              FROM tmpMovement
                                              WHERE tmpMovement.isMain = TRUE
                                                AND tmpMovement.StaffListKindId IN (zc_Enum_StaffListKind_In(),zc_Enum_StaffListKind_Add())
                                              ) AS tmp
                                        WHERE tmp.ord = 1
                                        )
               --прием посовместительству все документы 
              , tmpMovement_add AS (SELECT * 
                                    FROM (SELECT *
                                               , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                          FROM tmpMovement
                                          WHERE tmpMovement.isMain = FALSE
                                            AND tmpMovement.StaffListKindId IN (zc_Enum_StaffListKind_In(),zc_Enum_StaffListKind_Add())
                                          ) AS tmp
                                    )  
              --выбираем для isMain=True последний документ перевода  
              , tmpMovement_main_send AS (SELECT * 
                                          FROM (SELECT *
                                                     , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                                FROM tmpMovement
                                                WHERE tmpMovement.isMain = TRUE
                                                  AND tmpMovement.StaffListKindId = zc_Enum_StaffListKind_Send()  
                                                ) AS tmp
                                          WHERE tmp.ord = 1
                                          )
              --выбираем для isMain=True последний документ увольнения  
              , tmpMovement_main_out AS (SELECT * 
                                          FROM (SELECT *
                                                     , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                                FROM tmpMovement
                                                WHERE tmpMovement.isMain = TRUE
                                                  AND tmpMovement.StaffListKindId = zc_Enum_StaffListKind_Out()  
                                                ) AS tmp
                                          WHERE tmp.ord = 1
                                          )
           
              --выбираем для isMain=FALSE ВСЕ документы увольнения  
              , tmpMovement_Nomain_out AS (SELECT * 
                                          FROM (SELECT *
                                                     , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                                FROM tmpMovement
                                                WHERE tmpMovement.isMain = FALSE
                                                  AND tmpMovement.StaffListKindId = zc_Enum_StaffListKind_Out()  
                                                ) AS tmp
                                          )
           
              , tmpMember_byMovement AS (SELECT DISTINCT tmpMovement.MemberId
                                         FROM tmpMovement
                                         WHERE tmpMovement.isMain = TRUE
                                         )
             --данные по физ лицу - прием, перевод, совмещение без уволенных
             , tmpData AS (--основное место работы 
                           SELECT CASE WHEN COALESCE (Movement_send.Id,0) <> 0 THEN COALESCE (Movement_send.UnitId, 0)
                                       WHEN COALESCE (Movement_in.Id,0) <> 0 THEN COALESCE (Movement_in.UnitId, 0)
                                  END  AS UnitId 
                                
                                , CASE WHEN COALESCE (Movement_send.Id,0) <> 0 THEN COALESCE (Movement_send.PositionId, 0)
                                       WHEN COALESCE (Movement_in.Id,0) <> 0 THEN COALESCE (Movement_in.PositionId, 0)
                                  END  AS PositionId
                                , CASE WHEN COALESCE (Movement_send.Id,0) <> 0 THEN COALESCE (Movement_send.PositionLevelId, 0)
                                       WHEN COALESCE (Movement_in.Id,0) <> 0 THEN COALESCE (Movement_in.PositionLevelId, 0)
                                  END  AS PositionLevelId
                                , TRUE AS isMain
          
                                , Object_Member.ValueData AS MemberName
                                , NULL ::TVarChar         AS MemberName_add
                                , 1 ::TFloat AS Amount
                                , 0 ::TFloat AS Amount_add
                           FROM tmpMember_byMovement AS tmpMember
                                LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMember.MemberId
                                LEFT JOIN tmpMovement_main_in   AS Movement_in ON Movement_in.MemberId = tmpMember.MemberId
                                LEFT JOIN tmpMovement_main_send AS Movement_send ON Movement_send.MemberId = tmpMember.MemberId
                                                               AND Movement_send.OperDate >= Movement_in.OperDate 
                                LEFT JOIN tmpMovement_main_out  AS Movement_out ON Movement_out.MemberId = tmpMember.MemberId
                                                               AND Movement_out.OperDate > Movement_in.OperDate
                           WHERE COALESCE (Movement_out.OperDate, zc_DateEnd()) = zc_DateEnd()
                        UNION
                           SELECT tmpMovement_add.UnitId
                                , tmpMovement_add.PositionId
                                , tmpMovement_add.PositionLevelId 
                                , FALSE      AS isMain
          
                                , NULL ::TVarChar AS MemberName
                                , Object_Member.ValueData AS MemberName_add
                                , 0 ::TFloat AS Amount
                                , 1 ::TFloat AS Amount_add
                           FROM tmpMovement_add
                                LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMovement_add.MemberId
                                LEFT JOIN tmpMovement_Nomain_out AS Movement_out 
                                                                 ON Movement_out.MemberId = tmpMovement_add.MemberId
                                                                AND Movement_out.UnitId = tmpMovement_add.UnitId
                                                                AND Movement_out.PositionId = tmpMovement_add.PositionId
                                                                AND COALESCE (Movement_out.PositionLevelId,0) = COALESCE (tmpMovement_add.PositionLevelId,0)
                                                                AND Movement_out.OperDate > tmpMovement_add.OperDate
                           WHERE COALESCE (Movement_out.OperDate, zc_DateEnd()) = zc_DateEnd() 
                         )

                SELECT SUM (tmpData.Amount)                 AS Amount     --основное место работы
                     , SUM (COALESCE(tmpData.Amount_add,0)) AS Amount_add --совместительство
                     , ObjectLink_Unit_Department.ChildObjectId AS DepartmentId
                     , tmpData.UnitId
                     , tmpData.PositionId
                     , tmpData.PositionLevelId
                     , STRING_AGG ( COALESCE (tmpData.MemberName,'')
                                  , CHR (10) || CHR (13) order by tmpData.MemberName)     AS MemberName
                     , STRING_AGG ( COALESCE (tmpData.MemberName_add,'')
                                  , CHR (10) || CHR (13) order by tmpData.MemberName_add) AS MemberName_add
                FROM tmpData
                     INNER JOIN ObjectLink AS ObjectLink_Unit_Department
                                           ON ObjectLink_Unit_Department.ObjectId = tmpData.UnitId
                                          AND ObjectLink_Unit_Department.DescId = zc_ObjectLink_Unit_Department()
                                          AND (ObjectLink_Unit_Department.ChildObjectId = inDepartmentId OR inDepartmentId = 0)
                     -- Исключить из ШР
                     LEFT JOIN ObjectBoolean AS ObjectBoolean_Unit_notStaffList
                                             ON ObjectBoolean_Unit_notStaffList.ObjectId  = tmpData.UnitId
                                            AND ObjectBoolean_Unit_notStaffList.DescId    = zc_ObjectBoolean_Unit_notStaffList()
                                            AND ObjectBoolean_Unit_notStaffList.ValueData = TRUE
 
                WHERE tmpData.UnitId = inUnitId OR inUnitId = 0
                  -- Исключить из ШР
                  AND ObjectBoolean_Unit_notStaffList.ObjectId IS NULL
                GROUP BY  ObjectLink_Unit_Department.ChildObjectId
                                    , tmpData.UnitId
                                    , tmpData.PositionId
                                    , tmpData.PositionLevelId
                )
  
  --было так
  /*(WITH
                tmp AS (SELECT MovementLinkObject_Unit.ObjectId          AS UnitId
                             , ObjectLink_Unit_Department.ChildObjectId  AS DepartmentId
                             , MovementLinkObject_Position.ObjectId      AS PositionId
                             , MovementLinkObject_PositionLevel.ObjectId AS PositionLevelId
                             , MovementBoolean_Main.ValueData            AS isMain
                             , MovementLinkObject_Member.ObjectId        AS MemberId
                             , Movement.Id                               AS MovementId
                             , Movement.OperDate                         AS OperDate
                             , MovementLinkObject_StaffListKind.ObjectId AS StaffListKindId
                             , ROW_NUMBER () OVER (PARTITION BY MovementLinkObject_Unit.ObjectId
                                                              , MovementLinkObject_Member.ObjectId
                                                              , CASE WHEN MovementBoolean_Main.ValueData = TRUE THEN 0 ELSE 1 END -- по гл. должности нужно взять 1, для по совместительству всех

                                                   ORDER BY Movement.OperDate DESC, Movement.Id DESC, CASE WHEN MovementBoolean_Main.ValueData = TRUE THEN 0 ELSE 1 END
                                                   ) AS Ord
                            --, 1 AS Amount
                        FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                        AND (MovementLinkObject_Unit.ObjectId IN (SELECT DISTINCT tmpMovement.UnitId FROM tmpMovement)
                                                          OR inUnitId = 0
                                                            )
                           INNER JOIN ObjectLink AS ObjectLink_Unit_Department
                                                 ON ObjectLink_Unit_Department.ObjectId = MovementLinkObject_Unit.ObjectId
                                                AND ObjectLink_Unit_Department.DescId = zc_ObjectLink_Unit_Department()
                                                AND (ObjectLink_Unit_Department.ChildObjectId = inDepartmentId OR inDepartmentId = 0)

                           -- Исключить из ШР
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Unit_notStaffList
                                                   ON ObjectBoolean_Unit_notStaffList.ObjectId  = MovementLinkObject_Unit.ObjectId
                                                  AND ObjectBoolean_Unit_notStaffList.DescId    = zc_ObjectBoolean_Unit_notStaffList()
                                                  AND ObjectBoolean_Unit_notStaffList.ValueData = TRUE

                           INNER JOIN MovementLinkObject AS MovementLinkObject_StaffListKind
                                                         ON MovementLinkObject_StaffListKind.MovementId = Movement.Id
                                                        AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind()
                                                        --AND MovementLinkObject_StaffListKind.ObjectId

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Position
                                                        ON MovementLinkObject_Position.MovementId = Movement.Id
                                                       AND MovementLinkObject_Position.DescId = zc_MovementLinkObject_Position()
                           LEFT JOIN Object AS Object_Position ON Object_Position.Id = MovementLinkObject_Position.ObjectId

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PositionLevel
                                                        ON MovementLinkObject_PositionLevel.MovementId = Movement.Id
                                                       AND MovementLinkObject_PositionLevel.DescId = zc_MovementLinkObject_PositionLevel()
                           LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = MovementLinkObject_PositionLevel.ObjectId

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                                        ON MovementLinkObject_Member.MovementId = Movement.Id
                                                       AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()

                           LEFT JOIN MovementBoolean AS MovementBoolean_Main
                                                     ON MovementBoolean_Main.MovementId = Movement.Id
                                                    AND MovementBoolean_Main.DescId = zc_MovementBoolean_Main()

                        WHERE Movement.DescId = zc_Movement_StaffListMember()
                          AND Movement.OperDate <= inStartDate
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          -- Исключить из ШР
                          AND ObjectBoolean_Unit_notStaffList.ObjectId IS NULL
                        )
                --определяем уволенных
              , tmp_Out AS (SELECT tmp.*
                            FROM tmp
                            WHERE tmp.StaffListKindId = zc_Enum_StaffListKind_Out()
                              AND tmp.OperDate <= inStartDate
                            )
              , tmp_add AS (SELECT SUM (tmp.Amount_add) AS Amount_add --совместительство
                                 , tmp.UnitId
                                 , tmp.PositionId
                                 , COALESCE (tmp.PositionLevelId,0) AS PositionLevelId
                                 , STRING_AGG ( Object_Member.ValueData
                                              , CHR (10)||CHR (13) order by Object_Member.ValueData) AS MemberName_add
                            FROM (
                                  SELECT tmp.*
                                      , 1 ::TFloat AS Amount_add
                                  FROM tmp
                                      LEFT JOIN tmp AS tmp1 ON tmp1.OperDate = tmp.OperDate
                                                           AND tmp1.UnitId = tmp.UnitId
                                                           AND tmp1.PositionId = tmp.PositionId
                                                           AND tmp1.PositionLevelId = tmp.PositionLevelId
                                                           AND tmp1.MemberId = tmp.MemberId
                                                           AND tmp1.isMain = TRUE
                                      LEFT JOIN tmp_Out ON tmp_Out.OperDate >= tmp.OperDate
                                                       AND tmp_Out.UnitId = tmp.UnitId
                                                       AND tmp_Out.PositionId = tmp.PositionId
                                                       AND tmp_Out.PositionLevelId = tmp.PositionLevelId
                                                       AND tmp_Out.MemberId = tmp.MemberId
                                                       AND tmp_Out.isMain = FALSE
                                  WHERE (tmp.isMain = FALSE)
                                    AND tmp.StaffListKindId <> zc_Enum_StaffListKind_Out()
                                    AND tmp1.MemberId IS NULL
                                    AND tmp_Out.MemberId IS NULL
                                 ) AS tmp
                                 LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmp.MemberId
                            GROUP BY tmp.UnitId
                                   , tmp.PositionId
                                   , COALESCE (tmp.PositionLevelId,0)
                            )


                SELECT SUM (tmp.Amount)         AS Amount
                     , COALESCE(tmp_add.Amount_add,0) AS Amount_add --совместительство
                     , tmp.DepartmentId
                     , tmp.UnitId
                     , tmp.PositionId
                     , tmp.PositionLevelId
                     , STRING_AGG ( tmp.MemberName
                                  , CHR (10) || CHR (13) order by tmp.MemberName) AS MemberName
                     , tmp_add.MemberName_add
                FROM (SELECT tmp.*
                          , Object_Member.ValueData AS MemberName
                          , 1 ::TFloat AS Amount
                      FROM tmp
                           LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmp.MemberId

                           LEFT JOIN tmp_Out ON tmp_Out.OperDate >= tmp.OperDate
                                            AND tmp_Out.UnitId = tmp.UnitId
                                            AND tmp_Out.PositionId = tmp.PositionId
                                            AND tmp_Out.PositionLevelId = tmp.PositionLevelId
                                            AND tmp_Out.MemberId = tmp.MemberId
                                            AND tmp_Out.isMain = TRUE

                      WHERE (tmp.isMain = TRUE AND tmp.Ord = 1)
                       AND tmp.StaffListKindId <> zc_Enum_StaffListKind_Out()
                       AND tmp_Out.MemberId IS NULL
                    ) AS tmp
                     LEFT JOIN tmp_add ON tmp_add.UnitId = tmp.UnitId
                                      AND tmp_add.PositionId = tmp.PositionId
                                      AND tmp_add.PositionLevelId = tmp.PositionLevelId
                GROUP BY tmp.UnitId
                       , tmp.DepartmentId
                       , tmp.PositionId
                       , tmp.PositionLevelId
                       , COALESCE(tmp_add.Amount_add,0)
                       , tmp_add.MemberName_add
                )
 */
 --------***********


  , tmpData AS (SELECT Movement.DepartmentId
                     , Movement.UnitId
                     , MovementItem.ObjectId AS PositionId
                     , COALESCE (MILinkObject_PositionLevel.ObjectId,0) AS PositionLevelId
                     --, ROW_NUMBER() OVER (PARTITION BY Movement.DepartmentId, Movement.UnitId, MovementItem.ObjectId, COALESCE (MILinkObject_PositionLevel.ObjectId,0)) AS Ord

                     , MILinkObject_Personal.ObjectId           AS PersonalId
                     , MILinkObject_StaffHoursDay.ObjectId      AS StaffHoursDayId
                     , MILinkObject_StaffHours.ObjectId         AS StaffHoursId
                     , SUM (COALESCE (MIFloat_AmountReport.ValueData, 0)) ::TFloat AS AmountPlan         -- ШР для отчета из документа

                FROM tmpMovement AS Movement
                     LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId
                     LEFT JOIN Object AS Object_Department ON Object_Department.Id = Movement.DepartmentId

                     LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

                     LEFT JOIN tmpMILinkObject AS MILinkObject_PositionLevel
                                               ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                              AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()

                     LEFT JOIN tmpMILinkObject AS MILinkObject_StaffHoursDay
                                               ON MILinkObject_StaffHoursDay.MovementItemId = MovementItem.Id
                                              AND MILinkObject_StaffHoursDay.DescId = zc_MILinkObject_StaffHoursDay()

                     LEFT JOIN tmpMILinkObject AS MILinkObject_StaffHours
                                               ON MILinkObject_StaffHours.MovementItemId = MovementItem.Id
                                              AND MILinkObject_StaffHours.DescId = zc_MILinkObject_StaffHours()

                     LEFT JOIN tmpMILinkObject AS MILinkObject_Personal
                                               ON MILinkObject_Personal.MovementItemId = MovementItem.Id
                                              AND MILinkObject_Personal.DescId = zc_MILinkObject_Personal()

                     LEFT JOIN tmpMIFloat AS MIFloat_AmountReport
                                          ON MIFloat_AmountReport.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountReport.DescId = zc_MIFloat_AmountReport()
                GROUP BY Movement.DepartmentId
                       , Movement.UnitId
                       , MovementItem.ObjectId
                       , COALESCE (MILinkObject_PositionLevel.ObjectId,0)
                       , MILinkObject_Personal.ObjectId
                       , MILinkObject_StaffHoursDay.ObjectId
                       , MILinkObject_StaffHours.ObjectId
                     )
  , tmpResult AS (SELECT Object_Department.Id                          AS DepartmentId
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
                       , COALESCE (Movement.AmountPlan, 0) ::TFloat AS AmountPlan         -- ШР для отчета из документа
                       , tmpFact.Amount      ::TFloat    AS AmountFact         -- шт.ед. из спр. Сотрудники - основное место работы = Да, дата приема/увольнения считаем как раб. день, т.е. эту шт. ед. считаем в кол.факт
                       , tmpFact.Amount_add  ::TFloat    AS AmountFact_add     -- совместительство информационно
                       , (COALESCE (tmpFact.Amount,0) - COALESCE (Movement.AmountPlan, 0))  ::TFloat    AS Amount_diff
                       , CAST (CASE WHEN COALESCE (Movement.AmountPlan, 0) <> 0
                                    THEN (COALESCE (tmpFact.Amount,0)/COALESCE (Movement.AmountPlan, 0) * 100)
                                    ELSE 0
                               END
                               AS NUMERIC (16,0))   ::TFloat    AS Persent_diff
                       , tmpFact.MemberName
                       , tmpFact.MemberName_add
                  FROM tmpData AS Movement
                       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId
                       LEFT JOIN Object AS Object_Department ON Object_Department.Id = Movement.DepartmentId
                       LEFT JOIN Object AS Object_Position ON Object_Position.Id = Movement.PositionId
                       LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = Movement.PositionLevelId
                       LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = Movement.PersonalId
                       LEFT JOIN Object AS Object_StaffHoursDay ON Object_StaffHoursDay.Id = Movement.StaffHoursDayId
                       LEFT JOIN Object AS Object_StaffHours ON Object_StaffHours.Id = Movement.StaffHoursId

                       LEFT JOIN ObjectLink AS ObjectLink_Position_PositionProperty
                                            ON ObjectLink_Position_PositionProperty.ObjectId = Object_Position.Id
                                           AND ObjectLink_Position_PositionProperty.DescId = zc_ObjectLink_Position_PositionProperty()
                       LEFT JOIN Object AS Object_PositionProperty ON Object_PositionProperty.Id = ObjectLink_Position_PositionProperty.ChildObjectId

                       LEFT JOIN tmpFact ON tmpFact.UnitId = Movement.UnitId
                                        AND tmpFact.PositionId = Movement.PositionId
                                        AND COALESCE (tmpFact.PositionLevelId,0) = COALESCE (Movement.PositionLevelId,0)
                                        --AND Movement.Ord = 1
                 /* ORDER BY Object_Department.ValueData
                         , Object_Unit.ValueData
                         , Object_Position.ValueData
                         , Object_PositionLevel.ValueData
                         , tmpFact.MemberName
                         , tmpFact.MemberName_add    */
                -- Факт для которого нет плана
                 UNION
                  SELECT Object_Department.Id                          AS DepartmentId
                       , Object_Department.ValueData       ::TVarChar  AS DepartmentName
                       , Object_Unit.Id                    ::Integer   AS UnitId
                       , Object_Unit.ValueData             ::TVarChar  AS UnitName
                       , Object_Position.Id                ::Integer   AS PositionId
                       , Object_Position.ValueData         ::TVarChar  AS PositionName
                       , Object_PositionLevel.Id           ::Integer   AS PositionLevelId
                       , Object_PositionLevel.ValueData    ::TVarChar  AS PositionLevelName
                       , Object_PositionProperty.ValueData ::TVarChar  AS PositionPropertyName
                       , 0                                 ::Integer   AS PersonalId
                       , ''                                ::TVarChar  AS PersonalName
                       , ''                                ::TVarChar  AS StaffHoursDayName
                       , ''                                ::TVarChar  AS StaffHoursName
                       , 0                                 ::TFloat    AS AmountPlan         -- ШР для отчета из документа
                       , tmpFact.Amount                    ::TFloat    AS AmountFact         -- шт.ед. из спр. Сотрудники - основное место работы = Да, дата приема/увольнения считаем как раб. день, т.е. эту шт. ед. считаем в кол.факт
                       , tmpFact.Amount_add                ::TFloat    AS AmountFact_add     -- совместительство информационно
                       , (COALESCE (tmpFact.Amount,0))     ::TFloat    AS Amount_diff
                       , 0                                 ::TFloat    AS Persent_diff
                       , tmpFact.MemberName
                       , tmpFact.MemberName_add
                  FROM tmpFact
                       LEFT JOIN tmpData AS Movement
                                         ON Movement.UnitId = tmpFact.UnitId
                                        AND Movement.PositionId = tmpFact.PositionId
                                        AND COALESCE (Movement.PositionLevelId,0) = COALESCE (tmpFact.PositionLevelId,0)

                       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpFact.UnitId
                       LEFT JOIN Object AS Object_Department ON Object_Department.Id = tmpFact.DepartmentId
                       LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpFact.PositionId
                       LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmpFact.PositionLevelId
                       LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = Movement.PersonalId
                       LEFT JOIN Object AS Object_StaffHoursDay ON Object_StaffHoursDay.Id = Movement.StaffHoursDayId
                       LEFT JOIN Object AS Object_StaffHours ON Object_StaffHours.Id = Movement.StaffHoursId

                       LEFT JOIN ObjectLink AS ObjectLink_Position_PositionProperty
                                            ON ObjectLink_Position_PositionProperty.ObjectId = Object_Position.Id
                                           AND ObjectLink_Position_PositionProperty.DescId = zc_ObjectLink_Position_PositionProperty()
                       LEFT JOIN Object AS Object_PositionProperty ON Object_PositionProperty.Id = ObjectLink_Position_PositionProperty.ChildObjectId
                  WHERE Movement.PositionId IS NULL
                /*  ORDER BY Object_Department.ValueData
                         , Object_Unit.ValueData
                         , Object_Position.ValueData
                         , Object_PositionLevel.ValueData
                         , tmpFact.MemberName
                         , tmpFact.MemberName_add     */
           )



    -- результат
    SELECT tmpResult.DepartmentId
         , tmpResult.DepartmentName       ::TVarChar
         , tmpResult.UnitId               ::Integer
         , tmpResult.UnitName             ::TVarChar
         , tmpResult.PositionId           ::Integer
         , tmpResult.PositionName         ::TVarChar
         , tmpResult.PositionLevelId      ::Integer
         , tmpResult.PositionLevelName    ::TVarChar
         , tmpResult.PositionPropertyName ::TVarChar
         , tmpResult.PersonalId           ::Integer
         , tmpResult.PersonalName         ::TVarChar
         , tmpResult.StaffHoursDayName    ::TVarChar
         , tmpResult.StaffHoursName       ::TVarChar
         , tmpResult.AmountPlan           ::TFloat        -- ШР для отчета из документа
         , tmpResult.AmountFact           ::TFloat       -- шт.ед. из спр. Сотрудники - основное место работы = Да, дата приема/увольнения считаем как раб. день, т.е. эту шт. ед. считаем в кол.факт
         , tmpResult.AmountFact_add       ::TFloat
         , tmpResult.Amount_diff          ::TFloat
         , tmpResult.Persent_diff         ::TFloat
         , (tmpResult.MemberName || CASE WHEN COALESCE (tmpResult.Amount_diff,0) < 0 THEN CHR (10) || CHR (13)||'Вакансія'  ELSE '' END ) ::Text AS MemberName
         , tmpResult.MemberName_add       ::Text
         , CASE WHEN COALESCE (tmpResult.Amount_diff,0) < 0 THEN 'Вакансія' ELSE '' END ::TVarChar AS Vacancy

         , zc_Color_Black()  ::Integer AS Color_vacancy
         , CASE WHEN COALESCE (tmpResult.Amount_diff,0) < 0 THEN zc_Color_Red() ELSE zc_Color_Black() END ::Integer AS Color_diff
         , zc_Color_White()  ::Integer AS ColorFon_unit
         , zc_Color_Black()  ::Integer AS Color_unit
         , FALSE ::Boolean AS BoldRecord_unit

         , 0    :: TFloat AS TotalPlan
         , 0    :: TFloat AS TotalFact
         , 0    :: TFloat AS Total_diff
         , FALSE ::Boolean AS isTotal
    FROM tmpResult
    WHERE tmpResult.MemberName IS NOT NULL
  UNION
    SELECT tmpResult.DepartmentId
         , tmpResult.DepartmentName       ::TVarChar
         , tmpResult.UnitId               ::Integer
         , tmpResult.UnitName             ::TVarChar
         , tmpResult.PositionId           ::Integer
         , tmpResult.PositionName         ::TVarChar
         , tmpResult.PositionLevelId      ::Integer
         , tmpResult.PositionLevelName    ::TVarChar
         , tmpResult.PositionPropertyName ::TVarChar
         , tmpResult.PersonalId           ::Integer
         , tmpResult.PersonalName         ::TVarChar
         , tmpResult.StaffHoursDayName    ::TVarChar
         , tmpResult.StaffHoursName       ::TVarChar
         , CASE WHEN tmpMember.MemberName IS NULL THEN tmpResult.AmountPlan ELSE 0 END     ::TFloat AS AmountPlan      -- ШР для отчета из документа
         , CASE WHEN tmpMember.MemberName IS NULL THEN tmpResult.AmountFact ELSE 0 END     ::TFloat AS AmountFact     -- шт.ед. из спр. Сотрудники - основное место работы = Да, дата приема/увольнения считаем как раб. день, т.е. эту шт. ед. считаем в кол.факт
         , CASE WHEN tmpMember.MemberName IS NULL THEN tmpResult.AmountFact_add ELSE 0 END ::TFloat AS AmountFact_add
         , CASE WHEN tmpMember.MemberName IS NULL THEN tmpResult.Amount_diff ELSE 0 END    ::TFloat AS Amount_diff
         , CASE WHEN tmpMember.MemberName IS NULL THEN tmpResult.Persent_diff ELSE 0 END   ::TFloat AS Persent_diff
         , 'Вакансія'   ::Text       AS MemberName
         , ''           ::Text       AS MemberName_add
         , 'Вакансія'    ::TVarChar   AS Vacancy

         , zc_Color_Red()    ::Integer AS Color_vacancy
         , zc_Color_Red()    ::Integer AS Color_diff
         , zc_Color_White()  ::Integer AS ColorFon_unit
         , zc_Color_Black()  ::Integer AS Color_unit
         , FALSE             ::Boolean AS BoldRecord_unit

         , 0               :: TFloat AS TotalPlan
         , 0               :: TFloat AS TotalFact
         , 0               :: TFloat AS Total_diff
         , FALSE ::Boolean AS isTotal
    FROM tmpResult
         LEFT JOIN tmpResult AS tmpMember
                             ON tmpMember.MemberName IS NOT NULL
                            AND tmpMember.UnitId = tmpResult.UnitId
                            AND tmpMember.PositionId = tmpResult.PositionId
                            AND COALESCE (tmpMember.PositionLevelId,0) = COALESCE (tmpResult.PositionLevelId,0)
    WHERE COALESCE (tmpResult.Amount_diff, 0) < 0
      AND tmpMember.MemberName IS NULL
  UNION
    -- 1) итого план 2) итого факт 3)итого дельта
    SELECT tmpResult.DepartmentId
         , tmpResult.DepartmentName       ::TVarChar
         , tmpResult.UnitId               ::Integer
         , tmpResult.UnitName             ::TVarChar
         , 0      ::Integer  AS PositionId
         , ''     ::TVarChar AS PositionName
         , 0      ::Integer  AS PositionLevelId
         , ''     ::TVarChar AS PositionLevelName
         , ''     ::TVarChar AS PositionPropertyName    
         , 0      ::Integer  AS PersonalId
         , ''     ::TVarChar AS PersonalName
         , ''     ::TVarChar AS StaffHoursDayName
         , ''     ::TVarChar AS StaffHoursName

--       , 0      ::TFloat   AS AmountPlan                -- ШР для отчета из документа
--       , 0      ::TFloat   AS AmountFact               -- шт.ед. из спр. Сотрудники - основное место работы = Да, дата приема/увольнения считаем как раб. день, т.е. эту шт. ед. считаем в кол.факт
         , SUM (COALESCE (tmpResult.AmountPlan,0))    :: TFloat AS AmountPlan
         , SUM (COALESCE (tmpResult.AmountFact,0))    :: TFloat AS AmountFact
         , 0                                          :: TFloat AS AmountFact_add

--       , 0      ::TFloat   AS Amount_diff
         , (SUM (COALESCE (tmpResult.AmountFact,0)) - SUM (COALESCE (tmpResult.AmountPlan,0))) :: TFloat AS Amount_diff

         , CAST (CASE WHEN SUM (COALESCE (tmpResult.AmountPlan, 0)) <> 0
                      THEN (SUM (COALESCE (tmpResult.AmountFact,0)) / SUM (COALESCE (tmpResult.AmountPlan, 0)) * 100)
                      ELSE 0
                 END
                 AS NUMERIC (16,0))   ::TFloat    AS Persent_diff

         , ''     ::Text     AS MemberName
         , ''     ::Text     AS MemberName_add
         , ''     ::TVarChar AS Vacancy

         , zc_Color_Black()  ::Integer AS Color_vacancy
         , CASE WHEN SUM (COALESCE (tmpResult.AmountFact,0)) - SUM (COALESCE (tmpResult.AmountPlan,0)) < 0 THEN zc_Color_Red() ELSE zc_Color_Black() END ::Integer AS Color_diff
         , zc_Color_Yelow()  ::Integer AS ColorFon_unit
         , zc_Color_Blue()   ::Integer AS Color_unit
         , TRUE              ::Boolean AS BoldRecord_unit

         , SUM (COALESCE (tmpResult.AmountPlan,0))    :: TFloat AS TotalPlan
         , SUM (COALESCE (tmpResult.AmountFact,0))    :: TFloat AS TotalFact
         , (SUM (COALESCE (tmpResult.AmountFact,0)) - SUM (COALESCE (tmpResult.AmountPlan,0))) :: TFloat AS Total_diff
         , TRUE ::Boolean AS isTotal
    FROM tmpResult
    GROUP BY tmpResult.DepartmentId
           , tmpResult.DepartmentName
           , tmpResult.UnitId
           , tmpResult.UnitName

   --- добавить строки Вакансия, если кол-во факт меньше штатного

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
-- SELECT * FROM gpReport_StaffListRanking (inStartDate:= '02.10.2025'::TDateTime, inUnitId := 7271510 , inDepartmentId := 0 , inSession := '5');



/*

    WITH
    --все документы
     tmpMovement_all AS (SELECT *
                             , MovementLinkObject_Unit.ObjectId AS UnitId
                         FROM Movement
                                                         
                         WHERE Movement.DescId = zc_Movement_StaffListMember()
                           AND Movement.StatusId = zc_Enum_Status_Complete() --zc_Enum_Status_Erased()
                           AND Movement.OperDate <= inStartDate
                         )

   , tmpMovementBoolean AS (SELECT MovementBoolean.*
                            FROM MovementBoolean
                            WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all) 
                              AND MovementBoolean.DescId IN (zc_MovementBoolean_Official()
                                                           , zc_MovementBoolean_Main()
                                                            )
                            )       

   , tmpMovementDate AS (SELECT MovementDate.*
                         FROM MovementDate
                         WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all) 
                           AND MovementDate.DescId IN (zc_MovementDate_Insert()
                                                        , zc_MovementDate_Update()
                                                         )
                         )
   , tmpMLO AS (SELECT MovementLinkObject.*
                FROM MovementLinkObject
                WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all) 
                  AND MovementLinkObject.DescId IN (zc_MovementLinkObject_StaffListKind() 
                                                  , zc_MovementLinkObject_Member()
                                                  , zc_MovementLinkObject_Position()
                                                  , zc_MovementLinkObject_PositionLevel()
                                                  , zc_MovementLinkObject_Unit()
                                                   )
                )
     --все докум. 
   , tmpMovement AS (SELECT tmpMovement_all.*
                          , MovementLinkObject_Member.ObjectId        AS MemberId
                          , MovementLinkObject_StaffListKind.ObjectId AS StaffListKindId        --zc_Enum_StaffListKind_Send()  zc_Enum_StaffListKind_Out() zc_Enum_StaffListKind_Add() zc_Enum_StaffListKind_In()                   
                          , COALESCE (MovementBoolean_Official.ValueData, FALSE) ::Boolean  AS isOfficial
                          , COALESCE (MovementBoolean_Main.ValueData, FALSE)     ::Boolean  AS isMain
                          , MovementLinkObject_Position.ObjectId      AS PositionId
                          , MovementLinkObject_PositionLevel.ObjectId AS PositionLevelId
                          , MovementLinkObject_Unit.ObjectId          AS UnitId
                     FROM tmpMovement_all 
                          LEFT JOIN tmpMLO AS MovementLinkObject_Unit
                                           ON MovementLinkObject_Unit.MovementId = tmpMovement_all.Id
                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         
                          LEFT JOIN tmpMLO AS MovementLinkObject_Member
                                            ON MovementLinkObject_Member.MovementId = tmpMovement_all.Id
                                           AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member() 
                                           
                          LEFT JOIN tmpMovementBoolean AS MovementBoolean_Main
                                                       ON MovementBoolean_Main.MovementId = tmpMovement_all.Id
                                                      AND MovementBoolean_Main.DescId = zc_MovementBoolean_Main()  
                                        
                          LEFT JOIN tmpMLO AS MovementLinkObject_StaffListKind
                                           ON MovementLinkObject_StaffListKind.MovementId = tmpMovement_all.Id
                                          AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind() --and 1=0

                          LEFT JOIN tmpMovementBoolean AS MovementBoolean_Official
                                         ON MovementBoolean_Official.MovementId = tmpMovement_all.Id
                                        AND MovementBoolean_Official.DescId = zc_MovementBoolean_Official()-- and 1=0
  
                          LEFT JOIN tmpMLO AS MovementLinkObject_Position
                                           ON MovementLinkObject_Position.MovementId = tmpMovement_all.Id
                                          AND MovementLinkObject_Position.DescId = zc_MovementLinkObject_Position()-- and 1=0

                          LEFT JOIN tmpMLO AS MovementLinkObject_PositionLevel
                                           ON MovementLinkObject_PositionLevel.MovementId = tmpMovement_all.Id
                                          AND MovementLinkObject_PositionLevel.DescId = zc_MovementLinkObject_PositionLevel()
                    --
                    /* WHERE (MovementLinkObject_Unit.ObjectId = inUnitId  OR inUnitId = 0)
                       AND COALESCE (MovementBoolean_Main.ValueData, FALSE) = TRUE  
                    */
                     )

  
   --выбираем для isMain=True последний документ приема (для понимания когда принят на работу) 
   , tmpMovement_main_in AS (SELECT * 
                             FROM (SELECT *
                                        , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                   FROM tmpMovement
                                   WHERE tmpMovement.isMain = TRUE
                                     AND tmpMovement.StaffListKindId IN (zc_Enum_StaffListKind_In(),zc_Enum_StaffListKind_Add())
                                   ) AS tmp
                             WHERE tmp.ord = 1
                             )
   --прием посовместительству все документы 
      , tmpMovement_add AS (SELECT * 
                            FROM (SELECT *
                                       , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                  FROM tmpMovement
                                  WHERE tmpMovement.isMain = FALSE
                                    AND tmpMovement.StaffListKindId IN (zc_Enum_StaffListKind_In(),zc_Enum_StaffListKind_Add())
                                  ) AS tmp
                            --WHERE tmp.ord = 1
                            )  
   --выбираем для isMain=True последний документ перевода  
   , tmpMovement_main_send AS (SELECT * 
                               FROM (SELECT *
                                          , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                     FROM tmpMovement
                                     WHERE tmpMovement.isMain = TRUE
                                       AND tmpMovement.StaffListKindId = zc_Enum_StaffListKind_Send()  
                                     ) AS tmp
                               WHERE tmp.ord = 1
                               )
   --выбираем для isMain=True последний документ увольнения  
   , tmpMovement_main_out AS (SELECT * 
                               FROM (SELECT *
                                          , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                     FROM tmpMovement
                                     WHERE tmpMovement.isMain = TRUE
                                       AND tmpMovement.StaffListKindId = zc_Enum_StaffListKind_Out()  
                                     ) AS tmp
                               WHERE tmp.ord = 1
                               )

   --выбираем для isMain=FALSE документы увольнения  
   , tmpMovement_Nomain_out AS (SELECT * 
                               FROM (SELECT *
                                          , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                     FROM tmpMovement
                                     WHERE tmpMovement.isMain = TRUE
                                       AND tmpMovement.StaffListKindId = zc_Enum_StaffListKind_Out()  
                                     ) AS tmp
                               WHERE tmp.ord = 1
                               )
   , tmpPersonal_main AS (SELECT *
                          FROM (SELECT tmpViewPersonal.*
                                     , ROW_NUMBER() OVER (PARTITION BY tmpViewPersonal.MemberId ORDER BY COALESCE (tmpViewPersonal.DateSend, tmpViewPersonal.DateIn) DESC) AS Ord
                                     --, Count() OVER (PARTITION BY tmpViewPersonal.MemberId) AS Count
                                FROM tmpViewPersonal
                                WHERE tmpViewPersonal.isMain = TRUE
                                ) AS tmp
                          WHERE tmp.Ord = 1
                          )

   , tmpMember_byMovement AS (SELECT DISTINCT tmpMovement.MemberId
                              FROM tmpMovement
                              WHERE tmpMovement.isMain = TRUE
                              )
   --данные по физ лицу - прием, перевод, увольнение
   , tmpData AS (--основное место работы 
                 SELECT CASE WHEN COALESCE (Movement_send.Id,0) <> 0 THEN COALESCE (Movement_send.UnitId, 0)
                             WHEN COALESCE (Movement_in.Id,0) <> 0 THEN COALESCE (Movement_in.UnitId, 0)
                        END  AS UnitId 
                      
                      , CASE WHEN COALESCE (Movement_send.Id,0) <> 0 THEN COALESCE (Movement_send.PositionId, 0)
                             WHEN COALESCE (Movement_in.Id,0) <> 0 THEN COALESCE (Movement_in.PositionId, 0)
                        END  AS PositionId
                      , CASE WHEN COALESCE (Movement_send.Id,0) <> 0 THEN COALESCE (Movement_send.PositionLevelId, 0)
                             WHEN COALESCE (Movement_in.Id,0) <> 0 THEN COALESCE (Movement_in.PositionLevelId, 0)
                        END  AS PositionLevelId
                      , TRUE AS isMain
                      , tmpMember.MemberId
                      , Object_Member.ValueData
                      , 1 ::TFloat AS Amount
                      , 0 ::TFloat AS Amount_add
                 FROM tmpMember_byMovement AS tmpMember
                      LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMember.MemberId
                      LEFT JOIN tmpMovement_main_in   AS Movement_in ON Movement_in.MemberId = tmpMember.MemberId
                      LEFT JOIN tmpMovement_main_send AS Movement_send ON Movement_send.MemberId = tmpMember.MemberId
                                                     AND Movement_send.OperDate >= Movement_in.OperDate 
                      LEFT JOIN tmpMovement_main_out  AS Movement_out ON Movement_out.MemberId = tmpMember.MemberId
                                                     AND Movement_out.OperDate > Movement_in.OperDate
                 WHERE COALESCE (Movement_out.OperDate, zc_DateEnd()) = zc_DateEnd()
               UNION
                 SELECT tmpMovement_add.UnitId
                      , tmpMovement_add.MemberId
                      , tmpMovement_add.PositionId
                      , tmpMovement_add.PositionLevelId 
                      , FALSE      AS isMain
                      , tmpMember.MemberId
                      , Object_Member.ValueData
                      , 0 ::TFloat AS Amount
                      , 1 ::TFloat AS Amount_add
                 FROM tmpMovement_add
                      LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMember.MemberId
                      LEFT JOIN tmpMovement_Nomain_out AS Movement_out 
                                                       ON Movement_out.MemberId = tmpMember.MemberId
                                                      AND Movement_out.UnitId = tmpMember.UnitId
                                                      AND Movement_out.PositionId = tmpMember.PositionId
                                                      AND COALESCE (Movement_out.PositionLevelId,0) = COALESCE (tmpMember.PositionLevelId,0)
                                                      AND Movement_out.OperDate > tmpMovement_add.OperDate
                 WHERE COALESCE (Movement_out.OperDate, zc_DateEnd()) = zc_DateEnd() 
               )

   SELECT *
   FROM tmpData
                              INNER JOIN ObjectLink AS ObjectLink_Unit_Department
                                                 ON ObjectLink_Unit_Department.ObjectId = tmpData.UnitId
                                                AND ObjectLink_Unit_Department.DescId = zc_ObjectLink_Unit_Department()
                                                AND (ObjectLink_Unit_Department.ChildObjectId = inDepartmentId OR inDepartmentId = 0) 
   WHERE tmpData.UnitId = inUnitId OR inUnitId = 0
   

*/