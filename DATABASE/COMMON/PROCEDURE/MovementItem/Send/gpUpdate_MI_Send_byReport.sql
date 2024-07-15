-- Function: gpUpdate_MI_Send_byReport()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_byReport (Integer, TDateTime,TDateTime, Integer, Integer, Integer, Integer, TDateTime
                                                 , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                 , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_byReport (Integer, TDateTime,TDateTime, Integer, Integer, Integer, Integer, TDateTime
                                                 , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                 , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_byReport(
    IN inUnitId                Integer  , --
    IN inStartDate             TDateTime,
    IN inEndDate               TDateTime,
    IN inMovementId            Integer,
    IN inMovementItemId        Integer,
    IN inGoodsId               Integer,
    IN inGoodsKindId           Integer,
    IN inPartionGoodsDate      TDateTime, --
 INOUT ioPartionCellId_1       Integer,
 INOUT ioPartionCellId_2       Integer,
 INOUT ioPartionCellId_3       Integer,
 INOUT ioPartionCellId_4       Integer,
 INOUT ioPartionCellId_5       Integer,
 INOUT ioPartionCellId_6       Integer,
 INOUT ioPartionCellId_7       Integer,
 INOUT ioPartionCellId_8       Integer,
 INOUT ioPartionCellId_9       Integer,
 INOUT ioPartionCellId_10      Integer,
    IN inOrd                   Integer, --є пп
   OUT outPartionCellId_last   Integer,
 INOUT ioPartionCellName_1     TVarChar, --
 INOUT ioPartionCellName_2     TVarChar,
 INOUT ioPartionCellName_3     TVarChar,
 INOUT ioPartionCellName_4     TVarChar,
 INOUT ioPartionCellName_5     TVarChar,
 INOUT ioPartionCellName_6     TVarChar, --
 INOUT ioPartionCellName_7     TVarChar,
 INOUT ioPartionCellName_8     TVarChar,
 INOUT ioPartionCellName_9     TVarChar,
 INOUT ioPartionCellName_10    TVarChar,  
   OUT outisPrint              Boolean,
    IN inSession               TVarChar  -- сесси€ пользовател€
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

   DECLARE vbPartionCellId_old_1 Integer;
   DECLARE vbPartionCellId_old_2 Integer;
   DECLARE vbPartionCellId_old_3 Integer;
   DECLARE vbPartionCellId_old_4 Integer;
   DECLARE vbPartionCellId_old_5 Integer;
   DECLARE vbPartionCellId_old_6 Integer;
   DECLARE vbPartionCellId_old_7 Integer;
   DECLARE vbPartionCellId_old_8 Integer;
   DECLARE vbPartionCellId_old_9 Integer;
   DECLARE vbPartionCellId_old_10 Integer;

   DECLARE vbIsClose_1  Boolean;
   DECLARE vbIsClose_2  Boolean;
   DECLARE vbIsClose_3  Boolean;
   DECLARE vbIsClose_4  Boolean;
   DECLARE vbIsClose_5  Boolean;
   DECLARE vbIsClose_6  Boolean;
   DECLARE vbIsClose_7  Boolean;
   DECLARE vbIsClose_8  Boolean;
   DECLARE vbIsClose_9  Boolean;
   DECLARE vbIsClose_10 Boolean;
   DECLARE vbMI_Id_check Integer;

BEGIN
     -- проверка прав пользовател€ на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId:= lpGetUserBySession (inSession);


     --обнул€ем последнюю измененную €чейку
     outPartionCellId_last := NULL ::Integer;

if zfConvert_StringToNumber (ioPartionCellName_1) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_1, 1)) > 0   then ioPartionCellName_1     := right (ioPartionCellName_1,  LENGTH(ioPartionCellName_1) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_1, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_1, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_1, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_2) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_2, 1)) > 0   then ioPartionCellName_2     := right (ioPartionCellName_2,  LENGTH(ioPartionCellName_2) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_2, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_2, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_2, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_3) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_3, 1)) > 0   then ioPartionCellName_3     := right (ioPartionCellName_3,  LENGTH(ioPartionCellName_3) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_3, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_3, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_3, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_4) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_4, 1)) > 0   then ioPartionCellName_4     := right (ioPartionCellName_4,  LENGTH(ioPartionCellName_4) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_4, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_4, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_4, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_5) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_5, 1)) > 0   then ioPartionCellName_5     := right (ioPartionCellName_5,  LENGTH(ioPartionCellName_5) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_5, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_5, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_5, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_6) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_6, 1)) > 0   then ioPartionCellName_6     := right (ioPartionCellName_6,  LENGTH(ioPartionCellName_6) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_6, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_6, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_6, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_7) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_7, 1)) > 0   then ioPartionCellName_7     := right (ioPartionCellName_7,  LENGTH(ioPartionCellName_7) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_7, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_7, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_7, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_8) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_8, 1)) > 0   then ioPartionCellName_8     := right (ioPartionCellName_8,  LENGTH(ioPartionCellName_8) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_8, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_8, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_8, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_9) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_9, 1)) > 0   then ioPartionCellName_9     := right (ioPartionCellName_9,  LENGTH(ioPartionCellName_9) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_9, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_9, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_9, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_10) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_10, 1)) > 0  then ioPartionCellName_10    := right (ioPartionCellName_10, LENGTH(ioPartionCellName_10) - CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_10, 4))> 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_10, 3))> 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_10, 2))> 0 THEN 2 ELSE 1 END); end if;


     --  1
     IF ioPartionCellName_1 ILIKE '%отбор%' OR TRIM (ioPartionCellName_1) = '0'
     THEN
         vbPartionCellId_1:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_1, '')) <> ''
         THEN
             -- если ввели код
             IF zfConvert_StringToNumber (ioPartionCellName_1) <> 0
             THEN
                 -- поиск по коду
                 vbPartionCellId_1:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_1)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 -- поиск по названию
                 vbPartionCellId_1:= (SELECT Object.Id
                                      FROM Object
                                      WHERE TRIM (Object.ValueData) ILIKE TRIM (ioPartionCellName_1)
                                        AND Object.DescId           = zc_Object_PartionCell());
             END IF;
             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_1, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_1;
             END IF;

         ELSE
             -- обнулили
             vbPartionCellId_1:= NULL;
         END IF;

     END IF;


     --  2
     IF ioPartionCellName_2 ILIKE '%отбор%' OR TRIM (ioPartionCellName_2) = '0'
     THEN
         vbPartionCellId_2:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_2, '')) <> ''
         THEN
             -- если ввели код
             IF zfConvert_StringToNumber (ioPartionCellName_2) <> 0
             THEN
                 -- поиск по коду
                 vbPartionCellId_2:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_2)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 -- поиск по названию
                 vbPartionCellId_2:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_2))
                                        AND Object.DescId     = zc_Object_PartionCell());
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_2, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_2;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_2:= NULL;
         END IF;

     END IF;


     --  3
     IF ioPartionCellName_3 ILIKE '%отбор%' OR TRIM (ioPartionCellName_3) = '0'
     THEN
         vbPartionCellId_3:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_3, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_3) <> 0
             THEN
                 -- поиск по коду
                 vbPartionCellId_3:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_3)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 -- поиск по названию
                 vbPartionCellId_3:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_3))
                                        AND Object.DescId     = zc_Object_PartionCell());
             END IF;
             --если не нашли ошибка
             IF COALESCE (vbPartionCellId_3, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_3;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_3:= NULL;
         END IF;

     END IF;


     --  4
     IF ioPartionCellName_4 ILIKE '%отбор%' OR TRIM (ioPartionCellName_4) = '0'
     THEN
         vbPartionCellId_4:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_4, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_4) <> 0
             THEN
                 -- поиск по коду
                 vbPartionCellId_4:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_4)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 -- поиск по названию
                 vbPartionCellId_4:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_4))
                                        AND Object.DescId     = zc_Object_PartionCell());
             END IF;
             --если не нашли ошибка
             IF COALESCE (vbPartionCellId_4, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_4;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_4:= NULL;
         END IF;

     END IF;


     --  5
     IF ioPartionCellName_5 ILIKE '%отбор%' OR TRIM (ioPartionCellName_5) = '0'
     THEN
         vbPartionCellId_5:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_5, '')) <> ''
         THEN
             -- если ввели код ищем по коду, иначе по названию
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
             IF COALESCE (vbPartionCellId_5, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_5;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_5:= NULL;
         END IF;

     END IF;


     --  6
     IF ioPartionCellName_6 ILIKE '%отбор%' OR TRIM (ioPartionCellName_6) = '0'
     THEN
         vbPartionCellId_6:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_6, '')) <> ''
         THEN
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
             IF COALESCE (vbPartionCellId_6, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_6;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_6:= NULL;
         END IF;

     END IF;


     --  7
     IF ioPartionCellName_7 ILIKE '%отбор%' OR TRIM (ioPartionCellName_7) = '0'
     THEN
         vbPartionCellId_7:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_7, '')) <> ''
         THEN
             -- если ввели код ищем по коду, иначе по названию
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
             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_7, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_7;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_7:= NULL;
         END IF;

     END IF;


     --  8
     IF ioPartionCellName_8 ILIKE '%отбор%' OR TRIM (ioPartionCellName_8) = '0'
     THEN
         vbPartionCellId_8:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_8, '')) <> ''
         THEN
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
             IF COALESCE (vbPartionCellId_8, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_8;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_8:= NULL;
         END IF;

     END IF;


     --  9
     IF ioPartionCellName_9 ILIKE '%отбор%' OR TRIM (ioPartionCellName_9) = '0'
     THEN
         vbPartionCellId_9:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_9, '')) <> ''
         THEN
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
             IF COALESCE (vbPartionCellId_9, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_9;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_9:= NULL;
         END IF;

     END IF;


     --  10
     IF ioPartionCellName_10 ILIKE '%отбор%' OR TRIM (ioPartionCellName_10) = '0'
     THEN
         vbPartionCellId_10:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_10, '')) <> ''
         THEN
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
             IF COALESCE (vbPartionCellId_10, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_10;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_10:= NULL;
         END IF;

     END IF;


     -- ѕереброска любой €чейки в отбор
     IF inOrd <> 1 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11056843)
        AND zc_PartionCell_RK() IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5
                                  , vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10
                                   )
     THEN
         RAISE EXCEPTION 'ќшибка.Ќет прав перемещать в отбор. є п/п должен быть = 1.';
     END IF;


     -- если дублируютс€ €чейки, объедин€ем
     IF vbPartionCellId_2 <> zc_PartionCell_RK() AND vbPartionCellId_2 IN (vbPartionCellId_1)
     THEN vbPartionCellId_2:= NULL; END IF;

     IF vbPartionCellId_3 <> zc_PartionCell_RK() AND vbPartionCellId_3 IN (vbPartionCellId_1, vbPartionCellId_2)
     THEN vbPartionCellId_3:= NULL; END IF;

     IF vbPartionCellId_4 <> zc_PartionCell_RK() AND vbPartionCellId_4 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3)
     THEN vbPartionCellId_4:= NULL; END IF;

     IF vbPartionCellId_5 <> zc_PartionCell_RK() AND vbPartionCellId_5 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4)
     THEN vbPartionCellId_5:= NULL; END IF;

     IF vbPartionCellId_6 <> zc_PartionCell_RK() AND vbPartionCellId_6 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5)
     THEN vbPartionCellId_6:= NULL; END IF;

     IF vbPartionCellId_7 <> zc_PartionCell_RK() AND vbPartionCellId_7 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6)
     THEN vbPartionCellId_7:= NULL; END IF;

     IF vbPartionCellId_8 <> zc_PartionCell_RK() AND vbPartionCellId_8 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7)
     THEN vbPartionCellId_8:= NULL; END IF;

     IF vbPartionCellId_9 <> zc_PartionCell_RK() AND vbPartionCellId_9 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8)
     THEN vbPartionCellId_9:= NULL; END IF;

     IF vbPartionCellId_10 <> zc_PartionCell_RK() AND vbPartionCellId_10 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9)
     THEN vbPartionCellId_10:= NULL; END IF;


     -- 1. ѕроверка - дл€ €чейки может быть только одна парти€
     IF vbPartionCellId_1 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_1
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%> <%>% <%> <%>.%(%)'
                           , lfGet_Object_ValueData (vbPartionCellId_1)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT  Movement.InvNumber FROM MovementItem AS MI JOIN Movement ON Movement.Id = MI.MovementId WHERE MI.Id = vbMI_Id_check)
                           , (SELECT  zfConvert_DateToString (Movement.OperDate) FROM MovementItem AS MI JOIN Movement ON Movement.Id = MI.MovementId WHERE MI.Id = vbMI_Id_check)
                           , (SELECT  MovementDesc.ItemName FROM MovementItem AS MI JOIN Movement ON Movement.Id = MI.MovementId JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE MI.Id = vbMI_Id_check)
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                           , CHR (13)
                           , vbMI_Id_check
                            ;
         END IF;

     END IF;

     -- 2. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_2 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_2
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_2)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 3. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_3 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_3
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_3)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 4. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_4 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_4
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_4)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- 5. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_5 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_5
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_5)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- 6. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_6 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_6
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_6)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- 7. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_7 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_7
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_7)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 8. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_8 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_8
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_8)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- 9. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_9 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_9
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_9)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- 10. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_10 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_10
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_10)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- сохранить
     IF inMovementItemId <> 0
     THEN
         --
         IF vbPartionCellId_6  <> 0 THEN RAISE EXCEPTION 'ќшибка.ячейка є 6 только дл€ просмотра.'; END IF;
         IF vbPartionCellId_7  <> 0 THEN RAISE EXCEPTION 'ќшибка.ячейка є 7 только дл€ просмотра.'; END IF;
         IF vbPartionCellId_8  <> 0 THEN RAISE EXCEPTION 'ќшибка.ячейка є 8 только дл€ просмотра.'; END IF;
         IF vbPartionCellId_9  <> 0 THEN RAISE EXCEPTION 'ќшибка.ячейка є 9 только дл€ просмотра.'; END IF;
         IF vbPartionCellId_10 <> 0 THEN RAISE EXCEPTION 'ќшибка.ячейка є 10 только дл€ просмотра.'; END IF;

         -- 1. обнулили
         IF COALESCE (vbPartionCellId_1, 0) = 0
         THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inMovementItemId, FALSE);

             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inMovementItemId, NULL);
             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_1 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_old_1:= (SELECT MILO.ObjectId
                                      FROM MovementItemLinkObject AS MILO
                                      WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_1() AND MILO.ObjectId <> zc_PartionCell_RK()
                                     );

             -- если была реальна€ €чейка
             IF vbPartionCellId_old_1 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), inMovementItemId, vbPartionCellId_old_1 :: TFloat);
             ELSE
                 -- попробуем найти, если сохран€ли оригинал
                 vbPartionCellId_old_1:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_1() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inMovementItemId, vbPartionCellId_1);
             -- закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inMovementItemId, TRUE);
             --
             vbIsClose_1:= vbPartionCellId_old_1 > 0;

             --записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_1 ::Integer;

         ELSE
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inMovementItemId, vbPartionCellId_1);
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), inMovementItemId, 0 :: TFloat);
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inMovementItemId, FALSE);

             --записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_1 ::Integer;
         END IF;


         -- 2. обнулили
         IF COALESCE (vbPartionCellId_2, 0) = 0
         THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), inMovementItemId, FALSE);

             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inMovementItemId, NULL);
             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_2(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_2 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_old_2:= (SELECT MILO.ObjectId
                                      FROM MovementItemLinkObject AS MILO
                                      WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_2() AND MILO.ObjectId <> zc_PartionCell_RK()
                                     );

             -- если была реальна€ €чейка
             IF vbPartionCellId_old_2 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_2(), inMovementItemId, vbPartionCellId_old_2 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_2:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_2() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inMovementItemId, vbPartionCellId_2);
             -- закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), inMovementItemId, TRUE);
             --
             vbIsClose_2:= vbPartionCellId_old_2 > 0;

             --записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_2 ::Integer;
         ELSE
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inMovementItemId, vbPartionCellId_2);
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_2(), inMovementItemId, 0 :: TFloat);
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), inMovementItemId, FALSE);

             --записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_2 ::Integer;
         END IF;


         -- 3. обнулили
         IF COALESCE (vbPartionCellId_3, 0) = 0
         THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), inMovementItemId, FALSE);

             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inMovementItemId, NULL);
             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_3(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_3 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_old_3:= (SELECT MILO.ObjectId
                                      FROM MovementItemLinkObject AS MILO
                                      WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_3() AND MILO.ObjectId <> zc_PartionCell_RK()
                                     );

             -- если была реальна€ €чейка
             IF vbPartionCellId_old_3 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_3(), inMovementItemId, vbPartionCellId_old_3 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_3:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_3() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inMovementItemId, vbPartionCellId_3);
             -- закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), inMovementItemId, TRUE);
             --
             vbIsClose_3:= vbPartionCellId_old_3 > 0;

             --записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_3 ::Integer;
         ELSE
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inMovementItemId, vbPartionCellId_3);
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_3(), inMovementItemId, 0 :: TFloat);
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), inMovementItemId, FALSE);

             --записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_3 ::Integer;
         END IF;


         -- 4. обнулили
         IF COALESCE (vbPartionCellId_4, 0) = 0
         THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), inMovementItemId, FALSE);

             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inMovementItemId, NULL);
             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_4(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_4 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_old_4:= (SELECT MILO.ObjectId
                                      FROM MovementItemLinkObject AS MILO
                                      WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_4() AND MILO.ObjectId <> zc_PartionCell_RK()
                                     );

             -- если была реальна€ €чейка
             IF vbPartionCellId_old_4 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_4(), inMovementItemId, vbPartionCellId_old_4 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_4:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_4() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inMovementItemId, vbPartionCellId_4);
             -- закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), inMovementItemId, TRUE);
             --
             vbIsClose_4:= vbPartionCellId_old_4 > 0;

             --записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_4 ::Integer;
         ELSE
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inMovementItemId, vbPartionCellId_4);
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_4(), inMovementItemId, 0 :: TFloat);
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), inMovementItemId, FALSE);

             --записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_4 ::Integer;
         END IF;


         -- 5. обнулили
         IF COALESCE (vbPartionCellId_5, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_5(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_5 = zc_PartionCell_RK()
         THEN
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_5:= (SELECT MILO.ObjectId
                                      FROM MovementItemLinkObject AS MILO
                                      WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_5() AND MILO.ObjectId <> zc_PartionCell_RK()
                                     );

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_5 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_5(), inMovementItemId, vbPartionCellId_old_5 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_5:= (SELECT MILO.ObjectId
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_5() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inMovementItemId, vbPartionCellId_5);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), inMovementItemId, TRUE);
             --
             vbIsClose_5:= vbPartionCellId_old_5 > 0;

             --записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_5 ::Integer;
         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inMovementItemId, vbPartionCellId_5);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_5(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), inMovementItemId, FALSE);

             --записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_5 ::Integer;
         END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);

     ELSE

         SELECT outPartionCellId_1, outPartionCellId_2, outPartionCellId_3, outPartionCellId_4, outPartionCellId_5
              , outPartionCellId_6, outPartionCellId_7, outPartionCellId_8, outPartionCellId_9, outPartionCellId_10
              , outIsClose_1, outIsClose_2, outIsClose_3, outIsClose_4, outIsClose_5, outIsClose_6, outIsClose_7, outIsClose_8, outIsClose_9, outIsClose_10
         INTO vbPartionCellId_old_1, vbPartionCellId_old_2, vbPartionCellId_old_3, vbPartionCellId_old_4, vbPartionCellId_old_5
            , vbPartionCellId_old_6, vbPartionCellId_old_7, vbPartionCellId_old_8, vbPartionCellId_old_9, vbPartionCellId_old_10
            , vbIsClose_1, vbIsClose_2, vbIsClose_3, vbIsClose_4, vbIsClose_5, vbIsClose_6, vbIsClose_7, vbIsClose_8, vbIsClose_9, vbIsClose_10

         FROM lpUpdate_MI_Send_byReport_all (inUnitId                := inUnitId
                                           , inStartDate             := inStartDate
                                           , inEndDate               := inEndDate
                                           , inGoodsId               := inGoodsId
                                           , inGoodsKindId           := inGoodsKindId
                                           , inPartionGoodsDate      := inPartionGoodsDate
                                           , inPartionCellId_1       := ioPartionCellId_1
                                           , inPartionCellId_2       := ioPartionCellId_2
                                           , inPartionCellId_3       := ioPartionCellId_3
                                           , inPartionCellId_4       := ioPartionCellId_4
                                           , inPartionCellId_5       := ioPartionCellId_5
                                           , inPartionCellId_6       := ioPartionCellId_6
                                           , inPartionCellId_7       := ioPartionCellId_7
                                           , inPartionCellId_8       := ioPartionCellId_8
                                           , inPartionCellId_9       := ioPartionCellId_9
                                           , inPartionCellId_10      := ioPartionCellId_10

                                           , inPartionCellId_1_new   := vbPartionCellId_1
                                           , inPartionCellId_2_new   := vbPartionCellId_2
                                           , inPartionCellId_3_new   := vbPartionCellId_3
                                           , inPartionCellId_4_new   := vbPartionCellId_4
                                           , inPartionCellId_5_new   := vbPartionCellId_5
                                           , inPartionCellId_6_new   := vbPartionCellId_6
                                           , inPartionCellId_7_new   := vbPartionCellId_7
                                           , inPartionCellId_8_new   := vbPartionCellId_8
                                           , inPartionCellId_9_new   := vbPartionCellId_9
                                           , inPartionCellId_10_new  := vbPartionCellId_10
                                           , inUserId                := vbUserId
                                            ) AS tmp;

     END IF;

     --outPartionCellId_last := COALESCE (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10, 0);
     IF     COALESCE(ioPartionCellId_1,0) <> COALESCE (vbPartionCellId_1, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_1, 0); 
     ELSEIF COALESCE(ioPartionCellId_2,0) <> COALESCE (vbPartionCellId_2, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_2, 0); 
     ELSEIF COALESCE(ioPartionCellId_3,0) <> COALESCE (vbPartionCellId_3, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_3, 0); 
     ELSEIF COALESCE(ioPartionCellId_4,0) <> COALESCE (vbPartionCellId_4, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_4, 0); 
     ELSEIF COALESCE(ioPartionCellId_5,0) <> COALESCE (vbPartionCellId_5, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_5, 0); 
     ELSEIF COALESCE(ioPartionCellId_6,0) <> COALESCE (vbPartionCellId_6, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_6, 0); 
     ELSEIF COALESCE(ioPartionCellId_7,0) <> COALESCE (vbPartionCellId_7, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_7, 0); 
     ELSEIF COALESCE(ioPartionCellId_8,0) <> COALESCE (vbPartionCellId_8, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_8, 0); 
     ELSEIF COALESCE(ioPartionCellId_9,0) <> COALESCE (vbPartionCellId_9, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_9, 0); 
     ELSEIF COALESCE(ioPartionCellId_10,0)<> COALESCE (vbPartionCellId_10, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_10, 0); 
     END IF;
     --пареметр дл€ печати
     outisPrint := CASE WHEN COALESCE (outPartionCellId_last,0) = 0 THEN FALSE ELSE TRUE END;

     -- вернули Id
     ioPartionCellId_1 := CASE WHEN vbPartionCellId_old_1 > 0 THEN vbPartionCellId_old_1 ELSE vbPartionCellId_1 END;
     ioPartionCellId_2 := CASE WHEN vbPartionCellId_old_2 > 0 THEN vbPartionCellId_old_2 ELSE vbPartionCellId_2 END;
     ioPartionCellId_3 := CASE WHEN vbPartionCellId_old_3 > 0 THEN vbPartionCellId_old_3 ELSE vbPartionCellId_3 END;
     ioPartionCellId_4 := CASE WHEN vbPartionCellId_old_4 > 0 THEN vbPartionCellId_old_4 ELSE vbPartionCellId_4 END;
     ioPartionCellId_5 := CASE WHEN vbPartionCellId_old_5 > 0 THEN vbPartionCellId_old_5 ELSE vbPartionCellId_5 END;
     ioPartionCellId_6 := CASE WHEN vbPartionCellId_old_6 > 0 THEN vbPartionCellId_old_6 ELSE vbPartionCellId_6 END;
     ioPartionCellId_7 := CASE WHEN vbPartionCellId_old_7 > 0 THEN vbPartionCellId_old_7 ELSE vbPartionCellId_7 END;
     ioPartionCellId_8 := CASE WHEN vbPartionCellId_old_8 > 0 THEN vbPartionCellId_old_8 ELSE vbPartionCellId_8 END;
     ioPartionCellId_9 := CASE WHEN vbPartionCellId_old_9 > 0 THEN vbPartionCellId_old_9 ELSE vbPartionCellId_9 END;
     ioPartionCellId_10:= CASE WHEN vbPartionCellId_old_10 > 0 THEN vbPartionCellId_old_10 ELSE vbPartionCellId_10 END;

     -- вернули Name
     ioPartionCellName_1  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_1, vbPartionCellId_1)), vbIsClose_1);
     ioPartionCellName_2  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_2, vbPartionCellId_2)), vbIsClose_2);
     ioPartionCellName_3  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_3, vbPartionCellId_3)), vbIsClose_3);
     ioPartionCellName_4  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_4, vbPartionCellId_4)), vbIsClose_4);
     ioPartionCellName_5  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_5, vbPartionCellId_5)), vbIsClose_5);
     ioPartionCellName_6  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_6, vbPartionCellId_6)), vbIsClose_6);
     ioPartionCellName_7  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_7, vbPartionCellId_7)), vbIsClose_7);
     ioPartionCellName_8  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_8, vbPartionCellId_8)), vbIsClose_8);
     ioPartionCellName_9  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_9, vbPartionCellId_9)), vbIsClose_9);
     ioPartionCellName_10 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_10,vbPartionCellId_10)),vbIsClose_10);



     -- сохранили протокол
     --PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 »—“ќ–»я –ј«–јЅќ“ »: ƒј“ј, ј¬“ќ–
               ‘елонюк ».¬.    ухтин ».¬.    лиментьев  .».

 04.01.24         *
*/

-- тест
--