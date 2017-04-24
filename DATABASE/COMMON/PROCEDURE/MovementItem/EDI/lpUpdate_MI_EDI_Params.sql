-- Function: lpUpdate_MI_EDI_Params()

DROP FUNCTION IF EXISTS lpUpdate_MI_EDI_Params (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_EDI_Params(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inContractId          Integer   , -- Ключ 
    IN inJuridicalId         Integer   , -- Ключ 
    IN inUserId              Integer     -- пользователь
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbGoodsPropertyId  Integer;
BEGIN
     -- Проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определен документ <EDI>.';
     END IF;


     -- сохранили <Contract> !!!в некоторых случаях здесь происходит сохранение "лишний" раз!!!
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inMovementId, inContractId);


     -- Поиск <Классификатор товаров>
     vbGoodsPropertyId := zfCalc_GoodsPropertyId (inContractId, inJuridicalId, (SELECT MLO_Partner.ObjectId FROM MovementLinkObject AS MLO_Partner WHERE MLO_Partner.MovementId = inMovementId AND MLO_Partner.DescId = zc_MovementLinkObject_Partner()));
     -- сохранили <Классификатор товаров>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), inMovementId, vbGoodsPropertyId);


     -- сохранили элементы !!!на самом деле только обновили GoodsId and GoodsKindId!!!
     PERFORM lpInsertUpdate_MovementItem (ioId         := MovementItem.Id
                                        , inDescId     := MovementItem.DescId
                                        , inObjectId   := tmpGoodsPropertyValue.GoodsId
                                        , inMovementId := MovementItem.MovementId
                                        , inAmount     := MovementItem.Amount -- !!!Количество по заявке не должно измениться!!!
                                        , inParentId   := MovementItem.ParentId
                                         )
           , lpInsertUpdate_MovementItemLinkObject (inDescId         := zc_MILinkObject_GoodsKind()
                                                  , inMovementItemId := MovementItem.Id
                                                  , inObjectId       := tmpGoodsPropertyValue.GoodsKindId
                                                   )
     FROM MovementItem
          LEFT JOIN MovementItemString AS MIString_GLNCode
                                       ON MIString_GLNCode.MovementItemId = MovementItem.Id
                                      AND MIString_GLNCode.DescId = zc_MIString_GLNCode()
          LEFT JOIN (SELECT ObjectString_ArticleGLN.ValueData AS ArticleGLN
                          , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
                          , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId AS GoodsKindId
                     FROM (SELECT MAX (Id) AS Id FROM Object_GoodsPropertyValue_View WHERE GoodsPropertyId = vbGoodsPropertyId AND ArticleGLN <> '' GROUP BY ArticleGLN
                          ) AS tmpGoodsPropertyValue
                          LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                                 ON ObjectString_ArticleGLN.ObjectId = tmpGoodsPropertyValue.Id
                                                AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
                          LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                               ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = tmpGoodsPropertyValue.Id
                                              AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                          LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                               ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = tmpGoodsPropertyValue.Id
                                              AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                    ) AS tmpGoodsPropertyValue ON tmpGoodsPropertyValue.ArticleGLN = MIString_GLNCode.ValueData
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.isErased   = FALSE
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.05.15                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_MI_EDI_Params (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
