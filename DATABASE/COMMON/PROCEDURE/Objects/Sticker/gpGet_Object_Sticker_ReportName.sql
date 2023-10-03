-- Function: gpGet_Object_Sticker_ReportName()

-- DROP FUNCTION IF EXISTS gpGet_Object_Sticker_ReportName (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_Sticker_ReportName (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Sticker_ReportName (
    IN inObjectId           Integer  , -- ключ Свойства этикетки
    IN inIs70_70            Boolean  , -- 
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId          Integer;
   DECLARE vbStickerFileName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- поиск ШАБЛОНА
     vbStickerFileName := (WITH -- Шаблоны "по умолчанию" - для конкретной ТМ
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
                           SELECT Object_StickerFile.ValueData AS StickerFileName
                           FROM Object AS Object_StickerProperty
                                -- индивидуальный - Свойства этикетки
                                LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile
                                                     ON ObjectLink_StickerProperty_StickerFile.ObjectId = Object_StickerProperty.Id
                                                    AND ObjectLink_StickerProperty_StickerFile.DescId   = CASE WHEN inIs70_70 = TRUE
                                                                                                               THEN zc_ObjectLink_StickerProperty_StickerFile_70_70()
                                                                                                               ELSE zc_ObjectLink_StickerProperty_StickerFile()
                                                                                                          END
                                -- без 70x70
                                LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile_f
                                                     ON ObjectLink_StickerProperty_StickerFile_f.ObjectId = Object_StickerProperty.Id
                                                    AND ObjectLink_StickerProperty_StickerFile_f.DescId   = zc_ObjectLink_StickerProperty_StickerFile()

                                LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                                     ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                                    AND ObjectLink_StickerProperty_Sticker.DescId   = zc_ObjectLink_StickerProperty_Sticker()
                                -- индивидуальный - Этикетка
                                LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerFile
                                                     ON ObjectLink_Sticker_StickerFile.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                    AND ObjectLink_Sticker_StickerFile.DescId   = CASE WHEN inIs70_70 = TRUE
                                                                                                       THEN zc_ObjectLink_Sticker_StickerFile_70_70()
                                                                                                       ELSE zc_ObjectLink_Sticker_StickerFile()
                                                                                                  END
                                -- без 70x70
                                LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerFile_f
                                                     ON ObjectLink_Sticker_StickerFile_f.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                    AND ObjectLink_Sticker_StickerFile_f.DescId   = zc_ObjectLink_Sticker_StickerFile()

                                LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                                     ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                    AND ObjectLink_Sticker_Goods.DescId   = zc_ObjectLink_Sticker_Goods()
                                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                     ON ObjectLink_Goods_TradeMark.ObjectId = ObjectLink_Sticker_Goods.ChildObjectId
                                                    AND ObjectLink_Goods_TradeMark.DescId   = zc_ObjectLink_Goods_TradeMark()
                                -- "по умолчанию" - для конкретной ТМ
                                LEFT JOIN tmpStickerFile ON tmpStickerFile.TradeMarkId = ObjectLink_Goods_TradeMark.ChildObjectId

                                LEFT JOIN Object AS Object_StickerFile ON Object_StickerFile.Id = COALESCE (ObjectLink_StickerProperty_StickerFile.ChildObjectId
                                                                                                          , ObjectLink_Sticker_StickerFile.ChildObjectId
                                                                                                          , tmpStickerFile.StickerFileId
                                                                                                          , ObjectLink_StickerProperty_StickerFile_f.ChildObjectId
                                                                                                          , ObjectLink_Sticker_StickerFile_f.ChildObjectId
                                                                                                           )

                           WHERE Object_StickerProperty.Id = inObjectId
                          );

     -- Проверка
     IF COALESCE (vbStickerFileName, '') = ''
     THEN
          RAISE EXCEPTION 'Ошибка.Шаблон не установлен';
     END IF;

     -- Результат
     RETURN (CASE WHEN vbUserId = 5 AND 1=0
                       THEN REPLACE (vbStickerFileName, 'ТМ', 'тм')
                       --THEN REPLACE (vbStickerFileName, 'тм', 'ТМ')
                  ELSE vbStickerFileName
             END
          || CASE WHEN vbStickerFileName ILIKE '%_70_70'   THEN ''
                  WHEN inIs70_70 = TRUE /*AND vbUserId=5*/ THEN '_70_70'
                  ELSE ''
             END
          || '.Sticker');

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.10.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Sticker_ReportName (inObjectId:= 1371321, inIs70_70:= TRUE, inSession:= '5'); -- все
