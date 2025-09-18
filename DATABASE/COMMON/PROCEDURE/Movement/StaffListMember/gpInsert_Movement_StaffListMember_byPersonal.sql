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
                                                     , inOperDate            := tmp.DateIn
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
                                                     , inComment             := 'Авто.' ::TVarChar           
                                                     , inUserId              := vbUserId
                                                      )
     FROM (
           WITH
           tmp AS (--новый и совместительство
                   SELECT Object_Personal_View.*
                        , ROW_NUMBER () OVER (ORDER BY Object_Personal_View.DateIn, COALESCE (Object_Personal_View.DateSend,zc_DateStart() ) ) AS Ord
                        , ROW_NUMBER () OVER (Partition by memberId  ORDER BY isMain desc, Object_Personal_View.DateIn, COALESCE (Object_Personal_View.DateSend,zc_DateStart() )) AS Ord_member
                        , CASE WHEN isMain = True THEN zc_Enum_StaffListKind_In() ELSE zc_Enum_StaffListKind_Add() END AS StaffListKindId
                   FROM Object_Personal_View
                   WHERE (COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) = zc_DateEnd()
                      and (isMain = True --основное место работы
                         OR
                           (isMain <> True AND COALESCE (Object_Personal_View.DateSend,zc_DateStart()) = zc_DateStart())
                           ) -- по совместительству 
                          )
                  AND inParam = 1
                UNION
                  --перевод
                  SELECT Object_Personal_View.*
                        , ROW_NUMBER () OVER (ORDER BY Object_Personal_View.DateIn, COALESCE (Object_Personal_View.DateSend,zc_DateStart() ) ) AS Ord
                        , ROW_NUMBER () OVER (Partition by memberId  ORDER BY isMain desc, Object_Personal_View.DateIn, COALESCE (Object_Personal_View.DateSend,zc_DateStart() )) AS Ord_member
                        , zc_Enum_StaffListKind_Send()  AS StaffListKindId
                   FROM Object_Personal_View
                   WHERE (COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) = zc_DateEnd()
                     AND isMain <> True AND COALESCE (Object_Personal_View.DateSend,zc_DateStart()) <> zc_DateStart() -- перевод
                         )
                     AND inParam = 2
                UNION
                  --уволенные
                  SELECT Object_Personal_View.*
                        , ROW_NUMBER () OVER (ORDER BY Object_Personal_View.DateIn, COALESCE (Object_Personal_View.DateSend,zc_DateStart() ) ) AS Ord
                        , ROW_NUMBER () OVER (Partition by memberId  ORDER BY isMain desc, Object_Personal_View.DateIn, COALESCE (Object_Personal_View.DateSend,zc_DateStart() )) AS Ord_member
                        , zc_Enum_StaffListKind_Out()  AS StaffListKindId
                   FROM Object_Personal_View
                   WHERE COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) <> zc_DateEnd()
                  AND inParam = 3
                  )
           SELECT *
           FROM tmp
           WHERE tmp.DateIn>='01.09.2025'
           ) AS tmp
     ORDER BY tmp.Ord;   
 
     IF  vbUserId = 9457 THEN RAISE EXCEPTION 'Admin - Test = OK'; END IF;
    
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
