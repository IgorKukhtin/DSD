-- Function: gpInsertUpdate_Object_GoodsSP()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP (Integer, TVarChar, Boolean, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP (Integer, Boolean, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP (Integer, Boolean, TFloat, TFloat, TFloat,  TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                     , TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP (Integer, Boolean, TFloat, TFloat,  TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                     , TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP (Integer, Boolean, TFloat, TFloat,  TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP (Integer, Boolean, TFloat, TFloat,  TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsSP(
    IN inId                  Integer   ,    -- ключ объекта <Товар> MainID
    IN inisSP                Boolean   ,    -- участвует в Соц. проекте
    IN inPriceSP             TFloat    ,    -- Референтна ціна за уп, грн (Соц. проект)
   -- IN inGroupSP             TFloat    ,    -- Групи відшкоду-вання – І або ІІ
    IN inCountSP             TFloat    ,    -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект)

    IN inColSP               TFloat    ,    --
    IN inPriceOptSP          TFloat    ,    --
    IN inPriceRetSP          TFloat    ,    --
    IN inDailyNormSP         TFloat    ,    --
    IN inDailyCompensationSP TFloat    ,    --
    IN inPaymentSP           TFloat    ,    --

    IN inDateReestrSP        TVarChar  ,    --
    IN inPack                TVarChar  ,    -- дозування
    IN inIntenalSPName       TVarChar  ,    -- Міжнародна непатентована назва (Соц. проект)
    IN inBrandSPName         TVarChar  ,    -- Торговельна назва лікарського засобу (Соц. проект)
    IN inKindOutSPName       TVarChar  ,    -- Форма випуску (Соц. проект)
    IN inCodeATX             TVarChar  ,    --
    IN inMakerSP             TVarChar  ,    --
    IN inReestrSP            TVarChar  ,    --
    IN inInsertDateSP        TDateTime ,    --
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

   DECLARE vbId Integer;
   DECLARE text_var1 text;
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

     -- ищем № п.п. Не должно быть товаров с одинаковым №, если находим обнуляем
     IF COALESCE (inColSP, 0) <> 0
        THEN
            vbId := (SELECT ObjectFloat.ObjectId
                     FROM ObjectFloat
                     WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_ColSP()
                       AND ObjectFloat.ValueData = inColSP
                       AND ObjectFloat.ObjectId <> COALESCE (inId, 0)
                    );

            IF COALESCE (vbId, 0) <> 0
               THEN
                   --убираем № п.п. если нашли
                   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_ColSP(), vbId, Null);
            END IF;
     END IF;

    -- сохранили связь с <>
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_IntenalSP(), inId, vbIntenalSPId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_BrandSP(), inId, vbBrandSPId);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_KindOutSP(), inId, vbKindOutSPId );

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Pack(), inId, inPack);

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PriceSP(), inId, inPriceSP);
    -- сохранили свойство <>
    --PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_GroupSP(), inId, inGroupSP);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_CountSP(), inId, inCountSP);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SP(), inId, TRUE);

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PriceOptSP(), inId, inPriceOptSP);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PriceRetSP(), inId, inPriceRetSP);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_DailyNormSP(), inId, inDailyNormSP);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_DailyCompensationSP(), inId, inDailyCompensationSP);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PaymentSP(), inId, inPaymentSP);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_ColSP(), inId, inColSP);

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_CodeATX(), inId, inCodeATX);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_ReestrSP(), inId, inReestrSP);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_MakerSP(), inId, inMakerSP);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_ReestrDateSP(), inId, inDateReestrSP);

    -- сохранили свойство <Дата создания>
    PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_InsertSP(), inId, inInsertDateSP);

     -- Сохранили в плоскую таблицй
    BEGIN
      IF NOT EXISTS(SELECT 1 FROM Object_Goods_SP WHERE Object_Goods_SP.Id = inId)
      THEN
        INSERT INTO Object_Goods_SP (id, isSP) VALUES (inId, False);
      END IF;

      UPDATE Object_Goods_SP SET isSP                = TRUE
                               , IntenalSPID         = vbIntenalSPId
                               , BrandSPID           = vbBrandSPId
                               , KindOutSPID         = vbKindOutSPId
                              -- , GroupSP             = inGroupSP
                               , PriceSP             = inPriceSP
                               , CountSP             = inCountSP
                               , PriceOptSP          = inPriceOptSP
                               , PriceRetSP          = inPriceRetSP
                               , DailyNormSP         = inDailyNormSP
                               , PaymentSP           = inPaymentSP
                               , ColSP               = inColSP
                               , DailyCompensationSP = inDailyCompensationSP
                               , ReestrDateSP        = inDateReestrSP
                               , MakerSP             = inMakerSP
                               , ReestrSP            = inReestrSP
                               , Pack                = inPack
                               , CodeATX             = inCodeATX
      WHERE Object_Goods_SP.Id = inId;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpAddObject_Goods_Temp_Error('gpInsertUpdate_Object_GoodsSP', text_var1::TVarChar, vbUserId);
    END;


    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.10.19                                                       *
 07.04.17         *
 04.04.17         *
 19.12.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsSP (324, '17', True, 4::TFloat, 5::TFloat, 0, 0, 0, '3');