-- Function: gpGet_Object_Product_CIN()

DROP FUNCTION IF EXISTS gpGet_Object_Product_CIN(Integer, Integer, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Product_CIN(
    IN inId                    Integer   ,    -- ключ объекта <Лодки>
    IN inModelId               Integer   ,
    IN inDateStart             TDateTime ,
 INOUT ioCIN                   TVarChar  ,
    IN inSession               TVarChar       -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbDateStart TDateTime;
   DECLARE vbModelId Integer;
   DECLARE vbModelNom TVarChar;
BEGIN

   -- Проверка
   IF COALESCE (inModelId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должна быть определена <Model>' :: TVarChar
                                             , inProcedureName := 'gpGet_Object_Product_CIN'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- находим сохраненную дату производства и модель, если изменили то нужно изменять CIN,
   /*vbDateStart := (SELECT ObjectDate_DateStart.ValueData
                   FROM ObjectDate AS ObjectDate_DateStart
                   WHERE ObjectDate_DateStart.ObjectId = inId
                     AND ObjectDate_DateStart.DescId = zc_ObjectDate_Product_DateStart()
                   );*/

   -- находим модель
   vbModelId := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inId AND OL.DescId   = zc_ObjectLink_Product_Model());

   --
   IF COALESCE (ioCIN, '') <> COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Product_CIN() AND OS.ObjectId = inId), '-')
   THEN

       IF COALESCE (vbModelId,0) <> inModelId OR LENGTH (COALESCE (TRIM (ioCIN), '')) < 10
       THEN
           -- находим последний номер конкретной модели + 1
           vbModelNom := COALESCE ((SELECT LPAD ( (1 + MAX (zfConvert_StringToNumber (SUBSTRING (ObjectString_CIN.ValueData, 8, 4)) :: Integer)) :: TVarChar, 4, '0')
                                    FROM ObjectLink AS ObjectLink_Model
                                         LEFT JOIN ObjectString AS ObjectString_CIN
                                                                ON ObjectString_CIN.ObjectId = ObjectLink_Model.ObjectId
                                                               AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
                                         INNER JOIN Object AS Object_Product
                                                           ON Object_Product.Id = ObjectLink_Model.ObjectId
                                                          AND Object_Product.isErased = FALSE
                                    WHERE ObjectLink_Model.ChildObjectId = inModelId
                                      AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model())
                                    , '0001'
                                   ) ::TVarChar ;

           /* zc_ObjectString_ProdModel_PatternCIN
              потом последний номер конкретной модели +1
              потом 1 буква месяца (от 1 до 12)
              потом 1 цифра 0
              потом 2 цифры год производства
           Пример: DE-AGLD0001A020 или DE-AGLA0002F019*/

           --
           -- RAISE EXCEPTION 'Ошибка.<%>', vbModelNom, inModelId;

           ioCIN := (SELECT ObjectString_PatternCIN.ValueData
                          || vbModelNom
                          || COALESCE (LEFT (zfCalc_MonthName_ABC( inDateStart), 1), '')
                          || '0'
                          || COALESCE (RIGHT ( (EXTRACT (YEAR FROM inDateStart) ::TVarChar), 2), '')
                     FROM ObjectString AS ObjectString_PatternCIN
                     WHERE ObjectString_PatternCIN.ObjectId = inModelId
                       AND ObjectString_PatternCIN.DescId   = zc_ObjectString_ProdModel_PatternCIN()
                     );
       END IF;

   END IF;

   -- сохраняем модель и дату производства , что б при изменениее понимать к какому расчитан СIN
   /*IF COALESCE (inId,0) <> 0
   THEN
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Model(), inId, inModelId);
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateStart(), inId, inDateStart);
   END IF;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.21         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Product_CIN(0,1903, Null ::TDateTime, ''::TVarChar , '5'::TVarChar)
