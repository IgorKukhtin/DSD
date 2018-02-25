-- Function: lpInsertUpdate_MovementItem

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem (Integer, Integer, Integer, Integer, Integer, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem(
 INOUT ioId           Integer, 
    IN inDescId       Integer, 
    IN inObjectId     Integer, 
    IN inPartionId    Integer, -- Партия в Object_PartionGoods.MovementItemId
    IN inMovementId   Integer,
    IN inAmount       TFloat ,
    IN inParentId     Integer,
    IN inUserId       Integer DEFAULT 0 -- Пользователь
)
RETURNS Integer
AS
$BODY$
  DECLARE vbStatusId   Integer;
  DECLARE vbInvNumber  TVarChar;
  DECLARE vbIsErased   Boolean;
  DECLARE vbMovementId Integer;
  DECLARE vbDescId     Integer;
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

     -- меняем параметр  
     IF inPartionId = 0
     THEN
         inPartionId := NULL;
     END IF;

     -- 0. Проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;


     -- определяем <Статус>
     SELECT StatusId, InvNumber INTO vbStatusId, vbInvNumber FROM Movement WHERE Id = inMovementId;

     -- проверка - проведенные/удаленные документы Изменять нельзя + !!!временно для SYBASE -1 * zc_User_Sybase() !!!
     IF vbStatusId <> zc_Enum_Status_UnComplete() AND inUserId <> -1 * zc_User_Sybase()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData_sh (vbStatusId);
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
         INSERT INTO MovementItem (DescId, ObjectId, PartionId, MovementId, Amount, ParentId)
                           VALUES (inDescId, inObjectId, inPartionId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;
     ELSE
         --
         UPDATE MovementItem SET ObjectId   = inObjectId
                               , PartionId  = inPartionId
                               , Amount     = inAmount
                               , ParentId   = inParentId
                            -- , MovementId = inMovementId
                            -- , DescId     = inDescId
         WHERE Id = ioId
         RETURNING isErased, MovementId, DescId INTO vbIsErased, vbMovementId, vbDescId
        ;

         -- если такой элемент не был найден
         IF NOT FOUND THEN
            -- Ошибка
            RAISE EXCEPTION 'Ошибка.Элемент <%> в документе № <%> не найден.', ioId, vbInvNumber;
            --
            INSERT INTO MovementItem (Id, DescId, ObjectId, PartionId, MovementId, Amount, ParentId)
                              VALUES (ioId, inDescId, inObjectId, inPartionId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;
         END IF;
 
         -- Проверка
         IF vbIsErased = TRUE
         THEN
             RAISE EXCEPTION 'Ошибка.Элемент не может корректироваться т.к. он <Удален>.';
         END IF;

         -- Проверка - т.к. DescId - !!!НЕ МЕНЯЕТСЯ!!!
         IF COALESCE (inDescId, -1) <> COALESCE (vbDescId, -2)
         THEN
             RAISE EXCEPTION 'Ошибка изменения DescId с <%>(<%>) на <%>(<%>)', (SELECT ItemName FROM MovementItemDesc WHERE Id = vbDescId), vbDescId
                                                                             , (SELECT ItemName FROM MovementItemDesc WHERE Id = inDescId), inDescId
                                                                              ;
         END IF;

         -- Проверка - т.к. MovementId - !!!НЕ МЕНЯЕТСЯ!!!
         IF COALESCE (inMovementId, -1) <> COALESCE (vbMovementId, -2)
         THEN
             RAISE EXCEPTION 'Ошибка изменения MovementId с <%> на <%>', vbMovementId, inMovementId;
         END IF;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.04.17         * add PartionId
*/

-- тест
