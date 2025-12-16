-- Function: gpUpdate_MI_Sale_PartionGoods_Q()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_PartionGoodsQ (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_Sale_PartionGoods_Q (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Sale_PartionGoods_Q (
    IN inMovementId                 Integer   , --
    IN inId                         Integer   , -- идентификатор строки
    IN inGoodsId                    Integer   , -- товар
    IN inGoodsKindId                Integer   , -- вид товара
    IN inPartionGoodsDate_q_1       TDateTime , -- новое значение
    IN inPartionGoodsDate_q_2       TDateTime , -- новое значение
    IN inPartionGoodsDate_q_3       TDateTime , -- новое значение
    IN inPartionGoodsDate_q_4       TDateTime , -- новое значение
    IN inPartionGoodsDate_q_5       TDateTime , -- новое значение
    IN inPartionGoodsDate_q_6       TDateTime , -- новое значение
    IN inPartionGoodsDate_q_7       TDateTime , -- новое значение
    IN inPartionGoodsDate_q_8       TDateTime , -- новое значение
    IN inPartionGoodsDate_q_9       TDateTime , -- новое значение
    IN inPartionGoodsDate_q_10      TDateTime , -- новое значение
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_Sale_PartionGoods_Q());
     vbUserId:= lpGetUserBySession (inSession);


     IF inId > 0
     THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q_1(),  inId, inPartionGoodsDate_q_1);
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q_2(),  inId, inPartionGoodsDate_q_2);
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q_3(),  inId, inPartionGoodsDate_q_3);
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q_4(),  inId, inPartionGoodsDate_q_4);
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q_5(),  inId, inPartionGoodsDate_q_5);
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q_6(),  inId, inPartionGoodsDate_q_6);
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q_7(),  inId, inPartionGoodsDate_q_7);
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q_8(),  inId, inPartionGoodsDate_q_8);
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q_9(),  inId, inPartionGoodsDate_q_9);
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q_10(), inId, inPartionGoodsDate_q_10);

         -- сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

     ELSE
	 RAISE EXCEPTION 'Ошибка.Нет прав.';

     END IF;

  if vbUserId = 9457 then RAISE EXCEPTION 'Test.Ок.';  end if;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.11.25         *
*/

-- тест
--