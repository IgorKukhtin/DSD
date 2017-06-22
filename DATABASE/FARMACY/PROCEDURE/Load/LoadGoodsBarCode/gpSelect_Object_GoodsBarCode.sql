-- Function: gpSelect_Object_GoodsBarCode

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsBarCode (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsBarCode (
    IN inSession TVarChar
)
RETURNS TABLE (Id               Integer
             , GoodsId          Integer
             , GoodsMainId      Integer
             , GoodsBarCodeId   Integer
             , GoodsJuridicalId Integer
             , JuridicalId      Integer
             , Code             Integer   -- Наш Код товара
             , Name             TVarChar  -- Название товара
             , ProducerName     TVarChar  -- Производитель
             , GoodsCode        TVarChar  -- Код товара поставщика
             , BarCode          TVarChar  -- Штрих-код
             , JuridicalName    TVarChar  -- Поставщик
             , ErrorText        TVarChar
              ) 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);
      -- определяется <Торговая сеть>
      vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

      -- Результат
      RETURN QUERY
        SELECT LoadGoodsBarCode.Id
             , LoadGoodsBarCode.GoodsId
             , LoadGoodsBarCode.GoodsMainId
             , LoadGoodsBarCode.GoodsBarCodeId
             , LoadGoodsBarCode.GoodsJuridicalId
             , LoadGoodsBarCode.JuridicalId
             , LoadGoodsBarCode.Code
             , LoadGoodsBarCode.Name
             , LoadGoodsBarCode.ProducerName
             , LoadGoodsBarCode.GoodsCode
             , LoadGoodsBarCode.BarCode
             , LoadGoodsBarCode.JuridicalName
             , LoadGoodsBarCode.ErrorText
        FROM LoadGoodsBarCode
        WHERE LoadGoodsBarCode.RetailId = vbObjectId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 08.06.2017                                                      *
*/

-- SELECT * FROM gpSelect_Object_GoodsBarCode (inSession:= zfCalc_UserAdmin());
