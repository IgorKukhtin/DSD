-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummInventory (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummInventory(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
    
    DECLARE 
        vbDeficitSumm   TFloat; --недостача сумма
        vbProficitSumm  TFloat; --излишек сумма
        vbDiff          TFloat; --разница кол-во
        vbDiffSumm      TFloat; --разница сумма

BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    
    SELECT
        SUM(MovementItem_Inventory.DeficitSumm)::TFloat,
        SUM(MovementItem_Inventory.ProficitSumm)::TFloat,
        SUM(MovementItem_Inventory.Diff)::TFloat,
        SUM(MovementItem_Inventory.DiffSumm)::TFloat
    INTO
        vbDeficitSumm,  --недостача сумма
        vbProficitSumm, --излишек сумма
        vbDiff,         --разница кол-во
        vbDiffSumm      --разница сумма
    FROM gpSelect_MovementItem_Inventory(inMovementId   := inMovementId, -- ключ Документа
                                         inShowAll      := FALSE, --
                                         inIsErased     := FALSE, --
                                         inShowDeviated := FALSE, --
                                         inSession      := '') AS MovementItem_Inventory;-- сессия пользователя
    

    -- Сохранили свойство <Итого сумма недостачи>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDeficitSumm(), inMovementId, vbDeficitSumm);
      
    -- Сохранили свойство <Итого сумма излишка>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalProficitSumm(), inMovementId, vbProficitSumm);
    
    -- Сохранили свойство <Итого разница в количестве>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiff(), inMovementId, vbDiff);
    
    -- Сохранили свойство <Итого разница в сумме>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiffSumm(), inMovementId, vbDiffSumm);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummInventory (Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.15                         * 
*/

-- тест
-- SELECT lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId:= Movement.Id) FROM Movement WHERE DescId = zc_Movement_Inventory() and OperDate BETWEEN '01.11.2016' and '31.11.2016'
