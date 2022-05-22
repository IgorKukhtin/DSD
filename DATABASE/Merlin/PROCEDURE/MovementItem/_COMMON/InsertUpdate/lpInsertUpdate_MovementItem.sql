-- Function: lpInsertUpdate_MovementItem

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem (Integer, Integer, Integer, Integer, Integer, TFloat, Integer, Integer);
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
  DECLARE vbStatusId        Integer;
  DECLARE vbInvNumber       TVarChar;
  DECLARE vbIsErased        Boolean;
  DECLARE vbMovementId      Integer;
  DECLARE vbMovementDescId  Integer;
  DECLARE vbDescId          Integer;
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
     SELECT StatusId, InvNumber, DescId INTO vbStatusId, vbInvNumber, vbMovementDescId FROM Movement WHERE Id = inMovementId;

     -- проверка - проведенные/удаленные документы Изменять нельзя + !!!временно для SYBASE -1 * zc_User_Sybase() !!!
     IF vbStatusId <> zc_Enum_Status_UnComplete()  AND (vbMovementDescId <> zc_Movement_Cash() OR inDescId <> zc_MI_Child())
        AND inDescId <> zc_MI_Sign()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData_sh (vbStatusId);
     END IF;

     -- проверка - inAmount
     IF inAmount IS NULL AND inDescId = zc_MI_Master()
     THEN
         RAISE EXCEPTION 'Ошибка-1.Не определено Количество в документе № <%>.', vbInvNumber;
     ELSEIF inAmount IS NULL AND inDescId <> zc_MI_Master()
     THEN
         RAISE EXCEPTION 'Ошибка-1.Не определена Сумма в документе № <%>.', vbInvNumber;
     END IF;

     -- проверка - inObjectId
     IF inObjectId IS NULL AND inDescId = zc_MI_Master()
     THEN
         RAISE EXCEPTION 'Ошибка-1.Не определен Элемент в документе № <%>.', vbInvNumber;
     END IF;

     IF COALESCE (ioId, 0) = 0
     THEN
         --
         INSERT INTO MovementItem (DescId, ObjectId, MovementId, Amount, ParentId)
                           VALUES (inDescId, inObjectId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;

     ELSE
         --
         UPDATE MovementItem SET ObjectId   = inObjectId
                               , Amount     = inAmount
                               , ParentId   = inParentId
                                 -- !!!временно для Sybase!!!
                               , MovementId = inMovementId
                            -- , DescId     = inDescId
         WHERE Id = ioId
         RETURNING isErased, MovementId, DescId INTO vbIsErased, vbMovementId, vbDescId
        ;

         -- если такой элемент не был найден
         IF NOT FOUND THEN
            -- Ошибка
            RAISE EXCEPTION 'Ошибка.Элемент <%> в документе № <%> не найден.', ioId, vbInvNumber;
            --
            INSERT INTO MovementItem (Id, DescId, ObjectId, MovementId, Amount, ParentId)
                              VALUES (ioId, inDescId, inObjectId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;

         END IF;
 
         -- Проверка
         IF vbIsErased = TRUE
         THEN
             RAISE EXCEPTION 'Ошибка.Элемент не может корректироваться т.к. он <Удален>.';
         END IF;

     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.01.22         *
*/

-- тест
