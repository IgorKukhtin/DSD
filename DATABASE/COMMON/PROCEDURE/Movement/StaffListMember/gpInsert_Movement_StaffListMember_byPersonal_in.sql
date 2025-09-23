-- Function: gpInsert_Movement_StaffListMember_byPersonal ()

DROP FUNCTION IF EXISTS gpInsert_Movement_StaffListMember_byPersonal_In (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_StaffListMember_byPersonal_in(
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
     PERFORM lpInsert_Movement_StaffListMember ( ioId                  := 0    ::Integer
                                                     , inInvNumber           := NULL ::TVarChar
                                                     , inOperDate            := tmp.OperDate
                                                     , inMemberId            := tmp.MemberId 
                                                     , inPositionId          := tmp.PositionId
                                                     , inPositionLevelId     := tmp.PositionLevelId    
                                                     , inUnitId              := tmp.UnitId             
                                                     , inPositionId_old      := 0         ::Integer 
                                                     , inPositionLevelId_old := 0    ::Integer
                                                     , inUnitId_old          := 0             ::Integer     
                                                     , inReasonOutId         := 0    ::Integer   
                                                     , inStaffListKindId     := tmp.StaffListKindId    
                                                     , inisOfficial          := tmp.isOfficial         
                                                     , inisMain              := tmp.isMain             
                                                     , inComment             := ('Авто.'||tmp.Comment::TVarChar) ::TVarChar 
                                                     , inUserId_protocol     := tmp.UserId_pr       ::Integer
                                                     , inOperDate_protocol   := tmp.Operdate_pr     ::TDateTime          
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

   --выбрали сотрудников для которых не было док. приема на работу
, tmp_notIN AS (WITH
                tmpSave AS (WITH  
                            tmpMovement AS (SELECT Movement.*
                                            FROM  Movement 
                                            WHERE Movement.DescId = zc_Movement_StaffListMember()
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
                               ,  MovementLinkObject_StaffListKind.ObjectId  AS StaffListKindId
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
              , tmpMember AS (SELECT DIstinct MemberId FROM tmpSave)
               
                SELECT DIstinct
                       tmpMember.MemberId
                    -- , Object.ValueData
                FROM tmpMember
                  LEFT JOIN tmpSave ON tmpSave.MemberId = tmpMember.MemberId
                                   AND tmpSave.StaffListKindId IN (zc_Enum_StaffListKind_In())
                --left join Object ON Object.Id = tmpMember.MemberId
                WHERE tmpSave.MemberId IS NULL
               )  
              

         , tmp AS (--новый и совместительство   inParam = 1
                   --основное м.р. без перевода
                   SELECT tmp.*
                   FROM tmp_notIN
                    LEFT JOIN (SELECT tmpViewPersonal.DateIn AS OperDate
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
                        --INNER JOIN tmp_notIN ON tmp_notIN.MemberId = tmpViewPersonal.MemberId
                   WHERE (tmpViewPersonal.isMain = True --основное место работы
                           AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) <> zc_DateStart()
                          ) 
                      AND 1 = 1
                 --   AND tmpViewPersonal.MemberId = 8244486 --11121446 --
                     ) AS tmp ON tmp.MemberId = tmp_notIN.MemberId
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
                        , CASE WHEN MovementLinkObject_StaffListKind.ObjectId IN (zc_Enum_StaffListKind_In()) THEN 1 --(), zc_Enum_StaffListKind_Add())
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
         --данные из Протоколв
         
, tmpProtocol AS (SELECT tmp.Operdate
                       , tmp.UserId
                       , tmp.PersonalId
                       , tmp.Id
                       , ROW_NUMBER() OVER (PARTITION BY tmp.PersonalId ORDER BY tmp.Operdate ASC ) AS Ord_in
                       --, ROW_NUMBER() OVER (PARTITION BY tmp.PersonalId ORDER BY tmp.Operdate ASC ) AS Ord_in
                  FROM (
                       SELECT ObjectProtocol.Operdate
                            , ObjectProtocol.Id AS Id
                            , ObjectProtocol.UserId AS UserId
                            , ObjectProtocol.ObjectId AS PersonalId
                       FROM objectProtocol --limit 10
                           INNER JOIN (SELECT DISTINCT tmp.PersonalId 
                                       FROM tmp
                                      ) AS tmpData ON tmpData.PersonalId = objectProtocol.ObjectId 
                       ) AS tmp
                 )


         
          SELECT tmp.*
               , tmpProtocol.Operdate AS Operdate_pr
               , tmpProtocol.UserId   AS UserId_pr
          FROM tmp
               /*LEFT JOIN tmpSave ON tmpSave.MemberId = tmp.MemberId
                                AND tmpSave.Param = 1   */
               LEFT JOIN tmpProtocol ON tmpProtocol.PersonalId = tmp.PersonalId AND tmpProtocol.Ord_in = 1
         -- WHERE  tmpSave.MemberId IS NULL
          order by tmp.MemberId, tmp.OperDate, tmp.PersonalId, tmp.Comment, tmp.ismain 

           ) AS tmp
          -- ORDER BY tmp.DateIn
;   
 
   IF  vbUserId = 9457 THEN RAISE EXCEPTION 'Admin - Test = OK'; END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.09.25         *
*/

-- тест
--  select * from gpInsert_Movement_StaffListMember_byPersonal_in(inParam := 1 , inSession := '9457');


/*


  ДЛЯ  сотрудников у которых не было док. приема на работу    после первой загрузки
       
            SELECT lpInsert_Movement_StaffListMember ( ioId                  := 0    ::Integer
                                                     , inInvNumber           := NULL ::TVarChar
                                                     , inOperDate            := tmp.OperDate  ::TDateTime
                                                     , inMemberId            := tmp.MemberId  ::Integer
                                                     , inPositionId          := tmp.PositionId ::Integer
                                                     , inPositionLevelId     := tmp.PositionLevelId     ::Integer
                                                     , inUnitId              := tmp.UnitId             ::Integer
                                                     , inPositionId_old      := 0         ::Integer 
                                                     , inPositionLevelId_old := 0    ::Integer
                                                     , inUnitId_old          := 0             ::Integer     
                                                     , inReasonOutId         := 0    ::Integer   
                                                     , inStaffListKindId     := tmp.StaffListKindId    ::Integer
                                                     , inisOfficial          := tmp.isOfficial         ::Boolean
                                                     , inisMain              := tmp.isMain             ::Boolean
                                                     , inComment             := ('Авто.'||tmp.Comment::TVarChar) ::TVarChar 
                                                     , inUserId_protocol     := tmp.UserId_pr       ::Integer
                                                     , inOperDate_protocol   := tmp.Operdate_pr     ::TDateTime          
                                                     , inUserId              := 9457 ::Integer
                                                      )
     FROM(

     WITH
           tmpViewPersonal AS (SELECT *
                               FROM Object_Personal_View
                               WHERE Object_Personal_View.isERased = FALSE
                               )


   --выбрали сотрудников для которых не было док. приема на работу
, tmp_notIN AS (WITH
                tmpSave AS (WITH  
                            tmpMovement AS (SELECT Movement.*
                                            FROM  Movement 
                                            WHERE Movement.DescId = zc_Movement_StaffListMember()
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
                               ,  MovementLinkObject_StaffListKind.ObjectId  AS StaffListKindId
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
              , tmpMember AS (SELECT DIstinct MemberId FROM tmpSave)
               
                SELECT DIstinct
                       tmpMember.MemberId
                    -- , Object.ValueData
                FROM tmpMember
                  LEFT JOIN tmpSave ON tmpSave.MemberId = tmpMember.MemberId
                                   AND tmpSave.StaffListKindId IN (zc_Enum_StaffListKind_In())
                --left join Object ON Object.Id = tmpMember.MemberId
                WHERE tmpSave.MemberId IS NULL
               )  
              

         , tmp AS (--новый и совместительство   inParam = 1
                   --основное м.р. без перевода
                   SELECT tmp.*
                   FROM tmp_notIN
                    LEFT JOIN (SELECT tmpViewPersonal.DateIn AS OperDate
                        , tmpViewPersonal.MemberId
                        , tmpViewPersonal.PersonalId 
                        , tmpViewPersonal.PositionId
                        , tmpViewPersonal.PositionLevelId    
                        , tmpViewPersonal.UnitId
                        , Null AS PositionId_old
                        , Null AS PositionLevelId_old    
                        , Null AS UnitId_old             
                        , tmpViewPersonal.isOfficial         
                        , FALSE AS isMain   --tmpViewPersonal.isMain 
                        , zc_Enum_StaffListKind_In() AS StaffListKindId
                        , 1 AS Comment                                                    
                   FROM tmpViewPersonal 
                        --INNER JOIN tmp_notIN ON tmp_notIN.MemberId = tmpViewPersonal.MemberId
                   WHERE (tmpViewPersonal.isMain = True --основное место работы
                           AND COALESCE (tmpViewPersonal.DateSend,zc_DateStart()) <> zc_DateStart()
                          ) 
                      AND 1 = 1
                 --   AND tmpViewPersonal.MemberId = 8244486 --11121446 --
                     ) AS tmp ON tmp.MemberId = tmp_notIN.MemberId
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
                        , CASE WHEN MovementLinkObject_StaffListKind.ObjectId IN (zc_Enum_StaffListKind_In()) THEN 1 --(), zc_Enum_StaffListKind_Add())
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
         --данные из Протоколв
         
, tmpProtocol AS (SELECT tmp.Operdate
                       , tmp.UserId
                       , tmp.PersonalId
                       , tmp.Id
                       , ROW_NUMBER() OVER (PARTITION BY tmp.PersonalId ORDER BY tmp.Operdate ASC ) AS Ord_in
                       --, ROW_NUMBER() OVER (PARTITION BY tmp.PersonalId ORDER BY tmp.Operdate ASC ) AS Ord_in
                  FROM (
                       SELECT ObjectProtocol.Operdate
                            , ObjectProtocol.Id AS Id
                            , ObjectProtocol.UserId AS UserId
                            , ObjectProtocol.ObjectId AS PersonalId
                       FROM objectProtocol --limit 10
                           INNER JOIN (SELECT DISTINCT tmp.PersonalId 
                                       FROM tmp
                                      ) AS tmpData ON tmpData.PersonalId = objectProtocol.ObjectId 
                       ) AS tmp
                 )


         
          SELECT tmp.*
               , tmpProtocol.Operdate AS Operdate_pr
               , tmpProtocol.UserId   AS UserId_pr
          FROM tmp
               /*LEFT JOIN tmpSave ON tmpSave.MemberId = tmp.MemberId
                                AND tmpSave.Param = 1   */
               LEFT JOIN tmpProtocol ON tmpProtocol.PersonalId = tmp.PersonalId AND tmpProtocol.Ord_in = 1
         -- WHERE  tmpSave.MemberId IS NULL
where tmp.MemberId IS NOT NULL
          order by tmp.MemberId, tmp.OperDate, tmp.PersonalId, tmp.Comment, tmp.ismain 

)  AS tmp

*/
