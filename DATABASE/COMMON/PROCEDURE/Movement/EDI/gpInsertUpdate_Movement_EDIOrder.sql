-- Function: gpInsertUpdate_Movement_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDIOrder (TVarChar, TDateTime, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDIOrder(
    IN inOrderInvNumber      TVarChar  , -- Номер документа
    IN inOrderOperDate       TDateTime , -- Дата документа
    IN inGLN                 TVarChar   , -- 
    IN inGLNPlace            TVarChar   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (MovementId Integer, GoodsPropertyID Integer) -- Классификатор товаров) 
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbDescCode TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
     vbUserId := inSession;

     vbMovementId := NULL;

     SELECT Id INTO vbMovementId 
       FROM Movement WHERE DescId = zc_Movement_EDI() 
        AND OperDate = inOrderOperDate 
        AND InvNumber = inOrderInvNumber;

     -- определяется параметр
     vbDescCode:= (SELECT MovementDesc.Code FROM MovementDesc WHERE Id = zc_Movement_OrderExternal());
     IF vbDescCode IS NULL
     THEN
         RAISE EXCEPTION 'Ошибка в параметре.<%>', inDesc;
     END IF;


     -- сохранили <Документ>
     IF COALESCE(vbMovementId, 0) = 0 THEN
        vbMovementId := lpInsertUpdate_Movement (vbMovementId, zc_Movement_EDI(), inOrderInvNumber, inOrderOperDate, NULL);
     END IF;

     -- сохранили
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId, vbDescCode);

     IF inGLN <> '' THEN 
        PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNCode(), vbMovementId, inGLN);
     END IF;

     IF inGLNPlace <> '' THEN 
        PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNPlaceCode(), vbMovementId, inGLNPlace);
        -- Пытаемся установить связь с точкой доставки
        vbPartnerId := COALESCE((SELECT MIN(ObjectId)
                    FROM ObjectString WHERE DescId = zc_ObjectString_Partner_GLNCode() AND ValueData = inGLNPlace), 0);
        IF vbPartnerId <> 0 THEN
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), vbMovementId, vbPartnerId);
        END IF;
     END IF;


     IF vbPartnerId <> 0 THEN -- Находим Юр лицо по контрагенту
        vbJuridicalId := COALESCE((SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Partner_Juridical() AND ObjectId = vbPartnerId), 0);
     END IF;

     IF COALESCE (vbJuridicalId, 0) <> 0 THEN
        -- сохранили <Юр лицо>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), vbMovementId, vbJuridicalId);

        -- сохранили <ОКПО>
        PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), vbMovementId, (SELECT OKPO FROM ObjectHistory_JuridicalDetails_View WHERE JuridicalId = vbJuridicalId));

        -- Возвращаем ссылку на классификатор товаров
        vbGoodsPropertyID := (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Juridical_GoodsProperty() AND ObjectId = vbJuridicalId);

        -- сохранили <классификатор>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), vbMovementId, vbGoodsPropertyId);

     END IF;

     PERFORM lpInsert_Movement_EDIEvents(vbMovementId, 'Загрузка ORDER из EDI', vbUserId);

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
