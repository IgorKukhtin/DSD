-- Function: gpInsertUpdate_MI_GoodsSPInform_1303_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsSPInform_1303_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_GoodsSPInform_1303_From_Excel(
    IN inMovementId               Integer   ,    -- Идентификатор документа

    IN inIntenalSP_1303Name       TVarChar  ,    -- Міжнародна непатентована або загальноприйнята назва лікарського засобу (1)
    IN inKindOutSP_1303Name       TVarChar  ,    -- Форма випуску (3)
    IN inDosage_1303Name          TVarChar  ,    -- Дозування (Соц. проект)(4)

    IN inPriceMargSP              TFloat    ,    -- Гранична оптово-відпускна ціна в перерахунку на одиницю лікарської форми (грн.)(Соц. проект)
    IN inReferral                 TVarChar  ,    -- Реферування

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
   DECLARE vbKindOutSP_1303Id Integer;
   DECLARE vbDosage_1303Id Integer;
   
   DECLARE vbPriceOptSP TFloat;

   DECLARE vbCount Integer;
   DECLARE text_var1 text;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId:= lpGetUserBySession (inSession);
  
  
  IF TRIM(COALESCE(inIntenalSP_1303Id, '')) = ''
  THEN
    RETURN;
  END IF;

  BEGIN   
        
     -- пытаемся найти "Міжнародна непатентована назва (Соц. проект)(2)" 
     -- если не находим записывае новый элемент в справочник
     IF inIntenalSP_1303Id <> ''
     THEN
       vbIntenalSP_1303Id := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_IntenalSP_1303() AND UPPER (TRIM(Object.ValueData)) ILIKE UPPER (TRIM(inIntenalSP_1303Name)) LIMIT 1);
       IF COALESCE (vbIntenalSP_1303Id, 0) = 0 AND COALESCE (inIntenalSP_1303Name, '') <> '' THEN
          -- записываем новый элемент
          vbIntenalSP_1303Id := gpInsertUpdate_Object_IntenalSP_1303 (ioId     := 0
                                                                    , inCode   := lfGet_ObjectCode(0, zc_Object_IntenalSP_1303()) 
                                                                    , inName   := TRIM(inIntenalSP_1303Name)
                                                                    , inSession:= inSession
                                                                      );
       END IF;   
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

     -- ищем если уже создали
     SELECT MovementItem.Id, MovementItem.ObjectId, MIFloat_PriceOptSP.ValueData
     INTO vbId, vbGoodsId, vbPriceOptSP
     FROM MovementItem


          LEFT JOIN MovementItemLinkObject AS MI_IntenalSP_1303
                                           ON MI_IntenalSP_1303.MovementItemId = MovementItem.Id
                                          AND MI_IntenalSP_1303.DescId = zc_MILinkObject_IntenalSP_1303()
                                                    
          LEFT JOIN MovementItemLinkObject AS MI_Dosage_1303
                                           ON MI_Dosage_1303.MovementItemId = MovementItem.Id
                                          AND MI_Dosage_1303.DescId = zc_MILinkObject_Dosage_1303()

          LEFT JOIN MovementItemLinkObject AS MI_KindOutSP_1303
                                           ON MI_KindOutSP_1303.MovementItemId = MovementItem.Id
                                          AND MI_KindOutSP_1303.DescId = zc_MILinkObject_KindOutSP_1303()
                                          AND MI_KindOutSP_1303.ObjectId = vbKindOutSP_1303Id

          LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                      ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                     AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()

     WHERE MovementItem.MovementId = inMovementId
       AND (MI_IntenalSP_1303.ObjectId = vbIntenalSP_1303Id OR COALESCE(vbIntenalSP_1303Id, 0) = 0) 
       AND (MI_Dosage_1303.ObjectId = vbDosage_1303Id OR COALESCE(vbDosage_1303Id, 0) = 0)
       AND (MI_KindOutSP_1303.ObjectId = vbKindOutSP_1303Id OR COALESCE(vbKindOutSP_1303Id, 0) = 0)
     Limit 1 -- на всякий случай
     ;
                            
     IF EXISTS(SELECT MovementItem.ID FROM MovementItem WHERE MovementItem.ID = vbId AND MovementItem.isErased = True)
     THEN
       UPDATE MovementItem SET isErased = False  WHERE MovementItem.ID = vbId AND MovementItem.isErased = True;
     END IF;
              
    -- сохранить запись
    PERFORM lpInsertUpdate_MovementItem_GoodsSPInform_1303 (ioId                  := COALESCE(vbId, 0)
                                                          , inMovementId          := inMovementId
                                                          , inGoodsId             := COALESCE(vbGoodsId, 0)
                                                          , inCol                 := inCol
                                                          , inIntenalSP_1303Id    := vbIntenalSP_1303Id
                                                          , inKindOutSP_1303Id    := vbKindOutSP_1303Id
                                                          , inDosage_1303Id       := vbDosage_1303Id
                                                          
                                                          , inPriceMargSP         := COALESCE(inPriceMargSP, 0)
                                                          , inPriceOptSP          := COALESCE(vbPriceOptSP, 0)

                                                          , inReferral            := TRIM(inReferral)::TVarChar
                                                          , inUserId              := vbUserId);
                                                                                                                                                                                         
  EXCEPTION
     WHEN others THEN 
       GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
       --PERFORM lpAddObject_Goods_Temp_Error('gpInsertUpdate_MI_GoodsSPInform_1303_From_Excel', text_var1::TVarChar, vbUserId);
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
 01.04.23                                                       *
*/

-- тест

-- 