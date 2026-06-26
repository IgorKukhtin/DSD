-- Function: gpInsertUpdate_Object_CommercRetail_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CommercRetail_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CommercRetail_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CommercRetail_Load(
    IN inCommercRetailCode    Integer   ,
    IN inRetailName           TVarChar  ,
    IN inPositionName_1       TVarChar  ,
    IN inPositionName_2       TVarChar  ,
    IN inPositionName_3       TVarChar  ,
    IN inPersonalGroupName_1  TVarChar  ,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId            Integer;
           vbCommercRetailId   Integer;
           vbRetailId          Integer;
           vbPositionId_1      Integer;
           vbPositionId_2      Integer;
           vbPositionId_3      Integer;
           vbPersonalGroupId_1 Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());

    /* IF COALESCE (inCommercRetailName,'') = ''
     THEN
         RETURN;
     END IF;
      */

     IF COALESCE (inCommercRetailCode,0) = 0
     THEN   
         vbCommercRetailId := 0;
         inCommercRetailCOde := lfGet_ObjectCode(0, zc_Object_CommercRetail());
     ELSE
         vbCommercRetailId := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inCommercRetailCode AND Object.DescId = zc_Object_CommercRetail());
         IF COALESCE (vbCommercRetailCode,0) = 0
         THEN
             RAISE EXCEPTION 'Помилка.Елемент довідника <Структура комерції (Мережі)> з кодом <%> не знайдено', inCommercRetailCode;
         END IF;
     END IF;

     -- Подразделение
     IF COALESCE (inRetailName,'') <> ''
     THEN
         -- проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inRetailName) AND Object.DescId = zc_Object_Retail())
         THEN
             RAISE EXCEPTION 'Помилка.Знайдено кілька значень Торгівельна мережа = <%>', inRetailName;
         END IF;
     
         -- находим Подразделение
         vbRetailId := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inRetailName) AND Object.DescId = zc_Object_Retail());

         IF COALESCE (vbRetailId,0) = 0
         THEN 
             RAISE EXCEPTION 'Помилка.Торгівельна мережа = <%> не знайдено', inRetailName;
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

     -- сохранили елемент<>
     PERFORM gpInsertUpdate_Object_CommercRetail (ioId          := COALESCE (vbCommercRetailId,0)    ::Integer
                                               , inCode         := COALESCE (vbCommercRetailCode,0)  ::Integer
                                               , inRetailId     := vbRetailId                    ::Integer
                                               , inPositionId_1 := vbPositionId_1                ::Integer
                                               , inPositionId_2 := vbPositionId_2                ::Integer
                                               , inPositionId_3 := vbPositionId_3                ::Integer
                                               , inPersonalGroupId_1 := vbPersonalGroupId_1      ::Integer
                                               , inComment      := ''                            ::TVarChar
                                               , inSession      := inSession                     ::TVarChar
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