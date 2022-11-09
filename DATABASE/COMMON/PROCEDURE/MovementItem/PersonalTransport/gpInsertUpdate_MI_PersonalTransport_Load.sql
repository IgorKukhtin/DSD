-- Function: gpInsertUpdate_MI_PersonalTransport_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalTransport_Load (Integer, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalTransport_Load(
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inPersonalName           TVarChar  , -- ФИО  сотрудника
    IN inPositionName           TVarChar  , -- должность 
    IN inComment                TVarChar  , -- примечание
    IN inAmount                 TFloat    , 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
   DECLARE vbPositionId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalTransport());

     IF COALESCE (inAmount,0) = 0 THEN RETURN; END IF;
     
     -- поиск
     vbMemberId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_object_Member() AND TRIM(Object.ValueData) ILIKE  TRIM (inPersonalName));
     
     -- поиск-2
     IF COALESCE (vbMemberId,0) = 0
     THEN 
         vbMemberId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_object_Member() AND TRIM(Object.ValueData) ILIKE  TRIM (REPLACE (inPersonalName, '`', CHR (39))));
     END IF;
     -- поиск-3
     IF COALESCE (vbMemberId,0) = 0
     THEN 
         vbMemberId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_object_Member() AND TRIM(Object.ValueData) ILIKE  TRIM (REPLACE (inPersonalName, CHR (39), '`')));
     END IF;

     IF COALESCE (vbMemberId,0) = 0
     THEN 
          RAISE EXCEPTION 'Ошибка.Не найдено Физ.лицо <%> Сумма компенсации = <%>.<%>', inPersonalName, zfConvert_FloatToString (inAmount), REPLACE (inPersonalName, '`', CHR (39));
     END IF; 
     
     --находим должность
     vbPositionId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_object_Position() AND  (Object.ValueData) ILIKE TRIM (inPositionName));
     
     IF COALESCE (vbPositionId,0) = 0
     THEN 
          RAISE EXCEPTION 'Ошибка.Не найдена должность <%> для <%> Сумма компенсации = <%>.', inPositionName, inPersonalName, zfConvert_FloatToString (inAmount);
     END IF; 
     
      --находим сотрудника
     SELECT lfSelect.PersonalId
          , lfSelect.UnitId    
   INTO vbPersonalId, vbUnitId
     FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
     WHERE lfSelect.Ord = 1
       AND lfSelect.MemberId = vbMemberId AND lfSelect.PositionId = vbPositionId
     LIMIT 1;  --на всякий случай

     IF COALESCE (vbPersonalId,0) = 0
     THEN 
          RAISE EXCEPTION 'Ошибка.Не найден сотруник <> должность <%> для <%> Сумма компенсации = <%>.', inPersonalName, inPositionName, zfConvert_FloatToString (inAmount);
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
 01.09.22         *
*/

-- тест
--