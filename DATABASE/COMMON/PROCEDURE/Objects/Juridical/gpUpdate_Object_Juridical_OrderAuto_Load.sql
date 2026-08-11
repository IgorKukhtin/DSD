-- Function: gpUpdate_Object_Juridical_OrderAuto_Load()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_OrderAuto_Load (Integer, TVarChar, TVarChar, TVarChar);
-- 1)Код юр.л (информативно) 2) назв (по нему заливаем) 3) Да/нет, если не нашли - ошибка

CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_OrderAuto_Load(
    IN inJuridicalCode     Integer   , --
    IN inJuridicalName     TVarChar  ,
    IN inisAuto            TVarChar  ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
           vbJuridicalId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());

     IF COALESCE (inJuridicalName,'') = ''
     THEN
         RETURN;
     END IF;

     -- проверка
     IF COALESCE (inisAuto,'') = ''
     THEN
         RETURN;
     END IF;

     inJuridicalName:= REPLACE (inJuridicalName, CHR(39), '`');


     -- 1
     -- проверка - 1
     IF 1 < (SELECT COUNT(*) FROM Object WHERE REPLACE (Object.ValueData, CHR(39), '`') ILIKE ' ' || inJuridicalName AND Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE)
     THEN
         RAISE EXCEPTION 'Ошибка-1. Найдено несколько значений Юр.лицо = <%> не найдено.', ' ' || inJuridicalName
        ;
     END IF;

     -- находим-1
     vbJuridicalId := (SELECT Object.Id FROM Object WHERE REPLACE (Object.ValueData, CHR(39), '`') ILIKE ' ' || inJuridicalName AND Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE);


     -- 2
     IF COALESCE (vbJuridicalId,0) = 0
     THEN
         -- проверка - 2
         IF 1 < (SELECT COUNT(*) FROM Object WHERE REPLACE (Object.ValueData, CHR(39), '`') ILIKE inJuridicalName || ' ' AND Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE)
         THEN
             RAISE EXCEPTION 'Ошибка-2. Найдено несколько значений Юр.лицо = <%> не найдено.', inJuridicalName || ' '
             ;
         END IF;

         -- находим - 2
         vbJuridicalId := (SELECT Object.Id FROM Object WHERE REPLACE (Object.ValueData, CHR(39), '`') ILIKE inJuridicalName || ' ' AND Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE);

     END IF;


     -- 3
     IF COALESCE (vbJuridicalId,0) = 0
     THEN
         -- проверка - 3
         IF 1 < (SELECT COUNT(*) FROM Object WHERE REPLACE (Object.ValueData, CHR(39), '`') ILIKE inJuridicalName AND Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE)
         THEN
             RAISE EXCEPTION 'Ошибка-3. Найдено несколько значений Юр.лицо = <%> не найдено.', inJuridicalName
             ;
         END IF;

         -- находим - 3
         vbJuridicalId := (SELECT Object.Id FROM Object WHERE REPLACE (Object.ValueData, CHR(39), '`') ILIKE inJuridicalName AND Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE);

     END IF;


     -- 4
     IF COALESCE (vbJuridicalId,0) = 0
     THEN
         -- проверка - 4
         IF 1 < (SELECT COUNT(*) FROM Object WHERE TRIM (REPLACE (Object.ValueData, CHR(39), '`')) ILIKE TRIM (inJuridicalName) AND Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE)
         THEN
             RAISE EXCEPTION 'Ошибка-4. Найдено несколько значений Юр.лицо = <%> не найдено.', TRIM (inJuridicalName)
             ;
         END IF;

         -- находим - 4
         vbJuridicalId := (SELECT Object.Id FROM Object WHERE TRIM (REPLACE (Object.ValueData, CHR(39), '`')) ILIKE TRIM (inJuridicalName) AND Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE);

     END IF;


     IF COALESCE (vbJuridicalId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Юр.лицо <%> не найдено.'
                       , REPLACE (inJuridicalName, CHR(39), '`')
                     --, 'SELECT COUNT(*) FROM Object WHERE Object.ValueData ILIKE ' || CHR(39) || inJuridicalName || CHR(39) || ' AND Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE'
                        ;
     END IF;

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_OrderAuto(), vbJuridicalId, CASE WHEN UPPER (TRIM (inisAuto)) = 'ДА' THEN TRUE ELSE FALSE END);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (vbJuridicalId, vbUserId);

     if vbUserId = 9457 then  RAISE EXCEPTION 'Test admin.Ok'; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.26         *
*/

-- тест
--