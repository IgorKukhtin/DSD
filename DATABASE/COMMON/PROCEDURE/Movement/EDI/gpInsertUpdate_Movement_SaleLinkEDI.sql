-- Function: gpInsertUpdate_Movement_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SaleLinkEDI (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SaleLinkEDI(
    IN inMovementId          Integer   , --
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID 
AS
$BODY$
DECLARE
   vbJuridicalId Integer;
   vbInvNumberOrder TVarChar;
   vbOperDate TDateTime;
   vbEDIId Integer;
   vbUserId INTEGER;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
     vbUserId := inSession;

     -- Выбираем данные из текущего документа

     SELECT MovementString_InvNumberOrder.ValueData
          , ObjectLink_Partner_Juridical.ChildObjectId 
          , Movement.OperDate 
              INTO vbInvNumberOrder, vbJuridicalId, vbOperDate
     FROM Movement 
     JOIN MovementString AS MovementString_InvNumberOrder
                         ON MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder() 
                        AND MovementString_InvNumberOrder.MovementId = Movement.Id
     JOIN MovementLinkObject AS MovementLinkObject_To
                             ON MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                            AND MovementLinkObject_To.MovementId = Movement.Id
     JOIN ObjectLink AS ObjectLink_Partner_Juridical
                     ON ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical() 
                    AND ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
    WHERE Movement.Id = inMovementId;  

     SELECT Id INTO vbEDIId 
       FROM Movement 
       JOIN MovementLinkObject AS MovementLinkObject_Juridical 
                               ON MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                              AND MovementLinkObject_Juridical.MovementId = Movement.Id
                              AND MovementLinkObject_Juridical.ObjectId = vbJuridicalId
      WHERE Movement.DescId = zc_Movement_EDI() 
        AND Movement.OperDate BETWEEN (vbOperDate - INTERVAL '3 DAY') AND (vbOperDate + INTERVAL '3 DAY') 
        AND Movement.InvNumber = vbInvNumberOrder;

     IF COALESCE(vbEDIId, 0) = 0 THEN
        RAISE EXCEPTION 'Для данного документа не загружен документ COMDOC';
     END IF;

     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Sale(), inMovementId, vbEDIId);

     -- Распроводим документ
     PERFORM gpUnComplete_Movement_Sale(inMovementId, inSession);

     -- Устанавливаем количество у покупателя в 0
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), MovementItem.Id, 0)
        FROM MovementItem WHERE MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = false
                            AND MovementItem.MovementId = inMovementId;

     PERFORM lpInsertUpdate_MI_SaleCOMDOC(inMovementId, MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId, 
                                          MIFloat_AmountPartner.ValueData, MIFloat_PricePartner.ValueData)
        FROM MovementItem 

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

            LEFT JOIN MovementItemFloat AS MIFloat_PricePartner
                                        ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_PricePartner.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

   WHERE MovementItem.MovementId = vbEDIId
     AND COALESCE(MovementItem.ObjectId, 0) <> 0
     AND MovementItem.DescId =  zc_MI_Master();

     PERFORM lpInsert_Movement_EDIEvents(vbMovementId, 'Установлена связь с расходной накладной', vbUserId);


     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.05.14                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_EDI (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
