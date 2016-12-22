-- Function: gpInsertUpdate_Object_GoodsSP_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP_Load (Integer, TVarChar, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsSP_Load(
    IN inCode                Integer   ,    -- код объекта <Товар> MainID
    IN inName                TVarChar  ,    -- Наименование
    IN inPriceSP             TFloat    ,    -- Референтна ціна за уп, грн (Соц. проект)
    IN inGroupSP             TFloat    ,    -- Групи відшкоду-вання – І або ІІ
    IN inCountSP             TFloat    ,    -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект) 
    IN inPack                TVarChar  ,    -- дозування
    IN inIntenalSPName       TVarChar  ,    -- Міжнародна непатентована назва (Соц. проект)
    IN inBrandSPName         TVarChar  ,    -- Торговельна назва лікарського засобу (Соц. проект)
    IN inKindOutSPName       TVarChar  ,    -- Форма випуску (Соц. проект)
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка <inName>
     IF COALESCE (inCode, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Значение <Товар> должно быть установлено.';
     END IF; 

     -- !!!поиск ИД главного товара!!!
     vbId:= (SELECT ObjectBoolean_Goods_isMain.ObjectId
            FROM ObjectBoolean AS ObjectBoolean_Goods_isMain 
                 INNER JOIN Object AS Object_Goods 
                                   ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId
                                  AND Object_Goods.ObjectCode = inCode
            WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain());
   
     IF COALESCE (vbId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Значение % не найдено в справочнике.', inName;
     END IF;  
   
     PERFORM gpInsertUpdate_Object_GoodsSP (ioId              := vbId
                                          , inisSP            := TRUE
                                          , inPriceSP         := inPriceSP
                                          , inGroupSP         := inGroupSP
                                          , inCountSP         := inCountSP
                                          , inPack            := TRIM(inPack)
                                          , inIntenalSPName   := TRIM(inIntenalSPName)
                                          , inBrandSPName     := TRIM(inBrandSPName)
                                          , inKindOutSPName   := TRIM(inKindOutSPName)
                                          , inSession         := inSession
                                          );
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.12.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsSP_Load (324, '17', True, 4::TFloat, 5::TFloat, 0, 0, 0, '3');