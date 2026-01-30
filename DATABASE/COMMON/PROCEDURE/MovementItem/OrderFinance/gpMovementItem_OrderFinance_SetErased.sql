-- Function: gpMovementItem_OrderFinance_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_OrderFinance_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_OrderFinance_SetErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
   OUT outSumm_parent        TFloat               , --
   OUT outInvNumber_parent   TVarChar             , -- 
   OUT outInvNumber_Invoice_parent   TVarChar             , -- 
   OUT outGoodsName_parent   TVarChar             , -- 
    IN inSession             TVarChar               -- текущий пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbOrderFinanceId Integer;
   DECLARE vbMovementId     Integer;
   DECLARE vbParentId       Integer;
BEGIN
   -- !!!криво!!!
   -- нашли
   vbOrderFinanceId := (SELECT MovementLinkObject.ObjectId AS Id
                        FROM MovementItem 
                             INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementItem.MovementId
                                                          AND MovementLinkObject.DescId     = zc_MovementLinkObject_OrderFinance()
                        WHERE MovementItem.Id     = inMovementItemId
                          AND MovementItem.DescId = zc_MI_Master()
                       );

  -- проверка прав пользователя на вызов процедуры
  IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = inMovementItemId AND MovementItem.DescId = zc_MI_Master())
     -- НЕ СЧЕТА
     AND NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbOrderFinanceId AND OB.DescId = zc_ObjectBoolean_OrderFinance_SB() AND OB.ValueData = TRUE)
  THEN vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_OrderFinance());
  ELSE vbUserId:= lpGetUserBySession (inSession);
  END IF;

  -- нашли
  SELECT MovementItem.MovementId, MovementItem.ParentId INTO vbMovementId, vbParentId FROM MovementItem WHERE MovementItem.Id = inMovementItemId;

  -- устанавливаем новое значение
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

  -- Проверка - после SetErased
  -- PERFORM lpCheck_Movement_OrderFinance (inMovementId:= vbMovementId, inUserId:= vbUserId);

  -- для zc_MI_Child
  IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = inMovementItemId AND MovementItem.DescId = zc_MI_Child())
  THEN
      -- Только после Set Erased
      SELECT STRING_AGG (tmpMI.InvNumber, '; ') AS InvNumber
           , STRING_AGG (tmpMI.InvNumber_Invoice, '; ') AS InvNumber_Invoice
           , STRING_AGG (tmpMI.GoodsName, '; ') AS GoodsName
           , SUM (tmpMI.Amount)          AS Amount
             INTO outInvNumber_parent, outInvNumber_Invoice_parent, outGoodsName_parent, outSumm_parent
      FROM (SELECT COALESCE (MIString_GoodsName.ValueData, '') AS GoodsName
                 , COALESCE (MIString_InvNumber.ValueData, '') AS InvNumber
                 , COALESCE (MIString_InvNumber_Invoice.ValueData, '') AS InvNumber_Invoice
                 , MovementItem.Amount
            FROM MovementItem
                LEFT JOIN MovementItemString AS MIString_InvNumber
                                             ON MIString_InvNumber.MovementItemId = MovementItem.Id
                                            AND MIString_InvNumber.DescId = zc_MIString_InvNumber()
                LEFT JOIN MovementItemString AS MIString_InvNumber_Invoice
                                             ON MIString_InvNumber_Invoice.MovementItemId = MovementItem.Id
                                            AND MIString_InvNumber_Invoice.DescId = zc_MIString_InvNumber_Invoice()
                LEFT JOIN MovementItemString AS MIString_GoodsName
                                             ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                            AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
            WHERE MovementItem.MovementId = vbMovementId
              AND MovementItem.DescId     = zc_MI_Child()
              AND MovementItem.isErased   = FALSE
              AND MovementItem.ParentId   = vbParentId
              -- НЕ Важно - Сортировать
            ORDER BY MovementItem.Id ASC
          ) AS tmpMI;

      -- сохранили <Итого>
      PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, zc_MI_Master(), MovementItem.ObjectId, MovementItem.MovementId, COALESCE (outSumm_parent, 0), MovementItem.ParentId)
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.Id         = vbParentId
       ;

  END IF;

  -- пересчитали Итоговые суммы
  PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderFinance (vbMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.14         *
*/

-- тест
--