-- Function: gpInsertUpdate_MI_EDI()

DROP FUNCTION IF EXISTS gpInsert_Protocol_EDIStatus(Boolean, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Protocol_EDIStatus(
    IN inFrom                TVarChar  , 
    IN inTo                  TVarChar  , 
    IN inDate                TDateTime , 
    IN inStatus              TVarChar  ,
    IN inDocumentNumber      TVarChar  , 
    IN inDescription         TVarChar  , -- Описание события
    IN inMessageClass        TVarChar  ,
    IN inSession             TVarChar     -- Пользователь
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbTaxMovementId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);

   CASE inMessageClass 
        WNEN 'DECLAR' THEN 







        END
   END;

   -- Задача найти документ EDI по номеру налоговой и дате
    SELECT Movement.Id, Movement_Tax.Id INTO vbMovementId, vbTaxMovementId
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

   IF COALESCE(vbMovementId, 0) = 0 THEN 
   	
      SELECT Movement.id, COALESCE(MovementLinkMovement_Tax.MovementId, MovementLinkMovement_ChildEDI.MovementId) INTO vbMovementId, vbTaxMovementId 
                    FROM MovementString
        JOIN Movement ON Movement.id = MovementString.movementid AND Movement.descid = zc_Movement_EDI()
                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                      ON MovementLinkMovement_Tax.MovementChildId = Movement.Id 
                                     AND MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Tax()
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_ChildEDI
                                           ON MovementLinkMovement_ChildEDI.MovementChildId = Movement.Id 
                                          AND MovementLinkMovement_ChildEDI.DescId = zc_MovementLinkMovement_ChildEDI()

       WHERE MovementString.DescId = zc_MovementString_FileName()
         AND UPPER(MovementString.ValueData) LIKE UPPER(inFileName);
   END IF;


   IF COALESCE (vbMovementId, 0) <> 0 THEN
      IF COALESCE (vbTaxMovementId, 0) = 0
      THEN
          RAISE EXCEPTION 'Ошибка. Налоговый документ № <%> не найден. (%) (%) (%) (%)', inTaxNumber, inisOk, inEDIEvent, inOperMonth, inFileName;
      END IF;

      PERFORM lpInsert_Movement_EDIEvents(vbMovementId, inEDIEvent, vbUserId);

      IF inisOk THEN 
         PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Electron(), vbMovementId, inisOk);
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (vbMovementId, vbUserId, FALSE);

         PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Electron(), vbTaxMovementId, inisOk);
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (vbTaxMovementId, vbUserId, FALSE);
      END IF;
   END IF;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.12.14                         * add сохранили протокол
 14.10.14                         * 
 04.08.14                         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_EDI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
