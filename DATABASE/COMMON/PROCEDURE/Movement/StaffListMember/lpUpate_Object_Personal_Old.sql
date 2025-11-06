-- Function: lpUpate_Object_Personal_Old ()

DROP FUNCTION IF EXISTS lpUpate_Object_Personal_Old (Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpUpate_Object_Personal_Old (
    IN inMovementId          Integer   , -- Ключ объекта <Документ, который отменяем>
    IN inSession             TVarChar      -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMemberId   Integer;
           vbPersonalId Integer;
           vbMovementId Integer;
           vbMovementId_old  Integer;
           vbStaffListKindId Integer;
           vbOperDate   TDateTime;
           
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     --чтоб пока ничего не поломать
     IF vbUserId NOT IN (5, 9457)
     THEN
         RETURN;
     END IF;

     --данные из вх. документа
     SELECT tmp.OperDate
          , tmp.Id 
          , tmp.PersonalId
          , tmp.MemberId
          , tmp.StaffListKindId
    INTO vbOperDate, vbMovementId, vbPersonalId, vbMemberId, vbStaffListKindId
     FROM gpGet_Movement_StaffListMember (inMovementId := inMovementId, inOperDate := CURRENT_DATE ::TDateTime, inSession := inSession ::TVarChar) AS tmp;
 
 
 --RAISE EXCEPTION 'Ошибка.<%>', vbPersonalId; 
     
    --получаем предыдущий документа
    SELECT tmp.MovementId
        -- , tmp.StaffListKindId
   INTO vbMovementId_old 
    FROM (SELECT Movement.Id AS  MovementId
               --, MovementLinkObject_StaffListKind.ObjectId AS StaffListKindId
               , ROW_NUMBER() OVER (ORDER BY Movement.Id DESC, Movement.OperDate DESC) AS Ord
          FROM Movement 
               INNER JOIN MovementLinkObject AS MovementLinkObject_Member
                                             ON MovementLinkObject_Member.MovementId = Movement.Id
                                            AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                                            AND MovementLinkObject_Member.ObjectId = vbMemberId

               INNER JOIN MovementLinkObject AS MovementLinkObject_StaffListKind
                                             ON MovementLinkObject_StaffListKind.MovementId = Movement.Id
                                            AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind()  --zc_Enum_StaffListKind_Send
                                            AND ((MovementLinkObject_StaffListKind.ObjectId = vbStaffListKindId AND vbStaffListKindId = zc_Enum_StaffListKind_Add()) 
                                                 OR (MovementLinkObject_StaffListKind.ObjectId <> zc_Enum_StaffListKind_Add() AND vbStaffListKindId <> zc_Enum_StaffListKind_Add()) 
                                                 ) 
          WHERE Movement.DescId = zc_Movement_StaffListMember()
            AND Movement.OperDate <= vbOperDate
            AND Movement.StatusId = zc_Enum_Status_Complete()
            AND Movement.Id <> inMovementId
          ) AS tmp
    WHERE  Ord = 1;
   
    --перезаписываем элемент справочника
    PERFORM gpInsertUpdate_Object_Personal(ioId                              := COALESCE (vbPersonalId,0)          ::Integer    -- ключ объекта <Сотрудники>
                                         , inMemberId                        := vbMemberId                         ::Integer    -- ссылка на Физ.лица
                                         , inPositionId                      := tmp.PositionId                      ::Integer    -- ссылка на Должность
                                         , inPositionLevelId                 := tmp.PositionLevelId                 ::Integer    -- ссылка на Разряд должности
                                         , inUnitId                          := tmp.UnitId                          ::Integer    -- ссылка на Подразделение
                                         , inPersonalGroupId                 := tmp.PersonalGroupId                 ::Integer    -- Группировки Сотрудников
                                         , inPersonalServiceListId           := tmp.PersonalServiceListId           ::Integer    -- Ведомость начисления(главная)
                                         , inPersonalServiceListOfficialId   := tmp.PersonalServiceListOfficialId   ::Integer    -- Ведомость начисления(БН)
                                         , inPersonalServiceListCardSecondId := tmp.ServiceListCardSecondId         ::Integer    -- Ведомость начисления(Карта Ф2) 
                                         , inPersonalServiceListId_AvanceF2  := tmp.ServiceListId_AvanceF2  ::Integer    --  Ведомость начисления(аванс Карта Ф2)
                                         , inSheetWorkTimeId                 := tmp.SheetWorkTimeId                 ::Integer    -- Режим работы (Шаблон табеля р.вр.)
                                         , inStorageLineId                   := tmp.StorageLineId_1                   ::Integer    -- ссылка на линию производства
                                         
                                         , inMember_ReferId                  := tmp.Member_ReferId                  ::Integer    -- Фамилия рекомендателя
                                         , inMember_MentorId                 := tmp.Member_MentorId                 ::Integer    -- Фамилия наставника 	
                                         , inReasonOutId                     := tmp.ReasonOutId                     ::Integer    -- Причина увольнения 	
                                         
                                         , inDateIn                          := CASE WHEN tmp.StaffListKindId IN (zc_Enum_StaffListKind_Add(), zc_Enum_StaffListKind_In() ) THEN tmp.OperDate ELSE ObjectDate_DateIn.ValueData END ::TDateTime  -- Дата принятия
                                         , inDateOut                         := CASE WHEN tmp.StaffListKindId = zc_Enum_StaffListKind_Out() THEN tmp.OperDate ELSE NULL END  ::TDateTime  -- Дата увольнения 
                                         , inDateSend                        := CASE WHEN tmp.StaffListKindId = zc_Enum_StaffListKind_Send() THEN tmp.OperDate ELSE NULL END ::TDateTime  -- Дата перевода
                                         , inIsDateOut                       := CASE WHEN tmp.StaffListKindId = zc_Enum_StaffListKind_Out() THEN TRUE ELSE False END         ::Boolean    -- Уволен
                                         , inIsDateSend                      := CASE WHEN tmp.StaffListKindId = zc_Enum_StaffListKind_Send() THEN True ELSE False END        ::Boolean    -- переведен
                                         , inIsMain                          := tmp.IsMain                          ::Boolean    -- Основное место работы
                                         , inComment                         := tmp.Comment                         ::TVarChar  
                                         , inSession                         := inSession                           ::TVarChar   -- сессия пользователя 
                                         )
    FROM gpGet_Movement_StaffListMember (inMovementId := vbMovementId_old, inOperDate := CURRENT_DATE ::TDateTime, inSession := inSession ::TVarChar) AS tmp
       --LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = vbPersonalId --tmp.PersonalId
        LEFT JOIN ObjectDate AS ObjectDate_DateIn
                             ON ObjectDate_DateIn.ObjectId = vbPersonalId
                            AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()
    ;    
    
  --  IF  vbUserId = 9457 THEN RAISE EXCEPTION 'Admin - Test = OK'; END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.10.25         *
*/

-- тест
--