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
           vbOperDate        TDateTime;
           vbUnitId          Integer;
           vbPositionId      Integer;
           vbPositionLevelId Integer;
           vbisMain          Boolean;
           
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     --чтоб пока ничего не поломать
    /* IF vbUserId NOT IN (9457)
     THEN
         RETURN;
     END IF;
    */
     --данные из вх. документа
     SELECT tmp.OperDate
          , tmp.Id 
          , tmp.PersonalId
          , tmp.MemberId
          , tmp.StaffListKindId
          , tmp.isMain
          , tmp.UnitId
          , tmp.PositionId
          , tmp.PositionLevelId
          
    INTO vbOperDate, vbMovementId, vbPersonalId, vbMemberId, vbStaffListKindId
       , vbisMain, vbUnitId, vbPositionId, vbPositionLevelId
     FROM gpGet_Movement_StaffListMember (inMovementId := inMovementId, inOperDate := CURRENT_DATE ::TDateTime, inSession := inSession ::TVarChar) AS tmp;
 
 
 --RAISE EXCEPTION 'Ошибка.<%>', vbPersonalId; 
     
    --получаем предыдущий документа 
    
    -- для основного места работы по физ.лицу 
    -- ищим предудущий документ с признаком гл. место работы 
    IF COALESCE (vbisMain, FALSE) = TRUE
    THEN 
        SELECT tmp.MovementId
            -- , tmp.StaffListKindId
       INTO vbMovementId_old 
        FROM (SELECT Movement.Id AS  MovementId
                   , ROW_NUMBER() OVER (ORDER BY Movement.Id DESC, Movement.OperDate DESC) AS Ord
              FROM Movement 
                   INNER JOIN MovementLinkObject AS MovementLinkObject_Member
                                                 ON MovementLinkObject_Member.MovementId = Movement.Id
                                                AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                                                AND MovementLinkObject_Member.ObjectId = vbMemberId

                   INNER JOIN MovementBoolean AS MovementBoolean_Main
                                              ON MovementBoolean_Main.MovementId = Movement.Id
                                             AND MovementBoolean_Main.DescId = zc_MovementBoolean_Main()
                                             AND COALESCE (MovementBoolean_Main.ValueData, FALSE) = TRUE
              WHERE Movement.DescId = zc_Movement_StaffListMember()
                AND Movement.OperDate <= vbOperDate
                AND Movement.StatusId = zc_Enum_Status_Complete()
                AND Movement.Id <> inMovementId
              ) AS tmp
        WHERE Ord = 1;
    END IF;
    
    -- для совместителя ищем предыдущий документ по физ.лицу +подраз. + должность + разряд 
    -- если удаляют или отменяют увольнение тогда пересохр. прием, для приема пока ничего не делаем
    IF COALESCE (vbisMain, FALSE) = FALSE
    THEN
        SELECT tmp.MovementId
       INTO vbMovementId_old 
        FROM (SELECT Movement.Id AS  MovementId
                   , ROW_NUMBER() OVER (ORDER BY Movement.Id DESC, Movement.OperDate DESC) AS Ord
              FROM Movement 
                   INNER JOIN MovementLinkObject AS MovementLinkObject_Member
                                                 ON MovementLinkObject_Member.MovementId = Movement.Id
                                                AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                                                AND MovementLinkObject_Member.ObjectId = vbMemberId
    
                   LEFT JOIN MovementBoolean AS MovementBoolean_Main
                                             ON MovementBoolean_Main.MovementId = Movement.Id
                                            AND MovementBoolean_Main.DescId = zc_MovementBoolean_Main()    

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                AND MovementLinkObject_Unit.ObjectId = vbUnitId

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Position
                                                 ON MovementLinkObject_Position.MovementId = Movement.Id
                                                AND MovementLinkObject_Position.DescId = zc_MovementLinkObject_Position()
                                                AND MovementLinkObject_Position.ObjectId = vbPositionId
       
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_PositionLevel
                                                ON MovementLinkObject_PositionLevel.MovementId = Movement.Id
                                               AND MovementLinkObject_PositionLevel.DescId = zc_MovementLinkObject_PositionLevel()

              WHERE Movement.DescId = zc_Movement_StaffListMember()
                AND Movement.OperDate <= vbOperDate
                AND Movement.StatusId = zc_Enum_Status_Complete()
                AND Movement.Id <> inMovementId
                
                AND COALESCE (MovementLinkObject_PositionLevel.ObjectId,0) = COALESCE (vbPositionLevelId,0)
                AND COALESCE (MovementBoolean_Main.ValueData, FALSE) = FALSE  --только совместительство
              ) AS tmp
        WHERE  Ord = 1;
    END IF;
                 
    --Если НЕ НАШЛИ предыдущий документ - пока ничего не делаем
    IF COALESCE (vbMovementId_old, 0) = 0
    THEN
         -- 
         /* когда не находит предыдущую инфу, надо удалять в справ. сотрудников - только если это подработка
           для основного - разрешать удалять если в справ сотрудников нет видимой строчки с основным местом работы (т.е. в справочнике его вручную удалили) иначе сообщение что надо удалить сотрудника в справочнике*/
        
        -- совместительство и найден сотрудник, то метим на удаление  -- т.е. отмена проведения приема на работу
        IF COALESCE (vbisMain, FALSE) = FALSE AND COALESCE (vbPersonalId,0) <> 0
        THEN
            PERFORM lpUpdate_Object_isErased (inObjectId:= vbPersonalId, inUserId:= vbUserId);
            RETURN; 
            --RAISE EXCEPTION 'Admin - Test1 = OK';
        END IF; 
        
        --Основное место работы
        IF COALESCE (vbisMain, FALSE) = TRUE 
            IF COALESCE (vbPersonalId,0) <> 0
            THEN 
             --Если еще не помечен на удаление тогда выдем сообщение
                IF (SELECT Object.isErased FROM Object WHERE Object.Id = vbPersonalId AND Object.DescId = zc_Object_Personal()) = FALSE
                THEN
                   RAISE EXCEPTION 'Внимание. Не найден предыдущий документ для сотрудника <%>, <%> нужно удалить сотрудника в справочнике.'
                                    , (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPersonalId AND Object.DescId = zc_Object_Personal())
                                    , CHR (13);
                ELSE
                    RETURN;
                END IF;
        END IF;
        --если не найден сотрудник по основному месту работы, например уже удалили
        IF COALESCE (vbisMain, FALSE) = TRUE AND COALESCE (vbPersonalId,0) = 0
        THEN 
            RETURN;
        END IF;
        
    END IF; 
    
    --Если НАШЛИ предыдущий документ - перезаписываем элемент справочника
    PERFORM gpInsertUpdate_Object_Personal(ioId                              := COALESCE (vbPersonalId,0)           ::Integer    -- ключ объекта <Сотрудники>
                                         , inMemberId                        := vbMemberId                          ::Integer    -- ссылка на Физ.лица
                                         , inPositionId                      := tmp.PositionId                      ::Integer    -- ссылка на Должность
                                         , inPositionLevelId                 := tmp.PositionLevelId                 ::Integer    -- ссылка на Разряд должности
                                         , inUnitId                          := tmp.UnitId                          ::Integer    -- ссылка на Подразделение
                                         , inPersonalGroupId                 := tmp.PersonalGroupId                 ::Integer    -- Группировки Сотрудников
                                         , inPersonalServiceListId           := tmp.PersonalServiceListId           ::Integer    -- Ведомость начисления(главная)
                                         , inPersonalServiceListOfficialId   := tmp.PersonalServiceListOfficialId   ::Integer    -- Ведомость начисления(БН)
                                         , inPersonalServiceListCardSecondId := tmp.ServiceListCardSecondId         ::Integer    -- Ведомость начисления(Карта Ф2) 
                                         , inPersonalServiceListId_AvanceF2  := tmp.ServiceListId_AvanceF2          ::Integer    --  Ведомость начисления(аванс Карта Ф2)
                                         , inSheetWorkTimeId                 := tmp.SheetWorkTimeId                 ::Integer    -- Режим работы (Шаблон табеля р.вр.)
                                         , inStorageLineId                   := tmp.StorageLineId_1                 ::Integer    -- ссылка на линию производства
                                         
                                         , inMember_ReferId                  := tmp.Member_ReferId                  ::Integer    -- Фамилия рекомендателя
                                         , inMember_MentorId                 := tmp.Member_MentorId                 ::Integer    -- Фамилия наставника 	
                                         , inReasonOutId                     := tmp.ReasonOutId                     ::Integer    -- Причина увольнения 	
                                         
                                         , inDateIn                          := CASE WHEN tmp.StaffListKindId IN (zc_Enum_StaffListKind_Add(), zc_Enum_StaffListKind_In() ) THEN tmp.OperDate ELSE ObjectDate_DateIn.ValueData END ::TDateTime  -- Дата принятия
                                         , inDateOut                         := CASE WHEN tmp.StaffListKindId = zc_Enum_StaffListKind_Out() THEN tmp.OperDate ELSE NULL END  ::TDateTime  -- Дата увольнения 
                                         , inDateSend                        := CASE WHEN tmp.StaffListKindId = zc_Enum_StaffListKind_Send() THEN tmp.OperDate ELSE NULL END ::TDateTime  -- Дата перевода
                                         , inIsDateOut                       := CASE WHEN tmp.StaffListKindId = zc_Enum_StaffListKind_Out() THEN TRUE ELSE False END         ::Boolean    -- Уволен
                                         , inIsDateSend                      := CASE WHEN tmp.StaffListKindId = zc_Enum_StaffListKind_Send() THEN True ELSE False END        ::Boolean    -- переведен
                                         , inIsMain                          := tmp.IsMain                          ::Boolean    -- Основное место работы
                                         , inNumBiz                          := tmp.NumBiz                          ::TVarChar
                                         , inComment                         := tmp.Comment                         ::TVarChar  
                                         , inSession                         := (-1 * vbUserId)                     ::TVarChar   -- сессия пользователя 
                                         )
    FROM gpGet_Movement_StaffListMember (inMovementId := vbMovementId_old
                                       , inOperDate := CURRENT_DATE ::TDateTime
                                       , inSession := inSession ::TVarChar
                                        ) AS tmp
        LEFT JOIN ObjectDate AS ObjectDate_DateIn
                             ON ObjectDate_DateIn.ObjectId = vbPersonalId
                            AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()
    ;    
    
   IF  vbUserId = 9457 THEN RAISE EXCEPTION 'Admin - Test = OK'; END IF;

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