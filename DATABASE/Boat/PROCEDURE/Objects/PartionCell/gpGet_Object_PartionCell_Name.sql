-- Function: gpGet_Object_PartionCell_Name()

DROP FUNCTION IF EXISTS gpGet_Object_PartionCell_Name (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PartionCell_Name(
     IN inPartionCellName   TVarChar ,      -- 
     IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             ) AS                
$BODY$
      DECLARE vbPartionCellId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры

     --находим ячейку хранения, если нет такой создаем
     IF COALESCE (inPartionCellName, '') <> '' THEN
         -- !!!поиск ИД !!! 
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (inPartionCellName) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --если не нашли ошибка
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 RAISE EXCEPTION 'Ошибка.Не найдена ячейка с кодом <%>.', inPartionCellName;
             END IF;
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --если не нашли ошибка
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName;
             END IF;
         END IF;
         --
     ELSE 
         vbPartionCellId := NULL ::Integer;
     END IF;


       RETURN QUERY
       SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
       FROM Object 
       WHERE Object.Id = vbPartionCellId
       ;


END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.01.24         *
*/

-- тест
-- SELECT * FROM gpGet_Object_PartionCell_Name('3','2')