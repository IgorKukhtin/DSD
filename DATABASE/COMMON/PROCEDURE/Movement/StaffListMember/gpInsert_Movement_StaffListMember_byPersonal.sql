-- Function: gpInsert_Movement_StaffListMember_byPersonal ()

DROP FUNCTION IF EXISTS gpInsert_Movement_StaffListMember_byPersonal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_StaffListMember_byPersonal(
    IN inParam               Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)     
                      
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_StaffListMember());
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили <Документ>
     PERFORM lpInsertUpdate_Movement_StaffListMember ( ioId                  := 0    ::Integer
                                                     , inInvNumber           := NULL ::TVarChar
                                                     , inOperDate            := tmp.OperDate
                                                     , inMemberId            := tmp.MemberId 
                                                     , inPositionId          := tmp.PositionId
                                                     , inPositionLevelId     := tmp.PositionLevelId    
                                                     , inUnitId              := tmp.UnitId             
                                                     , inPositionId_old      := tmp.PositionId_old         ::Integer 
                                                     , inPositionLevelId_old := tmp.PositionLevelId_old    ::Integer
                                                     , inUnitId_old          := tmp.UnitId_old             ::Integer     
                                                     , inReasonOutId         := 0    ::Integer   
                                                     , inStaffListKindId     := tmp.StaffListKindId    
                                                     , inisOfficial          := tmp.isOfficial         
                                                     , inisMain              := tmp.isMain             
                                                     , inComment             := ('Авто.'||tmp.Comment::TVarChar) ::TVarChar           
                                                     , inUserId              := vbUserId
                                                      )
     FROM (
           WITH
           tmpViewPersonal AS (SELECT *
                               FROM Object_Personal_View
                               WHERE Object_Personal_View.isERased = FALSE
                               )
           --вспомогательная, если есть перевод но нет второй записи с переводом - берем сотр. с большим Id 
         , tmp_PersonalDop AS (SELECT tmpViewPersonal.*
                                    , ROW_NUMBER() OVER (PARTITION BY tmpViewPersonal.MemberId ORDER BY tmpViewPersonal.PersonalId desc) AS Ord 
                               FROM tmpViewPersonal
                                    INNER JOIN tmpViewPersonal AS tmpMain
                                                              ON tmpMain.isMain = True
                                                             AND COALESCE (tmpMain.DateSend,zc_DateStart()) <> zc_DateStart()
                                                             AND tmpMain.PersonalId > tmpViewPersonal.PersonalId
                                                             AND tmpMain.MemberId = tmpViewPersonal.MemberId
                               WHERE tmpViewPersonal.isMain = FALSE 
                                 AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) = zc_DateStart() 
                               )
           --если в tmp_PersonalDop тогда берем просто макс не главный                    
         , tmp_PersonalDop2 AS (SELECT *
                                     , ROW_NUMBER() OVER (PARTITION BY tmpViewPersonal.MemberId ORDER BY tmpViewPersonal.PersonalId desc) AS Ord 
                                FROM tmpViewPersonal
                                WHERE tmpViewPersonal.isMain = FALSE 
                                  AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) = zc_DateStart() 
                               )

          --если несколько с одинаковой датой перевода берем с большим c которого перевели
         , tmp_PersonalSend AS (SELECT *
                                     , ROW_NUMBER() OVER (PARTITION BY tmpViewPersonal.MemberId ORDER BY tmpViewPersonal.PersonalId desc) AS Ord 
                                FROM tmpViewPersonal
                                WHERE tmpViewPersonal.isMain = FALSE 
                                  AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) <> zc_DateStart()
                                )

         , tmp AS (--новый и совместительство   inParam = 1
                   --основное м.р. без перевода
                   SELECT tmpViewPersonal.DateIn AS OperDate
                        , tmpViewPersonal.MemberId
                        , tmpViewPersonal.PersonalId 
                        , tmpViewPersonal.PositionId
                        , tmpViewPersonal.PositionLevelId    
                        , tmpViewPersonal.UnitId
                        , Null AS PositionId_old
                        , Null AS PositionLevelId_old    
                        , Null AS UnitId_old             
                        , tmpViewPersonal.isOfficial         
                        , tmpViewPersonal.isMain 
                        , zc_Enum_StaffListKind_In() AS StaffListKindId
                        , 1 AS Comment                                                    
                   FROM tmpViewPersonal
                   WHERE (tmpViewPersonal.isMain = True --основное место работы
                           AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) = zc_DateStart()
                          ) 
                      AND inParam = 1
                 --   AND tmpViewPersonal.MemberId = 8244486 --11121446 --
                UNION
                   --основное место работы до перевода
                   SELECT tmp.DateIn AS OperDate
                        , tmp.MemberId 
                        , tmp.PersonalId
                        , tmp.PositionId
                        , tmp.PositionLevelId    
                        , tmp.UnitId 
                        , NULL ::Integer AS PositionId_old
                        , NULL ::Integer AS PositionLevelId_old    
                        , NULL ::Integer AS UnitId_old             
                        , tmp.isOfficial         
                        , tmp.isMain
                        , zc_Enum_StaffListKind_In()  AS StaffListKindId
                        , 1 AS Comment
                   FROM (SELECT tmpViewPersonal.DateIn
                              , tmpViewPersonal.MemberId
                              , tmpViewPersonal.PersonalId
                              , tmpViewPersonal.PositionId
                              , tmpViewPersonal.PositionLevelId    
                              , tmpViewPersonal.UnitId 
                              --, tmpSend.PositionId AS PositionId_old
                              --, tmpSend.PositionLevelId AS PositionLevelId_old    
                              --, tmpSend.UnitId AS UnitId_old             
                              , tmpViewPersonal.isOfficial         
                              , tmpViewPersonal.isMain
                              , ROW_NUMBER() OVER (PARTITION BY tmpViewPersonal.MemberId ORDER BY tmpViewPersonal.DateSend ASC, tmpViewPersonal.PersonalId DESC) AS Ord
                         FROM tmpViewPersonal
                              LEFT JOIN tmpViewPersonal AS tmpSend 
                                                         ON tmpSend.MemberId = tmpViewPersonal.MemberId
                                                        AND tmpSend.DateIn = tmpViewPersonal.DateIn
                                                        AND tmpSend.isMain = TRUE
                                                        AND tmpSend.PersonalId <> tmpViewPersonal.PersonalId                  --если несколько переводов как быть ???  получить первого сотрудника, остальных внести как перевод  ???
                                                        --AND COALESCE (tmpSend.DateSend,zc_DateStart()) <> zc_DateStart()
                                                        AND COALESCE (tmpSend.DateSend,zc_DateStart()) = COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) 
                         WHERE (tmpViewPersonal.isMain <> True --основное место работы
                                 AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) <> zc_DateStart()
                                )      
                          AND inParam = 1
                     --     AND tmpViewPersonal.MemberId = 8244486 --11121446 --
                        ) AS tmp
                   WHERE tmp.Ord = 1    --берем первый как прием на работу,
              UNION 
                   --по совместительству 
                   SELECT tmpViewPersonal.DateIn AS OperDate
                        , tmpViewPersonal.MemberId 
                        , tmpViewPersonal.PersonalId
                        , tmpViewPersonal.PositionId
                        , tmpViewPersonal.PositionLevelId    
                        , tmpViewPersonal.UnitId 
                        , Null ::Integer AS PositionId_old
                        , Null ::Integer AS PositionLevelId_old    
                        , Null ::Integer AS UnitId_old             
                        , tmpViewPersonal.isOfficial         
                        , tmpViewPersonal.isMain
                        , zc_Enum_StaffListKind_Add() AS StaffListKindId
                        , 1 AS Comment
                   FROM tmpViewPersonal
                   WHERE ((tmpViewPersonal.isMain <> True --основное место работы
                           AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) = zc_DateStart())
                          ) -- по совместительству 
                      AND inParam = 1
                   -- AND tmpViewPersonal.MemberId = 8244486 --11121446 --
                UNION
                  -- inParam = 2

                   --перевод - ---если было несколько переводов
                   SELECT tmp.DateSend AS OperDate
                        , tmp.MemberId
                        , tmp.PersonalId
                        , tmp.PositionId
                        , tmp.PositionLevelId    
                        , tmp.UnitId  
                        , tmp.PositionId_old
                        , tmp.PositionLevelId_old    
                        , tmp.UnitId_old           
                        , tmp.isOfficial         
                        , tmp.isMain
                        , zc_Enum_StaffListKind_Send()  AS StaffListKindId
                        , 2 AS Comment
                   FROM (SELECT tmpViewPersonal.DateSend
                              , tmpViewPersonal.MemberId 
                              , tmpViewPersonal.PersonalId
                              , tmpViewPersonal.PositionId
                              , tmpViewPersonal.PositionLevelId    
                              , tmpViewPersonal.UnitId 
                              , COALESCE (tmpSend.PositionId, tmpSend2.PositionId, tmpSend3.PositionId)            AS PositionId_old
                              , COALESCE (tmpSend.PositionLevelId, tmpSend2.PositionLevelId, tmpSend3.PositionLevelId) AS PositionLevelId_old    
                              , COALESCE (tmpSend.UnitId, tmpSend2.UnitId, tmpSend3.UnitId)                   AS UnitId_old         
                              , tmpViewPersonal.isOfficial         
                              , tmpViewPersonal.isMain
                              , ROW_NUMBER() OVER (PARTITION BY tmpViewPersonal.MemberId ORDER BY tmpViewPersonal.DateSend ASC, COALESCE (tmpSend.PersonalId, tmpSend2.PersonalId, tmpSend3.PersonalId) asc) AS Ord
                         FROM tmpViewPersonal
                               LEFT JOIN tmp_PersonalSend AS tmpSend 
                                                         ON tmpSend.MemberId = tmpViewPersonal.MemberId
                                                        AND tmpSend.DateIn = tmpViewPersonal.DateIn
                                                       -- AND tmpSend.isMain <> TRUE
                                                       AND tmpSend.PersonalId <> tmpViewPersonal.PersonalId                  --если несколько переводов как быть ???  получить первого сотрудника, остальных внести как перевод  ???
                                                      AND COALESCE (tmpSend.DateSend,zc_DateStart()) = COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) 
                                                      AND tmpSend.Ord = 1
                               LEFT JOIN tmp_PersonalDop AS tmpSend2 
                                                         ON tmpSend2.Ord = 1
                                                        AND tmpSend2.MemberId = tmpViewPersonal.MemberId
                                                        AND tmpSend2.DateIn = tmpViewPersonal.DateIn
                                                        AND tmpSend2.PersonalId <> tmpViewPersonal.PersonalId                  --если несколько переводов как быть ???  получить первого сотрудника, остальных внести как перевод  ???
                                                        --AND COALESCE (tmpSend.DateSend,zc_DateStart()) = COALESCE (tmpViewPersonal.DateSend,zc_DateStart())
                                                        AND tmpSend.PersonalId IS NULL 
                               LEFT JOIN tmp_PersonalDop2 AS tmpSend3 
                                                          ON tmpSend3.Ord = 1
                                                         AND tmpSend3.MemberId = tmpViewPersonal.MemberId
                                                         AND tmpSend3.DateIn = tmpViewPersonal.DateIn
                                                         AND tmpSend3.PersonalId <> tmpViewPersonal.PersonalId                  --если несколько переводов как быть ???  получить первого сотрудника, остальных внести как перевод  ???
                                                         --AND COALESCE (tmpSend.DateSend,zc_DateStart()) = COALESCE (tmpViewPersonal.DateSend,zc_DateStart())
                                                         AND (tmpSend.PersonalId IS NULL AND tmpSend2.PersonalId IS NULL) 
                                                                 
                           WHERE (tmpViewPersonal.isMain = True --основное место работы
                                 AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) <> zc_DateStart()
                                )      
                           AND inParam = 2
                        --  AND tmpViewPersonal.MemberId = 8244486 --11121446 --
                        ) AS tmp
                  -- WHERE tmp.Ord <> 1     
                UNION
                  --inParam = 3
                  --уволенные
                   SELECT tmpViewPersonal.DateOut AS OperDate
                        , tmpViewPersonal.MemberId 
                        , tmpViewPersonal.PersonalId
                        , tmpViewPersonal.PositionId
                        , tmpViewPersonal.PositionLevelId    
                        , tmpViewPersonal.UnitId 
                        , Null ::Integer AS PositionId_old
                        , Null ::Integer AS PositionLevelId_old    
                        , Null ::Integer AS UnitId_old             
                        , tmpViewPersonal.isOfficial         
                        , tmpViewPersonal.isMain
                        , zc_Enum_StaffListKind_Out()  AS StaffListKindId
                        , 3 AS Comment
                   FROM tmpViewPersonal
                   WHERE COALESCE (tmpViewPersonal.DateOut, zc_DateEnd()) <> zc_DateEnd()
                  AND inParam = 3
                 --         AND tmpViewPersonal.MemberId = 8244486 --11121446 --
                 )
       --выбор уже сохраненных сотрудников, чтоб не дублировались документы
       , tmpSave AS (WITH  
                     tmpMovement AS (SELECT Movement.*
                                     FROM  Movement 
                                     WHERE Movement.DescId = zc_Movement_StaffListMember()
                                   -- AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                       AND Movement.StatusId = zc_Enum_Status_Complete() 
                                     )

                   , tmpMLO AS (SELECT MovementLinkObject.*
                                FROM MovementLinkObject
                                WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement) 
                                  AND MovementLinkObject.DescId IN (zc_MovementLinkObject_StaffListKind() 
                                                                  , zc_MovementLinkObject_Member()
                                                                   )
                                )
                    SELECT DISTINCT MovementLinkObject_Member.ObjectId AS MemberId
                        , CASE WHEN MovementLinkObject_StaffListKind.ObjectId IN (zc_Enum_StaffListKind_In(), zc_Enum_StaffListKind_Add()) THEN 1
                               WHEN MovementLinkObject_StaffListKind.ObjectId IN (zc_Enum_StaffListKind_Send()) THEN 2
                               WHEN MovementLinkObject_StaffListKind.ObjectId IN (zc_Enum_StaffListKind_Out()) THEN 3
                          END AS Param 
                    FROM tmpMovement AS Movement    
                         INNER JOIN tmpMLO AS MovementLinkObject_Member
                                        ON MovementLinkObject_Member.MovementId = Movement.Id
                                       AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                       LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId
           
                       LEFT JOIN tmpMLO AS MovementLinkObject_StaffListKind
                                        ON MovementLinkObject_StaffListKind.MovementId = Movement.Id
                                       AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind()
                       LEFT JOIN Object AS Object_StaffListKind ON Object_StaffListKind.Id = MovementLinkObject_StaffListKind.ObjectId
                     )
 
          SELECT tmp.*
           FROM tmp
                LEFT JOIN tmpSave ON tmpSave.MemberId = tmp.MemberId
                                 AND tmpSave.Param = inParam
           WHERE tmp.MemberId IN (10406401, 12570, 12492, 11121446, 8244486) --  --12492 ващенко --Comment = 2 
             AND tmpSave.MemberId IS NULL
            order by tmp.MemberId, tmp.OperDate, tmp.PersonalId, tmp.Comment, tmp.ismain 


           ) AS tmp
          -- ORDER BY tmp.DateIn
;   
 
   --  IF  vbUserId = 9457 THEN RAISE EXCEPTION 'Admin - Test = OK'; END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.09.25         *
*/

-- тест
--  select * from gpInsert_Movement_StaffListMember_byPersonal(inParam := 1 , inSession := '9457');

--SELECT * FROM gpInsert_Movement_StaffListMember_byPersonal( inParam  := 1 :: Integer, inSession :='9457'::TVarChar)
--***
--SELECT * FROM gpInsert_Movement_StaffListMember_byPersonal( inParam  := 2 :: Integer, inSession :='9457'::TVarChar)
--****
--SELECT * FROM gpInsert_Movement_StaffListMember_byPersonal( inParam  := 3 :: Integer, inSession :='9457'::TVarChar)


