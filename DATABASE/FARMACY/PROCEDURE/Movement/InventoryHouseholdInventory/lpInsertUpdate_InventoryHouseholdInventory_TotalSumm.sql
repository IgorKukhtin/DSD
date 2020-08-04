-- Function: lpInsertUpdate_InventoryHouseholdInventory_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_InventoryHouseholdInventory_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_InventoryHouseholdInventory_TotalSumm(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalDiff TFloat;
  DECLARE vbTotalDiffSum TFloat;
BEGIN

      SELECT SUM(MovementItem.Diff) AS TotalDiff, SUM(MovementItem.DiffSumm) AS TotalDiffSum
      INTO vbTotalDiff, vbTotalDiffSum
      FROM gpSelect_MovementItem_InventoryHouseholdInventory(inMovementId := inMovementId, inShowAll := 'False', inIsErased := 'False', inSession := zfCalc_UserAdmin()) AS MovementItem;
        
      -- Сохранили свойство <Итого количество>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiff(), inMovementId, COALESCE(vbTotalDiff, 0));
      -- Сохранили свойство <Итого сумма>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiffSumm(), inMovementId, COALESCE(vbTotalDiffSum, 0));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_InventoryHouseholdInventory_TotalSumm (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 30.07.20                                                                      * 
 17.07.20                                                                      * 
*/

