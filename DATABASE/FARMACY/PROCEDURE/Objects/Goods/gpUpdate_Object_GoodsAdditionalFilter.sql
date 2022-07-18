-- Function: gpUpdate_Object_GoodsAdditionalFilter()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsAdditionalFilter(Integer, TVarChar, Boolean, Integer, Boolean, Integer, Boolean, Integer, Boolean, Boolean, Boolean, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsAdditionalFilter(
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
    IN inSession             TVarChar     -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE text_var1 text;
BEGIN

   vbUserId := inSession;

   IF COALESCE(inId, 0) = 0
   THEN
      RETURN;
   END IF;

   SELECT CASE WHEN inis_MakerName = TRUE        THEN inMakerName        ELSE COALESCE(Object_Goods_Main.MakerName, '') END
        , CASE WHEN inis_MakerNameUkr = TRUE     THEN inMakerNameUkr     ELSE COALESCE(Object_Goods_Main.MakerNameUkr, '') END
        , CASE WHEN inis_FormDispensingId = TRUE THEN inFormDispensingId ELSE COALESCE(Object_Goods_Main.FormDispensingId, 0) END
        , CASE WHEN inis_NumberPlates = TRUE     THEN inNumberPlates     ELSE COALESCE(Object_Goods_Main.NumberPlates, 0) END
        , CASE WHEN inis_QtyPackage = TRUE       THEN inQtyPackage       ELSE COALESCE(Object_Goods_Main.QtyPackage, 0) END
        , CASE WHEN inis_IsRecipe = TRUE         THEN inIsRecipe         ELSE COALESCE(Object_Goods_Main.IsRecipe, False) END
   INTO inMakerName
      , inMakerNameUkr
      , inFormDispensingId
      , inNumberPlates
      , inQtyPackage
      , inIsRecipe
   FROM Object_Goods_Main
   WHERE Object_Goods_Main.Id = inId;


   IF EXISTS(SELECT * 
             FROM Object_Goods_Main
             WHERE Object_Goods_Main.Id                                = inId
               AND COALESCE(Object_Goods_Main.MakerName, '')           = COALESCE(inMakerName, '')  
               AND COALESCE(Object_Goods_Main.MakerNameUkr, '')        = COALESCE(inMakerNameUkr, '')  
               AND COALESCE(Object_Goods_Main.FormDispensingId, 0)     = COALESCE(inFormDispensingId, 0)  
               AND COALESCE(Object_Goods_Main.NumberPlates, 0)         = COALESCE(inNumberPlates, 0)  
               AND COALESCE(Object_Goods_Main.QtyPackage, 0)           = COALESCE(inQtyPackage, 0)  
               AND COALESCE(Object_Goods_Main.IsRecipe, False)         = COALESCE(inIsRecipe, FALSE)) 
   THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   -- сохранили свойство <Производитель>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Maker(), inId, inMakerName);
   -- сохранили свойство <Производитель>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_MakerUkr(), inId, inMakerNameUkr);

   -- сохранили свойство <Форма отпуска>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_FormDispensing(), inId, inFormDispensingId);

   -- сохранили свойство <Кол-во пластин в упаковке>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_NumberPlates(), inId, inNumberPlates);
   -- сохранили свойство <Кол-во в упаковке>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_QtyPackage(), inId, inQtyPackage);
   
   -- сохранили свойство <Рецептура>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Recipe(), inId, inIsRecipe);

    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET MakerName          = NULLIF(inMakerName, '')  
                                , MakerNameUkr       = NULLIF(inMakerNameUkr, '')  
                                , FormDispensingId   = NULLIF(inFormDispensingId, 0)  
                                , NumberPlates       = NULLIF(inNumberPlates, 0)    
                                , QtyPackage         = NULLIF(inQtyPackage, 0)    
                                , IsRecipe           = COALESCE(inIsRecipe, FALSE)  
     WHERE Object_Goods_Main.Id = inId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Object_GoodsAdditional', text_var1::TVarChar, vbUserId);
   END;
   
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

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

-- select * from gpUpdate_Object_GoodsAdditionalFilter(inId := 24168 , inMakerName := '' , inis_MakerName := 'False' , inFormDispensingId := 18067782 , inis_FormDispensing := 'True' , inNumberPlates := 0 , inis_NumberPlates := 'False' , inQtyPackage := 0 , inis_QtyPackage := 'False' , inIsRecipe := 'False' , inis_IsRecipe := 'False' ,  inSession := '3');