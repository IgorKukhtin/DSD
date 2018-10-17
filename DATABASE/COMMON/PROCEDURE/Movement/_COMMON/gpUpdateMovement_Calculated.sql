-- Function: gpUpdateMovement_Calculated()

DROP FUNCTION IF EXISTS gpUpdateMovement_Calculated (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Calculated(
    IN inId                  Integer   , -- Ключ объекта <Документ>
 INOUT ioisCalculated        Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= inSession;

     -- определили признак
     ioisCalculated:= NOT ioisCalculated;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Calculated(), inId, ioisCalculated);

     -- обновили поле в строчной части
     WITH tmpGoodsSeparate AS (SELECT DISTINCT ObjectLink_GoodsSeparate_Goods.ChildObjectId AS GoodsId
                               FROM Object AS Object_GoodsSeparate
                                    INNER JOIN ObjectBoolean AS ObjectBoolean_Calculated
                                                             ON ObjectBoolean_Calculated.ObjectId  = Object_GoodsSeparate.ObjectId
                                                            AND ObjectBoolean_Calculated.DescId    = zc_ObjectBoolean_GoodsSeparate_Calculated()
                                                            AND ObjectBoolean_Calculated.ValueData = TRUE
                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsSeparate_Goods
                                                         ON ObjectLink_GoodsSeparate_Goods.ObjectId = Object_GoodsSeparate.ObjectId
                                                        AND ObjectLink_GoodsSeparate_Goods.DescId   = zc_ObjectLink_GoodsSeparate_Goods()
                               WHERE Object_GoodsSeparate.DescId   = zc_Object_GoodsSeparate()
                                 AND Object_GoodsSeparate.isErased = FALSE
                              )
         , tmpMIChild AS (SELECT MovementItem.Id, MovementItem.ObjectId AS GoodsId, COALESCE (MIBoolean_Calculated.ValueData, FALSE) AS isCalculated
                          FROM MovementItem
                               LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                             ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                            AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                          WHERE MovementItem.MovementId = inId
                            AND MovementItem.DescId     = zc_MI_Child()
                         )
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), tmpMIChild.Id
                                          , CASE -- если снимается - снимаем у всех
                                                 WHEN ioisCalculated = FALSE THEN FALSE
                                                 -- если уже поставили в ручном режиме - оставляем
                                                 WHEN EXISTS (SELECT 1 FROM tmpMIChild AS tmpMIChild_find WHERE tmpMIChild_find.isCalculated = TRUE) THEN tmpMIChild.isCalculated
                                                 -- иначе - по справочнику
                                                 ELSE COALESCE (tmpGoodsSeparate.isCalculated, FALSE)
                                            END
                                           )
     FROM tmpMIChild
          LEFT JOIN tmpGoodsSeparate ON tmpGoodsSeparate.GoodsId = tmpMIChild.GoodsId
     ;


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.10.18         * 
*/


-- тест
-- SELECT * FROM gpUpdateMovement_Calculated (inId:= 275079, ioisCalculated:= 'False', inSession:= '2')
