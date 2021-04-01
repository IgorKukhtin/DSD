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
   DECLARE vbObjectId Integer;
   DECLARE vbConditionsKeepId Integer;
   DECLARE vbId Integer;
   DECLARE text_var1 text;
BEGIN

     IF COALESCE(inObjectId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Сначала выберите поставщика';
     END IF;

     IF COALESCE(inGoodsCode, '') = '' THEN
        RETURN;
     END IF;

     vbUserId := lpGetUserBySession (inSession);
     --vbObjectId := COALESCE(lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

     -- находим товар поставщика
     SELECT ObjectString.ObjectId 
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
     WHERE ObjectString.DescId = zc_ObjectString_Goods_Code()
       AND ObjectString.ValueData = TRIM(inGoodsCode);

     -- пытаемся найти "условие хранения" 
     -- если не находим записывае новый элемент в справочник
     vbConditionsKeepId := (SELECT Object.Id FROM Object 
                            WHERE Object.DescId = zc_Object_ConditionsKeep() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inConditionsKeepName)) );
     
     IF COALESCE (vbConditionsKeepId, 0) = 0 AND COALESCE (inConditionsKeepName, '')<> ''
     THEN
        -- записываем новый элемент
        vbConditionsKeepId := gpInsertUpdate_Object_ConditionsKeep (ioId               := 0
                                                                  , inCode             := lfGet_ObjectCode(0, zc_Object_ConditionsKeep()) 
                                                                  , inName             := TRIM(inConditionsKeepName)
                                                                  , inRelatedProductId := 0
                                                                  , inSession          := inSession
                                                                    );
     END IF;

 
     IF COALESCE( vbId, 0) = 0 THEN
        RETURN;
     END IF;

     -- сохранили свойство <условие хранения> у товара поставщика
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_ConditionsKeep(), vbId, vbConditionsKeepId);
  
     -- сохранили свойство <условие хранения> у товара сети
     -- если пустое значение записываем всегда, иначе смотрим на вх.параметр inisUpdate
        -- PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_ConditionsKeep(), ObjectLink_Child_R.ChildObjectId, vbConditionsKeepId);
 
 /*       PERFORM CASE WHEN COALESCE (ObjectLink_Goods_ConditionsKeep.ChildObjectId,0) = 0 OR inisUpdate = TRUE
                     THEN lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_ConditionsKeep(), ObjectLink_Child_R.ChildObjectId, vbConditionsKeepId)
                END
        FROM ObjectLink AS ObjectLink_Goods_Object
          -- получаем GoodsMainId
          INNER JOIN ObjectLink AS ObjectLink_Child1
                                ON ObjectLink_Child1.ChildObjectId = ObjectLink_Goods_Object.ObjectId
                               AND ObjectLink_Child1.DescId        = zc_ObjectLink_LinkGoods_Goods()
          INNER JOIN ObjectLink AS ObjectLink_Main
                                ON ObjectLink_Main.ObjectId = ObjectLink_Child1.ObjectId
                               AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
          -- связь с товар сети ...
          INNER JOIN ObjectLink AS ObjectLink_Main_R 
                                ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                               AND ObjectLink_Main_R.DescId     = zc_ObjectLink_LinkGoods_GoodsMain()
          INNER JOIN ObjectLink AS ObjectLink_Child_R 
                                ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                               AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
          --торговая сеть
          INNER JOIN ObjectLink AS ObjectLink_Goods_Object1
                                ON ObjectLink_Goods_Object1.ObjectId = ObjectLink_Child_R.ChildObjectId
                               AND ObjectLink_Goods_Object1.DescId = zc_ObjectLink_Goods_Object()
                             --AND ObjectLink_Goods_Object1.ChildObjectId = vbObjectId
          INNER JOIN Object AS Object_Retail
                            ON Object_Retail.Id = ObjectLink_Goods_Object1.ChildObjectId
                           AND Object_Retail.DescId = zc_Object_Retail()
          LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                               ON ObjectLink_Goods_ConditionsKeep.ObjectId = ObjectLink_Child_R.ChildObjectId
                              AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
        WHERE ObjectLink_Goods_Object.ObjectId = vbId
          AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object();
 */
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_ConditionsKeep(), tmp.GoodsId, vbConditionsKeepId)
        FROM (
              with 
                 tmpObjectLink AS (select ObjectLink_Child_R.ChildObjectId
                                   FROM ObjectLink AS ObjectLink_Goods_Object
                                     -- получаем GoodsMainId
                                     INNER JOIN ObjectLink AS ObjectLink_Child1
                                                           ON ObjectLink_Child1.ChildObjectId = ObjectLink_Goods_Object.ObjectId
                                                          AND ObjectLink_Child1.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                     INNER JOIN ObjectLink AS ObjectLink_Main
                                                           ON ObjectLink_Main.ObjectId = ObjectLink_Child1.ObjectId
                                                          AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                     -- связь с товар сети ...
                                     INNER JOIN ObjectLink AS ObjectLink_Main_R 
                                                           ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                          AND ObjectLink_Main_R.DescId     = zc_ObjectLink_LinkGoods_GoodsMain()
                                     INNER JOIN ObjectLink AS ObjectLink_Child_R 
                                                           ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                          AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                   WHERE ObjectLink_Goods_Object.ObjectId = vbId
                                            AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                   )
                     
               , tmpOL_Object AS (SELECT ObjectLink.*
                                  FROM ObjectLink
                                       INNER JOIN Object AS Object_Retail
                                                         ON Object_Retail.Id = ObjectLink.ChildObjectId
                                                        AND Object_Retail.DescId = zc_Object_Retail()
                                  WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpObjectLink.ChildObjectId FROM tmpObjectLink)
                                    AND ObjectLink.DescId = zc_ObjectLink_Goods_Object()
                                 )
              
               , tmpOL_ConditionsKeep AS (SELECT ObjectLink.*
                                          FROM ObjectLink
                                          WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpObjectLink.ChildObjectId FROM tmpObjectLink)
                                            AND ObjectLink.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                                         )
              
              SELECT tmpObjectLink.ChildObjectId  AS GoodsId
              FROM tmpObjectLink
                 --торговая сеть
                 INNER JOIN tmpOL_Object AS ObjectLink_Goods_Object1
                                         ON ObjectLink_Goods_Object1.ObjectId = tmpObjectLink.ChildObjectId
                                  
                 LEFT JOIN tmpOL_ConditionsKeep AS ObjectLink_Goods_ConditionsKeep 
                                                ON ObjectLink_Goods_ConditionsKeep.ObjectId = tmpObjectLink.ChildObjectId
              WHERE COALESCE (ObjectLink_Goods_ConditionsKeep.ChildObjectId, 0) = 0 OR inisUpdate = TRUE
              ) AS tmp
                  ;  

    -- Сохранили в плоскую таблицй
    BEGIN
      
      UPDATE Object_Goods_Juridical SET ConditionsKeepId = vbConditionsKeepId
      WHERE Object_Goods_Juridical.ID = vbId;
     
      UPDATE Object_Goods_Main SET ConditionsKeepId = vbConditionsKeepId
      WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Juridical.GoodsMainId FROM Object_Goods_Juridical WHERE Object_Goods_Juridical.ID = vbId);  
    EXCEPTION
       WHEN others THEN 
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
         PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_ConditionsKeep', text_var1::TVarChar, vbUserId);
    END;
    
    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 17.10.19                                                      * 
 08.05.18         *
 07.01.17         *
*/

--select * from gpUpdate_Goods_ConditionsKeep(inObjectId := 59610 , inGoodsCode := '1171006' , inisUpdate := 'False' , inConditionsKeepName := '1.5.6ЛС_общий режим' ,  inSession := '3');