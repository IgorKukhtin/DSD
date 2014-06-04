-- Function: gpInsertUpdate_Movement_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDIComdoc (TVarChar, TDateTime, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDIComdoc(
    IN inOrderInvNumber      TVarChar  , -- Номер документа
    IN inOrderOperDate       TDateTime , -- Дата документа
    IN inSaleInvNumber       TVarChar  , -- Номер документа
    IN inSaleOperDate        TDateTime , -- Дата документа

    IN inOKPO                TVarChar   , -- 
    IN inJuridicalName       TVarChar   , --
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (MovementId Integer, GoodsPropertyID Integer) -- Классификатор товаров) 
AS
$BODY$
   DECLARE vbMovementId INTEGER;
   DECLARE vbGoodsPropertyId INTEGER;
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
     vbUserId := inSession;

     vbMovementId := null;

     SELECT Id INTO vbMovementId 
       FROM Movement WHERE DescId = zc_Movement_EDI() 
        AND OperDate BETWEEN (inSaleOperDate - (interval '3 DAY')) AND (inSaleOperDate + (interval '3 DAY'))  AND InvNumber = inOrderInvNumber;

     -- сохранили <Документ>
     IF COALESCE(vbMovementId, 0) = 0 THEN
        vbMovementId := lpInsertUpdate_Movement (vbMovementId, zc_Movement_EDI(), inOrderInvNumber, inOrderOperDate, NULL);
     END IF;

     PERFORM lpInsertUpdate_MovementString (zc_MovementString_SaleInvNumber(), vbMovementId, inSaleInvNumber);

     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SaleOperDate(), vbMovementId, inSaleOperDate);
    
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), vbMovementId, inOKPO);

     PERFORM lpInsertUpdate_MovementString (zc_MovementString_JuridicalName(), vbMovementId, inJuridicalName);

     -- Находим Юр лицо по OKPO
     IF (inOKPO <> '') AND (COALESCE(vbJuridicalId, 0) = 0) THEN
        vbJuridicalId := COALESCE((SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_ViewByDate
                         WHERE CURRENT_DATE BETWEEN StartDate AND EndDate
                           AND OKPO = inOKPO), 0);
     END IF;

     IF COALESCE(vbJuridicalId, 0) <> 0 THEN
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), vbMovementId, vbJuridicalId);
        -- Возвращаем ссылку на классификатор товаров
        vbGoodsPropertyID := (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Juridical_GoodsProperty() AND ObjectId = vbJuridicalId);
     END IF;

     PERFORM lpInsert_Movement_EDIEvents(vbMovementId, 'Загрузка COMDOC из EDI', vbUserId);

     RETURN QUERY 
     SELECT vbMovementId, vbGoodsPropertyID;

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.05.14                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_EDI (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
