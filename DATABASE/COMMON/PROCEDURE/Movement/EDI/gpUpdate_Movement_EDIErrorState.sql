-- Function: gpUpdate_Movement_EDI_Params()

DROP FUNCTION IF EXISTS gpUpdate_Movement_EDIErrorState (Integer, TVarChar, TDateTime, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_EDIErrorState(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inDocType             TVarChar  , -- Тип документа
    IN inOperDate            TDateTime , 
    IN inInvNumber           TVarChar  , 
    IN inIsError             Boolean   , -- 
   OUT IsFind                Boolean   ,
    IN inSession             TVarChar     -- Пользователь
)                              
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_EDI_Params());
   vbUserId:= lpGetUserBySession(inSession);

   IsFind := false;

   IF COALESCE(inMovementId, 0) = 0 THEN
      SELECT MAX(Movement.Id) INTO inMovementId 
        FROM Movement 
                              INNER JOIN MovementString AS MovementString_MovementDesc
                                                        ON MovementString_MovementDesc.MovementId =  Movement.Id
                                                       AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
                             --                          AND MovementString_MovementDesc.ValueData = 'zc_Movement_Sale'
       WHERE Movement.DescId = zc_Movement_EDI()
         AND Movement.OperDate BETWEEN (inOperDate - (INTERVAL '7 DAY')) AND (inOperDate + (INTERVAL '7 DAY'))
         AND Movement.InvNumber = inInvNumber;
   END IF;

   IF COALESCE(inMovementId, 0) <> 0 THEN
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Error(), inMovementId, inIsError);
      IsFind := true;
   END IF;
    
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.02.15                        * 
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_EDI_Params (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
