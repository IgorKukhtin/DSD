-- Function: gpInsertUpdate_MI_GoodsSPRegistry_1303Helsi_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsSPRegistry_1303Helsi_From_Excel (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                            , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                            , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_GoodsSPRegistry_1303Helsi_From_Excel(
    IN inMovementId          Integer   ,    -- 
    IN inCode                Integer   ,    -- код объекта <Товар> MainID
    IN inPriceSP             TFloat    ,    -- Референтна ціна за уп, грн (Соц. проект)
    IN inCountSPMin          TFloat    ,    -- Мінімальна кількість форм випуску до продажу
    IN inCountSP             TFloat    ,    -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект) 

    IN inColSP               TFloat    ,    --
    IN inPriceOptSP          TFloat    ,    -- 
    IN inPriceRetSP          TFloat    ,    -- 
    IN inDailyNormSP         TFloat    ,    -- 
    IN inDailyCompensationSP TFloat    ,    -- 
    IN inPaymentSP           TFloat    ,    -- 
    IN inDenumeratorValue    TFloat  ,    --

    IN inReestrDateSP        TVarChar  ,    -- 
    IN inPack                TVarChar  ,    -- дозування
    IN inIntenalSPName       TVarChar  ,    -- Міжнародна непатентована назва (Соц. проект)
    IN inBrandSPName         TVarChar  ,    -- Торговельна назва лікарського засобу (Соц. проект)
    IN inKindOutSPName       TVarChar  ,    -- Форма випуску (Соц. проект)

    IN inCodeATX             TVarChar  ,    --
    IN inMakerSP             TVarChar  ,    --
    IN inReestrSP            TVarChar  ,    --  
    IN inIdSP                TVarChar  ,    --
    IN inDosageIdSP          TVarChar  ,    --
    
    IN inCountry             TVarChar  ,    --
    IN inIntenalSPName_Lat   TVarChar  ,    --
    IN inProgramId           TVarChar  ,    --
    IN inNumeratorUnit       TVarChar  ,    --
    IN inDenumeratorUnit     TVarChar  ,    --

    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMainId Integer;
   DECLARE vbMI_Id Integer;
   DECLARE vbId Integer;
   DECLARE vbIntenalSPId Integer;
   DECLARE vbKindOutSPId Integer;
   DECLARE vbBrandSPId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbIntenalSPName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка <inName>
     IF COALESCE (inCode, 0) = 0 THEN
        RETURN;--RAISE EXCEPTION 'Ошибка.Значение <Товар> должно быть установлено.';
     END IF; 

     -- !!!поиск ИД главного товара!!!
     vbMainId:= (SELECT ObjectBoolean_Goods_isMain.ObjectId
                 FROM ObjectBoolean AS ObjectBoolean_Goods_isMain 
                      INNER JOIN Object AS Object_Goods 
                                        ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId
                                       AND Object_Goods.ObjectCode = inCode
                 WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain());
   
     IF COALESCE (vbMainId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Значение кода % не найдено в справочнике.', inCode;
     END IF;  

     -- пытаемся найти "Міжнародна непатентована назва (Соц. проект)" 
     -- если не находим записывае новый элемент в справочник
     vbIntenalSPName := TRIM (inIntenalSPName)||', '||TRIM (inIntenalSPName_Lat); --сливаем Укр и лат. названия через зпт.
     vbIntenalSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_IntenalSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(vbIntenalSPName)) );
     IF COALESCE (vbIntenalSPId, 0) = 0 AND COALESCE (vbIntenalSPName, '') <> '' THEN
        -- записываем новый элемент
        vbIntenalSPId := gpInsertUpdate_Object_IntenalSP (ioId     := 0
                                                        , inCode   := lfGet_ObjectCode(0, zc_Object_IntenalSP()) 
                                                        , inName   := TRIM(vbIntenalSPName)
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
            vbId := (SELECT MovementItem.Id
                     FROM MovementItem
                          INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                      AND MovementItemFloat.DescId = zc_ObjectFloat_Goods_ColSP()
                                                      AND MovementItemFloat.ValueData = inColSP
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.ObjectId <> COALESCE (vbMainId, 0)
                     Limit 1 -- на всякий случай
                    );

            IF COALESCE (vbId, 0) <> 0 
               THEN
                   --убираем № п.п. если нашли
                   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ColSP(), vbId, 0);
            END IF;
     END IF;

     -- ищем строку с таким товаром, если есть перезаписываем
     vbMI_Id := (SELECT MovementItem.Id
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.ObjectId = COALESCE (vbMainId, 0)
                 Limit 1 -- на всякий случай
                );
    

    -- сохранить запись
    PERFORM lpInsertUpdate_MovementItem_GoodsSPRegistry_1303 (ioId                  := COALESCE(vbMI_Id, 0)
                                               , inMovementId          := inMovementId
                                               , inGoodsId             := vbMainId
                                               , inIntenalSPId         := vbIntenalSPId
                                               , inBrandSPId           := vbBrandSPId
                                               , inKindOutSPId         := vbKindOutSPId
                                               , inColSP               := COALESCE (inColSP, 0) :: TFloat
                                               , inCountSPMin          := COALESCE (inCountSPMin, 0) :: TFloat
                                               , inCountSP             := COALESCE (inCountSP, 0) :: TFloat
                                               , inPriceOptSP          := COALESCE (inPriceOptSP, 0) :: TFloat
                                               , inPriceRetSP          := COALESCE (inPriceRetSP, 0) :: TFloat
                                               , inDailyNormSP         := COALESCE (inDailyNormSP, 0) :: TFloat
                                               , inDailyCompensationSP := COALESCE (inDailyCompensationSP, 0) :: TFloat
                                               , inPriceSP             := COALESCE (inPriceSP, 0) :: TFloat
                                               , inPaymentSP           := COALESCE (inPaymentSP, 0) :: TFloat
                                               , inGroupSP             := 0 ::TFloat
                                               , inDenumeratorValueSP  := COALESCE (inDenumeratorValue, 0) :: TFloat
                                               , inPack                := TRIM(inPack)          ::TVarChar
                                               , inCodeATX             := TRIM(inCodeATX)       ::TVarChar
                                               , inMakerSP             := (TRIM(inMakerSP)||', '|| TRIM(inCountry)) ::TVarChar
                                               , inReestrSP            := TRIM(inReestrSP)      ::TVarChar
                                               , inReestrDateSP        := TRIM(inReestrDateSP)  ::TVarChar
                                               , inIdSP                := TRIM(inIdSP)          ::TVarChar
                                               , inDosageIdSP          := TRIM(inDosageIdSP)    ::TVarChar
                                               , inProgramIdSP         := TRIM(inProgramId)::TVarChar
                                               , inNumeratorUnitSP     := TRIM(inNumeratorUnit)::TVarChar
                                               , inDenumeratorUnitSP   := TRIM(inDenumeratorUnit)::TVarChar
                                               , inUserId              := vbUserId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbMI_Id, vbUserId, vbIsInsert);
    
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.07.19         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsSPRegistry_1303_From_Excel (324, '17', True, 4::TFloat, 5::TFloat, 0, 0, 0, '3');