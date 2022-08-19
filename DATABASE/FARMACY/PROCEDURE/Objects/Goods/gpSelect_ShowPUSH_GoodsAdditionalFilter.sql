-- Function: gpSelect_ShowPUSH_GoodsAdditionalFilter()

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_GoodsAdditionalFilter(Integer, TVarChar, Boolean, Integer, Boolean, Integer, Boolean, Integer, Boolean, Boolean, Boolean, 
                                                                TVarChar, Boolean, TVarChar, Boolean, TVarChar, Boolean, 
                                                                Integer, Boolean, Integer, Boolean, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_GoodsAdditionalFilter(
    IN inId                  Integer ,    -- ключ объекта <Товар главный>
    IN inMakerName           TVarChar,    -- Производитель
    IN inis_MakerName        Boolean ,    -- 
    IN inFormDispensingId    Integer ,    -- Форма отпуска
    IN inis_FormDispensingId Boolean ,    -- 
    IN inNumberPlates        Integer ,    -- Кол-во пластин в упаковке:
    IN inis_NumberPlates     Boolean ,    -- 
    IN inQtyPackage          Integer ,    -- Кол-во в упаковке:
    IN inis_QtyPackage       Boolean ,    -- 
    IN inIsRecipe            Boolean ,    -- Рецептура
    IN inis_IsRecipe         Boolean ,    -- 
    IN inMakerNameUkr        TVarChar,    -- Производитель
    IN inis_MakerNameUkr     Boolean ,    -- 
    IN inDosage              TVarChar,    -- Дозировка
    IN inis_Dosage           Boolean ,    -- 
    IN inVolume              TVarChar,    -- Объем
    IN inis_Volume           Boolean ,    -- 
    IN inGoodsWhoCanId       Integer ,    -- Кому можно
    IN inis_GoodsWhoCan      Boolean ,    -- 
    IN inGoodsMethodApplId   Integer ,    -- Способ применения
    IN inis_GoodsMethodAppl  Boolean ,    -- 
    IN inGoodsSignOriginId   Integer ,    -- Признак происхождения
    IN inis_GoodsSignOrigin  Boolean ,    -- 

   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения

    IN inSession             TVarChar     -- текущий пользователь
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbText      Text;
BEGIN

   vbUserId := inSession;

   outShowMessage := False;
   vbText := '';
   
   IF COALESCE (inMakerName, '') = '' AND inis_MakerName = TRUE
   THEN
     vbText := Chr(13)||'Производителя';
   END IF;

   IF COALESCE (inMakerNameUkr, '') = '' AND inis_MakerNameUkr = TRUE
   THEN
     vbText := Chr(13)||'Производителя Укр. название';
   END IF;

   IF COALESCE (vbText, '') <> ''
   THEN
     outShowMessage := True;
     outPUSHType := zc_TypePUSH_Confirmation();
     outText := 'Вы уверенны, что нужно обнулить:'||Chr(13)||vbText||Chr(13)||Chr(13)||'Обновить данные?';
   END IF;
    
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.09.21                                                       *  

*/

-- тест
--

-- 

select * from gpSelect_ShowPUSH_GoodsAdditionalFilter(inId := 0 , inMakerName := '' , inis_MakerName := 'False' , inFormDispensingId := 0 , inis_FormDispensing := 'False' , inNumberPlates := 0 , inis_NumberPlates := 'False' , inQtyPackage := 0 , inis_QtyPackage := 'False' , inIsRecipe := 'False' , inis_IsRecipe := 'False' , inMakerNameUkr := '' , inis_MakerNameUkr := 'True' , inDosage := '' , inis_Dosage := 'False' , inVolume := '' , inis_Volume := 'False' , inGoodsWhoCanId := 0 , inis_GoodsWhoCan := 'False' , inGoodsMethodApplId := 0 , inis_GoodsMethodAppl := 'False' , inGoodsSignOriginId := 0 , inis_GoodsSignOrigin := 'False' ,  inSession := '3');
