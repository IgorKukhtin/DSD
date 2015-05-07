-- Function: gpUpdate_Movement_EDI_Params()

DROP FUNCTION IF EXISTS gpUpdate_Movement_EDI_Params (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_EDI_Params(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inContractId          Integer   , -- 
    IN inUnitId              Integer   , -- 
    IN inSession             TVarChar     -- Пользователь
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_EDI_Params());
     vbUserId:= lpGetUserBySession (inSession);


     -- сохранили
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inMovementId, inContractId);
     -- сохранили
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), inMovementId, inUnitId);


     -- обновили <Классификатор товаров> + сохранили элементы !!!на самом деле только обновили GoodsId and GoodsKindId!!!
     PERFORM lpUpdate_MI_EDI_Params (inMovementId  := inMovementId
                                   , inContractId  := inContractId
                                   , inJuridicalId := (SELECT MLO_Juridical.ObjectId FROM MovementLinkObject AS MLO_Juridical WHERE MLO_Juridical.MovementId = inMovementId AND MLO_Juridical.DescId = zc_MovementLinkObject_Juridical())
                                   , inUserId      := vbUserId
                                    );

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.10.14                                        * 
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_EDI_Params (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
