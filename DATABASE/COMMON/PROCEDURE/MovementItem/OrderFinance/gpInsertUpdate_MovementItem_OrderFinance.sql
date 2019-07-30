-- Function: gpInsertUpdate_MovementItem_OrderFinance()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderFinance(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inJuridicalId           Integer   , -- 
    IN inContractId            Integer   , -- 
    IN inAmount                TFloat    , -- 
    IN inComment               TVarChar  , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());

     -- сохранили
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_MovementItem_OrderFinance (ioId                  := ioId
                                                  , inMovementId          := inMovementId
                                                  , inJuridicalId         := inJuridicalId
                                                  , inContractId          := inContractId
                                                  , inAmount              := inAmount
                                                  , inComment             := inComment
                                                  , inUserId              := vbUserId
                                                   ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.19         *
*/

-- тест
--