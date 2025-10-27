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
     FROM (WITH
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
           WHERE /*tmp.MemberId IN (10406401, 12570, 12492, 11121446, 8244486) --  --12492 ващенко --Comment = 2 
             AND*/ tmpSave.MemberId IS NULL
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



/*
-- загрузка данных в процке  gpReport_StaffListMember_byPersonal


для перевода данные из протокола

--select *
-- from gpSelect_Protocol(inStartDate := ('01.01.2014')::TDateTime , inEndDate := ('01.02.2016')::TDateTime , inUserId := 0 , inObjectDescId := 0 , inObjectId := 11825652 ,  inSession := '9457');

select * from gpGet_Movement_StaffListMember(inMovementId := 32289835 , inOperDate := ('01.01.2025')::TDateTime ,  inSession := '9457');

WITH
tmpSave AS (WITH  
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
                                                                  , zc_MovementLinkObject_Unit()
                                                                  , zc_MovementLinkObject_Position()
                                                                  , zc_MovementLinkObject_PositionLevel()
                                                                   )
                                )
                    SELECT DISTINCT Movement.Id AS MovementId
                         , Movement.Operdate
                         , MovementLinkObject_Member.ObjectId AS MemberId
                         , MovementLinkObject_Unit.ObjectId AS UnitId
                         , MovementLinkObject_Position.ObjectId AS PositionId
                         , MovementLinkObject_PositionLevel.ObjectId AS PositionLevelId
                         , MovementLinkObject_StaffListKind.ObjectId AS StaffListKindId
                        /* , CASE WHEN MovementLinkObject_StaffListKind.ObjectId IN (zc_Enum_StaffListKind_In(), zc_Enum_StaffListKind_Add()) THEN 1
                                WHEN MovementLinkObject_StaffListKind.ObjectId IN (zc_Enum_StaffListKind_Send()) THEN 2
                                WHEN MovementLinkObject_StaffListKind.ObjectId IN (zc_Enum_StaffListKind_Out()) THEN 3
                           END AS Param
 */ 
                    FROM tmpMovement AS Movement    
                         INNER JOIN tmpMLO AS MovementLinkObject_Member
                                        ON MovementLinkObject_Member.MovementId = Movement.Id
                                       AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                       LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId
 
            LEFT JOIN tmpMLO AS MovementLinkObject_Unit
                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_Position
                             ON MovementLinkObject_Position.MovementId = Movement.Id
                            AND MovementLinkObject_Position.DescId = zc_MovementLinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MovementLinkObject_Position.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_PositionLevel
                             ON MovementLinkObject_PositionLevel.MovementId = Movement.Id
                            AND MovementLinkObject_PositionLevel.DescId = zc_MovementLinkObject_PositionLevel()
            LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = MovementLinkObject_PositionLevel.ObjectId
          
                       LEFT JOIN tmpMLO AS MovementLinkObject_StaffListKind
                                        ON MovementLinkObject_StaffListKind.MovementId = Movement.Id
                                       AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind()
                       LEFT JOIN Object AS Object_StaffListKind ON Object_StaffListKind.Id = MovementLinkObject_StaffListKind.ObjectId
                     )
, tmpPersonal AS(SELECT Object_Personal.Id AS PersonalId
                      , ObjectLink_Personal_Member.ChildObjectId AS MemberId
                      , ObjectLink_Personal_Unit.ChildObjectId AS UnitId
                      , ObjectLink_Personal_Position.ChildObjectId AS PositionId
                      , ObjectLink_Personal_PositionLevel.ChildObjectId AS PositionLevelId
                      FROM Object AS Object_Personal
                           INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                 ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                               -- AND ObjectLink_Personal_Member.ChildObjectId = inMemberId
                           INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                 ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                                --AND ObjectLink_Personal_Unit.ChildObjectId = inUnitId                      
                           INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                 ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                               -- AND ObjectLink_Personal_Position.ChildObjectId = inPositionId
                           LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                                ON ObjectLink_Personal_PositionLevel.ObjectId = Object_Personal.Id
                                               AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
                      WHERE Object_Personal.DescId = zc_Object_Personal()
                        AND Object_Personal.isErased = FALSE
                       -- AND COALESCE (ObjectLink_Personal_PositionLevel.ChildObjectId,0) = COALESCE (inPositionLevelId,0)
                      )

, tmpData AS (SELECT tmpSave.MovementId 
, tmpSave.OperDate
, tmpSave.MemberId
, tmpSave.StaffListKindId
, tmpPersonal.PersonalId 
FROM tmpSave
LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = tmpSave.MemberId
                     AND tmpPersonal.UnitId = tmpSave.UnitId
                     AND tmpPersonal.PositionId = tmpSave.PositionId
                     AND COALESCE (tmpPersonal.PositionLevelId,0) = COALESCE (tmpSave.PositionLevelId,0)
 
WHERE /*tmpSave.MemberId IN (2627877, 301518, 12544) -- 300841 --11313776 ---11825652
and*/ tmpSave.StaffListKindId = zc_Enum_StaffListKind_Send()
)

, tmpProtocol AS (

SELECT tmp.Operdate
, tmp.DateSend 
, tmp.UserId
, tmp.PersonalId
, tmp.Id
, ROW_NUMBER() OVER (PARTITION BY tmp.PersonalId,tmp.DateSend   ORDER BY tmp.Operdate ASC ) AS Ord

FROM (
SELECT 
 zfConvert_StringToDate ( REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата перевода сотрудника"]  /@FieldValue', ObjectProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')) AS DateSend
, ObjectProtocol.Operdate
, ObjectProtocol.Id AS Id
, ObjectProtocol.UserId AS UserId

, ObjectProtocol.ObjectId AS PersonalId
FROM objectProtocol --limit 10
    INNER JOIN (SELECT DISTINCT tmpData.PersonalId 
                FROM tmpData
              --  WHERE tmpData.StaffListKindId = zc_Enum_StaffListKind_Send()
               ) AS tmpData ON tmpData.PersonalId = objectProtocol.ObjectId 
) AS tmp
WHERE tmp.DateSend is not null

)



SELECT *
, lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), tmpData.MovementId, tmpProtocol.OperDate)
, lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), tmpData.MovementId, tmpProtocol.UserId)
FROm tmpProtocol
INNER JOIN tmpData ON tmpData.PersonalId = tmpProtocol.PersonalId
                  AND tmpData.OperDate = tmpProtocol.DateSend
WHERE tmpProtocol.Ord = 1

*/



/*

увольнение

WITH
tmpSave AS (WITH  
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
                                                                  , zc_MovementLinkObject_Unit()
                                                                  , zc_MovementLinkObject_Position()
                                                                  , zc_MovementLinkObject_PositionLevel()
                                                                   )
                                )
                    SELECT DISTINCT Movement.Id AS MovementId
                         , Movement.Operdate
                         , MovementLinkObject_Member.ObjectId AS MemberId
                         , MovementLinkObject_Unit.ObjectId AS UnitId
                         , MovementLinkObject_Position.ObjectId AS PositionId
                         , MovementLinkObject_PositionLevel.ObjectId AS PositionLevelId
                         , MovementLinkObject_StaffListKind.ObjectId AS StaffListKindId
                    FROM tmpMovement AS Movement    
                         INNER JOIN tmpMLO AS MovementLinkObject_Member
                                        ON MovementLinkObject_Member.MovementId = Movement.Id
                                       AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                       LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId
 
            LEFT JOIN tmpMLO AS MovementLinkObject_Unit
                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_Position
                             ON MovementLinkObject_Position.MovementId = Movement.Id
                            AND MovementLinkObject_Position.DescId = zc_MovementLinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MovementLinkObject_Position.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_PositionLevel
                             ON MovementLinkObject_PositionLevel.MovementId = Movement.Id
                            AND MovementLinkObject_PositionLevel.DescId = zc_MovementLinkObject_PositionLevel()
            LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = MovementLinkObject_PositionLevel.ObjectId
          
                       LEFT JOIN tmpMLO AS MovementLinkObject_StaffListKind
                                        ON MovementLinkObject_StaffListKind.MovementId = Movement.Id
                                       AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind()
                       LEFT JOIN Object AS Object_StaffListKind ON Object_StaffListKind.Id = MovementLinkObject_StaffListKind.ObjectId
                     )
, tmpPersonal AS(SELECT Object_Personal.Id AS PersonalId
                      , ObjectLink_Personal_Member.ChildObjectId AS MemberId
                      , ObjectLink_Personal_Unit.ChildObjectId AS UnitId
                      , ObjectLink_Personal_Position.ChildObjectId AS PositionId
                      , ObjectLink_Personal_PositionLevel.ChildObjectId AS PositionLevelId
                      FROM Object AS Object_Personal
                           INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                 ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                               -- AND ObjectLink_Personal_Member.ChildObjectId = inMemberId
                           INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                 ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                                --AND ObjectLink_Personal_Unit.ChildObjectId = inUnitId                      
                           INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                 ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                               -- AND ObjectLink_Personal_Position.ChildObjectId = inPositionId
                           LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                                ON ObjectLink_Personal_PositionLevel.ObjectId = Object_Personal.Id
                                               AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
                      WHERE Object_Personal.DescId = zc_Object_Personal()
                        AND Object_Personal.isErased = FALSE
                       -- AND COALESCE (ObjectLink_Personal_PositionLevel.ChildObjectId,0) = COALESCE (inPositionLevelId,0)
                      )

, tmpData AS (SELECT tmpSave.MovementId 
, tmpSave.OperDate
, tmpSave.MemberId
, tmpSave.StaffListKindId
, tmpPersonal.PersonalId 
FROM tmpSave
LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = tmpSave.MemberId
                   --  AND tmpPersonal.UnitId = tmpSave.UnitId
                     AND tmpPersonal.PositionId = tmpSave.PositionId
                     AND COALESCE (tmpPersonal.PositionLevelId,0) = COALESCE (tmpSave.PositionLevelId,0)
 
WHERE /*tmpSave.MemberId IN (8441867 ) -- 300841 --11313776 ---11825652
and*/ tmpSave.StaffListKindId IN (zc_Enum_StaffListKind_Out()) --  zc_Enum_StaffListKind_Add(), zc_Enum_StaffListKind_In() --zc_Enum_StaffListKind_Send()
)

, tmpProtocol AS (

SELECT tmp.Operdate
, tmp.DateOut 
, tmp.UserId
, tmp.PersonalId
, tmp.Id
, ROW_NUMBER() OVER (PARTITION BY tmp.PersonalId, tmp.DateOut ORDER BY tmp.Operdate ASC ) AS Ord

FROM (
SELECT zfConvert_StringToDate ( REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата увольнения у сотрудника"]  /@FieldValue', ObjectProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')) AS DateOut
, ObjectProtocol.Operdate
, ObjectProtocol.Id AS Id
, ObjectProtocol.UserId AS UserId

, ObjectProtocol.ObjectId AS PersonalId
FROM objectProtocol 
    INNER JOIN (SELECT DISTINCT tmpData.PersonalId 
                FROM tmpData
               ) AS tmpData ON tmpData.PersonalId = objectProtocol.ObjectId 
--WHERE isInsert = True
) AS tmp
--WHERE tmp.DateSend is not null

)


SELECT *
, lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), tmpData.MovementId, tmpProtocol.OperDate)
, lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), tmpData.MovementId, tmpProtocol.UserId)
FROm tmpData 
INNER JOIN tmpProtocol ON tmpData.PersonalId = tmpProtocol.PersonalId
                      AND tmpData.OperDate = tmpProtocol.DateOut
WHERE tmpProtocol.Ord = 1

*/