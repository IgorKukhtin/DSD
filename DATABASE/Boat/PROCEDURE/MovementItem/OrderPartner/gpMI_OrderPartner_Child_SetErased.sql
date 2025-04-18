-- Function: gpMI_OrderPartner_Child_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMI_OrderPartner_Child_SetErased (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMI_OrderPartner_Child_SetErased(
    IN inMovementId                Integer              , -- ключ объекта <документ>
    IN inMovementItemId_child      Integer              , -- ключ объекта <Элемент документа>
    IN inSession                   TVarChar               -- текущий пользователь
)
  RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_OrderPartner());
  vbUserId:= inSession;


  --при удалении строчки в нижнем гриде обнуляем по ней zc_MIFloat_MovementId
  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), inMovementItemId_child, 0);
  
  -- автоматом пересчитываем кол-во в мастере
  PERFORM lpInsertUpdate_MovementItem (MI_Master.Id, zc_MI_Master()
                                     , MI_Master.ObjectId
                                     , NULL, MI_Master.MovementId
                                     , (COALESCE (MI_Master.Amount,0) - COALESCE (MIFloat_AmountPartner.ValueData,0)) :: TFloat
                                     , NULL
                                     , vbUserId)
  FROM MovementItem AS MI_Master
       INNER JOIN MovementItem AS MI_Child_client
                               ON MI_Child_client.Id = inMovementItemId_child
                              AND MI_Child_client.DescId   = zc_MI_Child()
                              AND MI_Child_client.isErased = FALSE
                              AND MI_Child_client.ObjectId = MI_Master.ObjectId
       LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                   ON MIFloat_AmountPartner.MovementItemId = MI_Child_client.Id
                                  AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
  WHERE MI_Master.MovementId = inMovementId
    AND MI_Master.DescId = zc_MI_Master()
    AND MI_Master.isErased = FALSE;
  
  
  -- пересчитали Итоговые суммы по накладной
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.04.21         *
*/

-- тест
--