-- Function: gpInsertUpdate_MI_GoodsSPHelsi_From_Antibiotics()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsSPHelsi_From_Antibiotics (Integer, TVarChar, TVarChar, TFloat, TVarChar, TVarChar, TVarChar
                                                            , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                            , TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_GoodsSPHelsi_From_Antibiotics(
    IN inMovementId          Integer   ,    -- 
    IN inCountSPMin          TVarChar  ,    -- Мінімальна кількість форм випуску до продажу (5)
    IN inCountSP             TVarChar  ,    -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект) (4)

    IN inColSP               TFloat    ,    -- № з/п 
    IN inDenumeratorValue    TVarChar  ,    -- Кількість сутності (13)

    IN inReestrDateSP        TVarChar  ,    -- Дата закінчення строку дії реєстраційного посвідчення на лікарський засіб (7)
    IN inPack                TVarChar  ,    -- дозування (14)
    IN inIntenalSPName       TVarChar  ,    -- Міжнародна непатентована назва (Соц. проект) (16)
    IN inIntenalSPName_Lat   TVarChar  ,    -- Міжнародна непатентована назва (Соц. проект) (17)
    IN inBrandSPName         TVarChar  ,    -- Торговельна назва лікарського засобу (Соц. проект) (2)
    IN inKindOutSPName       TVarChar  ,    -- Форма випуску (Соц. проект) (12)

    IN inCodeATX             TVarChar  ,    -- Код АТХ (3)
    IN inMakerSP             TVarChar  ,    -- Найменування виробника, країна (8)
    IN inCountry             TVarChar  ,    -- Найменування виробника, країна (9)
    IN inReestrSP            TVarChar  ,    -- Номер реєстраційного посвідчення на лікарський засіб (6) 
    IN inIdSP                TVarChar  ,    -- ID лікар. засобу (1)
    
    IN inProgramId           TVarChar  ,    -- ID учасника програми (0)
    IN inNumeratorUnit       TVarChar  ,    -- Одиниця виміру сили дії (12)
    IN inDenumeratorUnit     TVarChar  ,    -- Одиниця виміру сутності (10)

    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbCountSPMin TFloat;
   DECLARE vbCountSP TFloat;
   DECLARE vbDenumeratorValue TFloat;

   DECLARE vbKindOutSPId Integer;
   DECLARE vbIntenalSPId Integer;
   DECLARE vbBrandSPId Integer;
   DECLARE vbIntenalSPName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

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

     -- ищем Id
     SELECT MovementItem.Id, MovementItem.ObjectId
     INTO vbId, vbGoodsId
     FROM MovementItem
          LEFT JOIN MovementItemString AS MIString_IdSP
                                       ON MIString_IdSP.MovementItemId = MovementItem.Id
                                      AND MIString_IdSP.DescId = zc_MIString_IdSP()
          LEFT JOIN MovementItemString AS MIString_ProgramIdSP
                                       ON MIString_ProgramIdSP.MovementItemId = MovementItem.Id
                                      AND MIString_ProgramIdSP.DescId = zc_MIString_ProgramIdSP()
     WHERE MovementItem.MovementId = inMovementId
       AND MIString_IdSP.ValueData = inIdSP
       AND MIString_ProgramIdSP.ValueData = inProgramId
     Limit 1; -- на всякий случай
     
     /*IF COALESCE (vbId, 0) > 0
     THEN
       RETURN;
     END IF;*/

     BEGIN  
       vbCountSPMin := inCountSPMin::TFloat;
     EXCEPTION WHEN others THEN 
       vbCountSPMin := Null;
     END;     

     BEGIN  
       vbCountSP := inCountSP::TFloat;
     EXCEPTION WHEN others THEN 
       vbCountSP := Null;
     END;     

     BEGIN  
       vbDenumeratorValue := inDenumeratorValue::TFloat;
     EXCEPTION WHEN others THEN 
       vbDenumeratorValue := Null;
     END;     
     
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (vbId, 0) = 0;

    -- сохранили <Элемент документа>
    vbId := lpInsertUpdate_MovementItem (COALESCE(vbId, 0), zc_MI_Master(), COALESCE(vbGoodsId, 0), inMovementId, 0, NULL);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ColSP(), vbId, inColSP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSPMin(), vbId, vbCountSPMin);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSP(), vbId, vbCountSP);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DenumeratorValueSP(), vbId, vbDenumeratorValue);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Pack(), vbId, TRIM(inPack));
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_CodeATX(), vbId, TRIM(inCodeATX));
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_MakerSP(), vbId, (TRIM(inMakerSP)||', '|| TRIM(inCountry)) ::TVarChar);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrSP(), vbId, TRIM(inReestrSP));
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrDateSP(), vbId, TRIM(inReestrDateSP));
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_IdSP(), vbId, TRIM(inIdSP));

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ProgramIdSP(), vbId, TRIM(inProgramId));
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_NumeratorUnitSP(), vbId, TRIM(inNumeratorUnit));
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_DenumeratorUnitSP(), vbId, TRIM(inDenumeratorUnit));
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_IntenalSP(), vbId, vbIntenalSPId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BrandSP(), vbId, vbBrandSPId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_KindOutSP(), vbId, vbKindOutSPId);


    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);
    
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.08.22                                                       *
*/

-- тест
 SELECT * FROM gpInsertUpdate_MI_GoodsSPHelsi_From_Antibiotics(
     inMovementId := 28396300,
     inCountSPMin := '10',
     inCountSP := '100',

     inColSP := 1,
     inDenumeratorValue := '1',

     inReestrDateSP := '2100-01-11',
     inPack := '10',
     inIntenalSPName := 'діоксидин',
     inIntenalSPName_Lat := 'dioxydine',
     inBrandSPName := 'ДІОКСИДИН',
     inKindOutSPName := 'AMPOULE',

     inCodeATX := 'J01XX',
     inMakerSP := 'АТ "Фармак"',
     inCountry := 'Україна',
     inReestrSP := 'UA/6867/01/01',
     inIdSP := '47f99caa-50e8-4410-be61-c8bfd634b70e',
    
     inProgramId := 'bf9b0f7e-500e-48f9-946c-1a35e4e830a7',
     inNumeratorUnit := 'AMPOULE',
     inDenumeratorUnit := 'ML',

     inSession := '3');