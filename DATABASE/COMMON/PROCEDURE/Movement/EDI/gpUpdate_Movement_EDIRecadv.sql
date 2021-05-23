-- Function: gpInsertUpdate_Movement_EDI()

DROP FUNCTION IF EXISTS gpUpdate_Movement_EDIRecadv (TVarChar, TDateTime, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_EDIRecadv(
    IN inOrderInvNumber      TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inGLNPlace            TVarChar  , -- Код GLN - место доставки
    IN inDesadvNumber        TVarChar  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (MovementId Integer, GoodsPropertyID Integer) -- Классификатор товаров) 
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
     vbUserId:= lpGetUserBySession (inSession);

     vbMovementId := NULL;

     -- находим документ !!!по точке доставки!!!
     IF EXISTS (SELECT COUNT (*)
                FROM Movement
                          INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                                    ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                                   AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                                   AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                WHERE Movement.DescId = zc_Movement_EDI()
                  AND Movement.OperDate BETWEEN (inOperDate - (INTERVAL '7 DAY')) AND (inOperDate + (INTERVAL '7 DAY'))
                  AND Movement.InvNumber = inOrderInvNumber
                HAVING COUNT (*) = 1
                )
     THEN
         vbMovementId:= (SELECT Movement.Id
                         FROM Movement
                              INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                                        ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                                       AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                                       AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                         WHERE Movement.DescId = zc_Movement_EDI()
                           AND Movement.OperDate BETWEEN (inOperDate - (INTERVAL '7 DAY')) AND (inOperDate + (INTERVAL '7 DAY'))
                           AND Movement.InvNumber = inOrderInvNumber
                        );
     END IF;

     -- сохранили
     IF vbMovementId <> 0
     THEN
         PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberMark(), vbMovementId, inDesadvNumber);
     END IF;


     -- сохранили
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), MovementLinkMovement_Sale.MovementId, ObjectString_RoomNumber.ValueData || '.' || inDesadvNumber)
     FROM MovementLinkMovement AS MovementLinkMovement_Sale
          LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                   ON MovementString_InvNumberPartner.MovementId =  MovementLinkMovement_Sale.MovementId
                                  AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = MovementLinkMovement_Sale.MovementId
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                 ON ObjectString_RoomNumber.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()
     WHERE MovementLinkMovement_Sale.MovementChildId = vbMovementId
       AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
       AND COALESCE (MovementString_InvNumberPartner.ValueData, '') = ''
       AND ObjectString_RoomNumber.ValueData <> ''
    ;


     -- сохранили протокол
     PERFORM lpInsert_Movement_EDIEvents (vbMovementId, 'Загрузка "Уведомление о приемке" из EDI', vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.10.15                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_EDI (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
