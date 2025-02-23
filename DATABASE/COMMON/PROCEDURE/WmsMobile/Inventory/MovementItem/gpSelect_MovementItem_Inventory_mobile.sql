-- Function: gpSelect_MovementItem_Inventory_mobile()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory_mobile (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Inventory_mobile(
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementItemId    Integer
              -- Товар
             , GoodsId           Integer
             , GoodsCode         Integer
             , GoodsName         TVarChar
              -- Вид
             , GoodsKindId       Integer
             , GoodsKindName     TVarChar
               -- Вес нетто
             , Amount            TFloat
               -- Ячейка хранения
             , PartionCellId     Integer
             , PartionCellName   TVarChar
               -- партия
             , PartionGoodsDate  TDateTime
               -- № паспорта
             , PartionNum        Integer
               -- Поддон
             , BoxId_1           Integer
             , BoxName_1         TVarChar
             , CountTare_1       Integer
             , WeightTare_1      TFloat
               -- Ящик
             , BoxId_2           Integer
             , BoxName_2         TVarChar
             , CountTare_2       Integer
             , WeightTare_2      TFloat
               -- Ящик
             , BoxId_3           Integer
             , BoxName_3         TVarChar
             , CountTare_3       Integer
             , WeightTare_3      TFloat
               -- Ящик
             , BoxId_4           Integer
             , BoxName_4         TVarChar
             , CountTare_4       Integer
             , WeightTare_4      TFloat
               -- Ящик
             , BoxId_5           Integer
             , BoxName_5         TVarChar
             , CountTare_5       Integer
             , WeightTare_5      TFloat

               -- ИТОГО Кол-во Ящиков
             , CountTare_calc    Integer

               -- ИТОГО Вес всех Ящиков
             , WeightTare_calc   TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
        SELECT
               gpGet.MovementItemId
             , gpGet.GoodsId
             , gpGet.GoodsCode
             , gpGet.GoodsName
             , gpGet.GoodsKindId
             , gpGet.GoodsKindName
               -- Вес нетто
             , gpGet.Amount
               -- Ячейка хранения
             , gpGet.PartionCellId
             , gpGet.PartionCellName
               -- партия
             , gpGet.PartionGoodsDate
               -- № паспорта
             , gpGet.PartionNum
               -- Поддон
             , gpGet.BoxId_1
             , gpGet.BoxName_1
             , gpGet.CountTare_1
             , gpGet.WeightTare_1

               -- Ящик
             , gpGet.BoxId_1
             , gpGet.BoxName_2
             , gpGet.CountTare_2
             , gpGet.WeightTare_2

               -- Ящик
             , gpGet.BoxId_3
             , gpGet.BoxName_3
             , gpGet.CountTare_3
             , gpGet.WeightTare_3

               -- Ящик
             , gpGet.BoxId_4
             , gpGet.BoxName_4
             , gpGet.CountTare_4
             , gpGet.WeightTare_4

               -- Ящик
             , gpGet.BoxId_5
             , gpGet.BoxName_5
             , gpGet.CountTare_5
             , gpGet.WeightTare_5

               -- ИТОГО Кол-во Ящиков
             , gpGet.CountTare_calc

               -- ИТОГО Вес всех Ящиков
             , gpGet.WeightTare_calc

        FROM gpGet_MovementItem_Inventory_mobile ('2033173234093', zfCalc_UserAdmin()) AS gpGet
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.02.25                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Inventory_mobile (zfCalc_UserAdmin())
