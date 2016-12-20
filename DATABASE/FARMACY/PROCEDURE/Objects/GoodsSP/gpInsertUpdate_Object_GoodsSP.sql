-- Function: gpInsertUpdate_Object_GoodsSP()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP (Integer, TVarChar, Boolean, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsSP(
    IN inId                  Integer   ,    -- ключ объекта <Товар> MainID
    IN inCountSP             TVarChar  ,    -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект) 
    IN inisSP                Boolean   ,    -- участвует в Соц. проекте
    IN inPriceSP             TFloat    ,    -- Референтна ціна за уп, грн (Соц. проект)
    IN inGroupSP             TFloat    ,    -- Групи відшкоду-вання – І або ІІ
    IN inIntenalSPName       TVarChar  ,    -- Міжнародна непатентована назва (Соц. проект)
    IN inBrandSPName         TVarChar  ,    -- Торговельна назва лікарського засобу (Соц. проект)
    IN inKindOutSPName       TVarChar  ,    -- Форма випуску (Соц. проект)
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIntenalSPId Integer;
   DECLARE vbKindOutSPId Integer;
   DECLARE vbBrandSPId Integer;
   DECLARE vbName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка <inName>
     IF COALESCE (inId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Значение <Товар> должно быть установлено.';
     END IF;

    -- !!!поиск ИД главного товара!!!
   /* inId:= (SELECT ObjectLink_Main.ChildObjectId
                        FROM ObjectLink AS ObjectLink_Child 
                             LEFT JOIN ObjectLink AS ObjectLink_Main
                                                  ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                        WHERE ObjectLink_Child.ChildObjectId = inId                      --Object_Goods.Id
                          AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods());
   */
     -- проверяем существует ли уже такой товар
  /* SELECT Object_Goods.ValueData 
     INTO vbName
     FROM ObjectBoolean
          LEFT JOIN Object AS Object_Goods 
                           ON Object_Goods.Id = ObjectBoolean.ObjectId
     WHERE ObjectBoolean.DescId = zc_ObjectBoolean_Goods_SP() 
       AND ObjectBoolean.ObjectId = inId;
    
     IF COALESCE(vbName, '') <> ''
        RAISE EXCEPTION 'Ошибка.Для товара % уже сформированы данные по Соц.проекту.',vbName;
     END IF;
*/

     -- пытаемся найти "Міжнародна непатентована назва (Соц. проект)" 
     -- если не находим записывае новый элемент в справочник
     vbIntenalSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_IntenalSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inIntenalSPName)) );
     IF COALESCE (vbIntenalSPId, 0) = 0 AND COALESCE (inIntenalSPName, '')<> '' THEN
        -- записываем новый элемент
        vbIntenalSPId := gpInsertUpdate_Object_IntenalSP (ioId     := 0
                                                        , inCode   := lfGet_ObjectCode(0, zc_Object_IntenalSP()) 
                                                        , inName   := TRIM(inIntenalSPName)
                                                        , inSession:= inSession
                                                          );
     END IF;   
     -- пытаемся найти "Торговельна назва лікарського засобу (Соц. проект)"
     -- если не находим записывае новый элемент в справочник
     vbKindOutSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_KindOutSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inKindOutSPName)));
     IF COALESCE (vbKindOutSPId, 0) = 0 AND COALESCE (inKindOutSPName, '')<> '' THEN
        -- записываем новый элемент
        vbKindOutSPId := gpInsertUpdate_Object_KindOutSP (ioId     := 0
                                                        , inCode   := lfGet_ObjectCode(0, zc_Object_KindOutSP()) 
                                                        , inName   := TRIM(inKindOutSPName)
                                                        , inSession:= inSession
                                                          );
     END IF; 
     -- пытаемся найти "Форма випуску (Соц. проект)"
     -- если не находим записывае новый элемент в справочник
     vbBrandSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_BrandSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inBrandSPName)));
     IF COALESCE (vbBrandSPId, 0) = 0 AND COALESCE (inBrandSPName, '')<> '' THEN
        -- записываем новый элемент
        vbBrandSPId := gpInsertUpdate_Object_BrandSP (ioId     := 0
                                                    , inCode   := lfGet_ObjectCode(0, zc_Object_BrandSP()) 
                                                    , inName   := TRIM(inBrandSPName)
                                                    , inSession:= inSession
                                                     );
     END IF; 
       
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_IntenalSP(), inId, vbIntenalSPId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_BrandSP(), inId, vbBrandSPId);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_KindOutSP(), inId, vbKindOutSPId ); 

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_CountSP(), inId, inCountSP); 

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PriceSP(), inId, inPriceSP);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_GroupSP(), inId, inGroupSP);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SP(), inId, TRUE);


    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.12.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsSP (324, '17', True, 4::TFloat, 5::TFloat, 0, 0, 0, '3');