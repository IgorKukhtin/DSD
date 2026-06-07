-- Function: gpInsertUpdate_Object_CommercLocal_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CommercLocal_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CommercLocal_Load(
    IN inCommercLocalCode     Integer   ,
    IN inUnitName             TVarChar  ,
    IN inPositionName_1       TVarChar  ,
    IN inPersonalGroupName_1  TVarChar  ,
    IN inPositionName_2       TVarChar  ,
    IN inPersonalGroupName_2  TVarChar  ,
    IN inPositionName_3       TVarChar  ,
    IN inPositionName_4       TVarChar  ,
    IN inPositionName_5       TVarChar  ,
    IN inPositionName_6       TVarChar  ,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId            Integer;
           vbCommercLocalId    Integer;
           vbUnitId            Integer;
           vbPositionId_1      Integer;
           vbPersonalGroupId_1 Integer;
           vbPositionId_2      Integer;
           vbPersonalGroupId_2 Integer;
           vbPositionId_3      Integer;
           vbPositionId_4      Integer;
           vbPositionId_5      Integer;
           vbPositionId_6      Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());

    /* IF COALESCE (inCommercLocalName,'') = ''
     THEN
         RETURN;
     END IF;
      */

     IF COALESCE (inCommercLocalCode,0) = 0
     THEN   
         vbCommercLocalId := 0;
         inCommercLocalCOde := lfGet_ObjectCode(0, zc_Object_CommercLocal());
     ELSE
         vbCommercLocalId := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inCommercLocalCode AND Object.DescId = zc_Object_CommercLocal());
         IF COALESCE (vbCommercLocalCode,0) = 0
         THEN
             RAISE EXCEPTION 'Помилка.Елемент довідника <Структура комерції (Роздріб, HoReCa, Регіональні мережі)> з кодом <%> не знайдено', inCommercLocalCode;
         END IF;
     END IF;

     -- Подразделение
     IF COALESCE (inUnitName,'') <> ''
     THEN
         -- проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inUnitName) AND Object.DescId = zc_Object_Unit())
         THEN
             RAISE EXCEPTION 'Помилка.Знайдено кілька значень Підрозділ = <%>', inUnitName;
         END IF;
     
         -- находим Подразделение
         vbUnitId := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inUnitName) AND Object.DescId = zc_Object_Unit());

         IF COALESCE (vbUnitId,0) = 0
         THEN 
             RAISE EXCEPTION 'Помилка.Підрозділ = <%> не знайдено', inUnitName;
         END IF;
     END IF;

     -- Должность 1
     IF COALESCE (inPositionName_1,'') <> ''
     THEN
         -- проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPositionName_1) AND Object.DescId = zc_Object_Position())
         THEN
             RAISE EXCEPTION 'Помилка.Знайдено кілька значень Посада = <%>', inPositionName_1;
         END IF;
     
         -- находим 
         vbPositionId_1 := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPositionName_1) AND Object.DescId = zc_Object_Position());

         IF COALESCE (vbPositionId_1,0) = 0
         THEN 
             RAISE EXCEPTION 'Помилка.Посаду = <%> не знайдено', inPositionName_1;
         END IF;
     END IF;

     -- Должность 2
     IF COALESCE (inPositionName_2,'') <> ''
     THEN
         -- проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPositionName_2) AND Object.DescId = zc_Object_Position())
         THEN
             RAISE EXCEPTION 'Помилка.Знайдено кілька значень Посада = <%>', inPositionName_2;
         END IF;
     
         -- находим 
         vbPositionId_2 := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPositionName_2) AND Object.DescId = zc_Object_Position());

         IF COALESCE (vbPositionId_2,0) = 0
         THEN 
             RAISE EXCEPTION 'Помилка.Посаду = <%> не знайдено', inPositionName_2;
         END IF;
     END IF;

     -- Должность 3
     IF COALESCE (inPositionName_3,'') <> ''
     THEN
         -- проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPositionName_3) AND Object.DescId = zc_Object_Position())
         THEN
             RAISE EXCEPTION 'Помилка.Знайдено кілька значень Посада = <%>', inPositionName_3;
         END IF;
     
         -- находим 
         vbPositionId_3 := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPositionName_3) AND Object.DescId = zc_Object_Position());

         IF COALESCE (vbPositionId_3,0) = 0
         THEN 
             RAISE EXCEPTION 'Помилка.Посаду = <%> не знайдено', inPositionName_3;
         END IF;
     END IF;
     -- Должность 4
     IF COALESCE (inPositionName_4,'') <> ''
     THEN
         -- проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPositionName_4) AND Object.DescId = zc_Object_Position())
         THEN
             RAISE EXCEPTION 'Помилка.Знайдено кілька значень Посада = <%>', inPositionName_4;
         END IF;
     
         -- находим 
         vbPositionId_4 := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPositionName_4) AND Object.DescId = zc_Object_Position());

         IF COALESCE (vbPositionId_4,0) = 0
         THEN 
             RAISE EXCEPTION 'Помилка.Посаду = <%> не знайдено', inPositionName_4;
         END IF;
     END IF;
     -- Должность 5
     IF COALESCE (inPositionName_5,'') <> ''
     THEN
         -- проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPositionName_5) AND Object.DescId = zc_Object_Position())
         THEN
             RAISE EXCEPTION 'Помилка.Знайдено кілька значень Посада = <%>', inPositionName_5;
         END IF;
     
         -- находим 
         vbPositionId_5 := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPositionName_5) AND Object.DescId = zc_Object_Position());

         IF COALESCE (vbPositionId_5,0) = 0
         THEN 
             RAISE EXCEPTION 'Помилка.Посаду = <%> не знайдено', inPositionName_5;
         END IF;
     END IF;
     -- Должность 6
     IF COALESCE (inPositionName_6,'') <> ''
     THEN
         -- проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPositionName_6) AND Object.DescId = zc_Object_Position())
         THEN
             RAISE EXCEPTION 'Помилка.Знайдено кілька значень Посада = <%>', inPositionName_6;
         END IF;
     
         -- находим 
         vbPositionId_6 := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPositionName_6) AND Object.DescId = zc_Object_Position());

         IF COALESCE (vbPositionId_6,0) = 0
         THEN 
             RAISE EXCEPTION 'Помилка.Посаду = <%> не знайдено', inPositionName_6;
         END IF;
     END IF;

     -- Группа 1
     IF COALESCE (inPersonalGroupName_1,'') <> ''
     THEN
         -- проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPersonalGroupName_1) AND Object.DescId = zc_Object_PersonalGroup())
         THEN
             RAISE EXCEPTION 'Помилка.Знайдено кілька значень Група співробітників = <%>', inPersonalGroupName_1;
         END IF;
     
         -- находим 
         vbPersonalGroupId_1 := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPersonalGroupName_1) AND Object.DescId = zc_Object_PersonalGroup());

         IF COALESCE (vbPersonalGroupId_1,0) = 0
         THEN 
             RAISE EXCEPTION 'Помилка.Групу співробітників = <%> не знайдено', inPersonalGroupName_1;
         END IF;
     END IF;

     -- Группа 2
     IF COALESCE (inPersonalGroupName_2,'') <> ''
     THEN
         -- проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPersonalGroupName_2) AND Object.DescId = zc_Object_PersonalGroup())
         THEN
             RAISE EXCEPTION 'Помилка.Знайдено кілька значень Група співробітників = <%>', inPersonalGroupName_2;
         END IF;
     
         -- находим 
         vbPersonalGroupId_2 := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPersonalGroupName_2) AND Object.DescId = zc_Object_PersonalGroup());

         IF COALESCE (vbPersonalGroupId_2,0) = 0
         THEN 
             RAISE EXCEPTION 'Помилка.Групу співробітників = <%> не знайдено', inPersonalGroupName_2;
         END IF;
     END IF;

     -- сохранили елемент <>
     PERFORM gpInsertUpdate_Object_CommercLocal (ioId                := COALESCE (vbCommercLocalId,0)    ::Integer
                                               , inCode              := COALESCE (vbCommercLocalCode,0)  ::Integer
                                               , inUnitId            := vbUnitId                      ::Integer
                                               , inPositionId_1      := vbPositionId_1                ::Integer
                                               , inPersonalGroupId_1 := vbPersonalGroupId_1           ::Integer
                                               , inPositionId_2      := vbPositionId_2                ::Integer
                                               , inPersonalGroupId_2 := vbPersonalGroupId_2           ::Integer
                                               , inPositionId_3      := vbPositionId_3                ::Integer
                                               , inPositionId_4      := vbPositionId_4                ::Integer
                                               , inPositionId_5      := vbPositionId_5                ::Integer
                                               , inPositionId_6      := vbPositionId_6                ::Integer
                                               , inComment           := ''                            ::TVarChar
                                               , inSession           := inSession                     ::TVarChar
                                               );   

    
     if vbUserId = 9457 then  RAISE EXCEPTION 'Test admin.Ok'; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.06.26         *
*/

-- тест
--