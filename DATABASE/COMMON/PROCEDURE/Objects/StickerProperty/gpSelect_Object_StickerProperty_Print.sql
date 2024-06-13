-- Function: gpSelect_Object_Sticker_Print()

DROP FUNCTION IF EXISTS gpSelect_Object_StickerProperty_Print (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_StickerProperty_Print (Integer, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Object_StickerProperty_Print(Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Object_StickerProperty_Print (Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Object_StickerProperty_Print (Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_StickerProperty_Print (Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TVarChar);

-- DROP FUNCTION gpselect_object_stickerproperty_print(integer, integer, boolean, boolean, boolean, boolean, boolean, boolean, boolean, tdatetime, tdatetime, tdatetime, tdatetime, tfloat, tfloat, tvarchar);
-- DROP FUNCTION gpselect_object_stickerproperty_print(integer, boolean, boolean, boolean, boolean, boolean, boolean, tdatetime, tdatetime, tdatetime, tdatetime, tfloat, tfloat, tvarchar);
-- DROP FUNCTION gpselect_object_stickerproperty_print(integer, integer, boolean, boolean, boolean, boolean, boolean, boolean, boolean, tdatetime, tdatetime, tdatetime, tdatetime, tfloat, tfloat, tvarchar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StickerProperty_Print(
    IN inObjectId          Integer  , -- ключ Этикетки
    IN inRetailId          Integer  , -- ключ
    IN inIsJPG             Boolean  , --
    IN inIsLength          Boolean  , --
    IN inIs70_70           Boolean  , --

    IN inIsStartEnd        Boolean  , -- 1 - печатать дату нач/конечн произв-ва на этикетке
    IN inIsTare            Boolean  , -- 2 - печатать для ТАРЫ
    IN inIsPartion         Boolean  , -- 3 - печатать ПАРТИЮ для тары
    IN inIsGoodsName       Boolean  , -- печатать название тов. (для режим 2,3)

    IN inDateStart         TDateTime, -- нач. дата (для режим 1)
    IN inDateTare          TDateTime, -- дата для тары  (для режим 2)

    IN inDatePack          TDateTime, -- дата упаковки  (для режим 3)
    IN inDateProduction    TDateTime, -- дата произв-ва (для режим 3)
    IN inNumPack           TFloat   , -- № партии  упаковки, по умолчанию = 1 (для режим 3)
    IN inNumTech           TFloat   , -- № смены технологов, по умолчанию = 1 (для режим 3)

    IN inWeight            TFloat   , --

    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Comment TVarChar
             , StickerId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , MeasureId Integer, MeasureName TVarChar, zc_Measure_Sh Integer
             , StickerPackId Integer, StickerPackName TVarChar
             , StickerFileId Integer, StickerFileName TVarChar, TradeMarkName_StickerFile TVarChar
             , StickerSkinId Integer, StickerSkinName TVarChar
             , isFix Boolean
             , Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat, Value5 TFloat, Value6 TFloat, Value7 TFloat, Value8 TFloat, Value9 TFloat, Value10 TFloat, Value11 TFloat
             , BarCode TVarChar
             , Sticker_Value1 TFloat, Sticker_Value2 TFloat, Sticker_Value3 TFloat, Sticker_Value4 TFloat, Sticker_Value5 TFloat, Sticker_Value6 TFloat, Sticker_Value7 TFloat, Sticker_Value8 TFloat

             , Level1           TVarChar
             , Level2           TVarChar
             , StickerGroupName TVarChar
             , StickerTypeName  TVarChar
             , StickerTagName   TVarChar
             , StickerSortName  TVarChar
             , StickerNormName  TVarChar
               --
             , Info               Text
               --
             , StickerHeader_Info Text
               --
             , Info_add TVarChar

             , isJPG             Boolean
             , isStartEnd        Boolean
             , isTare            Boolean
             , isPartion         Boolean
             , isGoodsName       Boolean

             , DateStart         TDateTime
             , DateEnd           TDateTime
             -- вложенность
             , StickerProperty_Value11 TVarChar

             , DateTare          TDateTime
             , DatePack          TDateTime
             , DateProduction    TDateTime
             , NumPack           TFloat
             , NumTech           TFloat

             , BranchCode        Integer
              )
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbBranchCode    Integer;
    DECLARE vbStickerFileId Integer;
    DECLARE vbParam1        Integer;
    DECLARE vbParam2        Integer;
    DECLARE vbAddLeft1      Integer;
    DECLARE vbAddLeft2      Integer;
    DECLARE vbAddLine       Integer;

    DECLARE vbGoodsPropertyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- тест
     IF COALESCE (inRetailId, 0) = 0
     THEN
         inRetailId:= 0; -- 83955; -- Алан
     END IF;

     -- проверка
     -- IF inIsTare = TRUE AND inIsPartion = TRUE
     --   THEN
     --    RAISE EXCEPTION 'Ошибка.Переданы некорректные параметры печати.';
     --END IF;

     IF zc_Measure_Sh() = (SELECT ObjectLink_Goods_Measure.ChildObjectId
                           FROM Object AS Object_StickerProperty
                                -- индивидуальный - Свойства этикетки
                                LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile
                                                     ON ObjectLink_StickerProperty_StickerFile.ObjectId = Object_StickerProperty.Id
                                                    AND ObjectLink_StickerProperty_StickerFile.DescId   = zc_ObjectLink_StickerProperty_StickerFile()

                                LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                                     ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                                    AND ObjectLink_StickerProperty_Sticker.DescId   = zc_ObjectLink_StickerProperty_Sticker()
                                LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                                     ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                    AND ObjectLink_Sticker_Goods.DescId   = zc_ObjectLink_Sticker_Goods()
                                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                     ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_Sticker_Goods.ChildObjectId
                                                    AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                           WHERE Object_StickerProperty.Id = inObjectId
                          )
     THEN
         -- поиск
         vbGoodsPropertyId:= COALESCE ((SELECT MAX (OL_Juridical_GoodsProperty.ChildObjectId)
                                        FROM ObjectLink AS OL_Juridical_Retail
                                             INNER JOIN ObjectLink AS OL_Juridical_GoodsProperty
                                                                   ON OL_Juridical_GoodsProperty.ObjectId      = OL_Juridical_Retail.ObjectId
                                                                  AND OL_Juridical_GoodsProperty.DescId        = zc_ObjectLink_Juridical_GoodsProperty()
                                                                  AND OL_Juridical_GoodsProperty.ChildObjectId > 0
                                        WHERE OL_Juridical_Retail.ChildObjectId = inRetailId
                                          AND OL_Juridical_Retail.DescId        = zc_ObjectLink_Juridical_Retail()
                                       )
                                     , (SELECT OL_Retail_GoodsProperty.ChildObjectId
                                        FROM ObjectLink AS OL_Retail_GoodsProperty
                                        WHERE OL_Retail_GoodsProperty.ObjectId = inRetailId
                                          AND OL_Retail_GoodsProperty.DescId   = zc_ObjectLink_Retail_GoodsProperty()
                                       )
                                     , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)
                                      );

     ELSE
         vbGoodsPropertyId:= 0;
     END IF;


      /*IF vbUserId = 5
      THEN
          RAISE EXCEPTION 'Ошибка.%   %.', vbGoodsPropertyId, lfGet_Object_ValueData_sh (vbGoodsPropertyId);
      END IF;*/

     -- поиск
     vbBranchCode:= (WITH tmpMember AS (SELECT OL.ChildObjectId AS MemberId FROM ObjectLink AS OL WHERE OL.ObjectId = vbUserId AND OL.DescId = zc_ObjectLink_User_Member())
                     SELECT Object_Branch.ObjectCode
                     FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                          INNER JOIN tmpMember ON tmpMember.MemberId = lfSelect.MemberId
                          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = CASE WHEN lfSelect.BranchId > 0 THEN lfSelect.BranchId ELSE zc_Branch_Basis() END
                    );

     -- поиск ШАБЛОНА
     vbStickerFileId:= (WITH -- Шаблоны "по умолчанию" - для конкретной ТМ
                             tmpStickerFile AS (SELECT Object_StickerFile.Id                          AS StickerFileId
                                                     , ObjectLink_StickerFile_TradeMark.ChildObjectId AS TradeMarkId
                                                FROM Object AS Object_StickerFile
                                                     LEFT JOIN ObjectLink AS ObjectLink_StickerFile_Juridical
                                                                          ON ObjectLink_StickerFile_Juridical.ObjectId = Object_StickerFile.Id
                                                                         AND ObjectLink_StickerFile_Juridical.DescId   = zc_ObjectLink_StickerFile_Juridical()
                                                     INNER JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                                                           ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                                                          AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()

                                                     INNER JOIN ObjectBoolean AS ObjectBoolean_Default
                                                                              ON ObjectBoolean_Default.ObjectId  = Object_StickerFile.Id
                                                                             AND ObjectBoolean_Default.DescId    = zc_ObjectBoolean_StickerFile_Default()
                                                                             AND ObjectBoolean_Default.ValueData = TRUE

                                                WHERE Object_StickerFile.DescId   = zc_Object_StickerFile()
                                                  AND Object_StickerFile.isErased = FALSE
                                                  AND ObjectLink_StickerFile_Juridical.ChildObjectId IS NULL -- !!!обязательно БЕЗ Покупателя!!!
                                               )
                        -- Результат
                        SELECT Object_StickerFile.Id AS StickerFileId
                        FROM Object AS Object_StickerProperty
                             -- индивидуальный - Свойства этикетки
                             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile
                                                  ON ObjectLink_StickerProperty_StickerFile.ObjectId = Object_StickerProperty.Id
                                                 AND ObjectLink_StickerProperty_StickerFile.DescId   = zc_ObjectLink_StickerProperty_StickerFile()

                             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                                  ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                                 AND ObjectLink_StickerProperty_Sticker.DescId   = zc_ObjectLink_StickerProperty_Sticker()
                             -- индивидуальный - Этикетка
                             LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerFile
                                                  ON ObjectLink_Sticker_StickerFile.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                 AND ObjectLink_Sticker_StickerFile.DescId = zc_ObjectLink_Sticker_StickerFile()

                             LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                                  ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                 AND ObjectLink_Sticker_Goods.DescId   = zc_ObjectLink_Sticker_Goods()
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                  ON ObjectLink_Goods_TradeMark.ObjectId = ObjectLink_Sticker_Goods.ChildObjectId
                                                 AND ObjectLink_Goods_TradeMark.DescId   = zc_ObjectLink_Goods_TradeMark()
                             -- "по умолчанию" - для конкретной ТМ
                             LEFT JOIN tmpStickerFile ON tmpStickerFile.TradeMarkId = ObjectLink_Goods_TradeMark.ChildObjectId

                             LEFT JOIN Object AS Object_StickerFile ON Object_StickerFile.Id = COALESCE (ObjectLink_StickerProperty_StickerFile.ChildObjectId, COALESCE (ObjectLink_Sticker_StickerFile.ChildObjectId, tmpStickerFile.StickerFileId))
                        WHERE Object_StickerProperty.Id = inObjectId
                       );

     -- Сколько пробелов добавим слева, т.е. это когда слева - Фирменный знак
     vbAddLeft1:= COALESCE ((SELECT ObF.ValueData :: Integer FROM ObjectFloat AS ObF WHERE ObF.ObjectId = vbStickerFileId AND ObF.DescId = zc_ObjectFloat_StickerFile_Left1_70_70() AND ObF.ValueData > 0 AND inIs70_70 = TRUE)
                          , (SELECT ObF.ValueData :: Integer FROM ObjectFloat AS ObF WHERE ObF.ObjectId = vbStickerFileId AND ObF.DescId = zc_ObjectFloat_StickerFile_Left1() AND ObF.ValueData > 0)
                          , 0);
     vbAddLeft2:= COALESCE ((SELECT ObF.ValueData :: Integer FROM ObjectFloat AS ObF WHERE ObF.ObjectId = vbStickerFileId AND ObF.DescId = zc_ObjectFloat_StickerFile_Left2_70_70() AND ObF.ValueData > 0 AND inIs70_70 = TRUE)
                          , (SELECT ObF.ValueData :: Integer FROM ObjectFloat AS ObF WHERE ObF.ObjectId = vbStickerFileId AND ObF.DescId = zc_ObjectFloat_StickerFile_Left2() AND ObF.ValueData > 0)
                          , 0);
                 /*CASE (SELECT ObjectLink_StickerFile_TradeMark.ChildObjectId
                       FROM ObjectLink AS ObjectLink_StickerFile_TradeMark
                       WHERE ObjectLink_StickerFile_TradeMark.ObjectId = vbStickerFileId
                         AND ObjectLink_StickerFile_TradeMark.DescId   = zc_ObjectLink_StickerFile_TradeMark()
                      )
                      -- WHEN 340617 -- тм Повна Чаша (Фоззи)
                      --      THEN 40
                      -- WHEN 340618 -- тм Премія (Фоззи)
                      --     THEN 62
                      WHEN 0
                           THEN 0
                      ELSE 0
                 END;*/

     -- При какой длине Level1 - StickerType - выводится в Level2 + при этом инфа в Level2 в 2 строки
     vbParam1:= COALESCE ((SELECT ObF.ValueData :: Integer FROM ObjectFloat AS ObF WHERE ObF.ObjectId = vbStickerFileId AND ObF.DescId = zc_ObjectFloat_StickerFile_Level1_70_70() AND ObF.ValueData > 0 AND inIs70_70 = TRUE)
                        , (SELECT ObF.ValueData :: Integer FROM ObjectFloat AS ObF WHERE ObF.ObjectId = vbStickerFileId AND ObF.DescId = zc_ObjectFloat_StickerFile_Level1() AND ObF.ValueData > 0)
                        , 30);
                /*CASE vbAddLeft
                     WHEN 40 -- тм Повна Чаша (Фоззи)
                          THEN 25
                     WHEN 62 -- тм Премія (Фоззи)
                          THEN 25
                    ELSE 25 -- 30
                END;*/
     -- При какой длине Level2 - StickerSort и StickerNorm - выводятся в 2 строки
     vbParam2:= COALESCE ((SELECT ObF.ValueData :: Integer FROM ObjectFloat AS ObF WHERE ObF.ObjectId = vbStickerFileId AND ObF.DescId = zc_ObjectFloat_StickerFile_Level2_70_70() AND ObF.ValueData > 0 AND inIs70_70 = TRUE)
                        , 100 + (SELECT ObF.ValueData :: Integer FROM ObjectFloat AS ObF WHERE ObF.ObjectId = vbStickerFileId AND ObF.DescId = zc_ObjectFloat_StickerFile_Level2() AND ObF.ValueData > 0)
                        , 100 + 30);
                /*CASE vbAddLeft
                     WHEN 40 -- тм Повна Чаша (Фоззи)
                          THEN 20
                     WHEN 62 -- тм Премія (Фоззи)
                          THEN 20
                    ELSE 25 -- 30
                END;*/

     -- Был Ли перевод в несколько строк для Level1 или Level2, тогда по следующим строка НУЖЕН сдвиг
     vbAddLine:= 0;


     -- Проверка
--     IF COALESCE (vbStickerFileId, 0) = 0
--     THEN
--          RAISE EXCEPTION 'Ошибка.Шаблон не установлен';
--     END IF;


     -- Результат
     RETURN QUERY
       WITH
          tmpObject_GoodsPropertyValue AS
                            (SELECT ObjectLink_GoodsPropertyValue_Goods.ObjectId      AS ObjectId
                                  , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
                                  , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                  , ObjectLink_Goods_Measure.ChildObjectId            AS MeasureId
                                  , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                              THEN ObjectString_BarCode.ValueData
                                              ELSE ''
                                    END AS BarCode
                                  , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId <> zc_Measure_Sh()
                                              THEN -- Левая часть Ш/К
                                                   LEFT (ObjectString_BarCode.ValueData, (ObjectFloat_StartPosInt.ValueData - 1) :: Integer)
                                                         -- добавили нули слева
                                                      || REPEAT ('0'
                                                                 -- сколько надо символов
                                                               , ((ObjectFloat_EndPosInt.ValueData - ObjectFloat_StartPosInt.ValueData + 1)
                                                                  -- МИНУС сколько символов в целой части веса
                                                                - LENGTH (-- первая часть
                                                                          SPLIT_PART (inWeight :: TVarChar, '.', 1))
                                                                 ) :: Integer
                                                                )
                                                         -- целая часть веса - первая часть
                                                      || SPLIT_PART (inWeight :: TVarChar, '.', 1)

                                                         -- дробная часть веса - вторая часть
                                                      || SPLIT_PART (inWeight :: TVarChar, '.', 2)
                                                         -- добавили нули справа
                                                      || REPEAT ('0'
                                                                 -- сколько надо символов
                                                               , ((ObjectFloat_EndPosFrac.ValueData - ObjectFloat_StartPosFrac.ValueData + 1)
                                                                  -- МИНУС сколько символов в дробной части веса
                                                                - LENGTH (-- вторая часть
                                                                          SPLIT_PART (inWeight :: TVarChar, '.', 2))
                                                                 ) :: Integer
                                                                )
                                    END AS BarCode_calc
                             FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId
                                  ) AS tmpGoodsProperty

                                  LEFT JOIN ObjectFloat AS ObjectFloat_StartPosInt
                                                        ON ObjectFloat_StartPosInt.ObjectId = tmpGoodsProperty.GoodsPropertyId
                                                       AND ObjectFloat_StartPosInt.DescId   = zc_ObjectFloat_GoodsProperty_StartPosInt()

                                  LEFT JOIN ObjectFloat AS ObjectFloat_EndPosInt
                                                        ON ObjectFloat_EndPosInt.ObjectId = tmpGoodsProperty.GoodsPropertyId
                                                       AND ObjectFloat_EndPosInt.DescId   = zc_ObjectFloat_GoodsProperty_EndPosInt()

                                  LEFT JOIN ObjectFloat AS ObjectFloat_StartPosFrac
                                                        ON ObjectFloat_StartPosFrac.ObjectId = tmpGoodsProperty.GoodsPropertyId
                                                       AND ObjectFloat_StartPosFrac.DescId   = zc_ObjectFloat_GoodsProperty_StartPosFrac()

                                  LEFT JOIN ObjectFloat AS ObjectFloat_EndPosFrac
                                                        ON ObjectFloat_EndPosFrac.ObjectId = tmpGoodsProperty.GoodsPropertyId
                                                       AND ObjectFloat_EndPosFrac.DescId   = zc_ObjectFloat_GoodsProperty_EndPosFrac()

                                  INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                        ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                       AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId        = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                  INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                                -- AND Object_GoodsPropertyValue.ValueData <> ''
                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                       ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                      AND ObjectLink_GoodsPropertyValue_Goods.DescId   = zc_ObjectLink_GoodsPropertyValue_Goods()
                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                       ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                      AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                  LEFT JOIN ObjectString AS ObjectString_BarCode
                                                         ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                        AND ObjectString_BarCode.DescId   = zc_ObjectString_GoodsPropertyValue_BarCode()
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                       ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
                                                      AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                            )
          -- расчет контрольной суммы
        , tmpObject_GoodsPropertyValue_calc AS
                            (SELECT tmpObject_GoodsPropertyValue.ObjectId
                                  , tmpObject_GoodsPropertyValue.GoodsId
                                  , tmpObject_GoodsPropertyValue.GoodsKindId
                                  , tmpObject_GoodsPropertyValue.MeasureId
                                    --
                                  , CASE WHEN tmpObject_GoodsPropertyValue.BarCode <> ''
                                              THEN tmpObject_GoodsPropertyValue.BarCode
                                              -- плюс контрольная
                                              ELSE BarCode_calc || zfCalc_SummBarCode (BarCode_calc)
                                    END AS BarCode
                             FROM (SELECT tmpObject_GoodsPropertyValue.ObjectId
                                        , tmpObject_GoodsPropertyValue.GoodsId
                                        , tmpObject_GoodsPropertyValue.GoodsKindId
                                        , tmpobject_goodspropertyvalue.MeasureId
                                        , tmpObject_GoodsPropertyValue.BarCode
                                          --
                                        , LEFT (CASE WHEN tmpObject_GoodsPropertyValue.BarCode <> ''
                                                          THEN ''
                                                          -- дополнили НУЛИ справа
                                                          ELSE tmpObject_GoodsPropertyValue.BarCode_calc
                                                               -- добавили нули справа
                                                            || REPEAT ('0'
                                                                       -- сколько надо символов
                                                                     , 12
                                                                       -- МИНУС сколько символов в Ш/К
                                                                     - LENGTH (tmpObject_GoodsPropertyValue.BarCode_calc)
                                                                      )
                                                END, 12) AS BarCode_calc
                                   FROM tmpObject_GoodsPropertyValue
                                  ) AS tmpObject_GoodsPropertyValue
                            )
     , tmpLanguageParam AS (SELECT ObjectString_Value1.ValueData  AS Value1   -- Склад:
                                 , ObjectString_Value2.ValueData  AS Value2   -- Умови та термін зберігання:
                                 , ObjectString_Value3.ValueData  AS Value3   -- за відносної вологості повітря від
                                 , ObjectString_Value4.ValueData  AS Value4   -- до
                                 , ObjectString_Value5.ValueData  AS Value5   -- за температури від
                                 , ObjectString_Value6.ValueData  AS Value6   -- до
                                 , ObjectString_Value7.ValueData  AS Value7   -- не більш ніж
                                 , ObjectString_Value8.ValueData  AS Value8   -- Поживна цінність та калорійність В 100гр.продукта:
                                 , ObjectString_Value15.ValueData AS Value15  -- вуглеводи не більше
                                 , ObjectString_Value16.ValueData AS Value16  -- гр
                                 , ObjectString_Value9.ValueData  AS Value9   -- білки не менше
                                 , ObjectString_Value10.ValueData AS Value10  -- гр
                                 , ObjectString_Value11.ValueData AS Value11  -- жири не більше
                                 , ObjectString_Value12.ValueData AS Value12  -- гр
                                 , ObjectString_Value13.ValueData AS Value13  -- кКал
                                 , ObjectString_Value14.ValueData AS Value14  -- діб.
                                 , ObjectString_Value17.ValueData AS Value17  -- кДж
                            FROM ObjectLink AS ObjectLink_StickerFile_Language
                                 LEFT JOIN ObjectString AS ObjectString_Value1
                                                        ON ObjectString_Value1.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value1.DescId = zc_ObjectString_Language_Value1()
                                 LEFT JOIN ObjectString AS ObjectString_Value2
                                                        ON ObjectString_Value2.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value2.DescId = zc_ObjectString_Language_Value2()
                                 LEFT JOIN ObjectString AS ObjectString_Value3
                                                        ON ObjectString_Value3.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value3.DescId = zc_ObjectString_Language_Value3()
                                 LEFT JOIN ObjectString AS ObjectString_Value4
                                                        ON ObjectString_Value4.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value4.DescId = zc_ObjectString_Language_Value4()
                                 LEFT JOIN ObjectString AS ObjectString_Value5
                                                        ON ObjectString_Value5.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value5.DescId = zc_ObjectString_Language_Value5()
                                 LEFT JOIN ObjectString AS ObjectString_Value6
                                                        ON ObjectString_Value6.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value6.DescId = zc_ObjectString_Language_Value6()
                                 LEFT JOIN ObjectString AS ObjectString_Value7
                                                        ON ObjectString_Value7.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value7.DescId = zc_ObjectString_Language_Value7()
                                 LEFT JOIN ObjectString AS ObjectString_Value8
                                                        ON ObjectString_Value8.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value8.DescId = zc_ObjectString_Language_Value8()
                                 LEFT JOIN ObjectString AS ObjectString_Value9
                                                        ON ObjectString_Value9.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value9.DescId = zc_ObjectString_Language_Value9()
                                 LEFT JOIN ObjectString AS ObjectString_Value10
                                                        ON ObjectString_Value10.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value10.DescId = zc_ObjectString_Language_Value10()
                                 LEFT JOIN ObjectString AS ObjectString_Value11
                                                        ON ObjectString_Value11.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value11.DescId = zc_ObjectString_Language_Value11()
                                 LEFT JOIN ObjectString AS ObjectString_Value12
                                                        ON ObjectString_Value12.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value12.DescId = zc_ObjectString_Language_Value12()
                                 LEFT JOIN ObjectString AS ObjectString_Value13
                                                        ON ObjectString_Value13.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value13.DescId = zc_ObjectString_Language_Value13()
                                 LEFT JOIN ObjectString AS ObjectString_Value14
                                                        ON ObjectString_Value14.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value14.DescId = zc_ObjectString_Language_Value14()
                                 LEFT JOIN ObjectString AS ObjectString_Value15
                                                        ON ObjectString_Value15.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value15.DescId = zc_ObjectString_Language_Value15()
                                 LEFT JOIN ObjectString AS ObjectString_Value16
                                                        ON ObjectString_Value16.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value16.DescId = zc_ObjectString_Language_Value16()
                                 LEFT JOIN ObjectString AS ObjectString_Value17
                                                        ON ObjectString_Value17.ObjectId = ObjectLink_StickerFile_Language.ChildObjectId
                                                       AND ObjectString_Value17.DescId = zc_ObjectString_Language_Value17()
                            WHERE ObjectLink_StickerFile_Language.ObjectId = vbStickerFileId
                              AND ObjectLink_StickerFile_Language.DescId = zc_ObjectLink_StickerFile_Language()
                           )
          , tmpGoodsByGoodsKind AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId          AS GoodsByGoodsKindId
                                         , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     AS GoodsId
                                         , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
                                         , ObjectFloat_GK_NormInDays.ValueData                 AS NormInDays_gk
                                    FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                         JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                         ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                        AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Order
                                                                 ON ObjectBoolean_Order.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                                AND ObjectBoolean_Order.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                                              --AND ObjectBoolean_Order.ValueData = TRUE
                                         INNER JOIN ObjectFloat AS ObjectFloat_GK_NormInDays
                                                                ON ObjectFloat_GK_NormInDays.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                               AND ObjectFloat_GK_NormInDays.DescId   = zc_ObjectFloat_GoodsByGoodsKind_NormInDays()
                                                               AND ObjectFloat_GK_NormInDays.ValueData <> 0
                                    WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                      AND 1=0
                                   )

       SELECT Object_StickerProperty.Id          AS Id
            , Object_StickerProperty.ObjectCode  AS Code
            , Object_StickerProperty.ValueData   AS Comment

            , ObjectLink_StickerProperty_Sticker.ChildObjectId AS StickerId

            , Object_Goods.Id                    AS GoodsId
            , Object_Goods.ObjectCode            AS GoodsCode
            , Object_Goods.ValueData             AS GoodsName

            , Object_GoodsKind.Id                AS GoodsKindId
            , Object_GoodsKind.ValueData         AS GoodsKindName

            , COALESCE (Object_Measure.Id, 0) :: Integer AS MeasureId
            , Object_Measure.ValueData         AS MeasureName
            , zc_Measure_Sh() :: Integer       AS zc_Measure_Sh

            , Object_StickerPack.Id              AS StickerPackId
            , Object_StickerPack.ValueData       AS StickerPackName

            , Object_StickerFile.Id              AS StickerFileId
            , Object_StickerFile.ValueData       AS StickerFileName
            , Object_TradeMark_StickerFile.ValueData  AS TradeMarkName_StickerFile

            , Object_StickerSkin.Id              AS StickerSkinId
            , Object_StickerSkin.ValueData       AS StickerSkinName

            , CASE WHEN inIs70_70 = TRUE AND tmpObject_GoodsPropertyValue_calc.MeasureId <> zc_Measure_Sh()
                        THEN TRUE
                   ELSE ObjectBoolean_Fix.ValueData
              END :: Boolean AS isFix

            , ObjectFloat_Value1.ValueData       AS Value1
            , ObjectFloat_Value2.ValueData       AS Value2
            , ObjectFloat_Value3.ValueData       AS Value3
            , ObjectFloat_Value4.ValueData       AS Value4
            --, ObjectFloat_Value5.ValueData       AS Value5
              -- Кількість діб -> ***срок в днях
            , CASE WHEN tmpGoodsByGoodsKind.NormInDays_gk > 0 THEN tmpGoodsByGoodsKind.NormInDays_gk ELSE COALESCE (ObjectFloat_Value5.ValueData, 0) END ::TFloat AS Value5
              -- вес
            , CASE WHEN inIs70_70 = TRUE AND tmpObject_GoodsPropertyValue_calc.MeasureId <> zc_Measure_Sh()
                        THEN inWeight
                   ELSE ObjectFloat_Value6.ValueData
              END :: TFloat AS Value6

            , ObjectFloat_Value7.ValueData       AS Value7
            , ObjectFloat_Value8.ValueData       AS Value8
            , ObjectFloat_Value9.ValueData       AS Value9
            , ObjectFloat_Value10.ValueData      AS Value10
            , ObjectFloat_Value11.ValueData      AS Value11

            , CASE WHEN ObjectString_BarCode.ValueData <> ''
                    AND ObjectString_BarCode.ValueData <> '0'
                    AND ObjectString_BarCode.ValueData <> '00000000000'
                    AND ObjectString_BarCode.ValueData <> '000000000000'
                    AND ObjectString_BarCode.ValueData <> '0000000000000'
                    AND ObjectString_BarCode.ValueData <> '2200000000002'
                        THEN ObjectString_BarCode.ValueData
                   WHEN tmpObject_GoodsPropertyValue_calc.BarCode <> ''
                    AND tmpObject_GoodsPropertyValue_calc.BarCode <> '0'
                    AND tmpObject_GoodsPropertyValue_calc.BarCode <> '00000000000'
                    AND tmpObject_GoodsPropertyValue_calc.BarCode <> '000000000000'
                    AND tmpObject_GoodsPropertyValue_calc.BarCode <> '0000000000000'
                    AND tmpObject_GoodsPropertyValue_calc.BarCode <> '2200000000002'
                        THEN tmpObject_GoodsPropertyValue_calc.BarCode
                   ELSE ''
              END :: TVarChar  AS BarCode

            , Sticker_Value1.ValueData           AS Sticker_Value1
            , Sticker_Value2.ValueData           AS Sticker_Value2
            , Sticker_Value3.ValueData           AS Sticker_Value3
            , Sticker_Value4.ValueData           AS Sticker_Value4
            , Sticker_Value5.ValueData           AS Sticker_Value5
            , Sticker_Value6.ValueData           AS Sticker_Value6
            , Sticker_Value7.ValueData           AS Sticker_Value7
            , Sticker_Value8.ValueData           AS Sticker_Value8

-- [frxDBDHeader."StickerGroupName"] [frxDBDHeader."StickerTypeName"] [frxDBDHeader."StickerTagName"]
-- [frxDBDHeader."StickerSortName"] [frxDBDHeader."StickerNormName"]
-- СКЛАД:[frxDBDHeader."Info"]
-- УМОВИ ТА ТЕРМІН ЗБЕРІГАННЯ [frxDBDHeader."StickerPackName"]:за відносної вологості повітря від [frxDBDHeader."Value1"]% до [frxDBDHeader."Value2"]%, за температури від [FormatFloat('+,0.#; -,0.#;0',<frxDBDHeader."Value3">)]С до [FormatFloat('+,0.#; -,0.#; ',<frxDBDHeader."Value4">)]С не більш ніж [frxDBDHeader."Value5"] діб.
-- ПОЖИВНА ЦІННІСТЬ ТА КАЛОРІЙНІСТЬ В 100ГР.ПРОДУКТА:білки не менше [FormatFloat(',0.0; -,0.0; ',<frxDBDHeader."Sticker_Value2">)] гр, жири не більше [FormatFloat(',0.0; -,0.0; ',<frxDBDHeader."Sticker_Value3">)] гр, [FormatFloat(',0.0; -,0.0; ',<frxDBDHeader."Sticker_Value4">)] кКал
--
-- [frxDBDHeader."Level1"]
-- [frxDBDHeader."Level2"]
-- [frxDBDHeader."Info"]

              -- Level1
            , (CASE WHEN inIsLength = TRUE
                    THEN LENGTH (REPEAT (' ', vbAddLeft1)
                              || CASE WHEN LENGTH (COALESCE (Object_StickerGroup.ValueData, '') || ' ' || COALESCE (Object_StickerType.ValueData, '') || ' ' || COALESCE (Object_StickerTag.ValueData, '')) > vbParam1
                                           THEN CASE WHEN LENGTH (COALESCE (Object_StickerGroup.ValueData, '') || ' ' || COALESCE (Object_StickerTag.ValueData, '')) > vbParam1
                                                          THEN -- Вид продукта (Группа)
                                                               COALESCE (Object_StickerGroup.ValueData, '')
                                                          ELSE -- Вид продукта (Группа) + Название продукта
                                                               COALESCE (Object_StickerGroup.ValueData, '')
                                                     || ' ' || COALESCE (Object_StickerTag.ValueData, '')
                                                END
                                      ELSE -- Вид продукта (Группа) + Способ изготовления продукта + Название продукта
                                           COALESCE (Object_StickerGroup.ValueData, '')
                                 || ' ' || COALESCE (Object_StickerType.ValueData, '')
                                 || ' ' || COALESCE (Object_StickerTag.ValueData, '')

                                 END
                                ) :: TVarChar || ' - (' || vbParam1 :: TVarChar || ')'
                    ELSE ''
               END
            || REPEAT (' ', vbAddLeft1)
            || CASE WHEN LENGTH (COALESCE (Object_StickerGroup.ValueData, '') || ' ' || COALESCE (Object_StickerType.ValueData, '') || ' ' || COALESCE (Object_StickerTag.ValueData, '')) > vbParam1
                         THEN CASE WHEN LENGTH (COALESCE (Object_StickerGroup.ValueData, '') || ' ' || COALESCE (Object_StickerTag.ValueData, '')) > vbParam1
                                        THEN -- Вид продукта (Группа)
                                             COALESCE (Object_StickerGroup.ValueData, '')
                                        ELSE -- Вид продукта (Группа) + Название продукта
                                             COALESCE (Object_StickerGroup.ValueData, '')
                                   || ' ' || COALESCE (Object_StickerTag.ValueData, '')
                              END

                    ELSE -- Вид продукта (Группа) + Способ изготовления продукта + Название продукта
                         COALESCE (Object_StickerGroup.ValueData, '')
               || ' ' || COALESCE (Object_StickerType.ValueData, '')
               || ' ' || COALESCE (Object_StickerTag.ValueData, '')

               END) :: TVarChar AS Level1

              -- Level2
            , (CASE WHEN inIsLength = TRUE
                    THEN LENGTH (REPEAT (' ', vbAddLeft2)
                              || CASE WHEN LENGTH (COALESCE (Object_StickerGroup.ValueData, '') || ' ' || COALESCE (Object_StickerTag.ValueData, '')) > vbParam1
                                           THEN -- Название продукта + Способ изготовления продукта + Сортность продукта + ТУ или ДСТУ
                                                COALESCE (Object_StickerTag.ValueData, '')
                                      || ' ' || COALESCE (Object_StickerType.ValueData, '')
                                      || ' ' || COALESCE (Object_StickerSort.ValueData, '')
                                 || CHR (13) || REPEAT (' ', vbAddLeft2)
                                             || COALESCE (Object_StickerNorm.ValueData, '')

                                      WHEN LENGTH (COALESCE (Object_StickerGroup.ValueData, '') || ' ' || COALESCE (Object_StickerType.ValueData, '') || ' ' || COALESCE (Object_StickerTag.ValueData, '')) > vbParam1
                                           THEN -- Способ изготовления продукта + Сортность продукта + ТУ или ДСТУ
                                                COALESCE (Object_StickerType.ValueData, '')
                                      || ' ' || COALESCE (Object_StickerSort.ValueData, '')
                                 || CHR (13) || REPEAT (' ', vbAddLeft2)
                                             || COALESCE (Object_StickerNorm.ValueData, '')

                                      WHEN LENGTH (COALESCE (Object_StickerSort.ValueData, '') || ' ' || COALESCE (Object_StickerNorm.ValueData, '')) > vbParam2
                                           THEN -- Сортность продукта + ТУ или ДСТУ
                                                COALESCE (Object_StickerSort.ValueData, '')
                                 || CHR (13) || REPEAT (' ', vbAddLeft2)
                                             || COALESCE (Object_StickerNorm.ValueData, '')

                                      ELSE -- Сортность продукта + ТУ или ДСТУ
                                           COALESCE (Object_StickerSort.ValueData, '')
                                 || ' ' || COALESCE (Object_StickerNorm.ValueData, '')

                                 END
                                ) :: TVarChar || ' - (' || vbParam2 :: TVarChar || ')'
                    ELSE ''
               END
            || REPEAT (' ', vbAddLeft2)
            || CASE WHEN LENGTH (COALESCE (Object_StickerGroup.ValueData, '') || ' ' || COALESCE (Object_StickerTag.ValueData, '')) > vbParam1
                         THEN -- Название продукта + Способ изготовления продукта + Сортность продукта + ТУ или ДСТУ
                              COALESCE (Object_StickerTag.ValueData, '')
                    || ' ' || COALESCE (Object_StickerType.ValueData, '')
                    || ' ' || COALESCE (Object_StickerSort.ValueData, '')
             --|| CHR (13) || REPEAT (' ', vbAddLeft2)
             --            || COALESCE (Object_StickerNorm.ValueData, '')
               || ' ' || COALESCE (Object_StickerNorm.ValueData, '')

                    WHEN LENGTH (COALESCE (Object_StickerGroup.ValueData, '') || ' ' || COALESCE (Object_StickerType.ValueData, '') || ' ' || COALESCE (Object_StickerTag.ValueData, '')) > vbParam1
                         THEN -- Способ изготовления продукта + Сортность продукта + ТУ или ДСТУ
                              COALESCE (Object_StickerType.ValueData, '')
                    || ' ' || COALESCE (Object_StickerSort.ValueData, '')
             --|| CHR (13) || REPEAT (' ', vbAddLeft2)
             --            || COALESCE (Object_StickerNorm.ValueData, '')
               || ' ' || COALESCE (Object_StickerNorm.ValueData, '')

                    WHEN LENGTH (COALESCE (Object_StickerSort.ValueData, '') || ' ' || COALESCE (Object_StickerNorm.ValueData, '')) > vbParam2
                         THEN -- Сортность продукта + ТУ или ДСТУ
                              COALESCE (Object_StickerSort.ValueData, '')
               || CHR (13) || REPEAT (' ', vbAddLeft2)
                           || COALESCE (Object_StickerNorm.ValueData, '')

                    ELSE -- Сортность продукта + ТУ или ДСТУ
                         COALESCE (Object_StickerSort.ValueData, '')
               || ' ' || COALESCE (Object_StickerNorm.ValueData, '')

               END) :: TVarChar AS Level2

              -- Вид продукта (Группа)
            , Object_StickerGroup.ValueData   AS StickerGroupName
              -- Способ изготовления продукта
            , Object_StickerType.ValueData    AS StickerTypeName
              -- Название продукта
            , Object_StickerTag.ValueData     AS StickerTagName
              -- Сортность
            , Object_StickerSort.ValueData    AS StickerSortName
              -- ТУ или ДСТУ
            , Object_StickerNorm.ValueData    AS StickerNormName
              -- !!!СКЛАД!!!
            , zfCalc_Text_parse (vbStickerFileId, Object_TradeMark_StickerFile.Id
                                 -- Сколько пробелов добавим слева, т.е. это когда слева - Фирменный знак
                               , vbAddLeft2
                                 -- Был Ли перевод в несколько строк для Level1 или Level2, тогда по следующим строкам НУЖЕН сдвиг
                               , CASE WHEN LENGTH (COALESCE (Object_StickerGroup.ValueData, '') || ' ' || COALESCE (Object_StickerType.ValueData, '') || ' ' || COALESCE (Object_StickerTag.ValueData, '')) > vbParam1
                                        OR LENGTH (COALESCE (Object_StickerSort.ValueData, '') || ' ' || COALESCE (Object_StickerNorm.ValueData, '')) > vbParam2
                                       THEN 1
                                       ELSE 0
                                 END
                               -- , 'СКЛАД:'
                               , tmpLanguageParam.Value1 ||': '
                              || ObjectBlob_Info.ValueData

                            --|| CASE WHEN Object_StickerSkin.ValueData ILIKE '%без оболонки%' THEN ' ' || Object_StickerSkin.ValueData || CHR (13) ELSE '' END
                              || CASE WHEN Object_StickerSkin.ValueData ILIKE '%без оболонки%' THEN ' ' || Object_StickerSkin.ValueData || '.' ELSE '' END

                              -- || 'УМОВИ ТА ТЕРМІН ЗБЕРІГАННЯ:' || COALESCE (Object_StickerPack.ValueData, '') || ':'
                        || '' || tmpLanguageParam.Value2 ||': ' || COALESCE (Object_StickerPack.ValueData, '') || ': '
                              || CASE WHEN ObjectFloat_Value1.ValueData > 0 THEN
                                 tmpLanguageParam.Value3 ||' ' || zfConvert_FloatToString (COALESCE (ObjectFloat_Value1.ValueData, 0)) || '% '
                              || tmpLanguageParam.Value4 ||' ' || zfConvert_FloatToString (COALESCE (ObjectFloat_Value2.ValueData, 0)) || '% , '

                              || tmpLanguageParam.Value5 ||' ' || zfConvert_FloatToString (COALESCE (ObjectFloat_Value3.ValueData, 0)) || '°С '
                              || tmpLanguageParam.Value6 ||' ' || zfConvert_FloatToString (COALESCE (ObjectFloat_Value4.ValueData, 0)) || '°С '
                              || tmpLanguageParam.Value7 ||' ' || zfConvert_FloatToString (CASE WHEN tmpGoodsByGoodsKind.NormInDays_gk > 0 THEN tmpGoodsByGoodsKind.NormInDays_gk ELSE COALESCE (ObjectFloat_Value5.ValueData, 0) END
                                                                                          ) || tmpLanguageParam.Value14 ||'. '

                                 ELSE

                                 tmpLanguageParam.Value5 ||' ' || zfConvert_FloatToString (COALESCE (ObjectFloat_Value3.ValueData, 0)) || '°С '
                              || tmpLanguageParam.Value6 ||' ' || zfConvert_FloatToString (COALESCE (ObjectFloat_Value4.ValueData, 0)) || '°С '
                                'та відносної вологості повітря не більш ніж ' || zfConvert_FloatToString (COALESCE (ObjectFloat_Value2.ValueData, 0)) || '% '
                              || tmpLanguageParam.Value7 ||' ' || zfConvert_FloatToString (CASE WHEN tmpGoodsByGoodsKind.NormInDays_gk > 0 THEN tmpGoodsByGoodsKind.NormInDays_gk ELSE COALESCE (ObjectFloat_Value5.ValueData, 0) END
                                                                                          ) || tmpLanguageParam.Value14 ||'. '

                                 END
--                            || tmpLanguageParam.Value5 ||' ' || zfConvert_FloatToString (COALESCE (ObjectFloat_Value3.ValueData, 0)) || '°С '
--                            || tmpLanguageParam.Value6 ||' ' || zfConvert_FloatToString (COALESCE (ObjectFloat_Value4.ValueData, 0)) || '°С '
--                            || tmpLanguageParam.Value7 ||' ' || zfConvert_FloatToString (CASE WHEN tmpGoodsByGoodsKind.NormInDays_gk > 0 THEN tmpGoodsByGoodsKind.NormInDays_gk ELSE COALESCE (ObjectFloat_Value5.ValueData, 0) END) || tmpLanguageParam.Value14 ||'. '

                              -- 'ПОЖИВНА ЦІННІСТЬ ТА КАЛОРІЙНІСТЬ В 100ГР.ПРОДУКТА:'
                              -- білки не менше + жири не більше + кКал + кДж
                              || CASE WHEN Sticker_Value2.ValueData <> 0 OR Sticker_Value3.ValueData <> 0 OR Sticker_Value4.ValueData <> 0 OR Sticker_Value5.ValueData <> 0
                                           THEN tmpLanguageParam.Value8 ||': '
                                     ELSE ''
                                 END

                              -- вуглеводи не більше
                              || CASE WHEN Sticker_Value1.ValueData <> 0 AND Sticker_Value6.ValueData = 0 --  з них насичені (жири)
                                           THEN tmpLanguageParam.Value15  ||' ' || zfConvert_FloatToString (COALESCE (Sticker_Value1.ValueData, 0)) || tmpLanguageParam.Value16 ||', '
                                      ELSE ''
                                 END
/*
                              -- білки OR білки не менше
                              || CASE WHEN Sticker_Value6.ValueData > 0 --  з них насичені (жири)
                                           THEN SUBSTRING (tmpLanguageParam.Value9 FROM 1 FOR 5) || ' ' || zfConvert_FloatToString (COALESCE (Sticker_Value2.ValueData, 0)) || tmpLanguageParam.Value10 ||', '
                                      WHEN Sticker_Value2.ValueData <> 0
                                           THEN tmpLanguageParam.Value9  ||' ' || zfConvert_FloatToString (COALESCE (Sticker_Value2.ValueData, 0)) || tmpLanguageParam.Value10 ||', '
                                      ELSE ''
                                 END
*/
                              -- жири OR жири не більше
                              || CASE WHEN Sticker_Value6.ValueData > 0 --  з них насичені (жири)
                                           THEN SUBSTRING (tmpLanguageParam.Value11 FROM 1 FOR 4) || ' ' || zfConvert_FloatToString (COALESCE (Sticker_Value3.ValueData, 0)) || tmpLanguageParam.Value12 ||''
                                      WHEN Sticker_Value3.ValueData > 0
                                           THEN tmpLanguageParam.Value11 ||' ' || zfConvert_FloatToString (COALESCE (Sticker_Value3.ValueData, 0)) || tmpLanguageParam.Value12 ||''
                                      ELSE ''
                                 END
                              -- з них насичені (жири)
                              || CASE WHEN Sticker_Value6.ValueData > 0
                                           THEN ', з них насичені' ||' ' || zfConvert_FloatToString (COALESCE (Sticker_Value6.ValueData, 0)) || tmpLanguageParam.Value12
                                      ELSE ''
                                 END
                              -- вуглеводи
                              || CASE WHEN Sticker_Value1.ValueData <> 0 AND Sticker_Value6.ValueData > 0 --  з них насичені (жири)
                                           THEN ', вуглеводи' ||' ' || zfConvert_FloatToString (COALESCE (Sticker_Value1.ValueData, 0)) || tmpLanguageParam.Value16
                                      ELSE ''
                                 END
                              --  цукри
                              || CASE WHEN Sticker_Value6.ValueData > 0
                                           THEN ' з них цукри' ||' ' || zfConvert_FloatToString (COALESCE (Sticker_Value7.ValueData, 0)) || tmpLanguageParam.Value12
                                      ELSE ''
                                 END
                              -- білки OR білки не менше
                              || CASE WHEN Sticker_Value6.ValueData > 0 --  з них насичені (жири)
                                           THEN ', ' || SUBSTRING (tmpLanguageParam.Value9 FROM 1 FOR 5) || ' ' || zfConvert_FloatToString (COALESCE (Sticker_Value2.ValueData, 0)) || tmpLanguageParam.Value10
                                      WHEN Sticker_Value2.ValueData <> 0
                                           THEN ', ' || tmpLanguageParam.Value9  ||' ' || zfConvert_FloatToString (COALESCE (Sticker_Value2.ValueData, 0)) || tmpLanguageParam.Value10
                                      ELSE ''
                                 END
                              --  сіль
                              || CASE WHEN Sticker_Value6.ValueData > 0
                                           THEN ', сіль' ||' ' || zfConvert_FloatToString (COALESCE (Sticker_Value8.ValueData, 0)) || tmpLanguageParam.Value12
                                      ELSE ''
                                 END ||''
                              -- кДж
                              || CASE WHEN Sticker_Value5.ValueData <> 0
                                            THEN ', ' || zfConvert_FloatToString (COALESCE (Sticker_Value5.ValueData, 0)) ||  tmpLanguageParam.Value17 ||''
                                      ELSE ''
                                 END
                              -- кКал
                              || CASE WHEN Sticker_Value4.ValueData > 0
                                           THEN ', ' || zfConvert_FloatToString (COALESCE (Sticker_Value4.ValueData, 0)) ||  tmpLanguageParam.Value13 ||''
                                      ELSE ''
                                 END

                               , inIsLength
                               , FALSE -- теперь НЕ используется
                               , inIs70_70
                               , vbUserId
                                ) AS Info

              --
            , ObjectBlob_StickerHeader_Info.ValueData :: Text AS StickerHeader_Info
              --
            , CASE WHEN ObjectBoolean_StickerProperty_CK.ValueData = TRUE
                        THEN 'НА ПОВЕРХНІ ОБОЛОНКИ ДОПУСКАЄТЬСЯ БІЛИЙ НАЛІТ СОЛІ'
                   ELSE ''
              END :: TVarChar AS Info_add

            , inIsJPG                              :: Boolean   AS isJPG
            , (inIsStartEnd  AND inIsTare = FALSE) :: Boolean   AS isStartEnd
            , inIsTare                             :: Boolean   AS isTara
            , (inIsPartion   AND inIsTare = TRUE)  :: Boolean   AS isPartion
            , (inIsGoodsName AND inIsTare = TRUE)  :: Boolean   AS isGoodsName

            , inDateStart                                                          :: TDateTime AS DateStart
            , (inDateStart + (CASE WHEN tmpGoodsByGoodsKind.NormInDays_gk > 0 THEN tmpGoodsByGoodsKind.NormInDays_gk ELSE COALESCE (ObjectFloat_Value5.ValueData, 0) END :: TVarChar
                           ||' DAY') :: INTERVAL)  :: TDateTime AS DateEnd
             -- вложенность
            , CASE WHEN ObjectFloat_Value11.ValueData <> 0 THEN 'Кількість в упаковці ' || zfConvert_FloatToString (ObjectFloat_Value11.ValueData) || ' штук' ELSE '' END :: TVarChar AS StickerProperty_Value11

            , inDateTare          :: TDateTime AS DateTare
            , inDatePack          :: TDateTime AS DatePack
            , inDateProduction    :: TDateTime AS DateProduction
            , inNumPack           :: TFloat    AS NumPack
            , inNumTech           :: TFloat    AS NumTech

            , vbBranchCode        :: Integer   AS BranchCode

       FROM Object AS Object_StickerProperty
             LEFT JOIN Object AS Object_StickerFile ON Object_StickerFile.Id = vbStickerFileId

             LEFT JOIN tmpLanguageParam ON 1 = 1

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                  ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_Sticker.DescId = zc_ObjectLink_StickerProperty_Sticker()

             LEFT JOIN ObjectLink AS ObjectLink_Retail_StickerHeader
                                  ON ObjectLink_Retail_StickerHeader.ObjectId = inRetailId
                                 AND ObjectLink_Retail_StickerHeader.DescId   = zc_ObjectLink_Retail_StickerHeader()
             LEFT JOIN ObjectBlob AS ObjectBlob_StickerHeader_Info
                                  ON ObjectBlob_StickerHeader_Info.ObjectId = ObjectLink_Retail_StickerHeader.ChildObjectId
                                 AND ObjectBlob_StickerHeader_Info.DescId   = zc_ObjectBlob_StickerHeader_Info()

             LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                  ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                 AND ObjectLink_Sticker_Goods.DescId = zc_ObjectLink_Sticker_Goods()
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Sticker_Goods.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_GoodsKind
                                  ON ObjectLink_StickerProperty_GoodsKind.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_GoodsKind.DescId = zc_ObjectLink_StickerProperty_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_StickerProperty_GoodsKind.ChildObjectId

             LEFT JOIN tmpObject_GoodsPropertyValue_calc ON tmpObject_GoodsPropertyValue_calc.GoodsId     = Object_Goods.Id
                                                        AND tmpObject_GoodsPropertyValue_calc.GoodsKindId = Object_GoodsKind.Id

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPack
                                  ON ObjectLink_StickerProperty_StickerPack.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_StickerPack.DescId = zc_ObjectLink_StickerProperty_StickerPack()
             LEFT JOIN Object AS Object_StickerPack ON Object_StickerPack.Id = ObjectLink_StickerProperty_StickerPack.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerSkin
                                  ON ObjectLink_StickerProperty_StickerSkin.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_StickerSkin.DescId = zc_ObjectLink_StickerProperty_StickerSkin()
             LEFT JOIN Object AS Object_StickerSkin ON Object_StickerSkin.Id = ObjectLink_StickerProperty_StickerSkin.ChildObjectId

             LEFT JOIN ObjectBoolean AS ObjectBoolean_StickerProperty_CK
                                     ON ObjectBoolean_StickerProperty_CK.ObjectId = Object_StickerProperty.Id
                                    AND ObjectBoolean_StickerProperty_CK.DescId = zc_ObjectBoolean_StickerProperty_CK()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value1
                                   ON ObjectFloat_Value1.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value1.DescId = zc_ObjectFloat_StickerProperty_Value1()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value2
                                   ON ObjectFloat_Value2.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value2.DescId = zc_ObjectFloat_StickerProperty_Value2()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value3
                                   ON ObjectFloat_Value3.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value3.DescId = zc_ObjectFloat_StickerProperty_Value3()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value4
                                   ON ObjectFloat_Value4.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value4.DescId = zc_ObjectFloat_StickerProperty_Value4()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value5
                                   ON ObjectFloat_Value5.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value5.DescId = zc_ObjectFloat_StickerProperty_Value5()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value6
                                   ON ObjectFloat_Value6.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value6.DescId = zc_ObjectFloat_StickerProperty_Value6()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value7
                                   ON ObjectFloat_Value7.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value7.DescId = zc_ObjectFloat_StickerProperty_Value7()
             -- Т мін - второй срок
             LEFT JOIN ObjectFloat AS ObjectFloat_Value8
                                   ON ObjectFloat_Value8.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value8.DescId = zc_ObjectFloat_StickerProperty_Value8()
             -- Т макс - второй срок
             LEFT JOIN ObjectFloat AS ObjectFloat_Value9
                                   ON ObjectFloat_Value9.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value9.DescId = zc_ObjectFloat_StickerProperty_Value9()
             -- кількість діб - второй срок
             LEFT JOIN ObjectFloat AS ObjectFloat_Value10
                                   ON ObjectFloat_Value10.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value10.DescId = zc_ObjectFloat_StickerProperty_Value10()
             -- вложенность
             LEFT JOIN ObjectFloat AS ObjectFloat_Value11
                                   ON ObjectFloat_Value11.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value11.DescId = zc_ObjectFloat_StickerProperty_Value11()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_Fix
                                     ON ObjectBoolean_Fix.ObjectId = Object_StickerProperty.Id
                                    AND ObjectBoolean_Fix.DescId = zc_ObjectBoolean_StickerProperty_Fix()
             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = Object_StickerProperty.Id
                                   AND ObjectString_BarCode.DescId   = zc_ObjectString_StickerProperty_BarCode()

             LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                  ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                 AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()
             LEFT JOIN Object AS Object_TradeMark_StickerFile ON Object_TradeMark_StickerFile.Id = ObjectLink_StickerFile_TradeMark.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerGroup
                                  ON ObjectLink_Sticker_StickerGroup.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                 AND ObjectLink_Sticker_StickerGroup.DescId = zc_ObjectLink_Sticker_StickerGroup()
             LEFT JOIN Object AS Object_StickerGroup ON Object_StickerGroup.Id = ObjectLink_Sticker_StickerGroup.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerType
                                  ON ObjectLink_Sticker_StickerType.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                 AND ObjectLink_Sticker_StickerType.DescId = zc_ObjectLink_Sticker_StickerType()
             LEFT JOIN Object AS Object_StickerType ON Object_StickerType.Id = ObjectLink_Sticker_StickerType.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerTag
                                  ON ObjectLink_Sticker_StickerTag.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                 AND ObjectLink_Sticker_StickerTag.DescId = zc_ObjectLink_Sticker_StickerTag()
             LEFT JOIN Object AS Object_StickerTag ON Object_StickerTag.Id = ObjectLink_Sticker_StickerTag.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerSort
                                  ON ObjectLink_Sticker_StickerSort.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                 AND ObjectLink_Sticker_StickerSort.DescId = zc_ObjectLink_Sticker_StickerSort()
             LEFT JOIN Object AS Object_StickerSort ON Object_StickerSort.Id = ObjectLink_Sticker_StickerSort.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerNorm
                                  ON ObjectLink_Sticker_StickerNorm.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                 AND ObjectLink_Sticker_StickerNorm.DescId = zc_ObjectLink_Sticker_StickerNorm()
             LEFT JOIN Object AS Object_StickerNorm ON Object_StickerNorm.Id = ObjectLink_Sticker_StickerNorm.ChildObjectId

             LEFT JOIN ObjectBlob AS ObjectBlob_Info
                                  ON ObjectBlob_Info.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                 AND ObjectBlob_Info.DescId = zc_ObjectBlob_Sticker_Info()

             LEFT JOIN ObjectFloat AS Sticker_Value1
                                   ON Sticker_Value1.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                  AND Sticker_Value1.DescId = zc_ObjectFloat_Sticker_Value1()

             LEFT JOIN ObjectFloat AS Sticker_Value2
                                   ON Sticker_Value2.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                  AND Sticker_Value2.DescId = zc_ObjectFloat_Sticker_Value2()

             LEFT JOIN ObjectFloat AS Sticker_Value3
                                   ON Sticker_Value3.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                  AND Sticker_Value3.DescId = zc_ObjectFloat_Sticker_Value3()

             LEFT JOIN ObjectFloat AS Sticker_Value4
                                   ON Sticker_Value4.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                  AND Sticker_Value4.DescId = zc_ObjectFloat_Sticker_Value4()

             LEFT JOIN ObjectFloat AS Sticker_Value5
                                   ON Sticker_Value5.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                  AND Sticker_Value5.DescId = zc_ObjectFloat_Sticker_Value5()

             LEFT JOIN ObjectFloat AS Sticker_Value6
                                   ON Sticker_Value6.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                  AND Sticker_Value6.DescId = zc_ObjectFloat_Sticker_Value6()
             LEFT JOIN ObjectFloat AS Sticker_Value7
                                   ON Sticker_Value7.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                  AND Sticker_Value7.DescId = zc_ObjectFloat_Sticker_Value7()
             LEFT JOIN ObjectFloat AS Sticker_Value8
                                   ON Sticker_Value8.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                  AND Sticker_Value8.DescId = zc_ObjectFloat_Sticker_Value8()

             LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = Object_Goods.Id
                                          AND tmpGoodsByGoodsKind.GoodsKindId = Object_GoodsKind.Id

          WHERE Object_StickerProperty.Id = inObjectId
            AND Object_StickerProperty.DescId = zc_Object_StickerProperty()
         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.12.17         *
 26.10.17         *
*/

-- тест
-- SELECT BarCode, * FROM gpSelect_Object_StickerProperty_Print (inObjectId:= 7559997, inRetailId:= 310828, inIsJPG:= TRUE, inIsLength:= FALSE, inIs70_70:= TRUE, inIsStartEnd:= FALSE, inIsTare:= FALSE, inIsPartion:= FALSE, inIsGoodsName:= FALSE, inDateStart:= '01.01.2016', inDateTare:= '01.01.2016', inDatePack:= '01.01.2016', inDateProduction:= '01.01.2016', inNumPack:= 1, inNumTech:= 1, inWeight:=1.123, inSession:= zfCalc_UserAdmin());
