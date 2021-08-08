DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TaxFromMedoc (integer, TVarChar, TVarChar, tfloat, tfloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TaxFromMedoc(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsName           TVarChar  , -- Товары
    IN inMeasureName         TVarChar  , -- Единица измерения
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Сумма по позиции
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsExternalId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Tax());

     -- Ищем товар. Если не нашли - вставляем
     
     SELECT Id INTO vbGoodsExternalId FROM Object WHERE DescId = zc_Object_GoodsExternal() AND ValueData = inGoodsName || ' *** Киев';

     IF COALESCE(vbGoodsExternalId, 0) = 0 THEN
        vbGoodsExternalId := lpInsertUpdate_Object (vbGoodsExternalId, zc_Object_GoodsExternal(), 0, inGoodsName || ' *** Киев');
     END IF;

      -- сохранили <Элемент документа>
      PERFORM lpInsertUpdate_MovementItem_Tax (ioId              := 0
                                             , inMovementId         := inMovementId
                                             , inGoodsId            := vbGoodsExternalId
                                             , inAmount             := inAmount
                                             , inPrice              := inPrice
                                             , ioCountForPrice      := 1
                                             , inGoodsKindId        := NULL
                                             , inUserId             := vbUserId
                                              );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.04.15                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Tax (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, ioCountForPrice:= 1, inGoodsKindId:= 0, inSession:= '2')

/*
 update Object set ValueData = ValueData || ' *** Киев'
-- select * from Object , (
 from (
SELECT distinct MovementItem.ObjectId
                   FROM Movement
            inner JOIN MovementLinkObject AS MovementLinkObject_Branch
                                         ON MovementLinkObject_Branch.MovementId = Movement.Id
                                        AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()
                                        AND MovementLinkObject_Branch.ObjectId = 8379 -- филиал Киев

                        INNER join MovementItem on MovementItem.MovementId = Movement.Id
                                          AND MovementItem.isErased = FALSE
                                          AND MovementItem.DescId = zc_MI_Master()
                        INNER JOIN Object AS Object_GoodsExternal ON Object_GoodsExternal.Id = MovementItem.ObjectId
                                                                 AND Object_GoodsExternal.DescId = zc_Object_GoodsExternal()
                   WHERE Movement.OperDate between '01.10.2015' and '31.12.2015'
                     AND Movement.DescId = zc_Movement_Tax()
) as tmp
where tmp.ObjectId = Object.Id
  and STRPOS (ValueData, ' *** Киев') = 0



select  Object.*
, substring(Object.ValueData from 1 for STRPOS (Object.ValueData, ' *** Киев') - 1)

, lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsExternal_Goods(), Object2.Id, ObjectLink_GoodsExternal_Goods.ChildObjectId)
, lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsExternal_GoodsKind(), Object2.Id, ObjectLink_GoodsExternal_GoodsKind.ChildObjectId)

from Object 
join Object as Object2 on  Object2.ValueData =  substring(Object.ValueData from 1 for STRPOS (Object.ValueData, ' *** Киев') - 1)
and Object2.DescId = zc_Object_GoodsExternal()

        LEFT JOIN ObjectLink AS ObjectLink_GoodsExternal_Goods
                             ON ObjectLink_GoodsExternal_Goods.ObjectId = Object.Id 
                            AND ObjectLink_GoodsExternal_Goods.DescId = zc_ObjectLink_GoodsExternal_Goods()

        LEFT JOIN ObjectLink AS ObjectLink_GoodsExternal_GoodsKind
                             ON ObjectLink_GoodsExternal_GoodsKind.ObjectId = Object.Id 
                            AND ObjectLink_GoodsExternal_GoodsKind.DescId = zc_ObjectLink_GoodsExternal_GoodsKind()


where Object.DescId = zc_Object_GoodsExternal()
and STRPOS (Object.ValueData, ' *** Киев') <> 0
*/