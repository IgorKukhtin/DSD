-- Function: lpInsertUpdate_MI_PartionCell_table()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_PartionCell_table (Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_PartionCell_table(
    IN inMovementId               Integer, -- Ключ объекта <Документ>
    IN inMovementItemId           Integer,
    IN inDescId_MILO              Integer,
    IN inPartionCellId            Integer,
    IN inUserId                   Integer    
)
RETURNS VOID
AS
$BODY$
BEGIN
     
         UPDATE MI_PartionCell SET PartionCellId = inPartionCellId, MovementId = inMovementId, UserId = inUserId, OperDate = CURRENT_TIMESTAMP
         WHERE MovementItemId = inMovementItemId AND DescId_MILO = inDescId_MILO
        ;

         --
         IF NOT FOUND THEN
            INSERT INTO MI_PartionCell (MovementId, MovementItemId, DescId_MILO, PartionCellId, UserId, OperDate)
                                VALUES (inMovementId, inMovementItemId, inDescId_MILO, inPartionCellId, inUserId, CURRENT_TIMESTAMP);
         END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.05.26                                        *
*/

-- тест
--