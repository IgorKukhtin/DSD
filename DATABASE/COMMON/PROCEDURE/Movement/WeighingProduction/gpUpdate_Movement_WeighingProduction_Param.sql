-- Function: gpUpdate_Movement_WeighingProduction_Param()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingProduction_Param (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingProduction_Param(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inBarCodeBoxId        Integer   , -- 
    IN inGoodsTypeKindId     Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbInvNumber TVarChar;
   DECLARE vbParentId Integer;
   DECLARE vbStartWeighing TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_WeighingProduction_Param());

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BarCodeBox(), inId, inBarCodeBoxId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsTypeKind(), inId, inGoodsTypeKindId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.06.19         *
*/

-- тест
-- 