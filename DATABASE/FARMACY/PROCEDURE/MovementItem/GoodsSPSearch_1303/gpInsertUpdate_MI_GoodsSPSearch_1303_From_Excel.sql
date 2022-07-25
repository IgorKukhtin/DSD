-- Function: gpInsertUpdate_MI_GoodsSPSearch_1303_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsSPSearch_1303_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_GoodsSPSearch_1303_From_Excel(
    IN inMovementId               Integer   ,    -- Идентификатор документа

    IN inIntenalSPName            TVarChar  ,    -- Міжнародна непатентована або загальноприйнята назва лікарського засобу (1)
    IN inBrandSPName              TVarChar  ,    -- Торговельна назва лікарського засобу (2)

    IN inKindOutSP_1303Name       TVarChar  ,    -- Форма випуску (3)
    IN inDosage_1303Name          TVarChar  ,    -- Дозування (Соц. проект)(4)
    IN inCountSP_1303Name         TVarChar  ,    -- Кількість одиниць лікарського засобу у споживчій упаковці (5)
    IN inMakerCountrySP_1303Name  TVarChar  ,    -- Найменування виробника, країна (6)

    IN inCodeATX                  TVarChar  ,    -- Код АТХ (7)
    IN inReestrSP                 TVarChar  ,    -- Номер реєстраційного посвідчення на лікарський засіб (8)
    IN inValiditySP               TVarChar  ,    -- Дата закінчення строку дії реєстраційного посвідчення на лікарський засіб (9)

    IN inPriceOptSP               TFloat    ,    -- Задекларована оптово-відпускна ціна (грн.)(Соц. проект)(10)
    IN inExchangeRate             TVarChar  ,    -- Офіційний курс та вид іноземної валюти (11)

    IN inOrderDateNumberSP        TVarChar  ,    -- Дата та номер наказу МОЗ про декларування змін оптово-відпускної ціни на лікарські засоби (12)
    IN inCol                      Integer   ,    -- Номер по порядку

    IN inSession                  TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbGoodsId Integer;

   DECLARE vbIntenalSP_1303Id Integer;
   DECLARE vbBrandSPId Integer;
   DECLARE vbKindOutSP_1303Id Integer;
   DECLARE vbDosage_1303Id Integer;
   DECLARE vbCountSP_1303Id Integer;
   DECLARE vbmakercountrysp_1303id Integer;
   DECLARE vbCurrencyId Integer;
   DECLARE vbExchangeRate TFloat;

   DECLARE vbOrderDateSP TDateTime;
   DECLARE vbOrderNumberSP Integer;

   DECLARE vbValiditySP TDateTime;
   DECLARE vbCount Integer;
   DECLARE text_var1 text;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId:= lpGetUserBySession (inSession);
  
  
  IF TRIM(COALESCE(inIntenalSPName, '')) = '' AND TRIM(COALESCE(inBrandSPName, '')) = ''
  THEN
    RETURN;
  END IF;

  BEGIN   
        
     -- пытаемся найти "Міжнародна непатентована назва (Соц. проект)(2)" 
     -- если не находим записывае новый элемент в справочник
     IF inIntenalSPName <> ''
     THEN
       vbIntenalSP_1303Id := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_IntenalSP_1303() AND UPPER (TRIM(Object.ValueData)) ILIKE UPPER (TRIM(inIntenalSPName)) LIMIT 1);
       IF COALESCE (vbIntenalSP_1303Id, 0) = 0 AND COALESCE (inIntenalSPName, '') <> '' THEN
          -- записываем новый элемент
          vbIntenalSP_1303Id := gpInsertUpdate_Object_IntenalSP_1303 (ioId     := 0
                                                                    , inCode   := lfGet_ObjectCode(0, zc_Object_IntenalSP_1303()) 
                                                                    , inName   := TRIM(inIntenalSPName)
                                                                    , inSession:= inSession
                                                                      );
       END IF;   
     END IF;   

     -- пытаемся найти "Торговельна назва лікарського засобу (Соц. проект)(4)"
     -- если не находим записывае новый элемент в справочник
     vbBrandSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_BrandSP() AND UPPER (TRIM(Object.ValueData)) = UPPER (TRIM(inBrandSPName)) LIMIT 1);
     IF COALESCE (vbBrandSPId, 0) = 0 AND COALESCE (inBrandSPName, '') <> '' THEN
        -- записываем новый элемент
        vbBrandSPId := gpInsertUpdate_Object_BrandSP (ioId     := 0
                                                    , inCode   := lfGet_ObjectCode(0, zc_Object_BrandSP()) 
                                                    , inName   := TRIM(inBrandSPName)
                                                    , inSession:= inSession
                                                     );
     END IF; 
     
     -- пытаемся найти "Форма випуску (Соц. проект)(5)"
     -- если не находим записывае новый элемент в справочник
     WHILE POSITION('  ' IN inKindOutSP_1303Name) > 0 LOOP inKindOutSP_1303Name := REPLACE (inKindOutSP_1303Name, '  ', ' '); END LOOP;     
     vbKindOutSP_1303Id := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_KindOutSP_1303() AND UPPER (TRIM(Object.ValueData)) = UPPER (TRIM(inKindOutSP_1303Name)) LIMIT 1);
     IF COALESCE (vbKindOutSP_1303Id, 0) = 0 AND COALESCE (inKindOutSP_1303Name, '') <> '' THEN
        -- записываем новый элемент
        vbKindOutSP_1303Id := gpInsertUpdate_Object_KindOutSP_1303 (ioId     := 0
                                                                  , inCode   := lfGet_ObjectCode(0, zc_Object_KindOutSP_1303()) 
                                                                  , inName   := TRIM(inKindOutSP_1303Name)
                                                                  , inSession:= inSession
                                                                    );
     END IF; 

     -- пытаемся найти "Дозування (Соц. проект)(6)"
     -- если не находим записывае новый элемент в справочник
     WHILE POSITION('  ' IN inDosage_1303Name) > 0 LOOP inDosage_1303Name := REPLACE (inDosage_1303Name, '  ', ' '); END LOOP;     
     vbDosage_1303Id := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Dosage_1303() AND UPPER (TRIM(Object.ValueData)) = UPPER (TRIM(inDosage_1303Name)) LIMIT 1);
     IF COALESCE (vbDosage_1303Id, 0) = 0 AND COALESCE (inDosage_1303Name, '') <> '' THEN
        -- записываем новый элемент
        vbDosage_1303Id := gpInsertUpdate_Object_Dosage_1303 (ioId     := 0
                                                            , inCode   := lfGet_ObjectCode(0, zc_Object_Dosage_1303()) 
                                                            , inName   := TRIM(inDosage_1303Name)
                                                            , inSession:= inSession
                                                              );
     END IF; 

     -- пытаемся найти "Кількість таблеток в упаковці (Соц. проект)(7)"
     -- если не находим записывае новый элемент в справочник
     WHILE POSITION('  ' IN inCountSP_1303Name) > 0 LOOP inCountSP_1303Name := REPLACE (inCountSP_1303Name, '  ', ' '); END LOOP;     
     vbCountSP_1303Id := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CountSP_1303() AND UPPER (TRIM(Object.ValueData)) = UPPER (TRIM(inCountSP_1303Name)) LIMIT 1);
     IF COALESCE (vbCountSP_1303Id, 0) = 0 AND COALESCE (inCountSP_1303Name, '') <> '' THEN
        -- записываем новый элемент
        vbCountSP_1303Id := gpInsertUpdate_Object_CountSP_1303 (ioId     := 0
                                                              , inCode   := lfGet_ObjectCode(0, zc_Object_CountSP_1303()) 
                                                              , inName   := TRIM(inCountSP_1303Name)
                                                              , inSession:= inSession
                                                                );
     END IF; 

     -- пытаемся найти "Назва виробника (Соц. проект)(8)"
     -- если не находим записывае новый элемент в справочник
     WHILE POSITION('  ' IN inMakerCountrySP_1303Name) > 0 LOOP inMakerCountrySP_1303Name := REPLACE (inMakerCountrySP_1303Name, '  ', ' '); END LOOP;     
     vbMakerCountrySP_1303Id := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_MakerCountrySP_1303() AND UPPER (TRIM(Object.ValueData)) = UPPER (TRIM(inMakerCountrySP_1303Name)) LIMIT 1);
     IF COALESCE (vbMakerCountrySP_1303Id, 0) = 0 AND COALESCE (inMakerCountrySP_1303Name, '') <> '' THEN
        -- записываем новый элемент
        vbMakerCountrySP_1303Id := gpInsertUpdate_Object_MakerCountrySP_1303 (ioId     := 0
                                                              , inCode   := lfGet_ObjectCode(0, zc_Object_MakerCountrySP_1303()) 
                                                              , inName   := TRIM(inMakerCountrySP_1303Name)
                                                              , inSession:= inSession
                                                                );
     END IF; 



     -- пытаемся найти "Валюта (Соц. проект)(16)"
     IF COALESCE (inExchangeRate, '') <> ''
     THEN
       IF POSITION('США' IN UPPER(inExchangeRate)) > 0
       THEN
          vbCurrencyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Currency() AND Object.ObjectCode = 840);     
       ELSEIF POSITION('Є' IN UPPER(inExchangeRate)) > 0
       THEN
          vbCurrencyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Currency() AND Object.ObjectCode = 978);          
       ELSE
          vbCurrencyId := 0;
       END IF;       
     ELSE
        vbCurrencyId := 0;
     END IF;
     
     
     -- парсим курс
     IF SPLIT_PART (inExchangeRate, ' ', 1) <> ''
     THEN
       BEGIN  
         vbExchangeRate := REPLACE(SPLIT_PART (inExchangeRate, ' ', 1), ',', '.')::TFloat;
       EXCEPTION WHEN others THEN 
         vbExchangeRate := 0;
       END;
     ELSE
       vbExchangeRate := 0;
     END IF;

     -- переводим дату
     BEGIN  
       vbValiditySP := inValiditySP::TDateTime;
     EXCEPTION WHEN others THEN 
       vbValiditySP := Null;
     END;
     
     inOrderDateNumberSP := REPLACE(inOrderDateNumberSP, ', від', '; від');
     inOrderDateNumberSP := REPLACE(inOrderDateNumberSP, '; від', ';від');
     inOrderDateNumberSP := REPLACE(inOrderDateNumberSP, 'від.', 'від ');
     
     vbCount := 1;
     WHILE SPLIT_PART (inOrderDateNumberSP, ';', vbCount + 1) <> '' LOOP vbCount := vbCount + 1; END LOOP;     
     inOrderDateNumberSP := SPLIT_PART (inOrderDateNumberSP, ';', vbCount);

     -- Дата та номер наказу МОЗ про декларування змін оптово-відпускної ціни на лікарські засоби
     BEGIN  
       vbOrderDateSP := SPLIT_PART (SPLIT_PART (inOrderDateNumberSP, ';', 1), ' ', 2)::TDateTime;
     EXCEPTION WHEN others THEN 
       vbOrderDateSP := Null;
     END;

     BEGIN  
       vbOrderNumberSP := REPLACE(SPLIT_PART (SPLIT_PART (inOrderDateNumberSP, ';', 1), ' ', 3), '№', '')::Integer;
     EXCEPTION WHEN others THEN 
       vbOrderNumberSP := 0;
     END;
     
     
     IF vbOrderNumberSP = 0 AND REPLACE(SPLIT_PART (SPLIT_PART (inOrderDateNumberSP, ';', 1), ' ', 4), '№', '') <> ''
     THEN
       BEGIN  
         vbOrderNumberSP := REPLACE(SPLIT_PART (SPLIT_PART (inOrderDateNumberSP, ';', 1), ' ', 4), '№', '')::Integer;
       EXCEPTION WHEN others THEN 
         vbOrderNumberSP := 0;
       END;     
     END IF;

     -- ищем если уже создали
     SELECT MovementItem.Id, MovementItem.ObjectId
     INTO vbId, vbGoodsId
     FROM MovementItem


          LEFT JOIN MovementItemLinkObject AS MI_IntenalSP_1303
                                           ON MI_IntenalSP_1303.MovementItemId = MovementItem.Id
                                          AND MI_IntenalSP_1303.DescId = zc_MILinkObject_IntenalSP_1303()
                                                    
 
          LEFT JOIN MovementItemLinkObject AS MI_BrandSP
                                           ON MI_BrandSP.MovementItemId = MovementItem.Id
                                          AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()                                                    

          LEFT JOIN MovementItemLinkObject AS MI_Dosage_1303
                                           ON MI_Dosage_1303.MovementItemId = MovementItem.Id
                                          AND MI_Dosage_1303.DescId = zc_MILinkObject_Dosage_1303()

          LEFT JOIN MovementItemLinkObject AS MI_KindOutSP_1303
                                           ON MI_KindOutSP_1303.MovementItemId = MovementItem.Id
                                          AND MI_KindOutSP_1303.DescId = zc_MILinkObject_KindOutSP_1303()
                                          AND MI_KindOutSP_1303.ObjectId = vbKindOutSP_1303Id

          LEFT JOIN MovementItemLinkObject AS MI_CountSP_1303
                                           ON MI_CountSP_1303.MovementItemId = MovementItem.Id
                                          AND MI_CountSP_1303.DescId = zc_MILinkObject_CountSP_1303()

          LEFT JOIN MovementItemString AS MIString_CodeATX
                                       ON MIString_CodeATX.MovementItemId = MovementItem.Id
                                      AND MIString_CodeATX.DescId = zc_MIString_CodeATX()  
                                              
          LEFT JOIN MovementItemString AS MIString_ReestrSP
                                       ON MIString_ReestrSP.MovementItemId = MovementItem.Id
                                      AND MIString_ReestrSP.DescId = zc_MIString_ReestrSP()  

     WHERE MovementItem.MovementId = inMovementId
       AND (MI_IntenalSP_1303.ObjectId = vbIntenalSP_1303Id OR COALESCE(vbIntenalSP_1303Id, 0) = 0) 
       AND (MI_BrandSP.ObjectId = vbBrandSPId OR COALESCE(vbBrandSPId, 0) = 0)
       AND (MI_Dosage_1303.ObjectId = vbDosage_1303Id OR COALESCE(vbDosage_1303Id, 0) = 0)
       AND (MI_CountSP_1303.ObjectId = vbCountSP_1303Id OR COALESCE(vbCountSP_1303Id, 0) = 0)
       AND COALESCE(MIString_CodeATX.ValueData, '') = TRIM(inCodeATX)
       AND COALESCE(MIString_ReestrSP.ValueData, '') = TRIM(inReestrSP)
     Limit 1 -- на всякий случай
     ;
                            
     IF EXISTS(SELECT MovementItem.ID FROM MovementItem WHERE MovementItem.ID = vbId AND MovementItem.isErased = True)
     THEN
       UPDATE MovementItem SET isErased = False  WHERE MovementItem.ID = vbId AND MovementItem.isErased = True;
     END IF;
              
    /* IF COALESCE (vbId, 0) <> 0
     THEN
       PERFORM lpLog_Run_Schedule_Function('gpInsertUpdate_MI_GoodsSPSearch_1303_From_Excel', False, (inID_MED_FORM::tvarchar||'  '||inMorionSP::tvarchar)::TVarChar, vbUserId);
     END IF;*/
           
    -- сохранить запись
    PERFORM lpInsertUpdate_MovementItem_GoodsSPSearch_1303 (ioId                      := COALESCE(vbId, 0)
                                                          , inMovementId              := inMovementId
                                                          , inGoodsId                 := COALESCE(vbGoodsId, 0)
                                                          , inCol                     := inCol
                                                          , inIntenalSP_1303Id        := vbIntenalSP_1303Id
                                                          , inBrandSPId               := vbBrandSPId
                                                          , inKindOutSP_1303Id        := vbKindOutSP_1303Id
                                                          , inDosage_1303Id           := vbDosage_1303Id
                                                          , inCountSP_1303Id          := vbCountSP_1303Id
                                                          , inMakerCountrySP_1303Id   := vbMakerCountrySP_1303Id
                                                          , inCodeATX                 := TRIM(inCodeATX)::TVarChar
                                                          , inReestrSP                := TRIM(inReestrSP)::TVarChar
                                                          , inValiditySP              := vbValiditySP
                                                          , inPriceOptSP              := COALESCE (inPriceOptSP, 0) :: TFloat
                                                          , inCurrencyId              := vbCurrencyId
                                                          , inExchangeRate            := vbExchangeRate
                                                          , inOrderNumberSP           := vbOrderNumberSP
                                                          , inOrderDateSP             := vbOrderDateSP
                                                          , inUserId                  := vbUserId);
                                                          
    /*IF COALESCE(vbId, 0) <> 0 AND vbOrderDateSP IS NOT NULL
    THEN
      -- сохранили <>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OrderNumberSP(), vbId, vbOrderNumberSP);

      -- сохранили <>
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OrderDateSP(), vbId, vbOrderDateSP);
    
    END IF;*/
                                                                                                                    
  EXCEPTION
     WHEN others THEN 
       GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
       --PERFORM lpAddObject_Goods_Temp_Error('gpInsertUpdate_MI_GoodsSPSearch_1303_From_Excel', text_var1::TVarChar, vbUserId);
  END;

  /*raise NOTICE  'Value 03: <%> <%> <%> <%>', 
                      vbId, vbGoodsId, vbOrderDateSP, vbOrderNumberSP;  */   
  

/*  IF COALESCE (text_var1, '') <> ''
  THEN
     raise EXCEPTION  'Value 03: <%> <%> <%> <%> <%> <%> <%> <%> <%> <%> <%> <%> <%> <%>', 
                      vbId, vbIntenalSP_1303Id, vbBrandSPId, vbKindOutSP_1303Id, vbDosage_1303Id, vbCountSP_1303Id, 
                      vbMakerCountrySP_1303Id, vbCurrencyId, vbExchangeRate, vbValiditySP, vbOrderDateSP, vbOrderNumberSP, text_var1, TRIM(inMakerCountrySP_1303Name);     
  END IF;*/
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.05.22                                                       *
*/

-- тест

-- select * from gpInsertUpdate_MI_GoodsSPSearch_1303_From_Excel(inMovementId := 28341113 , inIntenalSPName := 'Comb drug' , inBrandSPName := 'Діаніл ПД 4 з вмістом глюкози 1,36% м/об/13,6мг/мл' , inKindOutSP_1303Name := 'Розчин для перитонеального діалізу' , inDosage_1303Name := 'на 1000 мл розчину: Глюкоза моногідрат 15 г, натрію хлорид 5,38, кальцію хлорид дигідрат 0,184 г, магнію хлорид гексагідрат 0,051 г, натрію лактат 4,48 г' , inCountSP_1303Name := '2000 мл розчину у пластиковому мішку "Віафлекс" PL146-3,одинарному, обладнаному ін`єкційним портом та з`єднувачем, або у мішку "Твін Бег" обладнаному ін`єкційним портом з інтегрованим за допомогаю двох магістралей та Y-з`єднувача порожнім пластиковим мішк' , inMakerCountrySP_1303Name := 'Бакстер Хелскеа С.А., Ірландія Бакстер Меньюфекчерінг Сп. з о.о., Польща' , inCodeATX := 'B05DB' , inReestrSP := 'UA/12425/01/03' , inValiditySP := 'необмежений' , inPriceOptSP := 1037.27 , inExchangeRate := '28,3408 грн. (за 1 дол. США)', inCol := 1, inOrderDateNumberSP := 'від 16.03.2016 №191, від 29.11.2018 №2221 ' ,  inSession := '3');

