-- Function: gpInsert_Movement_StaffListMember_byPersonalDel ()
--сохранение удаленных
DROP FUNCTION IF EXISTS gpInsert_Movement_StaffListMember_byPersonalDel ( Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_StaffListMember_byPersonalDel ( TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_StaffListMember_byPersonalDel(
    --IN inParam               Integer   , -- 
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
                                                     , inPositionId_old      := 0    ::Integer 
                                                     , inPositionLevelId_old := 0    ::Integer
                                                     , inUnitId_old          := 0    ::Integer     
                                                     , inReasonOutId         := 0    ::Integer   
                                                     , inStaffListKindId     := tmp.StaffListKindId    
                                                     , inisOfficial          := tmp.isOfficial         
                                                     , inisMain              := tmp.isMain             
                                                     , inComment             := ('Авто (удаленные) '||tmp.Comment::TVarChar) ::TVarChar 
                                                     , inUserId_protocol     := tmp.UserId_pr       ::Integer
                                                     , inOperDate_protocol   := tmp.Operdate_pr     ::TDateTime              
                                                     , inUserId              := vbUserId
                                                      )
     FROM (
                   WITH
           tmpViewPersonal AS (SELECT *
                               FROM Object_Personal_View
                               WHERE Object_Personal_View.isERased = TRUE
                               )


          , tmp1 AS (--новый и совместительство   inParam = 1
                   --основное м.р.  и  увольнение
                   SELECT tmpViewPersonal.DateIn AS OperDate
, tmpViewPersonal.DateOut
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
                           AND COALESCE (tmpViewPersonal.DateOut, zc_DateEnd()) <> zc_DateEnd()
                          ) 
                      AND 1 = 1
                 --   AND tmpViewPersonal.MemberId = 8244486 --11121446 --
             /*   UNION
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
                   WHERE (tmpViewPersonal.isMain = True
                          AND COALESCE (tmpViewPersonal.DateOut, zc_DateEnd()) <> zc_DateEnd())
                  AND 1 = 3
                 --         AND tmpViewPersonal.MemberId = 8244486 --11121446 --
*/
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
                        /*, CASE WHEN MovementLinkObject_StaffListKind.ObjectId IN (zc_Enum_StaffListKind_In(), zc_Enum_StaffListKind_Add()) THEN 1
                               WHEN MovementLinkObject_StaffListKind.ObjectId IN (zc_Enum_StaffListKind_Send()) THEN 2
                               WHEN MovementLinkObject_StaffListKind.ObjectId IN (zc_Enum_StaffListKind_Out()) THEN 3
                          END AS Param   
                          */
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
  , tmp AS (SELECT tmp1.*
            FROM tmp1
                LEFT JOIN tmpSave ON tmpSave.MemberId = tmp1.MemberId
            WHERE tmpSave.MemberId IS NULL
            )
  --данные из Протоколв
, tmpProtocol AS (SELECT tmp.Operdate
                       , tmp.DateOut
                       , tmp.UserId
                       , tmp.PersonalId
                       , ROW_NUMBER() OVER (PARTITION BY tmp.PersonalId ORDER BY tmp.Operdate ASC ) AS Ord_in
                       , ROW_NUMBER() OVER (PARTITION BY tmp.PersonalId, DateOut ORDER BY tmp.Operdate Asc ) AS Ord_out
                  FROM (
                       SELECT ObjectProtocol.Operdate
                            , ObjectProtocol.Id AS Id
                            , ObjectProtocol.UserId AS UserId
                            , ObjectProtocol.ObjectId AS PersonalId
                            , zfConvert_StringToDate ( REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата увольнения у сотрудника"]  /@FieldValue', ObjectProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')) AS DateOut

                       FROM objectProtocol --limit 10
                           INNER JOIN (SELECT DISTINCT tmp.PersonalId 
                                       FROM tmp
                                      ) AS tmpData ON tmpData.PersonalId = objectProtocol.ObjectId 
                       ) AS tmp
                 )
 
          SELECT tmp.OperDate
                        , tmp.MemberId
                        , tmp.PersonalId 
                        , tmp.PositionId
                        , tmp.PositionLevelId    
                        , tmp.UnitId
                        , tmp.isOfficial         
                        , tmp.isMain 
                        , zc_Enum_StaffListKind_In() AS StaffListKindId
                        , 1 AS Comment                                 

               , tmpProtocol.Operdate AS Operdate_pr
               , tmpProtocol.UserId   AS UserId_pr
           FROM tmp
                LEFT JOIN tmpProtocol ON tmpProtocol.PersonalId = tmp.PersonalId
                                     AND tmpProtocol.Ord_in = 1
       --where MemberId = 8470
         UNION ALL
           SELECT tmp.DateOut AS OperDate
                        , tmp.MemberId
                        , tmp.PersonalId 
                        , tmp.PositionId
                        , tmp.PositionLevelId    
                        , tmp.UnitId
                        , tmp.isOfficial         
                        , tmp.isMain 
                        , zc_Enum_StaffListKind_Out() AS StaffListKindId
                        , 3 AS Comment                                 

               , tmpProtocol_out.Operdate AS Operdate_pr
               , tmpProtocol_out.UserId   AS UserId_pr
           FROM tmp
                LEFT JOIN tmpProtocol AS tmpProtocol_out
                                      ON tmpProtocol_out.PersonalId = tmp.PersonalId
                                     AND tmpProtocol_out.Ord_out = 1
                                     AND tmpProtocol_out.DateOut = tmp.DateOut 
                                     --AND 1 = 3
           
--where MemberId = 8470


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
--  
--  SELECT * FROM gpInsert_Movement_StaffListMember_byPersonalDel(  inSession :='9457'::TVarChar)