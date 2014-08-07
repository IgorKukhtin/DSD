-- Function: gpInsertUpdate_MI_EDI()

DROP FUNCTION IF EXISTS gpInsert_Protocol_EDIReceipt(Boolean, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Protocol_EDIReceipt(
    IN inisOk                Boolean   ,
    IN inTaxNumber           TVarChar  , 
    IN inEDIEvent            TVarChar  , -- Описание события
    IN inOperMonth           TDateTime , 
    IN inSession             TVarChar     -- Пользователь
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);

   -- Задача найти документ EDI по номеру налоговой и дате
    SELECT Movement.Id INTO vbMovementId
      FROM Movement
            JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                      ON MovementLinkMovement_Tax.MovementChildId = Movement.Id 
                                     AND MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Tax()
            JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Tax.MovementId
                                         AND Movement_Tax.StatusId = zc_Enum_Status_Complete()
            JOIN MovementString AS MovementString_InvNumberPartner_Tax
                                ON MovementString_InvNumberPartner_Tax.MovementId =  Movement_Tax.Id
                               AND MovementString_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()

     WHERE Movement.DescId = zc_movement_EDI() 
       AND Movement_Tax.OperDate BETWEEN inOperMonth AND (inOperMonth + (interval '1 MONTH'))
       AND MovementString_InvNumberPartner_Tax.valuedata = inTaxNumber;

   IF COALESCE(vbMovementId, 0) <> 0 THEN 
      PERFORM lpInsert_Movement_EDIEvents(vbMovementId, inEDIEvent, vbUserId);
      PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Electron(), vbMovementId, inisOk);
   END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.08.14                         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_EDI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
