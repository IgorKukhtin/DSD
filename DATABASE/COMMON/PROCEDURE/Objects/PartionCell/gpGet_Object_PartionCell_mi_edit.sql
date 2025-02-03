-- Function: gpGet_Object_PartionCell_mi_edit()

DROP FUNCTION IF EXISTS gpGet_Object_PartionCell_mi_edit (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                        , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                         );

CREATE OR REPLACE FUNCTION gpGet_Object_PartionCell_mi_edit(
    IN inPartionCellId_1       Integer,
    IN inPartionCellId_2       Integer,
    IN inPartionCellId_3       Integer,
    IN inPartionCellId_4       Integer,
    IN inPartionCellId_5       Integer,
    IN inPartionCellId_6       Integer,
    IN inPartionCellId_7       Integer,
    IN inPartionCellId_8       Integer,
    IN inPartionCellId_9       Integer,
    IN inPartionCellId_10      Integer,
    IN inPartionCellId_11      Integer,
    IN inPartionCellId_12      Integer,
    IN inPartionCellId_13      Integer,
    IN inPartionCellId_14      Integer,
    IN inPartionCellId_15      Integer,
    IN inPartionCellId_16      Integer,
    IN inPartionCellId_17      Integer,
    IN inPartionCellId_18      Integer,
    IN inPartionCellId_19      Integer,
    IN inPartionCellId_20      Integer,
    IN inPartionCellId_21      Integer,
    IN inPartionCellId_22      Integer,
    IN inPartionCellName_1     TVarChar, --
    IN inPartionCellName_2     TVarChar,
    IN inPartionCellName_3     TVarChar,
    IN inPartionCellName_4     TVarChar,
    IN inPartionCellName_5     TVarChar,
    IN inPartionCellName_6     TVarChar, --
    IN inPartionCellName_7     TVarChar,
    IN inPartionCellName_8     TVarChar,
    IN inPartionCellName_9     TVarChar,
    IN inPartionCellName_10    TVarChar,
    IN inPartionCellName_11    TVarChar,
    IN inPartionCellName_12    TVarChar,
    IN inPartionCellName_13    TVarChar,
    IN inPartionCellName_14    TVarChar,
    IN inPartionCellName_15    TVarChar,
    IN inPartionCellName_16    TVarChar,
    IN inPartionCellName_17    TVarChar,
    IN inPartionCellName_18    TVarChar,
    IN inPartionCellName_19    TVarChar,
    IN inPartionCellName_20    TVarChar,
    IN inPartionCellName_21    TVarChar,
    IN inPartionCellName_22    TVarChar,
   OUT outExecForm             Boolean,       --
   OUT outIsLock_record        Boolean,       --
    IN inSession               TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbPartionCellId_1  Integer;
   DECLARE vbPartionCellId_2  Integer;
   DECLARE vbPartionCellId_3  Integer;
   DECLARE vbPartionCellId_4  Integer;
   DECLARE vbPartionCellId_5  Integer;
   DECLARE vbPartionCellId_6  Integer;
   DECLARE vbPartionCellId_7  Integer;
   DECLARE vbPartionCellId_8  Integer;
   DECLARE vbPartionCellId_9  Integer;
   DECLARE vbPartionCellId_10 Integer;
   DECLARE vbPartionCellId_11 Integer;
   DECLARE vbPartionCellId_12 Integer;
   DECLARE vbPartionCellId_13 Integer;
   DECLARE vbPartionCellId_14 Integer;
   DECLARE vbPartionCellId_15 Integer;
   DECLARE vbPartionCellId_16 Integer;
   DECLARE vbPartionCellId_17 Integer;
   DECLARE vbPartionCellId_18 Integer;
   DECLARE vbPartionCellId_19 Integer;
   DECLARE vbPartionCellId_20 Integer;
   DECLARE vbPartionCellId_21 Integer;
   DECLARE vbPartionCellId_22 Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     IF NOT EXISTS (SELECT 1 FROM ObjectString AS OS WHERE OS.ObjectId = vbUserId AND OS.DescId = zc_ObjectString_User_Key() AND OS.ValueData <> '')
     THEN
         -- НЕ Вызывается диалог
         outExecForm:= FALSE;
         outIsLock_record:= FALSE;

     ELSE
         --  1
         IF inPartionCellName_1 ILIKE '%отбор%' OR TRIM (inPartionCellName_1) = '0'
         THEN
             vbPartionCellId_1:= zc_PartionCell_RK();
         ELSEIF TRIM (inPartionCellName_1) = '1'
         THEN
             vbPartionCellId_1:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_1, '')) <> ''
             THEN
                 -- если ввели код
                 IF zfConvert_StringToNumber (inPartionCellName_1) <> 0
                 THEN
                     -- поиск по коду
                     vbPartionCellId_1:= (SELECT Object.Id
                                          FROM Object
                                          WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_1)
                                            AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     -- поиск по названию
                     vbPartionCellId_1:= (SELECT Object.Id
                                          FROM Object
                                          WHERE TRIM (Object.ValueData) ILIKE TRIM (inPartionCellName_1)
                                            AND Object.DescId           = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_1, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_1:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_1)
                                             );
                     END IF;

                 END IF;
                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_1, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_1;
                 END IF;

             ELSE
                 -- обнулили
                 vbPartionCellId_1:= NULL;
             END IF;

         END IF;


         --  2
         IF inPartionCellName_2 ILIKE '%отбор%' OR TRIM (inPartionCellName_2) = '0'
         THEN
             vbPartionCellId_2:= zc_PartionCell_RK();
         ELSEIF TRIM (inPartionCellName_2) = '1'
         THEN
             vbPartionCellId_2:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_2, '')) <> ''
             THEN
                 -- если ввели код
                 IF zfConvert_StringToNumber (inPartionCellName_2) <> 0
                 THEN
                     -- поиск по коду
                     vbPartionCellId_2:= (SELECT Object.Id
                                          FROM Object
                                          WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_2)
                                            AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     -- поиск по названию
                     vbPartionCellId_2:= (SELECT Object.Id
                                          FROM Object
                                          WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_2))
                                            AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_2, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_2:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_2)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_2, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_2;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_2:= NULL;
             END IF;

         END IF;


         --  3
         IF inPartionCellName_3 ILIKE '%отбор%' OR TRIM (inPartionCellName_3) = '0'
         THEN
             vbPartionCellId_3:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_3) = '1'
         THEN
             vbPartionCellId_3:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_3, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_3) <> 0
                 THEN
                     -- поиск по коду
                     vbPartionCellId_3:= (SELECT Object.Id
                                          FROM Object
                                          WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_3)
                                            AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     -- поиск по названию
                     vbPartionCellId_3:= (SELECT Object.Id
                                          FROM Object
                                          WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_3))
                                            AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_3, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_3:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_3)
                                             );
                     END IF;
                 END IF;
                 --если не нашли ошибка
                 IF COALESCE (vbPartionCellId_3, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_3;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_3:= NULL;
             END IF;

         END IF;


         --  4
         IF inPartionCellName_4 ILIKE '%отбор%' OR TRIM (inPartionCellName_4) = '0'
         THEN
             vbPartionCellId_4:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_4) = '1'
         THEN
             vbPartionCellId_4:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_4, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_4) <> 0
                 THEN
                     -- поиск по коду
                     vbPartionCellId_4:= (SELECT Object.Id
                                          FROM Object
                                          WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_4)
                                            AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     -- поиск по названию
                     vbPartionCellId_4:= (SELECT Object.Id
                                          FROM Object
                                          WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_4))
                                            AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_4, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_4:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_4)
                                             );
                     END IF;
                 END IF;
                 --если не нашли ошибка
                 IF COALESCE (vbPartionCellId_4, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_4;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_4:= NULL;
             END IF;

         END IF;


         --  5
         IF inPartionCellName_5 ILIKE '%отбор%' OR TRIM (inPartionCellName_5) = '0'
         THEN
             vbPartionCellId_5:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_5) = '1'
         THEN
             vbPartionCellId_5:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_5, '')) <> ''
             THEN
                 -- если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_5) <> 0
                 THEN
                     vbPartionCellId_5:= (SELECT Object.Id
                                          FROM Object
                                          WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_5)
                                            AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_5:= (SELECT Object.Id
                                          FROM Object
                                          WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_5))
                                            AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_5, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_5:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_5)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_5, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_5;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_5:= NULL;
             END IF;

         END IF;


         --  6
         IF inPartionCellName_6 ILIKE '%отбор%' OR TRIM (inPartionCellName_6) = '0'
         THEN
             vbPartionCellId_6:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_6) = '1'
         THEN
             vbPartionCellId_6:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_6, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_6) <> 0
                 THEN
                     vbPartionCellId_6:= (SELECT Object.Id
                                          FROM Object
                                          WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_6)
                                            AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_6:= (SELECT Object.Id
                                          FROM Object
                                          WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_6))
                                            AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_6, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_6:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_6)
                                             );
                     END IF;
                 END IF;

                 --если не нашли ошибка
                 IF COALESCE (vbPartionCellId_6, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_6;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_6:= NULL;
             END IF;

         END IF;


         --  7
         IF inPartionCellName_7 ILIKE '%отбор%' OR TRIM (inPartionCellName_7) = '0'
         THEN
             vbPartionCellId_7:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_7) = '1'
         THEN
             vbPartionCellId_7:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_7, '')) <> ''
             THEN
                 -- если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_7) <> 0
                 THEN
                     vbPartionCellId_7:= (SELECT Object.Id
                                          FROM Object
                                          WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_7)
                                            AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_7:= (SELECT Object.Id
                                          FROM Object
                                          WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_7))
                                            AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_7, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_7:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_7)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_7, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_7;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_7:= NULL;
             END IF;

         END IF;


         --  8
         IF inPartionCellName_8 ILIKE '%отбор%' OR TRIM (inPartionCellName_8) = '0'
         THEN
             vbPartionCellId_8:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_8) = '1'
         THEN
             vbPartionCellId_8:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_8, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_8) <> 0
                 THEN
                     vbPartionCellId_8:= (SELECT Object.Id
                                          FROM Object
                                          WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_8)
                                            AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_8:= (SELECT Object.Id
                                          FROM Object
                                          WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_8))
                                            AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_8, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_8:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_8)
                                             );
                     END IF;
                 END IF;

                 --если не нашли ошибка
                 IF COALESCE (vbPartionCellId_8, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_8;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_8:= NULL;
             END IF;

         END IF;


         --  9
         IF inPartionCellName_9 ILIKE '%отбор%' OR TRIM (inPartionCellName_9) = '0'
         THEN
             vbPartionCellId_9:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_9) = '1'
         THEN
             vbPartionCellId_9:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_9, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_9) <> 0
                 THEN
                     vbPartionCellId_9:= (SELECT Object.Id
                                          FROM Object
                                          WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_9)
                                            AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_9:= (SELECT Object.Id
                                          FROM Object
                                          WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_9))
                                            AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_9, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_9:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_9)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_9, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_9;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_9:= NULL;
             END IF;

         END IF;


         --  10
         IF inPartionCellName_10 ILIKE '%отбор%' OR TRIM (inPartionCellName_10) = '0'
         THEN
             vbPartionCellId_10:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_10) = '1'
         THEN
             vbPartionCellId_10:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_10, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_10) <> 0
                 THEN
                     vbPartionCellId_10:= (SELECT Object.Id
                                           FROM Object
                                           WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_10)
                                             AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_10:= (SELECT Object.Id
                                           FROM Object
                                           WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_10))
                                             AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_10, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_10:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_10)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_10, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_10;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_10:= NULL;
             END IF;

         END IF;


         --  11
         IF inPartionCellName_11 ILIKE '%отбор%' OR TRIM (inPartionCellName_11) = '0'
         THEN
             vbPartionCellId_11:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_11) = '1'
         THEN
             vbPartionCellId_11:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_11, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_11) <> 0
                 THEN
                     vbPartionCellId_11:= (SELECT Object.Id
                                           FROM Object
                                           WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_11)
                                             AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_11:= (SELECT Object.Id
                                           FROM Object
                                           WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_11))
                                             AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_11, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_11:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_11)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_11, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_11;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_11:= NULL;
             END IF;

         END IF;


         --  12
         IF inPartionCellName_12 ILIKE '%отбор%' OR TRIM (inPartionCellName_12) = '0'
         THEN
             vbPartionCellId_12:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_12) = '1'
         THEN
             vbPartionCellId_12:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_12, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_12) <> 0
                 THEN
                     vbPartionCellId_12:= (SELECT Object.Id
                                           FROM Object
                                           WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_12)
                                             AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_12:= (SELECT Object.Id
                                           FROM Object
                                           WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_12))
                                             AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_12, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_12:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_12)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_12, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_12;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_12:= NULL;
             END IF;

         END IF;

         --  13
         IF inPartionCellName_13 ILIKE '%отбор%' OR TRIM (inPartionCellName_13) = '0'
         THEN
             vbPartionCellId_13:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_13) = '1'
         THEN
             vbPartionCellId_13:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_13, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_13) <> 0
                 THEN
                     vbPartionCellId_13:= (SELECT Object.Id
                                           FROM Object
                                           WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_13)
                                             AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_13:= (SELECT Object.Id
                                           FROM Object
                                           WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_13))
                                             AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_13, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_13:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_13)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_13, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_13;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_13:= NULL;
             END IF;

         END IF;

         --  14
         IF inPartionCellName_14 ILIKE '%отбор%' OR TRIM (inPartionCellName_14) = '0'
         THEN
             vbPartionCellId_14:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_14) = '1'
         THEN
             vbPartionCellId_14:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_14, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_14) <> 0
                 THEN
                     vbPartionCellId_14:= (SELECT Object.Id
                                           FROM Object
                                           WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_14)
                                             AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_14:= (SELECT Object.Id
                                           FROM Object
                                           WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_14))
                                             AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_14, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_14:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_14)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_14, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_14;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_14:= NULL;
             END IF;

         END IF;

         --  15
         IF inPartionCellName_15 ILIKE '%отбор%' OR TRIM (inPartionCellName_15) = '0'
         THEN
             vbPartionCellId_15:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_15) = '1'
         THEN
             vbPartionCellId_15:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_15, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_15) <> 0
                 THEN
                     vbPartionCellId_15:= (SELECT Object.Id
                                           FROM Object
                                           WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_15)
                                             AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_15:= (SELECT Object.Id
                                           FROM Object
                                           WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_15))
                                             AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_15, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_15:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_15)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_15, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_15;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_15:= NULL;
             END IF;

         END IF;

         --  16
         IF inPartionCellName_16 ILIKE '%отбор%' OR TRIM (inPartionCellName_16) = '0'
         THEN
             vbPartionCellId_16:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_16) = '1'
         THEN
             vbPartionCellId_16:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_16, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_16) <> 0
                 THEN
                     vbPartionCellId_16:= (SELECT Object.Id
                                           FROM Object
                                           WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_16)
                                             AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_16:= (SELECT Object.Id
                                           FROM Object
                                           WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_16))
                                             AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_16, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_16:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_16)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_16, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_16;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_16:= NULL;
             END IF;

         END IF;

         --  17
         IF inPartionCellName_17 ILIKE '%отбор%' OR TRIM (inPartionCellName_17) = '0'
         THEN
             vbPartionCellId_17:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_17) = '1'
         THEN
             vbPartionCellId_17:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_17, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_17) <> 0
                 THEN
                     vbPartionCellId_17:= (SELECT Object.Id
                                           FROM Object
                                           WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_17)
                                             AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_17:= (SELECT Object.Id
                                           FROM Object
                                           WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_17))
                                             AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_17, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_17:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_17)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_17, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_17;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_17:= NULL;
             END IF;

         END IF;


         --  18
         IF inPartionCellName_18 ILIKE '%отбор%' OR TRIM (inPartionCellName_18) = '0'
         THEN
             vbPartionCellId_18:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_18) = '1'
         THEN
             vbPartionCellId_18:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_18, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_18) <> 0
                 THEN
                     vbPartionCellId_18:= (SELECT Object.Id
                                           FROM Object
                                           WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_18)
                                             AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_18:= (SELECT Object.Id
                                           FROM Object
                                           WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_18))
                                             AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_18, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_18:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_18)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_18, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_18;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_18:= NULL;
             END IF;

         END IF;


         --  19
         IF inPartionCellName_19 ILIKE '%отбор%' OR TRIM (inPartionCellName_19) = '0'
         THEN
             vbPartionCellId_19:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_19) = '1'
         THEN
             vbPartionCellId_19:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_19, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_19) <> 0
                 THEN
                     vbPartionCellId_19:= (SELECT Object.Id
                                           FROM Object
                                           WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_19)
                                             AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_19:= (SELECT Object.Id
                                           FROM Object
                                           WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_19))
                                             AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_19, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_19:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_19)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_19, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_19;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_19:= NULL;
             END IF;

         END IF;


         --  20
         IF inPartionCellName_20 ILIKE '%отбор%' OR TRIM (inPartionCellName_20) = '0'
         THEN
             vbPartionCellId_20:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_20) = '1'
         THEN
             vbPartionCellId_20:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_20, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_20) <> 0
                 THEN
                     vbPartionCellId_20:= (SELECT Object.Id
                                           FROM Object
                                           WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_20)
                                             AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_20:= (SELECT Object.Id
                                           FROM Object
                                           WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_20))
                                             AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_20, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_20:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_20)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_20, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_20;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_20:= NULL;
             END IF;

         END IF;

         --  21
         IF inPartionCellName_21 ILIKE '%отбор%' OR TRIM (inPartionCellName_21) = '0'
         THEN
             vbPartionCellId_21:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_21) = '1'
         THEN
             vbPartionCellId_21:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_21, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_21) <> 0
                 THEN
                     vbPartionCellId_21:= (SELECT Object.Id
                                           FROM Object
                                           WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_21)
                                             AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_21:= (SELECT Object.Id
                                           FROM Object
                                           WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_21))
                                             AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_21, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_21:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_21)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_21, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_21;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_21:= NULL;
             END IF;

         END IF;

         --  22
         IF inPartionCellName_22 ILIKE '%отбор%' OR TRIM (inPartionCellName_22) = '0'
         THEN
             vbPartionCellId_22:= zc_PartionCell_RK();

         ELSEIF TRIM (inPartionCellName_22) = '1'
         THEN
             vbPartionCellId_22:= zc_PartionCell_Err();
         ELSE
             IF TRIM (COALESCE (inPartionCellName_22, '')) <> ''
             THEN
                 --если ввели код ищем по коду, иначе по названию
                 IF zfConvert_StringToNumber (inPartionCellName_22) <> 0
                 THEN
                     vbPartionCellId_22:= (SELECT Object.Id
                                           FROM Object
                                           WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName_22)
                                             AND Object.DescId     = zc_Object_PartionCell());
                 ELSE
                     vbPartionCellId_22:= (SELECT Object.Id
                                           FROM Object
                                           WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName_22))
                                             AND Object.DescId     = zc_Object_PartionCell());
                     -- поиск без разделителя
                     IF COALESCE (vbPartionCellId_22, 0) = 0
                     THEN
                         -- поиск
                         vbPartionCellId_22:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                              SELECT tmpPartionCell.Id
                                              FROM tmpPartionCell
                                              WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (inPartionCellName_22)
                                             );
                     END IF;
                 END IF;

                 -- если не нашли ошибка
                 IF COALESCE (vbPartionCellId_22, 0) = 0
                 THEN
                     RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', inPartionCellName_22;
                 END IF;
             ELSE
                 -- обнулили
                 vbPartionCellId_22:= NULL;
             END IF;

         END IF;


         -- если поставили в ошибку
         IF  (vbPartionCellId_1  = zc_PartionCell_Err() AND COALESCE (inPartionCellId_1, 0)  <> zc_PartionCell_Err())
          OR (vbPartionCellId_2  = zc_PartionCell_Err() AND COALESCE (inPartionCellId_2, 0)  <> zc_PartionCell_Err())
          OR (vbPartionCellId_3  = zc_PartionCell_Err() AND COALESCE (inPartionCellId_3, 0)  <> zc_PartionCell_Err())
          OR (vbPartionCellId_4  = zc_PartionCell_Err() AND COALESCE (inPartionCellId_4, 0)  <> zc_PartionCell_Err())
          OR (vbPartionCellId_5  = zc_PartionCell_Err() AND COALESCE (inPartionCellId_5, 0)  <> zc_PartionCell_Err())
          OR (vbPartionCellId_6  = zc_PartionCell_Err() AND COALESCE (inPartionCellId_6, 0)  <> zc_PartionCell_Err())
          OR (vbPartionCellId_7  = zc_PartionCell_Err() AND COALESCE (inPartionCellId_7, 0)  <> zc_PartionCell_Err())
          OR (vbPartionCellId_8  = zc_PartionCell_Err() AND COALESCE (inPartionCellId_8, 0)  <> zc_PartionCell_Err())
          OR (vbPartionCellId_9  = zc_PartionCell_Err() AND COALESCE (inPartionCellId_9, 0)  <> zc_PartionCell_Err())
          OR (vbPartionCellId_10 = zc_PartionCell_Err() AND COALESCE (inPartionCellId_10, 0) <> zc_PartionCell_Err())
          OR (vbPartionCellId_11 = zc_PartionCell_Err() AND COALESCE (inPartionCellId_11, 0) <> zc_PartionCell_Err())
          OR (vbPartionCellId_12 = zc_PartionCell_Err() AND COALESCE (inPartionCellId_12, 0) <> zc_PartionCell_Err())
          OR (vbPartionCellId_13 = zc_PartionCell_Err() AND COALESCE (inPartionCellId_13, 0) <> zc_PartionCell_Err())
          OR (vbPartionCellId_14 = zc_PartionCell_Err() AND COALESCE (inPartionCellId_14, 0) <> zc_PartionCell_Err())
          OR (vbPartionCellId_15 = zc_PartionCell_Err() AND COALESCE (inPartionCellId_15, 0) <> zc_PartionCell_Err())
          OR (vbPartionCellId_16 = zc_PartionCell_Err() AND COALESCE (inPartionCellId_16, 0) <> zc_PartionCell_Err())
          OR (vbPartionCellId_17 = zc_PartionCell_Err() AND COALESCE (inPartionCellId_17, 0) <> zc_PartionCell_Err())
          OR (vbPartionCellId_18 = zc_PartionCell_Err() AND COALESCE (inPartionCellId_18, 0) <> zc_PartionCell_Err())
          OR (vbPartionCellId_19 = zc_PartionCell_Err() AND COALESCE (inPartionCellId_19, 0) <> zc_PartionCell_Err())
          OR (vbPartionCellId_20 = zc_PartionCell_Err() AND COALESCE (inPartionCellId_20, 0) <> zc_PartionCell_Err())
          OR (vbPartionCellId_21 = zc_PartionCell_Err() AND COALESCE (inPartionCellId_21, 0) <> zc_PartionCell_Err())
          OR (vbPartionCellId_22 = zc_PartionCell_Err() AND COALESCE (inPartionCellId_22, 0) <> zc_PartionCell_Err())
         THEN -- Вызывается диалог
              outExecForm:= TRUE;
              outIsLock_record:= TRUE;
         ELSE -- НЕ Вызывается диалог
              outExecForm:= FALSE;
              outIsLock_record:= FALSE;
         END IF;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.02.25                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_PartionCell_mi_edit ('1', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '5')
