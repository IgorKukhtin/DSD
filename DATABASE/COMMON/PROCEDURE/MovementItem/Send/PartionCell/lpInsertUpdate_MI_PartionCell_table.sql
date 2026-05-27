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
     
     IF NOT EXISTS (SELECT 1 FROM Object WHERE Id = inPartionCellId AND DescId = zc_Object_PartionCell()) AND inPartionCellId > 0
     THEN
	 RAISE EXCEPTION 'Ошибка.История ячейки хранения для % <%> № <%> от <%> % (%)(%)(%)(%)'
	                , CHR (13)
	                , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
	                , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
	                , (SELECT zfConvert_DateToString (Movement.OperDate)  FROM Movement WHERE Movement.Id = inMovementId)
	                , CHR (13)
	                , inMovementId    
	                , inMovementItemId
	                , inDescId_MILO  
	                , inPartionCellId
	                 ;
     END IF:

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