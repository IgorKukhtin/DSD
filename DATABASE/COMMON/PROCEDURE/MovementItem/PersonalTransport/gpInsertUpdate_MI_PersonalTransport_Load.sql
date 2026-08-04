-- Function: gpInsertUpdate_MI_PersonalTransport_Load()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalTransport_Load (Integer, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalTransport_Load (Integer,Integer, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalTransport_Load(
    IN inMovementId             Integer   , -- Ключ объекта <Документ> 
    IN inMemberCode             Integer   , -- ФИО  сотрудника
    IN inPersonalName           TVarChar  , -- ФИО  сотрудника
    IN inPositionName           TVarChar  , -- должность 
    IN inComment                TVarChar  , -- примечание
    IN inAmount                 TFloat    , 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbMemberId Integer;
   DECLARE vbPositionId Integer;
   DECLARE vbPositionId_new Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitId_old Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalTransport());

     IF COALESCE (inAmount,0) = 0 THEN RETURN; END IF;
     
     -- поиск
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     --сначала поиск по коду потом по фио
     --поиск - по коду
     vbMemberId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_object_Member() AND Object.ObjectCode = inMemberCode);
     
     IF COALESCE (vbMemberId,0) = 0 
     THEN     
         -- поиск 1
         IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_object_Member() AND TRIM(Object.ValueData) ILIKE TRIM (inPersonalName) AND Object.isErased = FALSE)
         THEN
              RAISE EXCEPTION 'Ошибка.Найдено несколько ФИО в справочнике Физ.лиц, ФИО = <%>.', TRIM (inPersonalName);
         ELSE
             vbMemberId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_object_Member() AND TRIM(Object.ValueData) ILIKE  TRIM (inPersonalName));
         END IF;
     END IF;
     
     -- поиск-2
     IF COALESCE (vbMemberId,0) = 0
     THEN 
         IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_object_Member() AND TRIM(Object.ValueData) ILIKE TRIM (REPLACE (inPersonalName, '`', CHR (39))) AND Object.isErased = FALSE)
         THEN
              RAISE EXCEPTION 'Ошибка.Найдено несколько ФИО в справочнике Физ.лиц, ФИО = <%>.', TRIM (REPLACE (inPersonalName, '`', CHR (39)));
         END IF;
         --
         vbMemberId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_object_Member() AND TRIM(Object.ValueData) ILIKE TRIM (REPLACE (inPersonalName, '`', CHR (39))) AND Object.isErased = FALSE);
     END IF;

     -- поиск-3
     IF COALESCE (vbMemberId,0) = 0
     THEN 
         IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_object_Member() AND TRIM(Object.ValueData) ILIKE TRIM (REPLACE (inPersonalName, CHR (39), '`')) AND Object.isErased = FALSE)
         THEN
              RAISE EXCEPTION 'Ошибка.Найдено несколько ФИО в справочнике Физ.лиц, ФИО = <%>.', TRIM (REPLACE (inPersonalName, CHR (39), '`'));
         END IF;
         --
         vbMemberId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_object_Member() AND TRIM(Object.ValueData) ILIKE TRIM (REPLACE (inPersonalName, CHR (39), '`')) AND Object.isErased = FALSE);
     END IF;

     IF COALESCE (vbMemberId,0) = 0
     THEN 
          RAISE EXCEPTION 'Ошибка.Не найдено Физ.лицо <%> Сумма компенсации = <%>.<%>', inPersonalName, zfConvert_FloatToString (inAmount), REPLACE (inPersonalName, '`', CHR (39));
     END IF; 
     

     --находим должность
     IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_object_Position() AND Object.ValueData ILIKE TRIM (inPositionName) AND Object.isErased = FALSE)
     THEN
          RAISE EXCEPTION 'Ошибка.Найдено несколько Должностей в справочнике Должности, Значение = <%>.', TRIM (inPositionName);
     END IF;

     -- находим должность через Перевод
     SELECT Object_Position_old.Id
          , MLO_Position.ObjectId
          , MLO_Unit_old.ObjectId
            INTO vbPositionId, vbPositionId_new, vbUnitId_old
     FROM MovementLinkObject AS MLO_Member
          JOIN Movement ON Movement.Id       = MLO_Member.MovementId
                       AND Movement.DescId   = zc_Movement_StaffListMember()
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                       AND Movement.OperDate < DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH'
          JOIN MovementBoolean AS MB_Main
                               ON MB_Main.MovementId = MLO_Member.MovementId
                              AND MB_Main.DescId     = zc_MovementBoolean_Main()
                              -- Только Основное место
                              AND MB_Main.ValueData  = TRUE
          -- Перевод
          INNER JOIN MovementLinkObject AS MLO_StaffListKind
                                        ON MLO_StaffListKind.MovementId = MLO_Member.MovementId
                                       AND MLO_StaffListKind.DescId     = zc_MovementLinkObject_StaffListKind()
                                       AND MLO_StaffListKind.ObjectId   = zc_Enum_StaffListKind_Send()

        /*INNER JOIN MovementLinkObject AS MLO_Unit
                                        ON MLO_Unit.MovementId = MLO_Member.MovementId
                                       AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                                       AND MLO_Unit.ObjectId   = inUnitId*/
          INNER JOIN MovementLinkObject AS MLO_Position
                                        ON MLO_Position.MovementId = MLO_Member.MovementId
                                       AND MLO_Position.DescId     = zc_MovementLinkObject_Position()

          INNER JOIN MovementLinkObject AS MLO_Unit_old
                                        ON MLO_Unit_old.MovementId = MLO_Member.MovementId
                                       AND MLO_Unit_old.DescId     = zc_MovementLinkObject_Unit_old()
          INNER JOIN MovementLinkObject AS MLO_Position_old
                                        ON MLO_Position_old.MovementId = MLO_Member.MovementId
                                       AND MLO_Position_old.DescId     = zc_MovementLinkObject_Position_old()
          INNER JOIN Object AS Object_Position_old ON Object_Position_old.Id = MLO_Position_old.ObjectId
                                                  AND TRIM (Object_Position_old.ValueData) ILIKE TRIM (inPositionName)

     WHERE MLO_Member.ObjectId = vbMemberId
       AND MLO_Member.DescId   = zc_MovementLinkObject_Member()
     ORDER BY Movement.OperDate DESC
     LIMIT 1
    ;
     

     -- находим должность
     IF COALESCE (vbPositionId,0) = 0
     THEN 
         vbPositionId := (SELECT Object_Personal_View.PositionId
                          FROM Object_Personal_View
                          WHERE Object_Personal_View.MemberId = vbMemberId
                            AND TRIM (Object_Personal_View.PositionName) ILIKE TRIM (inPositionName)
                            AND Object_Personal_View.isErased = FALSE
                         );
         vbPositionId_new:= vbPositionId;
     END IF; 
     
     IF COALESCE (vbPositionId,0) = 0
     THEN 
          RAISE EXCEPTION 'Ошибка.Не найдена должность <%> для <%> Сумма компенсации = <%>.', inPositionName, inPersonalName, zfConvert_FloatToString (inAmount);
     END IF; 
     

     -- находим сотрудника
     SELECT lfSelect.PersonalId
          , CASE WHEN vbUnitId_old > 0
                      -- Если был Перевод, подставляем подразделение ДО Перевода
                      THEN vbUnitId_old
                 ELSE lfSelect.UnitId
            END
            INTO vbPersonalId, vbUnitId
     FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
     WHERE lfSelect.Ord = 1
       AND lfSelect.MemberId = vbMemberId
       -- Не ошибка - ищем для Должности после перевода
       AND lfSelect.PositionId = vbPositionId_new
     LIMIT 1;  --на всякий случай

     IF COALESCE (vbPersonalId,0) = 0
     THEN 
          RAISE EXCEPTION 'Ошибка.Не найден сотруник <%> должность <%> для Сумма компенсации = <%>.(%)+(%)'
                         , inPersonalName
                         , lfGet_Object_ValueData_sh (vbPositionId_new) -- inPositionName
                         , zfConvert_FloatToString (inAmount)
                         , vbMemberId
                         , vbPositionId
                          ;
     END IF;    
     


     -- Выбираем сохраненные данные из документа
     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
            (SELECT tmp.*
             FROM gpSelect_MovementItem_PersonalTransport(inMovementId, FALSE, FALSE, inSession) AS tmp
            );
     
     -- добавиляем новые строки и обновляем существующие
     PERFORM lpInsertUpdate_MovementItem_PersonalTransport (ioId          := COALESCE (tmpMI.Id,0) ::Integer
                                                          , inMovementId  := inMovementId
                                                          , inPersonalId  := vbPersonalId 
                                                          , inInfoMoneyId := zc_Enum_InfoMoney_21421()--
                                                          , inUnitId      := vbUnitId
                                                          , inPositionId  := vbPositionId 
                                                          , inAmount      := inAmount
                                                          , inComment     := inComment
                                                          , inUserId      := vbUserId
                                                          ) 
     FROM (SELECT vbMemberId AS MemberId, vbPersonalId AS PersonalId, vbPositionId AS PositionId) AS tmp
          LEFT JOIN tmpMI ON tmpMI.PersonalId = tmp.PersonalId
                         AND tmpMI.MemberId = tmp.MemberId
                         AND tmpMI.PositionId = tmp.PositionId
     ;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.04.25         * add inMemberCode
 01.09.22         *
*/

-- тест
--