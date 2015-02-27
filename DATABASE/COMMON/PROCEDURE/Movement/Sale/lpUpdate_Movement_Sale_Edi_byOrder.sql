-- Function: lpUpdate_Movement_Sale_Edi_byOrder()

DROP FUNCTION IF EXISTS lpUpdate_Movement_Sale_Edi_byOrder (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_Sale_Edi_byOrder(
    IN inId                    Integer    , -- Ключ объекта <Документ>
    IN inMovementId_Order      Integer    , -- ключ Документа
    IN inUserId                Integer      -- пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementId_EDI Integer;
BEGIN

    -- нашли
    vbMovementId_EDI:= (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = inMovementId_Order AND DescId = zc_MovementLinkMovement_Order() AND MovementChildId <> 0);

    -- если есть
    IF vbMovementId_EDI <> 0 
       -- OR EXISTS (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = inId AND DescId = zc_MovementLinkMovement_Sale() AND MovementChildId <> 0)
    THEN
        IF vbMovementId_EDI <> 0
        THEN
            -- !!!поменяли у документа EDI признак!!!
            PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId_EDI, (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Sale()));
        END IF;

        -- сформировали связь у расходной накл. с EDI (такую же как и у заявки)
        PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Sale(), inId, vbMovementId_EDI);
    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.02.15                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Movement_Sale_Edi_byOrder (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
