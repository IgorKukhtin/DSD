-- Function: lpInsertUpdate_MI_UnnamedEnterprises_OrderInternal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_UnnamedEnterprises_OrderInternal(Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_UnnamedEnterprises_OrderInternal(
    IN vbOrderInternalId     Integer   ,    -- ключ объекта <>
    IN inGoodsId             Integer   ,    -- Код товара
    IN inAmountOrder         TFloat    ,    -- Количество
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOIIId Integer;
   DECLARE vbComment TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
  vbUserId:= inSession;

  IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.DescId = zc_MI_Master() AND MovementItem.ObjectId = inGoodsId AND MovementItem.MovementID = vbOrderInternalId)
  THEN
    SELECT
      MovementItem.Id,
      inAmountOrder + MovementItem.Amount
    INTO
      vbOIIId,
      inAmountOrder
    FROM MovementItem
    WHERE MovementItem.DescId = zc_MI_Master()
      AND MovementItem.ObjectId = inGoodsId
      AND MovementItem.MovementID = vbOrderInternalId;
  ELSE
    vbOIIId := 0;
  END IF;

  vbOIIId := lpInsertUpdate_MovementItem_OrderInternal(vbOIIId, vbOrderInternalId, inGoodsId, inAmountOrder, Null, NULL, vbUserId);

  vbComment := COALESCE ((SELECT MovementItemString.ValueData FROM MovementItemString
                          WHERE MovementItemString.DescId = zc_MIString_Comment() and MovementItemString.MovementItemID = vbOIIId), '');

  IF vbComment = ''
  THEN
    vbComment := 'БН';
  ELSE
    vbComment := vbComment || ' БН';
  END IF;

    -- сохранили свойство <Примечание>
  PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbOIIId, vbComment);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 15.11.18        *

*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_UnnamedEnterprises_OrderInternal
