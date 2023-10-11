-- Function: gpUpdate_Goods_NotTransferTime()

DROP FUNCTION IF EXISTS gpUpdate_Goods_CodeUKTZED(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_CodeUKTZED(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inCodeUKTZED          TVarChar  ,    -- Код УКТЗЕД
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbGoodsMainId  Integer;
   DECLARE vbCodeUKTZED   BIGINT;
   DECLARE text_var1      text;
BEGIN

   vbUserId := lpGetUserBySession (inSession);

   IF COALESCE(inId, 0) = 0 OR
      COALESCE(inCodeUKTZED, '') <> '' AND (
      length(REPLACE(REPLACE(REPLACE(inCodeUKTZED, ' ', ''), '.', ''), Chr(160), '')) < 4 OR
      length(REPLACE(REPLACE(REPLACE(inCodeUKTZED, ' ', ''), '.', ''), Chr(160), '')) > 10) OR
      inCodeUKTZED = (SELECT Object_Goods_Main.CodeUKTZED
                      FROM Object_Goods_Retail 
                           INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                      WHERE Object_Goods_Retail.Id = inId) 
   THEN
      RETURN;   
   END IF;
   
    -- Проверили на число
   BEGIN
     vbCodeUKTZED := REPLACE(REPLACE(REPLACE('0'||inCodeUKTZED, ' ', ''), '.', ''), Chr(160), '')::BIGINT;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        RETURN;   
   END;
   
   SELECT Object_Goods_Retail.GoodsMainId 
   INTO vbGoodsMainId
   FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId;

   IF COALESCE(vbGoodsMainId, 0) = 0
   THEN
      RETURN;   
   END IF;

   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_CodeUKTZED(), vbGoodsMainId, inCodeUKTZED);
                       
    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET CodeUKTZED = inCodeUKTZED
     WHERE Object_Goods_Main.ID = vbGoodsMainId;
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_CodeUKTZED', text_var1::TVarChar, vbUserId);
   END;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.10.23                                                       *         

*/

-- тест
-- SELECT * FROM gpUpdate_Goods_CodeUKTZED (24169 , '', '3')

