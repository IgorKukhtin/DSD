-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummInventory (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummInventory(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbTotalSummInventory     TFloat;
  DECLARE vbTotalCountInventory   TFloat;

BEGIN
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
     END IF;

     SELECT COUNT(MovementItem.Id), SUM(COALESCE(MovementItemFloat_Summ.ValueData,0)) INTO vbTotalCountInventory, vbTotalSummInventory
       FROM MovementItem
            LEFT OUTER JOIN MovementItemFloat AS MovementItemFloat_Summ
                                              ON MovementItemFloat_Summ.MovementItemId = MovementItem.Id
                                             AND MovementItemFloat_Summ.DescId = zc_MIFloat_Summ()
      WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = false;


      -- Сохранили свойство <Итого Сумма инвентаризации>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSummInventory);
      
      -- Сохранили свойство <Итого кол-во инвентаризации>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCountInventory);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummInventory (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.15                         * 
*/
-- select lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId:= id) from gpSelect_Movement_WeighingPartner (inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('30.06.2014')::TDateTime ,  inSession := '5') as a
-- тест
-- SELECT lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId:= Movement.Id) from Movement where DescId = zc_Movement_Inventory() and OperDate between ('01.11.2014')::TDateTime and  ('31.12.2014')::TDateTime
