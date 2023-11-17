 -- Function: gpInsertUpdate_Object_Goods_UKTZED_byCode_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_UKTZED2_From_Excel (Integer, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_UKTZED_byCode_Load (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_UKTZED_byCode_Load(
    IN inCode             Integer   , -- 
    IN inCodeUKTZED_new   TVarChar  ,
    IN inDateUKTZED_new   TDateTime ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbGoodsId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpGetUserBySession (inSession); 
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Goods_UKTZED());

     --проверка
     IF COALESCE (inCode,0) = 0
     THEN
         RETURN;
     END IF;
     --проверка
     IF COALESCE (inCodeUKTZED_new,'') = ''
     THEN
         RETURN;
     END IF;


     --проверка
     IF COALESCE (inCodeUKTZED_new,'') = ''
     THEN
         RAISE EXCEPTION 'Ошибка. Новый Код UKTZED не задан для товара с кодом = <%>.', inCode; 
     END IF;

     -- Проверка 
     vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inCode AND Object.DescId = zc_Object_Goods());
     IF COALESCE (vbGoodsId,0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Не найден Товар с Кодом = <%> .', inCode;
     END IF;


     --проверка чтоб новый код был пустой 
     IF EXISTS (SELECT 1
                FROM ObjectString
                WHERE ObjectString.DescId = zc_ObjectString_Goods_UKTZED_new()
                  AND ObjectString.ObjectId = vbGoodsId 
                  AND COALESCE (ObjectString.ValueData, '') <> ''
               ) 
     THEN 
         RAISE EXCEPTION 'Ошибка. Для товара c кодом = <%> новый Код UKTZED уже установлен.', inCode; 
     END IF;
     

     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_UKTZED_new(), vbGoodsId, TRIM (inCodeUKTZED_new));
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_UKTZED_new(), vbGoodsId, inDateUKTZED_new);
   
 
     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (vbGoodsId, vbUserId);


   IF vbUserId = 9457 OR vbUserId = 5
   THEN
         RAISE EXCEPTION 'Тест. Ок. <%>', inCode; 
   END IF;   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.23         *
*/

-- тест
--