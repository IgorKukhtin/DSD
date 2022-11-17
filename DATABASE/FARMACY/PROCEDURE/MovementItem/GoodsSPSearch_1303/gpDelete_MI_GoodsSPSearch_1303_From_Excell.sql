-- Function: gpDelete_MI_GoodsSPSearch_1303_From_Excel()

DROP FUNCTION IF EXISTS gpDelete_MI_GoodsSPSearch_1303_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_MI_GoodsSPSearch_1303_From_Excel(
    IN inMovementId               Integer   ,    -- Идентификатор документа
    IN inIntenalSP_1303Name       TVarChar  ,    -- Міжнародна непатентована або загальноприйнята назва лікарського засобу (1)
    IN inBrandSPName              TVarChar  ,    -- Торговельна назва лікарського засобу (2)
    IN inKindOutSP_1303Name       TVarChar  ,    -- Форма випуску (3)
    IN inDosage_1303Name          TVarChar  ,    -- Дозування (Соц. проект)(4)
    IN inCountSP_1303Name         TVarChar  ,    -- Кількість одиниць лікарського засобу у споживчій упаковці (5)
    IN inMakerCountrySP_1303Name  TVarChar  ,    -- Найменування виробника, країна (6)
    IN inSession                  TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbGoodsId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId:= lpGetUserBySession (inSession);
  
  
  IF TRIM(COALESCE(inIntenalSP_1303Name, '')) = '' AND TRIM(COALESCE(inBrandSPName, '')) = ''
  THEN
    RETURN;
  END IF;

/*
поиск по таким колонкам: Міжнародна непатентована або загальноприйнята назва лікарського засобу
                         Торговельна назва лікарського засобу  
                         Форма випуску  
                         Дозування  
                         Кількість одиниць лікарського засобу у споживчій упаковці  
                         Найменування виробника, країна
                         */

     -- ищем если уже создали
     SELECT MovementItem.Id, MovementItem.ObjectId
     INTO vbId, vbGoodsId
     FROM MovementItem
          LEFT JOIN MovementItemLinkObject AS MI_IntenalSP_1303
                                           ON MI_IntenalSP_1303.MovementItemId = MovementItem.Id
                                          AND MI_IntenalSP_1303.DescId = zc_MILinkObject_IntenalSP_1303()
          LEFT JOIN Object AS Object_IntenalSP_1303 ON Object_IntenalSP_1303.Id = MI_IntenalSP_1303.ObjectId
 
          LEFT JOIN MovementItemLinkObject AS MI_BrandSP
                                           ON MI_BrandSP.MovementItemId = MovementItem.Id
                                          AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()                                                    
          LEFT JOIN Object AS Object_BrandSP_1303 ON Object_BrandSP_1303.Id = MI_BrandSP.ObjectId

          LEFT JOIN MovementItemLinkObject AS MI_Dosage_1303
                                           ON MI_Dosage_1303.MovementItemId = MovementItem.Id
                                          AND MI_Dosage_1303.DescId = zc_MILinkObject_Dosage_1303()
          LEFT JOIN Object AS Object_Dosage_1303 ON Object_Dosage_1303.Id = MI_Dosage_1303.ObjectId

          LEFT JOIN MovementItemLinkObject AS MI_KindOutSP_1303
                                           ON MI_KindOutSP_1303.MovementItemId = MovementItem.Id
                                          AND MI_KindOutSP_1303.DescId = zc_MILinkObject_KindOutSP_1303()

          LEFT JOIN Object AS Object_KindOutSP_1303 ON Object_KindOutSP_1303.Id = MI_KindOutSP_1303.ObjectId

          LEFT JOIN MovementItemLinkObject AS MI_CountSP_1303
                                           ON MI_CountSP_1303.MovementItemId = MovementItem.Id
                                          AND MI_CountSP_1303.DescId = zc_MILinkObject_CountSP_1303()
          LEFT JOIN Object AS Object_CountSP_1303 ON Object_CountSP_1303.Id = MI_CountSP_1303.ObjectId
          
          LEFT JOIN MovementItemLinkObject AS MI_MakerCountrySP_1303
                                           ON MI_MakerCountrySP_1303.MovementItemId = MovementItem.Id
                                          AND MI_MakerCountrySP_1303.DescId = zc_MILinkObject_MakerCountrySP_1303()
          LEFT JOIN Object AS Object_MakerCountrySP_1303 ON Object_MakerCountrySP_1303.Id = MI_MakerCountrySP_1303.ObjectId 

     WHERE MovementItem.MovementId = inMovementId
       AND zfCalc_Text_replace (COALESCE(Object_IntenalSP_1303.ValueData, ''), ' ','') = zfCalc_Text_replace(inIntenalSP_1303Name, ' ','') 
       AND zfCalc_Text_replace (COALESCE(Object_BrandSP_1303.ValueData, ''), ' ','')   = zfCalc_Text_replace(inBrandSPName, ' ','')
       AND zfCalc_Text_replace (COALESCE(Object_Dosage_1303.ValueData, ''), ' ','')    = zfCalc_Text_replace(inDosage_1303Name, ' ','')
       AND zfCalc_Text_replace (COALESCE(Object_KindOutSP_1303.ValueData, ''), ' ','') = zfCalc_Text_replace(inKindOutSP_1303Name, ' ','')
       AND zfCalc_Text_replace (COALESCE(Object_CountSP_1303.ValueData, ''), ' ','')   = zfCalc_Text_replace(inCountSP_1303Name, ' ','')
       AND zfCalc_Text_replace (COALESCE(Object_MakerCountrySP_1303.ValueData, ''), ' ','') = zfCalc_Text_replace(inMakerCountrySP_1303Name, ' ','')
     Limit 1 -- на всякий случай
     ;
      
      --усли нашли такую строку метим на удаление                      
     /*IF EXISTS (SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.Id = vbId AND MovementItem.isErased = FALSE)
     THEN 
       -- убираем свойство с товара
       --PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SP(), vbGoodsId, FALSE);
       --удаляем строку
       UPDATE MovementItem SET isErased = True WHERE MovementItem.Id = vbId AND MovementItem.isErased = FALSE;
     END IF;
     */
     RAISE EXCEPTION 'Удалить <%> <%>.', vbId, inIntenalSP_1303Name;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.11.22         *
*/

-- тест
--