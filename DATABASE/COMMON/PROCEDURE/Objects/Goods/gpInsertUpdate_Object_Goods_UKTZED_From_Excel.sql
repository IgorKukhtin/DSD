 -- Function: gpInsertUpdate_Object_Goods_UKTZED_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_UKTZED_From_Excel (TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_UKTZED_From_Excel(
    IN inGoodsName        TVarChar   ,
    IN inCodeUKTZED       TVarChar  , -- 
    IN inCodeUKTZED_new   TVarChar  ,
    IN inDateUKTZED_new   TDateTime ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpGetUserBySession (inSession); 
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Goods_UKTZED());

     --проверка
     IF COALESCE (inCodeUKTZED,'') = ''
     THEN
         RAISE EXCEPTION 'Ошибка. Код UKTZED не задан для <%>.', inGoodsName;
     END IF;

     --проверка
     IF COALESCE (inCodeUKTZED_new,'') = ''
     THEN
         RAISE EXCEPTION 'Ошибка. Новый Код UKTZED не задан для <%>.', inGoodsName; 
     END IF;

          -- Проверка
     IF NOT EXISTS (SELECT 1 FROM ObjectString
                    WHERE ObjectString.DescId = zc_ObjectString_Goods_UKTZED()
                      AND TRIM (ObjectString.ValueData) = TRIM (inCodeUKTZED)
                    LIMIT 1)
     THEN
        RETURN;
        RAISE EXCEPTION 'Ошибка.Не найден Товар с Кодом UKTZED = <%> .', inCodeUKTZED;
     END IF;

     --проверка чтоб новый код был пустой 
     IF EXISTS (SELECT 1
                FROM ObjectString
                     INNER JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                             ON ObjectString_Goods_UKTZED_new.ObjectId = ObjectString.ObjectId
                                            AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
                                            AND COALESCE (ObjectString_Goods_UKTZED_new.ValueData, '') <> ''
                WHERE ObjectString.DescId = zc_ObjectString_Goods_UKTZED()
                  AND TRIM (ObjectString.ValueData) = TRIM (inCodeUKTZED)
                LIMIT 1) 
     THEN 
         RAISE EXCEPTION 'Ошибка. Для товара <%> новый Код UKTZED уже установлен.', inGoodsName; 
     END IF;
     

     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_UKTZED_new(), ObjectString.ObjectId, TRIM (inCodeUKTZED_new))
           , lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_UKTZED_new(), ObjectString.ObjectId, inDateUKTZED_new)
     FROM ObjectString
     WHERE ObjectString.DescId = zc_ObjectString_Goods_UKTZED()
       AND TRIM (ObjectString.ValueData) = TRIM (inCodeUKTZED);
   
 
   IF vbUserId = 9457 OR vbUserId = 5
   THEN
         RAISE EXCEPTION 'Тест. Ок. <%>', inGoodsName; 
   END IF;   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.23         *
*/

-- тест
--