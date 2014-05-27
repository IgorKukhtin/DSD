-- Function: gpInsertUpdate_Movement_EDI()

 DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDI (TVarChar, TDateTime, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDI(
    IN inOrderInvNumber      TVarChar  , -- Номер документа
    IN inOrderOperDate       TDateTime , -- Дата документа
    IN inSaleInvNumber       TVarChar  , -- Номер документа
    IN inSaleOperDate        TDateTime , -- Дата документа

    IN inGLN                 TVarChar   , -- 
    IN inGLNPlace            TVarChar   , -- 
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
   DECLARE vbPartnerId Integer;
   DECLARE vbJuridicalId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
     vbUserId := inSession;

     outId := null;

     SELECT Id INTO outId 
       FROM Movement WHERE DescId = zc_Movement_EDI() AND OperDate = inOrderOperDate AND InvNumber = inOrderInvNumber;

     -- сохранили <Документ>
     IF COALESCE(outId, 0) = 0 THEN
        outId := lpInsertUpdate_Movement (outId, zc_Movement_EDI(), inOrderInvNumber, inOrderOperDate, NULL);
     END IF;

     PERFORM lpInsertUpdate_MovementString (zc_MovementString_SaleInvNumber(), outId, inSaleInvNumber);

     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SaleOperDate(), outId, inSaleOperDate);
    
     IF inGLN <> '' THEN 
        PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNCode(), outId, inGLN);
     END IF;

     IF inGLNPlace <> '' THEN 
        PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNPlaceCode(), outId, inGLNPlace);
        -- Пытаемся установить связь с точкой доставки
        vbPartnerId := COALESCE((SELECT MIN(ObjectId)
                    FROM ObjectString WHERE DescId = zc_ObjectString_Partner_GLNCode() AND ValueData = inGLNPlace), 0);
        IF vbPartnerId <> 0 THEN
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), outId, vbPartnerId);
        END IF;
     END IF;

     PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), outId, inOKPO);

     PERFORM lpInsertUpdate_MovementString (zc_MovementString_JuridicalName(), outId, inJuridicalName);


     IF vbPartnerId <> 0 THEN -- Находим Юр лицо по контрагенту
        vbJuridicalId := COALSCE((SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Partner_Juridical AND ObjectId = vbPartnerId), 0);
     END IF;

     -- Находим Юр лицо по OKPO
     IF (inOKPO <> '') AND (COALESCE(vbJuridicalId, 0) = 0) THEN
        vbJuridicalId := COALESCE((SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_ViewByDate
                         WHERE CURRENT_DATE BETWEEN StartDate AND EndDate
                           AND OKPO = inOKPO), 0);
     END IF;

     IF COALESCE(vbJuridicalId, 0) <> 0 THEN
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), outId, vbJuridicalId);
        -- Возвращаем ссылку на классификатор товаров
        outGoodsPropertyId := SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Juridical_GoodsProperty() AND ValueData = vbJuridicalId;
     END IF;

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
