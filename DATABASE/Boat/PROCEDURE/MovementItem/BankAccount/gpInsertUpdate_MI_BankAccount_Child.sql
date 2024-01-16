-- Function: gpInsertUpdate_MovementItem_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_BankAccount_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_BankAccount_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_BankAccount_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <> 
    IN inParentId            Integer   ,
    IN inMovementId          Integer   ,  
    IN inMovementId_OrderClient Integer ,
    IN inMovementId_invoice  Integer   , -- 
    IN inInvoiceKindId       Integer  ,  --
    IN inObjectId            Integer   , -- 
    IN inAmount              TFloat    , --
    IN inAmount_invoice      TFloat    , --
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Invoice());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_invoice,0) = 0
     THEN
          -- сохранили <Документ>
        vbInvNumber := NEXTVAL ('movement_Invoice_seq')    :: TVarChar;

        inMovementId_invoice := lpInsertUpdate_Movement_Invoice (ioId               := 0                                   ::Integer
                                                               , inParentId         := inMovementId_OrderClient
                                                               , inInvNumber        := vbInvNumber                         :: TVarChar
                                                               , inOperDate         := CURRENT_DATE  :: TDateTime
                                                               , inPlanDate         := NULL                                ::TDateTime
                                                               , inVATPercent       := ObjectFloat_TaxKind_Value.ValueData ::TFloat
                                                               , inAmount           := CASE WHEN COALESCE (inAmount_invoice,0) <> 0 THEN inAmount_invoice ELSE inAmount END ::TFloat
                                                               , inInvNumberPartner := ''                                  ::TVarChar
                                                               , inReceiptNumber    := (1 + COALESCE ((SELECT MAX (zfConvert_StringToNumber (MovementString.ValueData))
                                                                                                       FROM MovementString
                                                                                                            JOIN Movement ON Movement.Id       = MovementString.MovementId
                                                                                                                         AND Movement.DescId   = zc_Movement_Invoice()
                                                                                                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                                                       WHERE MovementString.DescId = zc_MovementString_ReceiptNumber()
                                                                                                      ), 0)
                                                                                       ) :: TVarChar
                                                               , inComment          := ''                                  ::TVarChar
                                                               , inObjectId         := inObjectId
                                                               , inUnitId           := NULL                                ::Integer
                                                               , inInfoMoneyId      := ObjectLink_InfoMoney.ChildObjectId  ::Integer
                                                               , inPaidKindId       := zc_Enum_PaidKind_FirstForm()        ::Integer
                                                               , inInvoiceKindId    := inInvoiceKindId                     ::Integer
                                                               , inUserId           := vbUserId
                                                               )
                                FROM Object AS Object_Client
                                     LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                                          ON ObjectLink_TaxKind.ObjectId = Object_Client.Id
                                                         AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
                
                                     LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                           ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                                          AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                
                                     LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                                          ON ObjectLink_InfoMoney.ObjectId = Object_Client.Id
                                                         AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Client_InfoMoney()
                
                                WHERE Object_Client.Id = inObjectId;
     END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MI_BankAccount_Child (ioId
                                                , inParentId
                                                , inMovementId
                                                , inMovementId_invoice
                                                , inObjectId
                                                , inAmount
                                                , inComment
                                                , vbUserId
                                                 );

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.24         *
*/

-- тест
--