-- Function: gpGet_Object_GoodsBarCode

DROP FUNCTION IF EXISTS gpGet_Object_GoodsBarCode (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsBarCode (
    IN inId      Integer,
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
  
      IF COALESCE (inId, 0) = 0
      THEN
           -- Результат
           RETURN QUERY
             SELECT 0::Integer   AS Id
                  , 0::Integer   AS GoodsId
                  , 0::Integer   AS GoodsMainId
                  , 0::Integer   AS GoodsBarCodeId
                  , 0::Integer   AS GoodsJuridicalId
                  , 0::Integer   AS JuridicalId
                  , 0::Integer   AS Code
                  , ''::TVarChar AS Name
                  , ''::TVarChar AS ProducerName
                  , ''::TVarChar AS GoodsCode
                  , ''::TVarChar AS BarCode
                  , ''::TVarChar AS JuridicalName
                  , ''::TVarChar AS ErrorText;
      ELSE
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
             WHERE LoadGoodsBarCode.Id = inId
               AND LoadGoodsBarCode.RetailId = vbObjectId;
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 08.06.2017                                                      *
*/

/*
SELECT * FROM gpGet_Object_GoodsBarCode (inId:= 0, inSession:= zfCalc_UserAdmin())
UNION
SELECT * FROM gpGet_Object_GoodsBarCode (inId:= 1, inSession:= zfCalc_UserAdmin());
*/
