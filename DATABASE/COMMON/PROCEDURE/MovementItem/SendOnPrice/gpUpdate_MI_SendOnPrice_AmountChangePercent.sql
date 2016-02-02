-- Function: gpUpdate_MI_SendOnPrice_AmountChangePercent (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MI_SendOnPrice_AmountChangePercent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_SendOnPrice_AmountChangePercent(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbBranchId_from Integer;
   DECLARE vbBranchId_to Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendOnPrice_Branch());

     -- определяем от кого/кому - филиал или нет
     SELECT COALESCE (ObjectLink_Unit_BranchFrom.ChildObjectId, zc_Branch_Basis()), COALESCE (ObjectLink_Unit_BranchTo.ChildObjectId, zc_Branch_Basis()) --<> zc_Branch_Basis()
            INTO vbBranchId_from, vbBranchId_to
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_BranchFrom
                                 ON ObjectLink_Unit_BranchFrom.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Unit_BranchFrom.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_BranchTo
                                 ON ObjectLink_Unit_BranchTo.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Unit_BranchTo.DescId = zc_ObjectLink_Unit_Branch()
     WHERE Movement.Id = inMovementId; 

     -- проверка
     IF NOT (vbBranchId_from <> zc_Branch_Basis() AND vbBranchId_to = zc_Branch_Basis())
     THEN
        RAISE EXCEPTION 'Ошибка.Перенести данные возможно только для <Возврат с филиала>.';
     END IF;


     -- распровели
     PERFORM gpUnComplete_Movement_SendOnPrice (inMovementId:= inMovementId, inSession:= inSession);


     -- сохранили <Элемент документа> записали Amount
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, zc_MI_Master(), MovementItem.ObjectId, inMovementId, COALESCE (MIFloat_AmountPartner.ValueData, 0), NULL)
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                      ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
     WHERE MovementId = inMovementId;

     -- сохранили  свойство <Количество c учетом % скидки>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountChangePercent(), MovementItem.Id, COALESCE (MIFloat_AmountPartner.ValueData, 0))
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                      ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
     WHERE MovementId = inMovementId;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- провели
     PERFORM gpComplete_Movement_SendOnPrice (inMovementId:= inMovementId, inSession:= inSession);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.01.16         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_SendOnPrice_AmountChangePercent
