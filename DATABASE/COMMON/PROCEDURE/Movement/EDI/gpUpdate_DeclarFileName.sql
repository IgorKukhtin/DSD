-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_DeclarFileName(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_DeclarFileName(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inFileName            TVarChar  , -- Описание события
    IN inSession             TVarChar     -- Пользователь
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);

   PERFORM lpInsertUpdate_MovementString(zc_MovementString_DeclarFileName(), inMovementId, inFileName);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.03.15                         * 
 14.10.14                         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_EDI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
