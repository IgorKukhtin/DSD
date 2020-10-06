-- Function: gpInsertUpdate_Object_ReportBonus()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReportBonus (Integer, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReportBonus(
 INOUT ioId                  Integer   , --
    IN inMonth               TDateTime , --
    IN inJuridicalId         Integer   , --
    IN inPartnerId           Integer   , --
    IN inIsSend              Boolean   , -- Отмечен
   OUT outIsSend             Boolean   , -- Отмечен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    outIsSend := inIsSend;
    
    --пробуем найти, вдруг уже есть элемент
    IF COALESCE (ioId,0) = 0
    THEN
        IF COALESCE (inPartnerId, 0) = 0
        THEN
            -- ищем с пустым контрагентом
            ioId := (SELECT Object_ReportBonus.Id
                     FROM Object AS Object_ReportBonus
                          INNER JOIN ObjectDate AS ObjectDate_Month
                                               ON ObjectDate_Month.ObjectId = Object_ReportBonus.Id
                                              AND ObjectDate_Month.DescId = zc_Object_ReportBonus_Month()
                                              AND ObjectDate_Month.ValueData =  DATE_TRUNC ('MONTH', inMonth)
                          INNER JOIN ObjectLink AS ObjectLink_Juridical
                                                ON ObjectLink_Juridical.ObjectId = Object_ReportBonus.Id
                                               AND ObjectLink_Juridical.DescId = zc_ObjectLink_ReportBonus_Juridical()
                                               AND ObjectLink_Juridical.ChildObjectId = inJuridicalId
                          LEFT JOIN ObjectLink AS ObjectLink_Partner
                                               ON ObjectLink_Partner.ObjectId = Object_ReportBonus.Id
                                              AND ObjectLink_Partner.DescId = zc_ObjectLink_ReportBonus_Partner()
                     WHERE Object_ReportBonus.DescId = zc_Object_ReportBonus()
                       AND ObjectLink_Partner.ChildObjectId IS NULL
                    );
        ELSE
            -- ищем с установленным контрагентом
            ioId := (SELECT Object_ReportBonus.Id
                     FROM Object AS Object_ReportBonus
                          INNER JOIN ObjectDate AS ObjectDate_Month
                                               ON ObjectDate_Month.ObjectId  = Object_ReportBonus.Id
                                              AND ObjectDate_Month.DescId    = zc_Object_ReportBonus_Month()
                                              AND ObjectDate_Month.ValueData =  DATE_TRUNC ('MONTH', inMonth)
                          INNER JOIN ObjectLink AS ObjectLink_Juridical
                                                ON ObjectLink_Juridical.ObjectId      = Object_ReportBonus.Id
                                               AND ObjectLink_Juridical.DescId        = zc_ObjectLink_ReportBonus_Juridical()
                                               AND ObjectLink_Juridical.ChildObjectId = inJuridicalId
                          INNER JOIN ObjectLink AS ObjectLink_Partner
                                               ON ObjectLink_Partner.ObjectId      = Object_ReportBonus.Id
                                              AND ObjectLink_Partner.DescId        = zc_ObjectLink_ReportBonus_Partner()
                                              AND ObjectLink_Partner.ChildObjectId = inPartnerId 
                     WHERE Object_ReportBonus.DescId = zc_Object_ReportBonus()
                    );
        END IF;
    END IF;
    
    -- Если isSend = TRUE, удалеяем из списка тех, кого переносить НЕ надо, т.е. будет isErased = TRUE
    IF COALESCE (ioId, 0) <> 0 AND inIsSend = TRUE
    THEN 
        UPDATE Object SET isErased = TRUE WHERE Object.Id = ioId AND Object.DescId = zc_Object_ReportBonus();
    END IF;

    -- Если isSend = FALSE и такой элемент есть, восстанавливаем в списке тех, кого переносить НЕ надо, т.е. будет isErased = FALSE
    IF COALESCE (ioId,0) <> 0 AND inIsSend = FALSE
    THEN 
        UPDATE Object SET isErased = FALSE WHERE Object.Id = ioId AND Object.DescId = zc_Object_ReportBonus();
    END IF;
    
    -- если isSend = FALSE - и это новый элемент, сохраняем в списке тех, кого переносить НЕ надо
    IF COALESCE (ioId, 0) = 0 AND inIsSend = FALSE
    THEN
         -- сохранили <Объект>
         ioId := lpInsertUpdate_Object (ioId, zc_Object_ReportBonus(), 0, '');
         
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectDate (zc_Object_ReportBonus_Month(), ioId, DATE_TRUNC ('MONTH', inMonth));

         -- сохранили связь с <Юридическое лицо>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportBonus_Juridical(), ioId, inJuridicalId);
         -- сохранили связь с <Контрагент>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportBonus_Partner(), ioId, inPartnerId);

    END IF;
    

    IF ioId > 0
    THEN
        -- сохранили протокол
        PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
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