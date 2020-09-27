-- Function: gpInsertUpdate_Object_ReportBonus()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReportBonus (Integer, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReportBonus(
 INOUT ioId                  Integer   , --
    IN inMonth               TDateTime , --
    IN inJuridicalId         Integer   , --
    IN inPartnerId           Integer   , --
    IN inisSend              Boolean   , -- Отмечен
   OUT outisSend             Boolean   , -- Отмечен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    outisSend := inisSend;
    
    --Если isSend =True и до этого был сохранен - нужно установить отметку на удаление = true
    IF COALESCE (ioId,0) <> 0 AND inisSend = True
    THEN 
        UPDATE Object SET isErased = TRUE WHERE Object.Id = ioId AND Object.DescId = zc_Object_ReportBonus();
    END IF;

    --если isSend =False - и такой элемент уже есть ставим отметку на удаление = false
    IF COALESCE (ioId,0) <> 0 AND inisSend = False
    THEN 
        UPDATE Object SET isErased = False WHERE Object.Id = ioId AND Object.DescId = zc_Object_ReportBonus();
    END IF;
    
    --если isSend =False - и такой элемент еще не сохранен нужно его сохранить
    IF COALESCE (ioId,0) = 0 AND inisSend = False
    THEN
         -- сохранили <Объект>
         ioId := lpInsertUpdate_Object (ioId, zc_Object_ReportBonus(), 0, '');
         
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectDate (zc_Object_ReportBonus_Month(), ioId, DATE_TRUNC ('Month',inMonth) );

         -- сохранили связь с <Юридическое лицо>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportBonus_Juridical(), ioId, inJuridicalId);
         -- сохранили связь с <Контрагент>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportBonus_Partner(), ioId, inPartnerId);

    END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.20         * 
*/


-- тест
--