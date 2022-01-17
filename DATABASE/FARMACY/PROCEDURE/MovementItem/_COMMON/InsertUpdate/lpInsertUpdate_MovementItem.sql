-- Function: lpInsertUpdate_MovementItem

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem (Integer, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem (Integer, Integer, Integer, Integer, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem(
 INOUT ioId           Integer, 
    IN inDescId       Integer, 
    IN inObjectId     Integer, 
    IN inMovementId   Integer,
    IN inAmount       TFloat,
    IN inParentId     Integer,
    IN inUserId       Integer DEFAULT 0 -- Пользователь
)
  RETURNS Integer AS
$BODY$
  DECLARE vbStatusId  Integer;
  DECLARE vbInvNumber TVarChar;
  DECLARE vbIsErased  Boolean;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbItemName  TVarChar;
  DECLARE vbObjectName     TVarChar;
  DECLARE vbObjectDescName TVarChar;
BEGIN
     -- меняем параметр
     IF inParentId = 0
     THEN
         inParentId := NULL;
     END IF;

     -- меняем параметр
     IF inObjectId = 0
     THEN
         inObjectId := NULL;
     END IF;


     -- 0. Проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;


     -- определяем <Статус>
     SELECT Movement.StatusId, Movement.InvNumber, Movement.OperDate, MovementDesc.ItemName 
     INTO vbStatusId, vbInvNumber, vbOperDate, vbItemName
     FROM Movement 
          LEFT OUTER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.Id = inMovementId;
     
     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete() AND COALESCE (inUserId, 0) <> zc_Enum_Process_Auto_PartionClose()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     -- проверка - inAmount
     IF inAmount IS NULL
     THEN
         RAISE EXCEPTION 'Ошибка-1.Не определено количество/сумма в документе № <%>.', vbInvNumber;
     END IF;
     -- проверка - inObjectId
     IF inObjectId IS NULL
     THEN
--         RAISE EXCEPTION 'Ошибка-1.Не определен Объект в документе № <%>.', vbInvNumber;
     END IF;


     IF COALESCE (ioId, 0) = 0
     THEN
         --
         INSERT INTO MovementItem (DescId, ObjectId, MovementId, Amount, ParentId)
                           VALUES (inDescId, inObjectId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;
     ELSE
         --
         UPDATE MovementItem SET ObjectId = inObjectId, Amount = inAmount, ParentId = inParentId/*, MovementId = inMovementId*/ WHERE Id = ioId
         RETURNING isErased INTO vbIsErased;
         --
         IF NOT FOUND THEN
            RAISE EXCEPTION 'Ошибка.Элемент <%> в документе № <%> не найдена.', ioId, vbInvNumber;
            INSERT INTO MovementItem (Id, DescId, ObjectId, MovementId, Amount, ParentId)
                              VALUES (ioId, inDescId, inObjectId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;
         END IF;
         --
         IF vbIsErased = TRUE
         THEN
             -- определяем <Элемент>
             SELECT Object.ValueData, ObjectDesc.ItemName 
             INTO vbObjectName, vbObjectDescName
             FROM MovementItem 
                  LEFT OUTER JOIN Object ON Object.Id = MovementItem.ObjectId
                  LEFT OUTER JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
             WHERE MovementItem.Id = ioId;

             RAISE EXCEPTION 'Ошибка.Элемент не может корректироваться т.к. он <Удален>.%Документ <%> номер <%> от <%>%Элемент <%> название <%>', 
               CHR(13)||CHR(13), vbItemName, vbInvNumber, zfConvert_DateShortToString(vbOperDate), CHR(13)||CHR(13), vbObjectDescName, vbObjectName;
         END IF;
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.01.22                                                       * Подробно о удоляемой строчке 
 11.07.15                                        * add inUserId
 17.05.14                                        * add проверка - inAmount and inObjectId
 05.04.14                                        * add vbIsErased
 31.10.13                                        * add vbInvNumber
 06.10.13                                        * add vbStatusId
 09.08.13                                        * add inObjectId := NULL
 09.08.13                                        * add inObjectId := NULL
 23.07.13                                        * add inParentId := NULL
*/

-- тест