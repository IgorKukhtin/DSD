-- Function: gpInsertUpdate_MI_IncomeFuel_Sign()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_IncomeFuel_Sign (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_IncomeFuel_Sign(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inisSign              Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbIsInsert Boolean;

  DECLARE vbSignInternalId Integer; 
  DECLARE vbMIId Integer; 
  DECLARE vbAmount TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_IncomeFuel());

     -- выбираем все строки эл.подписи документа
     CREATE TEMP TABLE tmpMI (Id Integer, SignInternalId Integer, UserId Integer, Amount TFloat, isSign Boolean) ON COMMIT DROP;
     INSERT INTO tmpMI (Id, SignInternalId, UserId, Amount, isSign)
         SELECT tmp.Id
              , tmp.SignInternalId
              , tmp.UserId
              , MovementItem.Amount
              , tmp.isSign
         FROM gpSelect_MI_IncomeFuel_Sign (inMovementId:= inMovementId  , inIsErased:= False, inSession:= inSession) AS tmp
            LEFT JOIN MovementItem ON MovementItem.Id = tmp.Id;
     
     SELECT tmpMI.Id, tmpMI.SignInternalId, tmpMI.Amount
     INTO vbMIId, vbSignInternalId, vbAmount
     FROM tmpMI
     WHERE tmpMI.UserId = vbUserId;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMIId, 0) = 0;
 
     --
     IF inisSign = True THEN 
          IF COALESCE (vbAmount, 0) = 0 THEN
            vbAmount := (SELECT COALESCE(max(Amount),0)/*count(*)*/ FROM tmpMI WHERE tmpMI.isSign = True AND tmpMI.UserId <> vbUserId) + 1;
          END IF;
        
     ELSE 
        vbAmount := 0;
     END IF;

      
     -- сохранили <Элемент документа>
     vbMIId:= lpInsertUpdate_MovementItem (vbMIId, zc_MI_Sign(), vbSignInternalId, inMovementId, vbAmount, NULL);
   

   IF vbIsInsert = TRUE AND inisSign = True
   THEN
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), vbMIId, vbUserId);
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbMIId, CURRENT_TIMESTAMP);
   END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMIId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.  Климентьев К.И.
 23.08.16         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_IncomeFuel_Sign (inMovementId:= 10, inAmount:= 0, inSession:= '2')
