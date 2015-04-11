-- Function: gpInsertUpdate_Movement_SendOnPrice_Branch()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPriceFromIncome(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendOnPriceFromIncome(
    IN inIncomeId            Integer   , -- Документ прихода
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsProcess_BranchIn Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     FROM lpInsertUpdate_Movement_SendOnPrice
                                       (ioId               := ioId
                                      , inInvNumber        := inInvNumber
                                      , inOperDate         := CASE WHEN vbIsProcess_BranchIn = FALSE THEN inOperDate ELSE (SELECT OperDate FROM Movement WHERE Id = ioId) END
                                      , inOperDatePartner  := CASE WHEN vbIsProcess_BranchIn = TRUE OR COALESCE (ioId, 0) = 0 THEN inOperDatePartner ELSE (SELECT ValueData FROM MovementDate WHERE MovementId = ioId AND DescId = zc_MovementDate_OperDatePartner()) END
                                      , inPriceWithVAT     := CASE WHEN vbIsProcess_BranchIn = FALSE THEN inPriceWithVAT ELSE (SELECT ValueData FROM MovementBoolean WHERE MovementId = ioId AND DescId = zc_MovementBoolean_PriceWithVAT()) END
                                      , inVATPercent       := CASE WHEN vbIsProcess_BranchIn = FALSE THEN inVATPercent ELSE (SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_VATPercent()) END
                                      , inChangePercent    := CASE WHEN vbIsProcess_BranchIn = FALSE THEN inChangePercent ELSE (SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_ChangePercent()) END
                                      , inFromId           := CASE WHEN vbIsProcess_BranchIn = FALSE THEN inFromId ELSE (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_From()) END
                                      , inToId             := CASE WHEN vbIsProcess_BranchIn = FALSE THEN inToId ELSE (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_To()) END
                                      , inRouteSortingId   := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_RouteSorting())
                                      , ioPriceListId      := CASE WHEN vbIsProcess_BranchIn = FALSE THEN ioPriceListId ELSE (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_PriceList()) END
                                      , inProcessId        := zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                                      , inUserId           := vbUserId
                                       ) AS tmp;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.11.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_SendOnPriceFromIncome (inIncomeId:= 0, inSession:= '2')
