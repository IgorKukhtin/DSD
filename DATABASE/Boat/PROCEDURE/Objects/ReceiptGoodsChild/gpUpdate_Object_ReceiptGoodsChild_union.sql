-- Function: gp0Update_Object_ReceiptGoodsChild_union()

DROP FUNCTION IF EXISTS gpUpdate_Object_ReceiptGoodsChild_union (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReceiptGoodsChild_union(
    IN inReceiptGoodsId      Integer   ,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptGoodsChild());
   vbUserId:= lpGetUserBySession (inSession);


   -- Проверка
   IF COALESCE (inReceiptGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.ReceiptGoodsId не выбран.'
                                             , inProcedureName := 'gpUpdate_Object_ReceiptGoodsChild_union'
                                             , inUserId        := vbUserId
                                              );
   END IF;
                  
   
   PERFORM CASE WHEN ord = 1 THEN lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptGoodsChild_Value(), tmp.ReceiptGoodsChildId, tmp.Value) END
         , CASE WHEN ord > 1 THEN lpUpdate_Object_isErased (inObjectId:= tmp.ReceiptGoodsChildId, inIsErased:= TRUE, inUserId:= vbUserId)  END
   FROM (
         SELECT (ObjectLink_ReceiptGoodsChild.ObjectId) AS ReceiptGoodsChildId
               , ObjectLink_Object.ChildObjectId        AS ObjectId
               , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Object.ChildObjectId ORDER BY ObjectLink_ReceiptGoodsChild.ObjectId) AS ord
               , SUM (COALESCE (ObjectFloat_Value.ValueData,0)) OVER (PARTITION BY ObjectLink_Object.ChildObjectId) AS Value
         FROM ObjectLink AS ObjectLink_ReceiptGoodsChild  
            INNER JOIN Object AS Object_ReceiptGoodsChild
                              ON Object_ReceiptGoodsChild.Id = ObjectLink_ReceiptGoodsChild.ObjectId
                             AND Object_ReceiptGoodsChild.IsErased = FALSE
            INNER JOIN ObjectLink AS ObjectLink_Object
                                  ON ObjectLink_Object.ObjectId = ObjectLink_ReceiptGoodsChild.ObjectId
                                 AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                  ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptGoodsChild.ObjectId
                                 AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
         WHERE ObjectLink_ReceiptGoodsChild.ChildObjectId = inReceiptGoodsId
           AND ObjectLink_ReceiptGoodsChild.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods() 
         ) AS tmp
   ;
   
   -- сохранили протокол
   --PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.05.24         *
*/

-- тест
--