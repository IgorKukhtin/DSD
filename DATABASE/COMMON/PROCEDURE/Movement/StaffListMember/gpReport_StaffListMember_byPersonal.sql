-- Function: gpSelect_StaffListMember_byPersonal()

DROP FUNCTION IF EXISTS gpReport_StaffListMember_byPersonal (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_StaffListMember_byPersonal (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_StaffListMember_byPersonal(
    IN inUnitId            Integer ,
    IN inMemberId          Integer ,
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (DateIn TDateTime, DateSend TDateTime, DateOut TDateTime
             , OperDate TDateTime
             , PersonalId Integer
             , MemberId Integer, MemberCode Integer, MemberName TVarChar
             , PositionId Integer, PositionName TVarChar
             , PositionLevelId Integer, PositionLevelName TVarChar
             , UnitId Integer, UnitName TVarChar
             , PositionId_old Integer, PositionName_old TVarChar
             , PositionLevelId_old Integer, PositionLevelName_old TVarChar
             , UnitId_old Integer, UnitName_old TVarChar
             , StaffListKindId Integer, StaffListKindName TVarChar
             , isOfficial Boolean, isMain Boolean 
             , isDateOut Boolean
             , UserId_pr Integer, UserName_pr TVarChar
             , Operdate_pr TDateTime 
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsAccessKey_StaffListMember Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_StaffListMember());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH
           tmpViewPersonal AS (SELECT *
                               FROM (SELECT *
                                          -- есть задвоенные сотрудники для разных StorageLine для них не нужно дублировать документ приема
                                          , ROW_NUMBER() OVER (PARTITION BY tmp.MemberId, tmp.PositionId, COALESCE (tmp.PositionLevelId,0), tmp.UnitId/*, tmp.DateIn*/ ORDER BY tmp.isMain DESC, tmp.DateIn, tmp.PersonalId ASC) AS Ord_sl -- 
                                     FROM Object_Personal_View AS tmp
                                     WHERE (tmp.isERased = inIsErased OR inIsErased = TRUE)
                                       AND (tmp.MemberId = inMemberId OR inMemberId = 0)
                                       AND (tmp.UnitId = inUnitId OR inUnitId = 0)
                                     ) AS tmp
                               WHERE tmp.Ord_sl = 1
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
                                     , ROW_NUMBER() OVER (PARTITION BY tmpViewPersonal.MemberId , COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) ORDER BY tmpViewPersonal.PersonalId desc) AS Ord 
                                FROM tmpViewPersonal
                                WHERE tmpViewPersonal.isMain = FALSE 
                                  AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) <> zc_DateStart()
                                  AND tmpViewPersonal.isErased = FALSE
                                )
          , tmp_PersonalSend_erased AS (SELECT *
                                             , ROW_NUMBER() OVER (PARTITION BY tmpViewPersonal.MemberId , COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) ORDER BY tmpViewPersonal.PersonalId desc) AS Ord 
                                        FROM tmpViewPersonal
                                        WHERE tmpViewPersonal.isMain = FALSE 
                                          AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) <> zc_DateStart()
                                          AND tmpViewPersonal.isErased = TRUE
                                        )
         , tmpIn AS (--основное м.р. без перевода
                       SELECT tmpViewPersonal.DateIn AS OperDate
                            , tmpViewPersonal.MemberId
                            , tmpViewPersonal.PersonalId 
                            , tmpViewPersonal.PositionId
                            , tmpViewPersonal.PositionLevelId    
                            , tmpViewPersonal.UnitId
                            , 0 AS PositionId_old
                            , 0 AS PositionLevelId_old    
                            , 0 AS UnitId_old             
                            , tmpViewPersonal.isOfficial         
                            , tmpViewPersonal.isMain 
                            , zc_Enum_StaffListKind_In() AS StaffListKindId
                            , 1 AS Comment                                                    
                       FROM tmpViewPersonal
                       WHERE (tmpViewPersonal.isMain = True --основное место работы
                               AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) = zc_DateStart()
                              ) 
                           AND tmpViewPersonal.isERased = FALSE
                       )

       /*  , tmpIn_2 AS (--основное место работы до перевода
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
                             -- AND inParam = 1
                            ) AS tmp
                       WHERE tmp.Ord = 1    --берем первый как прием на работу,
                       )
              UNION 
                   --по совместительству 
                   SELECT tmpViewPersonal.DateIn AS OperDate
                        , tmpViewPersonal.MemberId 
                        , tmpViewPersonal.PersonalId
                        , tmpViewPersonal.PositionId
                        , tmpViewPersonal.PositionLevelId    
                        , tmpViewPersonal.UnitId 
                        , 0 ::Integer AS PositionId_old
                        , 0 ::Integer AS PositionLevelId_old    
                        , 0 ::Integer AS UnitId_old             
                        , tmpViewPersonal.isOfficial         
                        , tmpViewPersonal.isMain
                        , zc_Enum_StaffListKind_Add() AS StaffListKindId
                        , 1 AS Comment
                   FROM tmpViewPersonal
                   WHERE ((tmpViewPersonal.isMain <> True --основное место работы
                           AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) = zc_DateStart())
                          ) -- по совместительству 
                    --  AND inParam = 1
                UNION */
                  -- inParam = 2

     , tmpIn_Send AS (--перевод / прием
                   SELECT tmpViewPersonal.DateIn
                        , tmpViewPersonal.DateSend
                        , tmpViewPersonal.MemberId 
                        , tmpViewPersonal.PersonalId
                        , tmpViewPersonal.PositionId
                        , tmpViewPersonal.PositionLevelId    
                        , tmpViewPersonal.UnitId
                        , COALESCE (tmpSend.PersonalId,tmpSend_erased.PersonalId, tmpSend2.PersonalId, tmpSend3.PersonalId)            AS PersonalId_old
                        , COALESCE (tmpSend.PositionId,tmpSend_erased.PositionId, tmpSend2.PositionId, tmpSend3.PositionId)            AS PositionId_old
                        , COALESCE (tmpSend.PositionLevelId,tmpSend_erased.PositionLevelId, tmpSend2.PositionLevelId, tmpSend3.PositionLevelId) AS PositionLevelId_old    
                        , COALESCE (tmpSend.UnitId,tmpSend_erased.UnitId, tmpSend2.UnitId, tmpSend3.UnitId)                            AS UnitId_old         
                        , tmpViewPersonal.isOfficial         
                        , tmpViewPersonal.isMain
                        --, ROW_NUMBER() OVER (PARTITION BY tmpViewPersonal.MemberId ORDER BY tmpViewPersonal.DateSend ASC, COALESCE (tmpSend.PersonalId, tmpSend2.PersonalId, tmpSend3.PersonalId) asc) AS Ord
                   FROM tmpViewPersonal   
                         --ищем должность с которой перевели   
                         --1,
                         LEFT JOIN tmp_PersonalSend AS tmpSend 
                                                    ON tmpSend.MemberId = tmpViewPersonal.MemberId
                                                   AND tmpSend.DateIn = tmpViewPersonal.DateIn
                                                   AND tmpSend.isMain <> TRUE
                                                   AND tmpSend.PersonalId <> tmpViewPersonal.PersonalId
                                                   AND COALESCE (tmpSend.DateSend,zc_DateStart()) = COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) 
                                                   AND tmpSend.Ord = 1   --если несколько переводов  на одну и ту же дату берем один
                         --2, пробуем найти в удаленных должность с которой перевели                       
                         LEFT JOIN tmp_PersonalSend_erased AS tmpSend_erased 
                                                           ON tmpSend_erased.MemberId = tmpViewPersonal.MemberId
                                                          AND tmpSend_erased.DateIn = tmpViewPersonal.DateIn
                                                          AND tmpSend.isMain <> TRUE
                                                          AND tmpSend_erased.PersonalId <> tmpViewPersonal.PersonalId
                                                          AND COALESCE (tmpSend_erased.DateSend,zc_DateStart()) = COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) 
                                                          AND tmpSend_erased.Ord = 1 
                                                          AND tmpSend_erased.PersonalId IS NULL
                         --3. если не нашли выше берем должность до перевода 
                         LEFT JOIN tmp_PersonalDop AS tmpSend2 
                                                   ON tmpSend2.Ord = 1
                                                  AND tmpSend2.MemberId = tmpViewPersonal.MemberId
                                                  AND tmpSend2.DateIn = tmpViewPersonal.DateIn
                                                  AND tmpSend2.PersonalId <> tmpViewPersonal.PersonalId
                                                  AND (tmpSend.PersonalId IS NULL AND tmpSend_erased.PersonalId IS NULL) 
                         --4. если не нашли выше , тогда берем просто макс не главный 
                         LEFT JOIN tmp_PersonalDop2 AS tmpSend3 
                                                    ON tmpSend3.Ord = 1
                                                   AND tmpSend3.MemberId = tmpViewPersonal.MemberId
                                                   AND tmpSend3.DateIn = tmpViewPersonal.DateIn
                                                   AND tmpSend3.PersonalId <> tmpViewPersonal.PersonalId
                                                   AND (tmpSend.PersonalId IS NULL AND tmpSend2.PersonalId IS NULL AND tmpSend_erased.PersonalId IS NULL) 
                                                           
                     WHERE (tmpViewPersonal.isMain = True --основное место работы и есть дата перевода
                           AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) <> zc_DateStart()
                          )      
                  )
     , tmpOut AS ( --уволенные - не удаленные
                   SELECT tmpViewPersonal.DateOut AS OperDate
                        , tmpViewPersonal.MemberId 
                        , tmpViewPersonal.PersonalId
                        , tmpViewPersonal.PositionId
                        , tmpViewPersonal.PositionLevelId    
                        , tmpViewPersonal.UnitId 
                        , 0 ::Integer AS PositionId_old
                        , 0 ::Integer AS PositionLevelId_old    
                        , 0 ::Integer AS UnitId_old             
                        , tmpViewPersonal.isOfficial         
                        , tmpViewPersonal.isMain
                        , zc_Enum_StaffListKind_Out()  AS StaffListKindId
                        , 3 AS Comment
                   FROM tmpViewPersonal
                   WHERE COALESCE (tmpViewPersonal.DateOut, zc_DateEnd()) <> zc_DateEnd()
                   AND tmpViewPersonal.isERased = FALSE
                 ) 

     , tmpUnion AS (SELECT DISTINCT tmpIn.PersonalId, tmpIn.MemberId FROM tmpIn
              UNION SELECT DISTINCT tmpIn_Send.PersonalId, tmpIn_Send.MemberId FROM tmpIn_Send
              UNION SELECT DISTINCT tmpIn_Send.PersonalId_old, tmpIn_Send.MemberId FROM tmpIn_Send 
                    )
     , tmpAdd AS (--по совместительству   все кого нет в tmpIn и tmpIn_Send
                   SELECT tmpViewPersonal.DateIn AS OperDate
                        , tmpViewPersonal.MemberId 
                        , tmpViewPersonal.PersonalId
                        , tmpViewPersonal.PositionId
                        , tmpViewPersonal.PositionLevelId    
                        , tmpViewPersonal.UnitId 
                        , 0 ::Integer AS PositionId_old
                        , 0 ::Integer AS PositionLevelId_old    
                        , 0 ::Integer AS UnitId_old             
                        , tmpViewPersonal.isOfficial         
                        , tmpViewPersonal.isMain
                        , zc_Enum_StaffListKind_Add() AS StaffListKindId
                        , 1 AS Comment
                   FROM tmpViewPersonal
                        LEFT JOIN tmpUnion ON tmpUnion.PersonalId = tmpViewPersonal.PersonalId
                                          AND tmpUnion.MemberId = tmpViewPersonal.MemberId
                   WHERE (tmpViewPersonal.isMain <> True --основное место работы
                           AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) = zc_DateStart()
                          ) 
                        -- AND tmpViewPersonal.PersonalId NOT IN (SELECT DISTINCT tmpUnion.PersonalId FROM tmpUnion) 
                      AND tmpUnion.MemberId IS NULL
                      AND tmpViewPersonal.isERased = FALSE
                   )
     , tmp AS (
               SELECT tmp.OperDate
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
                    , tmp.StaffListKindId
                    , 1 AS Comment
               FROM tmpIn AS tmp
             UNION 
               --первый раз прием
               SELECT tmp.DateIn AS OperDate
                    , tmp.MemberId 
                    , tmp.PersonalId_old AS PersonalId
                    , tmp.PositionId_old AS PositionId
                    , tmp.PositionLevelId_old AS PositionLevelId    
                    , tmp.UnitId_old AS UnitId 
                    , 0 AS PositionId_old
                    , 0 AS PositionLevelId_old    
                    , 0 AS UnitId_old             
                    , tmp.isOfficial         
                    , tmp.isMain
                    , zc_Enum_StaffListKind_In() AS StaffListKindId
                    , 1 AS Comment
               FROM tmpIn_Send AS tmp 
             UNION 
               --второй раз перевод 
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
                    , zc_Enum_StaffListKind_Send() AS StaffListKindId
                    , 2 AS Comment
               FROM tmpIn_Send AS tmp
             UNION
               SELECT tmp.OperDate
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
                    , tmp.StaffListKindId
                    , 1 AS Comment
               FROM tmpAdd AS tmp
             UNION 
               --уволенные 
               SELECT tmp.OperDate
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
                    , tmp.StaffListKindId
                    , 3 AS Comment
               FROM tmpOut AS tmp
               )


     , tmpErased AS (--из удаленных берем тех кого не было (прем + удаление)
                     SELECT tmpViewPersonal.DateIn
                          , tmpViewPersonal.DateOut
                          , tmpViewPersonal.MemberId 
                          , tmpViewPersonal.PersonalId
                          , tmpViewPersonal.PositionId
                          , tmpViewPersonal.PositionLevelId    
                          , tmpViewPersonal.UnitId 
                          , 0 ::Integer AS PositionId_old
                          , 0 ::Integer AS PositionLevelId_old    
                          , 0 ::Integer AS UnitId_old             
                          , tmpViewPersonal.isOfficial         
                          , tmpViewPersonal.isMain
                          , 0 AS StaffListKindId
                          , 4 AS Comment
                     FROM tmpViewPersonal
                          LEFT JOIN tmp ON tmp.PersonalId = tmpViewPersonal.PersonalId
                                       AND tmp.MemberId = tmpViewPersonal.MemberId
                     WHERE (tmpViewPersonal.isMain = True --основное место работы
                             AND COALESCE (tmpViewPersonal.DateOut,zc_DateEnd()) <> zc_DateEnd()
                            ) 
                        AND tmp.MemberId IS NULL
                        AND tmpViewPersonal.isERased = TRUE
                     )

     , tmpAll AS (SELECT tmp.OperDate
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
                       , tmp.StaffListKindId
                       , tmp.Comment
                  FROM tmp
               UNION 
                  SELECT tmp.DateIn AS OperDate
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
                       , zc_Enum_StaffListKind_In() AS StaffListKindId
                       , 1 AS Comment
                 FROM tmpErased AS tmp
               UNION 
                  SELECT tmp.DateOut AS OperDate
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
                       , zc_Enum_StaffListKind_Out() AS StaffListKindId
                       , 3 AS Comment
                  FROM tmpErased AS tmp
                 )               


   , tmpProtocol_in AS (SELECT tmp.Operdate
                             , tmp.UserId
                             , tmp.PersonalId
                             , tmp.Id
                             , ROW_NUMBER() OVER (PARTITION BY tmp.PersonalId ORDER BY tmp.Operdate ASC ) AS Ord
                        FROM (
                             SELECT ObjectProtocol.Operdate
                                  , ObjectProtocol.Id AS Id
                                  , ObjectProtocol.UserId AS UserId
                                  , ObjectProtocol.ObjectId AS PersonalId
                             FROM ObjectProtocol
                                 INNER JOIN (SELECT DISTINCT tmpAll.PersonalId 
                                             FROM tmpAll
                                             WHERE tmpAll.StaffListKindId IN (zc_Enum_StaffListKind_In(), zc_Enum_StaffListKind_Add())
                                            ) AS tmpData ON tmpData.PersonalId = objectProtocol.ObjectId 
                            -- WHERE ObjectProtocol.isInsert = True
                             ) AS tmp
                       )

   , tmpProtocol_send AS (SELECT tmp.Operdate
                               , tmp.DateSend 
                               , tmp.UserId
                               , tmp.PersonalId
                               , tmp.Id
                               , ROW_NUMBER() OVER (PARTITION BY tmp.PersonalId,tmp.DateSend   ORDER BY tmp.Operdate ASC ) AS Ord
                               
                          FROM (
                               SELECT zfConvert_StringToDate ( REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата перевода сотрудника"]  /@FieldValue', ObjectProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')) AS DateSend
                                    , ObjectProtocol.Operdate
                                    , ObjectProtocol.Id AS Id
                                    , ObjectProtocol.UserId AS UserId
                                    , ObjectProtocol.ObjectId AS PersonalId
                               FROM objectProtocol
                                   INNER JOIN (SELECT DISTINCT tmpAll.PersonalId 
                                               FROM tmpAll
                                               WHERE tmpAll.StaffListKindId = zc_Enum_StaffListKind_Send()
                                              ) AS tmpData ON tmpData.PersonalId = objectProtocol.ObjectId 
                               ) AS tmp
                          WHERE tmp.DateSend is not null
                         )

   , tmpProtocol_out AS (SELECT tmp.Operdate
                              , tmp.DateOut 
                              , tmp.UserId
                              , tmp.PersonalId
                              , tmp.Id
                              , ROW_NUMBER() OVER (PARTITION BY tmp.PersonalId, tmp.DateOut ORDER BY tmp.Operdate ASC ) AS Ord
                              
                         FROM (SELECT zfConvert_StringToDate ( REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата увольнения у сотрудника"]  /@FieldValue', ObjectProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')) AS DateOut
                                    , ObjectProtocol.Operdate
                                    , ObjectProtocol.Id AS Id
                                    , ObjectProtocol.UserId AS UserId
                                    , ObjectProtocol.ObjectId AS PersonalId
                              FROM objectProtocol 
                                  INNER JOIN (SELECT DISTINCT tmpAll.PersonalId 
                                              FROM tmpAll
                                              WHERE tmpAll.StaffListKindId = zc_Enum_StaffListKind_Out()
                                             ) AS tmpData ON tmpData.PersonalId = objectProtocol.ObjectId 
                              --WHERE isInsert = True
                              ) AS tmp
                              --WHERE tmp.DateSend is not null
                         )
                 
 
          SELECT CASE WHEN Object_StaffListKind.Id IN (zc_Enum_StaffListKind_In(), zc_Enum_StaffListKind_Add()) THEN tmp.OperDate ELSE NULL END ::TDateTime AS DateIn
               , CASE WHEN Object_StaffListKind.Id = zc_Enum_StaffListKind_Send() THEN tmp.OperDate ELSE NULL END ::TDateTime AS DateSend
               , CASE WHEN Object_StaffListKind.Id = zc_Enum_StaffListKind_Out()  THEN tmp.OperDate ELSE NULL END ::TDateTime AS DateOut
               , tmp.OperDate
               , tmp.PersonalId
               , Object_Member.Id                      AS MemberId
               , Object_Member.ObjectCode              AS MemberCode
               , Object_Member.ValueData               AS MemberName

               , Object_Position.Id                    AS PositionId
               , Object_Position.ValueData             AS PositionName
               , Object_PositionLevel.Id               AS PositionLevelId
               , Object_PositionLevel.ValueData        AS PositionLevelName
               , Object_Unit.Id                        AS UnitId
               , Object_Unit.ValueData                 AS UnitName

               , Object_Position_old.Id                AS PositionId_old
               , Object_Position_old.ValueData         AS PositionName_old
               , Object_PositionLevel_old.Id           AS PositionLevelId_old
               , Object_PositionLevel_old.ValueData    AS PositionLevelName_old
               , Object_Unit_old.Id                    AS UnitId_old
               , Object_Unit_old.ValueData             AS UnitName_old

               , Object_StaffListKind.Id               AS StaffListKindId
               , Object_StaffListKind.ValueData        AS StaffListKindName

               , tmp.isOfficial ::Boolean  AS isOfficial
               , tmp.isMain     ::Boolean  AS isMain
               , CASE WHEN Object_StaffListKind.Id = zc_Enum_StaffListKind_Out() THEN TRUE ELSE FALSE END ::Boolean AS isDateOut 
                   
               , Object_User_pr.Id        ::Integer  AS UserId_pr
               , Object_User_pr.ValueData ::TVarChar AS UserName_pr
               
               , CASE WHEN Object_StaffListKind.Id IN (zc_Enum_StaffListKind_In(), zc_Enum_StaffListKind_Add()) THEN tmpProtocol_in.Operdate
                      WHEN Object_StaffListKind.Id = zc_Enum_StaffListKind_Send() THEN tmpProtocol_send.Operdate
                      WHEN Object_StaffListKind.Id = zc_Enum_StaffListKind_Out() THEN tmpProtocol_out.Operdate
                 END  ::TDateTime AS Operdate_pr
               , ('Авто.'||tmp.Comment::TVarChar) ::TVarChar 
          FROM tmpAll AS tmp 
               LEFT JOIN Object AS Object_StaffListKind ON Object_StaffListKind.Id = tmp.StaffListKindId
               LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmp.MemberId 
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp.UnitId
               LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmp.PositionId
               LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmp.PositionLevelId
               LEFT JOIN Object AS Object_Unit_old ON Object_Unit_old.Id = tmp.UnitId_old
               LEFT JOIN Object AS Object_Position_old ON Object_Position_old.Id = tmp.PositionId_old
               LEFT JOIN Object AS Object_PositionLevel_old ON Object_PositionLevel_old.Id = tmp.PositionLevelId_old

               LEFT JOIN tmpProtocol_in ON tmpProtocol_in.PersonalId = tmp.PersonalId
                                     --  AND tmpProtocol_in.DateOut = tmp.OperDate 
                                     AND tmpProtocol_in.Ord = 1
                                     AND tmp.StaffListKindId IN (zc_Enum_StaffListKind_In(), zc_Enum_StaffListKind_Add())

               LEFT JOIN tmpProtocol_send ON tmpProtocol_send.PersonalId = tmp.PersonalId
                                         AND tmpProtocol_send.DateSend = tmp.OperDate
                                         AND tmpProtocol_send.Ord = 1
                                         AND tmp.StaffListKindId = zc_Enum_StaffListKind_Send()
                                         
               LEFT JOIN tmpProtocol_out ON tmpProtocol_out.PersonalId = tmp.PersonalId
                                        AND tmpProtocol_out.DateOut = tmp.OperDate
                                        AND tmpProtocol_out.Ord = 1 
                                        AND tmp.StaffListKindId = zc_Enum_StaffListKind_Out() 

               LEFT JOIN Object AS Object_User_pr ON Object_User_pr.Id = CASE WHEN Object_StaffListKind.Id IN (zc_Enum_StaffListKind_In(), zc_Enum_StaffListKind_Add()) THEN tmpProtocol_in.UserId
                                                                              WHEN Object_StaffListKind.Id = zc_Enum_StaffListKind_Send() THEN tmpProtocol_send.UserId
                                                                              WHEN Object_StaffListKind.Id = zc_Enum_StaffListKind_Out() THEN tmpProtocol_out.UserId
                                                                         END                                                       
          ORDER BY tmp.MemberId, tmp.OperDate, tmp.PersonalId, tmp.Comment, tmp.ismain 



      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.25         *
*/

-- тест
-- SELECT * FROM gpReport_StaffListMember_byPersonal (inMemberId:= 0, inIsErased:=true, inSession:= zfCalc_UserAdmin())

 /*  
      заполнение документов ШР сотрудники    
      
      -- inUnitId = 8439    -- "Участок мясного сырья"
 WITH 
 tmpData AS (
            SELECT tmp.*
            FROM gpReport_StaffListMember_byPersonal (inUnitId := 8439, inMemberId:= 0 , inIsErased:=true, inSession:= zfCalc_UserAdmin())  AS tmp
           -- WHERE tmp.MemberId <> 11121446 
            )

     SELECT lpInsert_Movement_StaffListMember ( ioId                  := 0    ::Integer
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
                                              , inComment             := tmp.Comment::TVarChar
                                              , inUserId_protocol     := tmp.UserId_pr       ::Integer
                                              , inOperDate_protocol   := tmp.Operdate_pr     ::TDateTime          
                                              , inUserId              := 9457
                                               )
     FROM  tmpData AS tmp
     
     
     
     */                        
     
     
     
     /*
     
       
удаление Осторожно 

 WITH  tmpMovement22 AS (SELECT Movement.Id
                        --FROM Movement
                        WHERE Movement.DescId = zc_Movement_StaffListMember()
                                         -- AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                          --AND Movement.StatusId = tmpStatus.StatusId
                        )
select *--lpDelete_Movement (tmpMovement22.Id , '9457') 
from tmpMovement22
limit 1
     
     */