-- Function: gpInsertUpdate_MI_GoodsSPHelsi_From_ExcelFull()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsSPHelsi_From_ExcelFull (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_GoodsSPHelsi_From_ExcelFull(
    IN inOperDate            TDateTime ,    -- 
    IN inColSP               Integer    ,   -- № з/п 

    IN inMedicalProgramSPId  TVarChar  ,    -- Медицинская программа (A)

    IN inCountSPMin          TVarChar  ,    -- Мінімальна кількість форм випуску до продажу (AW)
    IN inCountSP             TVarChar  ,    -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект) (AX)

    IN inPriceSP             TVarChar  ,    -- Референтна ціна за уп, грн (Соц. проект) (BJ)
    IN inPriceOptSP          TVarChar  ,    -- Оптово-відпускна ціна за упаковку. грн (BG)
    IN inPriceRetSP          TVarChar  ,    -- Роздрібна ціна за упаковку. грн (BH)
    IN inDailyCompensationSP TVarChar  ,    -- Розмір відшкодування добової дози лікарського засобу. грн (BI)
    IN inPaymentSP           TVarChar  ,    -- Сума доплати за упаковку. грн (BK)


    IN inDenumeratorValue    TVarChar  ,    -- Кількість сутності (AI)

    IN inReestrDateSP        TVarChar  ,    -- Дата закінчення строку дії реєстраційного посвідчення на лікарський засіб (BB)
    IN inPack                TVarChar  ,    -- дозування (F)
    IN inIntenalSPName       TVarChar  ,    -- Міжнародна непатентована назва (Соц. проект) (D)
    IN inIntenalSPName_Lat   TVarChar  ,    -- Міжнародна непатентована назва (Соц. проект) (E)
    IN inBrandSPName         TVarChar  ,    -- Торговельна назва лікарського засобу (Соц. проект) (AV)
    IN inKindOutSPName       TVarChar  ,    -- Форма випуску (Соц. проект) (I)

    IN inMakerSP             TVarChar  ,    -- Найменування виробника, країна (AY)
    IN inCountry             TVarChar  ,    -- Найменування виробника, країна (AZ)
    IN inReestrSP            TVarChar  ,    -- Номер реєстраційного посвідчення на лікарський засіб (BA) 


    IN inIdSP                TVarChar  ,    -- ID лікар. засобу (AQ)
    
    IN inProgramId           TVarChar  ,    -- ID учасника програми (BF)
    IN inNumeratorUnit       TVarChar  ,    -- Одиниця виміру сили дії (AH)
    IN inDenumeratorUnit     TVarChar  ,    -- Одиниця виміру сутності (AU)
    
    IN inName                TVarChar  ,    -- Название (AF)
    
    IN inEndDate             TVarChar  ,    -- Дата окончания (BM)

    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbValue TFloat;

   DECLARE vbKindOutSPId Integer;
   DECLARE vbIntenalSPId Integer;
   DECLARE vbBrandSPId Integer;
   DECLARE vbIntenalSPName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     IF TRIM(inMedicalProgramSPId) = '' THEN RETURN; END IF;     
     
     IF inEndDate <> ''
     THEN
       IF inEndDate::TDateTime < inOperDate THEN RETURN; END IF;     
     END IF;
     
     -- Ищем или создаем Movement СП
     IF NOT EXISTS(SELECT Movement.Id
                   FROM Movement
                        INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                ON MovementDate_OperDateStart.MovementId = Movement.Id
                                               AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                               AND MovementDate_OperDateStart.ValueData  <= date_trunc('DAY', inOperDate)

                        INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                               AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                               AND MovementDate_OperDateEnd.ValueData  >= date_trunc('DAY', inOperDate)

                        INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                                      ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                                     AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                        INNER JOIN ObjectString AS ObjectString_ProgramId 	
                                                ON ObjectString_ProgramId.ObjectId = MLO_MedicalProgramSP.ObjectId
                                               AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()
                                               AND ObjectString_ProgramId.ValueData ILIKE TRIM(inMedicalProgramSPId)

                   WHERE Movement.DescId = zc_Movement_GoodsSP()
                     AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete()))
     THEN
       SELECT gpInsertUpdate_Movement_GoodsSP(ioId                  := 0, -- Ключ объекта <Документ Списания>
                                              inInvNumber           := CAST (NEXTVAL ('Movement_GoodsSP_seq') AS TVarChar), -- Номер документа
                                              inOperDate            := date_trunc('DAY', inOperDate), -- Дата документа
                                              inOperDateStart       := date_trunc('DAY', inOperDate), --
                                              inOperDateEnd         := date_trunc('DAY', inOperDate), --
                                              inMedicalProgramSPId  := MLO_MedicalProgramSP.ObjectId , --
                                              inPercentMarkup       := MovementFloat_PercentMarkup.ValueData, --
                                              inPercentPayment      := MovementFloat_PercentPayment.ValueData, --
                                              inSession             := inSession    -- сессия пользователя     
                                              )
       INTO vbMovementId
       FROM Movement

            INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                          ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                         AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
            INNER JOIN ObjectString AS ObjectString_ProgramId 	
                                    ON ObjectString_ProgramId.ObjectId = MLO_MedicalProgramSP.ObjectId
                                   AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()
                                   AND ObjectString_ProgramId.ValueData ILIKE TRIM(inMedicalProgramSPId)

            LEFT JOIN MovementFloat AS MovementFloat_PercentMarkup
                                    ON MovementFloat_PercentMarkup.MovementId = Movement.Id
                                   AND MovementFloat_PercentMarkup.DescId = zc_MovementFloat_PercentMarkup()

            LEFT JOIN MovementFloat AS MovementFloat_PercentPayment
                                    ON MovementFloat_PercentPayment.MovementId = Movement.Id
                                   AND MovementFloat_PercentPayment.DescId = zc_MovementFloat_PercentPayment()

       WHERE Movement.DescId = zc_Movement_GoodsSP()
         AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
       ORDER BY Movement.OperDate DESC
       LIMIT 1;
     ELSE
       SELECT Movement.Id
       INTO vbMovementId
       FROM Movement
            INNER JOIN MovementDate AS MovementDate_OperDateStart
                                    ON MovementDate_OperDateStart.MovementId = Movement.Id
                                   AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                   AND MovementDate_OperDateStart.ValueData  <= date_trunc('DAY', inOperDate)

            INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                    ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                   AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                   AND MovementDate_OperDateEnd.ValueData  >= date_trunc('DAY', inOperDate)

            INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                          ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                         AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
            INNER JOIN ObjectString AS ObjectString_ProgramId 	
                                    ON ObjectString_ProgramId.ObjectId = MLO_MedicalProgramSP.ObjectId
                                   AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()
                                   AND ObjectString_ProgramId.ValueData ILIKE TRIM(inMedicalProgramSPId)

       WHERE Movement.DescId = zc_Movement_GoodsSP()
         AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete());     
     END IF;
     
     -- Проверяем Movement СП
     IF COALESCE (vbMovementId, 0) <> 0
     THEN
       IF EXISTS(SELECT Movement.Id
                 FROM Movement
                 WHERE Movement.DescId = zc_Movement_GoodsSP()
                   AND Movement.Id = vbMovementId
                   AND Movement.StatusId = zc_Enum_Status_Complete())
       THEN
         RAISE EXCEPTION 'Документ для медицинской программы <%> % проведен.%Распроведите его.', inMedicalProgramSPId, 
               (SELECT Movement.InvNumber
                 FROM Movement
                 WHERE Movement.DescId = zc_Movement_GoodsSP()
                   AND Movement.Id = vbMovementId
                   AND Movement.StatusId = zc_Enum_Status_Complete()), Chr(13);     
       END IF;             
     ELSE
       RAISE EXCEPTION 'Документ для медицинской программы <%> не создан.', inMedicalProgramSPId;     
     END IF;
     
     -- пытаемся найти "Міжнародна непатентована назва (Соц. проект)" 
     -- если не находим записывае новый элемент в справочник
     vbIntenalSPName := TRIM (inIntenalSPName)||', '||TRIM (inIntenalSPName_Lat); --сливаем Укр и лат. названия через зпт.
     vbIntenalSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_IntenalSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(vbIntenalSPName)) LIMIT 1);
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
     vbKindOutSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_KindOutSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inKindOutSPName)) LIMIT 1);
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
     vbBrandSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_BrandSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inBrandSPName)) LIMIT 1);
     IF COALESCE (vbBrandSPId, 0) = 0 AND COALESCE (inBrandSPName, '')<> '' THEN
        -- записываем новый элемент
        vbBrandSPId := gpInsertUpdate_Object_BrandSP (ioId     := 0
                                                    , inCode   := lfGet_ObjectCode(0, zc_Object_BrandSP()) 
                                                    , inName   := TRIM(inBrandSPName)
                                                    , inSession:= inSession
                                                     );
     END IF; 

     -- Ищем Id строки
     SELECT MovementItem.Id
     INTO vbId
     FROM MovementItem
          LEFT JOIN MovementItemString AS MIString_IdSP
                                       ON MIString_IdSP.MovementItemId = MovementItem.Id
                                      AND MIString_IdSP.DescId = zc_MIString_IdSP()
     WHERE MovementItem.MovementId = vbMovementId
       AND MIString_IdSP.ValueData = inIdSP
     Limit 1; -- на всякий случай
     
     -- Ищем Id товара если есть
     SELECT Object_Goods_Main.Id
     INTO vbGoodsId
     FROM Object_Goods_Main
     WHERE Object_Goods_Main.IdSP = inIdSP
     Limit 1; -- на всякий случай
     
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (vbId, 0) = 0;

    -- сохранили <Элемент документа>
    vbId := lpInsertUpdate_MovementItem (COALESCE(vbId, 0), zc_MI_Master(), COALESCE(vbGoodsId, 0), vbMovementId, 0, NULL);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ColSP(), vbId, inColSP);

    -- сохранили <>
    IF inCountSPMin <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inCountSPMin, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSPMin(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- сохранили <>
    IF inCountSP <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inCountSP, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- сохранили <>
    IF inPriceOptSP <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inPriceOptSP, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceOptSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- сохранили <>
    IF inPriceRetSP <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inPriceRetSP, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceRetSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- сохранили <>
    IF inDailyCompensationSP <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inDailyCompensationSP, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DailyCompensationSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- сохранили <>
    IF inPriceSP <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inPriceSP, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- сохранили <>
    IF inPaymentSP <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inPaymentSP, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PaymentSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- сохранили <>
    IF inDenumeratorValue <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inDenumeratorValue, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DenumeratorValueSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Pack(), vbId, TRIM(inPack));
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
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Name(), vbId, TRIM(inName));

    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_IntenalSP(), vbId, vbIntenalSPId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BrandSP(), vbId, vbBrandSPId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_KindOutSP(), vbId, vbKindOutSPId);


    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);    
   
    -- !!!ВРЕМЕННО для ТЕСТА!!!
/*    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%> <%> <%>', vbMovementId, vbIsInsert, vbId, vbGoodsId, inSession;
    END IF;*/
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.11.22                                                       *
*/

-- тест
/* SELECT * FROM gpInsertUpdate_MI_GoodsSPHelsi_From_ExcelFull(
     inOperDate            := '01.12.2022',
     inColSP               := 760,    -- № з/п 

     inMedicalProgramSPId  := 'e9c6beeb-b19f-4b97-b42a-020c5c996c56',    -- Медицинская программа (A)

     inCountSPMin          := '1',    -- Мінімальна кількість форм випуску до продажу (AW)
     inCountSP             := '5',    -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект) (AX)

     inPriceSP             := '1740.2',    -- Референтна ціна за уп, грн (Соц. проект) (BJ)
     inPriceOptSP          := '1581.3',    -- Оптово-відпускна ціна за упаковку. грн (BG)
     inPriceRetSP          := '2047.3',    -- Роздрібна ціна за упаковку. грн (BH)
     inDailyCompensationSP := '69.608',    -- Розмір відшкодування добової дози лікарського засобу. грн (BI)
     inPaymentSP           := '307.1',    -- Сума доплати за упаковку. грн (BK)
     inDenumeratorValue    := '1',    -- Кількість сутності (AT)

     inReestrDateSP        := '2100-01-01'  ,    -- Дата закінчення строку дії реєстраційного посвідчення на лікарський засіб (BB)
     inPack                := '300'  ,    -- дозування (F)
     inIntenalSPName       := 'Інсулін Детемір'  ,    -- Міжнародна непатентована назва (Соц. проект) (D)
     inIntenalSPName_Lat   := 'Insulin detemir'  ,    -- Міжнародна непатентована назва (Соц. проект) (E)
     inBrandSPName         := 'ЛЕВЕМІР® ФЛЕКСПЕН®'  ,    -- Торговельна назва лікарського засобу (Соц. проект) (AV)
     inKindOutSPName       := 'SYRINGE_PEN'  ,    -- Форма випуску (Соц. проект) (I)

     inMakerSP             := 'А/Т Ново Нордіск'  ,    -- Найменування виробника, країна (AY)
     inCountry             := 'Данія'  ,    -- Найменування виробника, країна (AZ)
     inReestrSP            := 'UA/4858/01/01'  ,    -- Номер реєстраційного посвідчення на лікарський засіб (BA) 
     inIdSP                := 'dd2681b8-4476-4c14-886a-14fe0aecd736'  ,    -- ID лікар. засобу (AQ)
    
     inProgramId           := 'f4528123-ce19-4a6a-abbe-7ccc13914136'  ,    -- ID учасника програми (BF)
     inNumeratorUnit       := 'IU'  ,    -- Одиниця виміру сили дії (AH)
     inDenumeratorUnit     := 'SYRINGE_PEN'  ,    -- Одиниця виміру сутності (AU)
    
     inName                := 'ЛЕВЕМІР® ФЛЕКСПЕН® картридж вмонтований в одноразову шприц-ручку 3 мл, 100 МО/мл, тривалої дії'  ,    -- Название (AF)
     
     inEndDate             := '' , -- Дата окончания


     inSession := '3');*/
     
     
select * from gpInsertUpdate_MI_GoodsSPHelsi_From_ExcelFull(inOperDate := ('01.08.2023')::TDateTime , inColSP := 7500 , inMedicalProgramSPId := '1318eabc-1a1a-42f6-8450-61e11c19eede' , inCountSPMin := '100' , inCountSP := '100' , inPriceSP := '0.0' , inPriceOptSP := '0' , inPriceRetSP := '' , inDailyCompensationSP := '' , inPaymentSP := '' , inDenumeratorValue := '1.0' , inReestrDateSP := '2024-02-05' , inPack := '70.0' , inIntenalSPName := 'етанол' , inIntenalSPName_Lat := 'Ethanol' , inBrandSPName := 'СПИРТ ЕТИЛОВИЙ 70 %' , inKindOutSPName := 'SOLUTION' , inMakerSP := '"АТ \"Лубнифарм\""' , inCountry := 'UA' , inReestrSP := 'UA/17228/01/01' , inIdSP := 'df125d7e-35e5-4c6a-9c99-45fe1efc1163' , inProgramId := '525df984-65be-4ae7-a18d-d662642a8acb' , inNumeratorUnit := 'PERCENT' , inDenumeratorUnit := 'FLACON' , inName := 'етанол 70 відсоток/мл, розчин' , inEndDate := '' ,  inSession := '3');