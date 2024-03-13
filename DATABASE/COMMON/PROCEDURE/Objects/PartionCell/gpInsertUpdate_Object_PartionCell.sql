-- Function: gpInsertUpdate_Object_PartionCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartionCell (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartionCell(
 INOUT ioId	          Integer,   	-- ключ объекта <Единица измерения>
    IN inCode         Integer,      -- свойство <Код Единицы измерения>
    IN inName         TVarChar,     -- главное Название Единицы измерения
    IN inLevel        TFloat,
    IN inLength       TFloat,
    IN inWidth        TFloat,
    IN inHeight       TFloat, 
    IN inBoxCount     TFloat,
    IN inRowBoxCount  TFloat,
    IN inRowWidth     TFloat,
    IN inRowHeight    TFloat,
    IN inComment      TVarChar,
    IN inSession      TVarChar      -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PartionCell());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его
   inCode:=CASE WHEN inCode < 0 THEN lfGet_ObjectCode (inCode, zc_Object_PartionCell()) ELSE inCode END;

   -- проверка уникальности для свойства <Наименование Единицы измерения>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PartionCell(), inName);
   -- проверка уникальности для свойства <Код Единицы измерения>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PartionCell(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_PartionCell(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PartionCell_Comment(), ioId, inComment);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_Level(), ioId, inLevel);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_Length(), ioId, inLength);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_Width(), ioId, inWidth);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_Height(), ioId, inHeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_BoxCount(), ioId, inBoxCount);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_RowBoxCount(), ioId, inRowBoxCount);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_RowWidth(), ioId, inRowWidth);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_RowHeight(), ioId, inRowHeight);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 28.12.23         *

*/

-- тест
-- 

/*
--перенумеровать по Level

UPDATE Object
 SET ObjectCode = tmp.Ord 
 FROM (SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name 
           , ROW_NUMBER() OVER (ORDER BY ObjectFloat_Level.ValueData
                                       , zfConvert_StringToNumber (zfCalc_Word_Split (inValue:= Object.ValueData, inSep:= '-', inIndex:=2))::Integer
                                       --, zfConvert_StringToNumber (zfCalc_Word_Split (inValue:= Object.ValueData, inSep:= '-', inIndex:=3))::Integer
                                       , zfConvert_StringToNumber (zfCalc_Word_Split (inValue:= Object.ValueData, inSep:= '-', inIndex:=4))::Integer
                                       , zfConvert_StringToNumber (zfCalc_Word_Split (inValue:= Object.ValueData, inSep:= '-', inIndex:=3))::Integer
                                ) ::Integer AS Ord

           , Object.isErased   AS isErased

       FROM Object
        LEFT JOIN ObjectFloat AS ObjectFloat_Level
                              ON ObjectFloat_Level.ObjectId = Object.Id
                             AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()

       WHERE Object.DescId = zc_Object_PartionCell() 
         AND Object.isErased = FALSE
         AND Object.ObjectCode > 0
       ) as tmp
 WHERE Object.DescId = zc_Object_PartionCell()
   AND Object.Id = tmp.Id; 

*/