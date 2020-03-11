-- Function: gpSelect_Object_GoodsByGoodsKind_VMC(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind_lineVMC (Integer,Integer,Integer,Integer,Integer,Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind_lineVMC (Integer,Integer,Integer,Integer,Integer,Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind_lineVMC(
    IN inRetail1Id       Integer,
    IN inRetail2Id       Integer,
    IN inRetail3Id       Integer,
    IN inRetail4Id       Integer,
    IN inRetail5Id       Integer,
    IN inRetail6Id       Integer,
    IN inisShowAll       Boolean,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, Code Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsGroupAnalystName TVarChar
             , TradeMarkName TVarChar
             , GoodsTagName TVarChar
             , GoodsPlatformName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , Weight TFloat
             , WeightPackage TFloat, WeightPackageSticker TFloat
             , WeightTotal TFloat, ChangePercentAmount TFloat
             , WeightMin TFloat, WeightMax TFloat, WeightAvg TFloat
             , Height TFloat, Length TFloat, Width TFloat
             , NormInDays TFloat
             , isOrder Boolean, isScaleCeh Boolean, isNotMobile Boolean
             , GoodsSubId Integer, GoodsSubCode Integer, GoodsSubName TVarChar, MeasureSubName TVarChar
             , GoodsKindSubId Integer, GoodsKindSubName TVarChar
             , GoodsPackId Integer, GoodsPackCode Integer, GoodsPackName TVarChar, MeasurePackName TVarChar
             , GoodsKindPackId Integer, GoodsKindPackName TVarChar
             , ReceiptId Integer, ReceiptCode TVarChar, ReceiptName TVarChar
             , GoodsCode_basis Integer, GoodsName_basis TVarChar
             , GoodsCode_main Integer, GoodsName_main TVarChar
             , GoodsBrandName TVarChar
             , isCheck_basis Boolean, isCheck_main Boolean
             , GoodsTypeKindId Integer, GoodsTypeKindName TVarChar
             , CodeCalc TVarChar      -- Код ВМС

             , isCodeCalc_Diff Boolean   -- Повтор кода ВМС

             , WmsCellNum        Integer     -- № Ячейки на складе ВМС
             , WmsCode           Integer     -- новый Код ВМС*

             --
             , GoodsPropertyBoxId Integer
             , BoxId Integer, BoxCode Integer, BoxName TVarChar -- Ящик (E2/E3)
             , WeightOnBox TFloat                               -- Кол-во кг. в ящ. (E2/E3)
             , CountOnBox TFloat                                -- Кол-во ед. в ящ. (E2/E3)
             , BoxVolume TFloat
             , BoxWeight TFloat
             , BoxHeight TFloat
             , BoxLength TFloat
             , BoxWidth TFloat
             , WeightGross TFloat                               -- Вес брутто полного ящика "по ???" (E2/E3)
             , WeightAvgGross TFloat                            -- Вес брутто полного ящика "по среднему весу" (E2/E3)
             , WeightAvgNet TFloat                              -- Вес нетто полного ящика "по среднему весу" (E2/E3)
             , BoxId_2 Integer, BoxCode_2 Integer, BoxName_2 TVarChar
             , WeightOnBox_2 TFloat, CountOnBox_2 TFloat
             , BoxVolume_2 TFloat, BoxWeight_2 TFloat
             , BoxHeight_2 TFloat, BoxLength_2 TFloat, BoxWidth_2 TFloat
             , WeightGross_2 TFloat                             -- Вес брутто полного ящика "по ???" (Гофра)
             , WeightAvgGross_2 TFloat                          -- Вес брутто полного ящика "по среднему весу" (Гофра)
             , WeightAvgNet_2 TFloat                            -- Вес нетто полного ящика "по среднему весу" (Гофра)

             , BoxId_Retail1 Integer, BoxName_Retail1 TVarChar  -- ящик для Сети 1
             , BoxId_Retail2 Integer, BoxName_Retail2 TVarChar  -- ящик для Сети 2
             , BoxId_Retail3 Integer, BoxName_Retail3 TVarChar  -- ящик для Сети 3
             , BoxId_Retail4 Integer, BoxName_Retail4 TVarChar  -- ящик для Сети 4
             , BoxId_Retail5 Integer, BoxName_Retail5 TVarChar  -- ящик для Сети 5
             , BoxId_Retail6 Integer, BoxName_Retail6 TVarChar  -- ящик для Сети 6
             , WeightOnBox_Retail1 TFloat                       -- количество кг. в ящ. для Сети 1
             , WeightOnBox_Retail2 TFloat                       -- количество кг. в ящ. для Сети 2
             , WeightOnBox_Retail3 TFloat                       -- количество кг. в ящ. для Сети 3
             , WeightOnBox_Retail4 TFloat                       -- количество кг. в ящ. для Сети 4
             , WeightOnBox_Retail5 TFloat                       -- количество кг. в ящ. для Сети 5
             , WeightOnBox_Retail6 TFloat                       -- количество кг. в ящ. для Сети 6
             , CountOnBox_Retail1 TFloat                        -- количество ед. в ящ. для Сети 1
             , CountOnBox_Retail2 TFloat                        -- количество ед. в ящ. для Сети 2
             , CountOnBox_Retail3 TFloat                        -- количество ед. в ящ. для Сети 3
             , CountOnBox_Retail4 TFloat                        -- количество ед. в ящ. для Сети 4
             , CountOnBox_Retail5 TFloat                        -- количество ед. в ящ. для Сети 5
             , CountOnBox_Retail6 TFloat                        -- количество ед. в ящ. для Сети 6

             , WmsNameCalc TVarChar
             , sku_code    Integer
              )
AS
$BODY$
   DECLARE vbName_Sh  TVarChar;
   DECLARE vbName_Nom TVarChar;
   DECLARE vbName_Ves TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());

     -- Штучный
     vbName_Sh := (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_Enum_GoodsTypeKind_Sh());
     -- Номинальный
     vbName_Nom:= (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_Enum_GoodsTypeKind_Nom());
     -- Весовой
     vbName_Ves:= (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_Enum_GoodsTypeKind_Ves());


     RETURN QUERY
     WITH
     tmpGoodsByGoodsKind AS (SELECT *
                                  , zfCalc_Text_replace (zfCalc_Text_replace (tmp.GoodsName, CHR(39), '`'), '"', '`') AS GoodsName_repl
                             FROM gpSelect_Object_GoodsByGoodsKind_VMC (inRetail1Id, inRetail2Id , inRetail3Id, inRetail4Id, inRetail5Id, inRetail6Id, inSession) AS tmp
                            )
 
--WmsNameCalc = tmpGoods.name + WmsCodeCalc
     , tmpGoodsByGoodsKind_line AS (-- Штучный
                                  SELECT *
                                       , (tmp.GoodsName_repl || ' ' || tmp.GoodsKindName || ' ' || vbName_Sh) :: TVarChar AS WmsNameCalc
                                       , tmp.WmsCodeCalc_Sh   ::Integer   AS sku_code
                                       , tmp.CodeCalc_Sh                  AS CodeCalc
                                       , zc_Enum_GoodsTypeKind_Sh()       AS GoodsTypeKindId
                                  FROM tmpGoodsByGoodsKind AS tmp
                                  WHERE tmp.isGoodsTypeKind_Sh  = TRUE
                                 UNION ALL
                                  -- Номинальный
                                  SELECT *
                                       , (tmp.GoodsName_repl || ' ' || tmp.GoodsKindName || ' ' || vbName_Nom) :: TVarChar AS WmsNameCalc
                                       , tmp.WmsCodeCalc_Nom  ::Integer   AS sku_code
                                       , tmp.CodeCalc_Nom                 AS CodeCalc
                                       , zc_Enum_GoodsTypeKind_Nom()      AS GoodsTypeKindId
                                  FROM tmpGoodsByGoodsKind AS tmp
                                  WHERE tmp.isGoodsTypeKind_Nom  = TRUE
                                 UNION ALL
                                  -- Весовой
                                  SELECT *
                                       , (tmp.GoodsName_repl || ' ' || tmp.GoodsKindName || ' ' || vbName_Ves) :: TVarChar AS WmsNameCalc
                                       , tmp.WmsCodeCalc_Ves  ::Integer   AS sku_code
                                       , tmp.CodeCalc_Ves                 AS CodeCalc
                                       , zc_Enum_GoodsTypeKind_Ves()      AS GoodsTypeKindId
                                  FROM tmpGoodsByGoodsKind AS tmp
                                  WHERE tmp.isGoodsTypeKind_Ves  = TRUE
                                 UNION ALL
                                  -- остальные товары (для показать все)
                                  SELECT *
                                       , '' :: TVarChar AS WmsNameCalc
                                       , 0  :: Integer  AS sku_code
                                       , '' :: TVarChar AS CodeCalc
                                       , 0              AS GoodsTypeKindId
                                  FROM tmpGoodsByGoodsKind
                                  WHERE (tmpGoodsByGoodsKind.isGoodsTypeKind_Sh <> TRUE
                                    AND tmpGoodsByGoodsKind.isGoodsTypeKind_Ves <> TRUE
                                    AND tmpGoodsByGoodsKind.isGoodsTypeKind_Nom <> TRUE)
                                    AND inisShowAll = TRUE
                                 )

       -- Результат
       SELECT
             tmpGoodsByGoodsKind.Id
           , tmpGoodsByGoodsKind.GoodsId
           , tmpGoodsByGoodsKind.Code
           , tmpGoodsByGoodsKind.GoodsName
           , tmpGoodsByGoodsKind.GoodsKindId
           , tmpGoodsByGoodsKind.GoodsKindCode
           , tmpGoodsByGoodsKind.GoodsKindName

           , tmpGoodsByGoodsKind.GoodsGroupId
           , tmpGoodsByGoodsKind.GoodsGroupName
           , tmpGoodsByGoodsKind.GoodsGroupNameFull

           , tmpGoodsByGoodsKind.GoodsGroupAnalystName
           , tmpGoodsByGoodsKind.TradeMarkName
           , tmpGoodsByGoodsKind.GoodsTagName
           , tmpGoodsByGoodsKind.GoodsPlatformName

           , tmpGoodsByGoodsKind.InfoMoneyCode
           , tmpGoodsByGoodsKind.InfoMoneyGroupName
           , tmpGoodsByGoodsKind.InfoMoneyDestinationName
           , tmpGoodsByGoodsKind.InfoMoneyName

           , tmpGoodsByGoodsKind.MeasureId
           , tmpGoodsByGoodsKind.MeasureName

           , tmpGoodsByGoodsKind.Weight

           , tmpGoodsByGoodsKind.WeightPackage
           , tmpGoodsByGoodsKind.WeightPackageSticker
           , tmpGoodsByGoodsKind.WeightTotal
           , tmpGoodsByGoodsKind.ChangePercentAmount

           , tmpGoodsByGoodsKind.WeightMin
           , tmpGoodsByGoodsKind.WeightMax
           , tmpGoodsByGoodsKind.WeightAvg
           , tmpGoodsByGoodsKind.Height
           , tmpGoodsByGoodsKind.Length
           , tmpGoodsByGoodsKind.Width
           , tmpGoodsByGoodsKind.NormInDays

           , tmpGoodsByGoodsKind.isOrder
           , tmpGoodsByGoodsKind.isScaleCeh
           , tmpGoodsByGoodsKind.isNotMobile

           , tmpGoodsByGoodsKind.GoodsSubId
           , tmpGoodsByGoodsKind.GoodsSubCode
           , tmpGoodsByGoodsKind.GoodsSubName
           , tmpGoodsByGoodsKind.MeasureSubName
           , tmpGoodsByGoodsKind.GoodsKindSubId
           , tmpGoodsByGoodsKind.GoodsKindSubName

           , tmpGoodsByGoodsKind.GoodsPackId
           , tmpGoodsByGoodsKind.GoodsPackCode
           , tmpGoodsByGoodsKind.GoodsPackName
           , tmpGoodsByGoodsKind.MeasurePackName
           , tmpGoodsByGoodsKind.GoodsKindPackId
           , tmpGoodsByGoodsKind.GoodsKindPackName

           , tmpGoodsByGoodsKind.ReceiptId
           , tmpGoodsByGoodsKind.ReceiptCode
           , tmpGoodsByGoodsKind.ReceiptName

           , tmpGoodsByGoodsKind.GoodsCode_basis
           , tmpGoodsByGoodsKind.GoodsName_basis
           , tmpGoodsByGoodsKind.GoodsCode_main
           , tmpGoodsByGoodsKind.GoodsName_main
           , tmpGoodsByGoodsKind.GoodsBrandName

           , tmpGoodsByGoodsKind.isCheck_basis
           , tmpGoodsByGoodsKind.isCheck_main

           , tmpGoodsByGoodsKind.GoodsTypeKindId
           , Object_GoodsTypeKind.ValueData AS GoodsTypeKindName

           , tmpGoodsByGoodsKind.CodeCalc                           -- расчет: код на упак+вид+бренд+категория
/*           , tmpGoodsByGoodsKind.CodeCalc_Sh  :: TVarChar           -- шт. - расчет: код на упак+вид+бренд+категория
           , tmpGoodsByGoodsKind.CodeCalc_Nom  :: TVarChar          -- номинал - расчет: код на упак+вид+бренд+категория
           , tmpGoodsByGoodsKind.CodeCalc_Ves  :: TVarChar          -- неноминал - расчет: код на упак+вид+бренд+категория
*/
             -- Повтор кода ВМС - расчет: код на упак+вид+бренд+категория
           , tmpGoodsByGoodsKind.isCodeCalc_Diff                                         -- Повтор кода ВМС

           , tmpGoodsByGoodsKind.WmsCellNum       :: Integer        -- 
           , tmpGoodsByGoodsKind.WmsCode          :: Integer        -- Код ВМС* для выгрузки
 /*          , tmpGoodsByGoodsKind.WmsCodeCalc_Sh   :: TVarChar       -- шт. - Код ВМС* для выгрузки
           , tmpGoodsByGoodsKind.WmsCodeCalc_Nom  :: TVarChar       -- номинал - Код ВМС* для выгрузки
           , tmpGoodsByGoodsKind.WmsCodeCalc_Ves  :: TVarChar       -- неноминал - Код ВМС* для выгрузки
*/
            -- ящик (E2/E3)
            , tmpGoodsByGoodsKind.GoodsPropertyBoxId
            , tmpGoodsByGoodsKind.BoxId
            , tmpGoodsByGoodsKind.BoxCode
            , tmpGoodsByGoodsKind.BoxName

              -- Кол-во кг. в ящ. (E2/E3) - тоже что и WeightAvgNet
            , tmpGoodsByGoodsKind.WeightOnBox
              -- Кол-во ед. в ящ. (E2/E3)
            , tmpGoodsByGoodsKind.CountOnBox

            , tmpGoodsByGoodsKind.BoxVolume
            , tmpGoodsByGoodsKind.BoxWeight
            , tmpGoodsByGoodsKind.BoxHeight
            , tmpGoodsByGoodsKind.BoxLength
            , tmpGoodsByGoodsKind.BoxWidth

              -- Вес брутто полного ящика "??? по среднему весу" (E2/E3)
            , tmpGoodsByGoodsKind.WeightGross

             -- Вес брутто полного ящика "по среднему весу" (E2/E3)
            , tmpGoodsByGoodsKind.WeightAvgGross

              -- Вес нетто по среднему весу ящика (E2/E3) - тоже что и WeightOnBox
            , tmpGoodsByGoodsKind.WeightAvgNet

            -- ящик (Гофра)
            , tmpGoodsByGoodsKind.BoxId_2
            , tmpGoodsByGoodsKind.BoxCode_2
            , tmpGoodsByGoodsKind.BoxName_2

              -- Кол-во кг. в ящ. (Гофра)
            , tmpGoodsByGoodsKind.WeightOnBox_2
              -- Кол-во ед. в ящ. (Гофра)
            , tmpGoodsByGoodsKind.CountOnBox_2

            , tmpGoodsByGoodsKind.BoxVolume_2
            , tmpGoodsByGoodsKind.BoxWeight_2
            , tmpGoodsByGoodsKind.BoxHeight_2
            , tmpGoodsByGoodsKind.BoxLength_2
            , tmpGoodsByGoodsKind.BoxWidth_2

              -- Вес брутто полного ящика "по ???" (Гофра)
            , tmpGoodsByGoodsKind.WeightGross_2

             -- Вес брутто полного ящика "по среднему весу" (Гофра)
            , tmpGoodsByGoodsKind.WeightAvgGross_2

              -- Вес нетто полного ящика "по среднему весу" (Гофра)
            , tmpGoodsByGoodsKind.WeightAvgNet_2

              -- ящики торговые сети 1-6
            , tmpGoodsByGoodsKind.BoxId_Retail1, tmpGoodsByGoodsKind.BoxName_Retail1
            , tmpGoodsByGoodsKind.BoxId_Retail2, tmpGoodsByGoodsKind.BoxName_Retail2
            , tmpGoodsByGoodsKind.BoxId_Retail3, tmpGoodsByGoodsKind.BoxName_Retail3
            , tmpGoodsByGoodsKind.BoxId_Retail4, tmpGoodsByGoodsKind.BoxName_Retail4
            , tmpGoodsByGoodsKind.BoxId_Retail5, tmpGoodsByGoodsKind.BoxName_Retail5
            , tmpGoodsByGoodsKind.BoxId_Retail6, tmpGoodsByGoodsKind.BoxName_Retail6
            -- количество кг. в ящ. для сетей 1-6
            , tmpGoodsByGoodsKind.WeightOnBox_Retail1
            , tmpGoodsByGoodsKind.WeightOnBox_Retail2
            , tmpGoodsByGoodsKind.WeightOnBox_Retail3
            , tmpGoodsByGoodsKind.WeightOnBox_Retail4
            , tmpGoodsByGoodsKind.WeightOnBox_Retail5
            , tmpGoodsByGoodsKind.WeightOnBox_Retail6
            -- количество кг. в ед. для сетей 1-6
            , tmpGoodsByGoodsKind.CountOnBox_Retail1
            , tmpGoodsByGoodsKind.CountOnBox_Retail2
            , tmpGoodsByGoodsKind.CountOnBox_Retail3
            , tmpGoodsByGoodsKind.CountOnBox_Retail4
            , tmpGoodsByGoodsKind.CountOnBox_Retail5
            , tmpGoodsByGoodsKind.CountOnBox_Retail6

            , tmpGoodsByGoodsKind.WmsNameCalc :: TVarChar
            , tmpGoodsByGoodsKind.sku_code    :: Integer

       FROM tmpGoodsByGoodsKind_line AS tmpGoodsByGoodsKind
            LEFT JOIN Object AS Object_GoodsTypeKind ON Object_GoodsTypeKind.Id = tmpGoodsByGoodsKind.GoodsTypeKindId  
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.03.20        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind_lineVMC (0,0,0,0,0,0,FALSE,zfCalc_UserAdmin())--  limit 10  where sku_code = 1852
