-- Function: lpInsertUpdate_MovementItemFloat

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemFloat (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemFloat(
    IN inDescId                Integer           , -- ключ класса свойства
    IN inMovementItemId        Integer           , -- ключ
    IN inValueData             TFloat              -- свойство
)
RETURNS Boolean
AS
$BODY$
BEGIN
     -- проверка - inValueData
     IF inValueData IS NULL
     THEN
         RAISE EXCEPTION 'Ошибка-1.Не определено числовое значение Id=<%> ParentId=<%> MovementId=<%> InvNumber=<%> DescId=<%>.'
                       , inMovementItemId
                       , (SELECT MovementItem.ParentId   FROM MovementItem WHERE MovementItem.Id = inMovementItemId)
                       , (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inMovementItemId)
                       , (SELECT Movement.InvNumber      FROM Movement     WHERE Movement.Id = (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inMovementItemId))
                       , (SELECT MovementItemFloatDesc.Code FROM MovementItemFloatDesc WHERE MovementItemFloatDesc.Id = inDescId)
                        ;
     END IF;


     IF inDescId = zc_MIFloat_SummCardSecondDiff() AND ABS (inValueData) > 20
     THEN
         RAISE EXCEPTION 'Ошибка.Значение для округления = <%> не может быть больше 20.', inValueData;
     END IF;

     -- изменить <свойство>
     UPDATE MovementItemFloat SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;

     -- если не нашли
     IF NOT FOUND AND inValueData <> 0
     THEN
         -- добавить <свойство>
         INSERT INTO MovementItemFloat (DescId, MovementItemId, ValueData)
                                VALUES (inDescId, inMovementItemId, inValueData);
     END IF;

     RETURN TRUE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.03.15                                        * IF ... AND inValueData <> 0
 17.05.14                                        * add проверка - inValueData
*/
