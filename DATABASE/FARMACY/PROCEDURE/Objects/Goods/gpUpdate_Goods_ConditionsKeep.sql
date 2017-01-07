-- Function: gpUpdate_Object_Goods_ConditionsKeep()

DROP FUNCTION IF EXISTS gpUpdate_Goods_ConditionsKeep(Integer, TVarChar, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_ConditionsKeep(
    IN inObjectId            Integer   ,    -- поставщик
    IN inGoodsCode           TVarChar  ,    -- ключ объекта <Товар>
    IN inisUpdate            Boolean   ,    -- записвать свойство товару сети
    IN inConditionsKeepName  TVarChar  ,    -- условие хранения
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbConditionsKeepId Integer;
   DECLARE vbId Integer;
BEGIN

     IF COALESCE(inObjectId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Сначала выберите поставщика';
     END IF;

     IF COALESCE(inGoodsCode, '') = '' THEN
        RETURN;
     END IF;

     vbUserId := lpGetUserBySession (inSession);
    
     -- находим товар поставщика
     SELECT ObjectString.ObjectId--, ObjectLink_Main.ChildObjectId,
       INTO vbId
     FROM ObjectString 
          INNER JOIN Object AS Object_Goods 
                            ON Object_Goods.Id = ObjectString.ObjectId
                           AND Object_Goods.DescId = zc_Object_Goods()
          -- связь с Юридические лица или Торговая сеть или ...
          INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                               AND ObjectLink_Goods_Object.ChildObjectId = inObjectId
                         
          -- получается GoodsMainId
          LEFT JOIN ObjectLink AS ObjectLink_Child 
                               ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                              AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
          LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                               AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
     WHERE ObjectString.DescId = zc_ObjectString_Goods_Code()
       AND ObjectString.ValueData = inGoodsCode;

     -- пытаемся найти "условие хранения" 
     -- если не находим записывае новый элемент в справочник
     vbConditionsKeepId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ConditionsKeep() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inConditionsKeepName)) );
     IF COALESCE (vbConditionsKeepId, 0) = 0 AND COALESCE (inConditionsKeepName, '')<> '' THEN
        -- записываем новый элемент
        vbConditionsKeepId := gpInsertUpdate_Object_ConditionsKeep (ioId     := 0
                                                                  , inCode   := lfGet_ObjectCode(0, zc_Object_ConditionsKeep()) 
                                                                  , inName   := TRIM(inConditionsKeepName)
                                                                  , inSession:= inSession
                                                                    );
     END IF;   

 
     IF COALESCE( vbId, 0) = 0 THEN
        RETURN;
     END IF;

    -- сохранили свойство <условие хранения>
    PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_ConditionsKeep(), vbId, vbConditionsKeepId);
  

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 07.01.17         *
*/

--SELECT * FROM ObjectLink WHERE DESCID = zc_ObjectLink_Goods_ConditionsKeep()