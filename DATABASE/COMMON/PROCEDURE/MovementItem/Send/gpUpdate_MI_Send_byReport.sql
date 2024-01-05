-- Function: gpUpdate_MI_Send_byReport()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_byReport (Integer, Integer, Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_byReport(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId        Integer   , -- Ключ объекта <Элемент документа>  
    IN inGoodsId               Integer  ,
    IN inGoodsKindId           Integer  ,
    IN inPartionGoodsDate      TDateTime , -- 
 INOUT ioPartionCellName_1     TVarChar   , -- 
 INOUT ioPartionCellName_2     TVarChar   ,
 INOUT ioPartionCellName_3     TVarChar   ,
 INOUT ioPartionCellName_4     TVarChar   ,
 INOUT ioPartionCellName_5     TVarChar   ,
 INOUT ioPartionCellName_6     TVarChar   , -- 
 INOUT ioPartionCellName_7     TVarChar   ,
 INOUT ioPartionCellName_8     TVarChar   ,
 INOUT ioPartionCellName_9     TVarChar   ,
 INOUT ioPartionCellName_10    TVarChar   ,
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPartionCellId_1 Integer;
   DECLARE vbPartionCellId_2 Integer;
   DECLARE vbPartionCellId_3 Integer;
   DECLARE vbPartionCellId_4 Integer;
   DECLARE vbPartionCellId_5 Integer;
   DECLARE vbPartionCellId_6 Integer;
   DECLARE vbPartionCellId_7 Integer;
   DECLARE vbPartionCellId_8 Integer;
   DECLARE vbPartionCellId_9 Integer;
   DECLARE vbPartionCellId_10 Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     --  1  
     IF COALESCE (ioPartionCellName_1, '') <> '' THEN
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_1) <> 0
         THEN
             vbPartionCellId_1:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_1)
                                  AND Object.DescId     = zc_Object_PartionCell());
         ELSE
             vbPartionCellId_1:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_1))
                                  AND Object.DescId     = zc_Object_PartionCell());
         END IF;
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId_1,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_1;
         END IF;
     ELSE 
         vbPartionCellId_1 := Null :: Integer;
     END IF;

     --  2  
     IF COALESCE (ioPartionCellName_2, '') <> '' THEN
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_2) <> 0
         THEN
             vbPartionCellId_2:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_2)
                                  AND Object.DescId     = zc_Object_PartionCell());
         ELSE
             vbPartionCellId_2:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_2))
                                  AND Object.DescId     = zc_Object_PartionCell());
         END IF;
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId_2,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_2;
         END IF;
     ELSE 
         vbPartionCellId_2 := Null :: Integer;
     END IF;

     --  3 
     IF COALESCE (ioPartionCellName_3, '') <> '' THEN
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_3) <> 0
         THEN
             vbPartionCellId_3:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_3)
                                  AND Object.DescId     = zc_Object_PartionCell());
         ELSE
             vbPartionCellId_3:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_3))
                                  AND Object.DescId     = zc_Object_PartionCell());
         END IF;
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId_3,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_3;
         END IF;
     ELSE 
         vbPartionCellId_3 := Null :: Integer;
     END IF;

     --  4  
     IF COALESCE (ioPartionCellName_4, '') <> '' THEN
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_4) <> 0
         THEN
             vbPartionCellId_4:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_4)
                                  AND Object.DescId     = zc_Object_PartionCell());
         ELSE
             vbPartionCellId_4:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_4))
                                  AND Object.DescId     = zc_Object_PartionCell());
         END IF;
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId_4,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_4;
         END IF;
     ELSE 
         vbPartionCellId_4 := Null :: Integer;
     END IF;

     --  5  
     IF COALESCE (ioPartionCellName_5, '') <> '' THEN
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_5) <> 0
         THEN
             vbPartionCellId_5:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_5)
                                  AND Object.DescId     = zc_Object_PartionCell());
         ELSE
             vbPartionCellId_5:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_5))
                                  AND Object.DescId     = zc_Object_PartionCell());
         END IF;
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId_5,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_5;
         END IF;
     ELSE 
         vbPartionCellId_5 := Null :: Integer;
     END IF;

     --  6  
     IF COALESCE (ioPartionCellName_6, '') <> '' THEN
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_6) <> 0
         THEN
             vbPartionCellId_6:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_6)
                                  AND Object.DescId     = zc_Object_PartionCell());
         ELSE
             vbPartionCellId_6:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_6))
                                  AND Object.DescId     = zc_Object_PartionCell());
         END IF;
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId_6,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_6;
         END IF;
     ELSE 
         vbPartionCellId_6 := Null :: Integer;
     END IF;

     --  7  
     IF COALESCE (ioPartionCellName_7, '') <> '' THEN
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_7) <> 0
         THEN
             vbPartionCellId_7:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_7)
                                  AND Object.DescId     = zc_Object_PartionCell());
         ELSE
             vbPartionCellId_7:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_7))
                                  AND Object.DescId     = zc_Object_PartionCell());
         END IF;
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId_7,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_7;
         END IF;
     ELSE 
         vbPartionCellId_7 := Null :: Integer;
     END IF;

     --  8  
     IF COALESCE (ioPartionCellName_8, '') <> '' THEN
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_8) <> 0
         THEN
             vbPartionCellId_8:= (SELECT Object.Id
                                  FROM Object
                                  WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_8)
                                    AND Object.DescId     = zc_Object_PartionCell());
         ELSE
             vbPartionCellId_8:= (SELECT Object.Id
                                  FROM Object
                                  WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_8))
                                    AND Object.DescId     = zc_Object_PartionCell());
         END IF;
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId_8,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_8;
         END IF;
     ELSE 
         vbPartionCellId_8 := Null :: Integer;
     END IF;

     --  9  
     IF COALESCE (ioPartionCellName_9, '') <> '' THEN
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_9) <> 0
         THEN
             vbPartionCellId_9:= (SELECT Object.Id
                                  FROM Object
                                  WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_9)
                                    AND Object.DescId     = zc_Object_PartionCell());
         ELSE
             vbPartionCellId_9:= (SELECT Object.Id
                                  FROM Object
                                  WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_9))
                                    AND Object.DescId     = zc_Object_PartionCell());
         END IF;
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId_9,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_9;
         END IF;
     ELSE 
         vbPartionCellId_9 := Null :: Integer;
     END IF;

     --  10 
     IF COALESCE (ioPartionCellName_10, '') <> '' THEN
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_10) <> 0
         THEN
             vbPartionCellId_10:= (SELECT Object.Id
                                   FROM Object
                                   WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_10)
                                     AND Object.DescId     = zc_Object_PartionCell());
         ELSE
             vbPartionCellId_10:= (SELECT Object.Id
                                  FROM Object
                                  WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_10))
                                    AND Object.DescId     = zc_Object_PartionCell());
         END IF;
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId_1,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_10;
         END IF;
     ELSE 
         vbPartionCellId_10 := Null :: Integer;
     END IF;


     
     ioPartionCellName_1  := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId_1 );
     ioPartionCellName_2  := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId_2 );
     ioPartionCellName_3  := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId_3 );
     ioPartionCellName_4  := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId_4 );
     ioPartionCellName_5  := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId_5 );
     ioPartionCellName_6  := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId_6 );
     ioPartionCellName_7  := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId_7 );
     ioPartionCellName_8  := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId_8 );
     ioPartionCellName_9  := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId_9 );
     ioPartionCellName_10 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId_10); 
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.24         *
*/

-- тест
--