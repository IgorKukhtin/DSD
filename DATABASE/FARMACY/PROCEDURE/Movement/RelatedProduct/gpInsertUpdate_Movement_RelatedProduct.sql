-- Function: gpInsertUpdate_Movement_RelatedProduct()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_RelatedProduct (Integer, TVarChar, TDateTime, Integer, TFloat, TVarChar, TBlob, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_RelatedProduct(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inRetailID              Integer    , -- Торговая сеть
    IN inPriceMin              Tfloat     , -- От цены товара
    IN inComment               TVarChar   , -- Примечание
    IN inMessage               TBlob      , -- Сообщение
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := inSession;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_RelatedProduct (ioId            := ioId
                                                  , inInvNumber     := inInvNumber
                                                  , inOperDate      := inOperDate
                                                  , inRetailID      := inRetailID
                                                  , inPriceMin      := inPriceMin
                                                  , inComment       := inComment
                                                  , inMessage       := inMessage
                                                  , inUserId        := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Шаблий О.В.
 13.10.20                                                       *
*/