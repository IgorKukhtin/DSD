-- Function: gpUpdate_Object_PartnerTypeCommerc_Load()

DROP FUNCTION IF EXISTS gpUpdate_Object_PartnerTypeCommerc_Load (Integer, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_PartnerTypeCommerc_Load(
    IN inPartnerCode         Integer   , --
    IN inPartnerName         TVarChar  ,
    IN inTypeCommercName     TVarChar  ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
           vbPartnerId   Integer;
           vbTypeCommercId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_TypeCommerc());

     IF COALESCE (inPartnerCode,0) = 0
     THEN
         RETURN;
     END IF;

     -- проверка
     IF COALESCE (inTypeCommercName,'') = ''
     THEN
         RETURN;
     END IF;

     -- проверка
     IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.ObjectCode = inPartnerCode AND Object.DescId = zc_Object_Partner())
     THEN
         RAISE EXCEPTION 'Ошибка.Найдено несколько значений Контрагент по коду = <(%) %>.', inPartnerCode, inPartnerName;
     END IF;

     -- находим контрагента по коду
     vbPartnerId := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inPartnerCode AND Object.DescId = zc_Object_Partner());
     
     IF COALESCE (vbPartnerId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден Контрагент по коду = <(%) %>.', inPartnerCode, inPartnerName;
     END IF;


     -- проверка
     IF 1 < (SELECT COUNT(*) FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inTypeCommercName) AND Object.DescId = zc_Object_TypeCommerc())
     THEN
         RAISE EXCEPTION 'Ошибка.Найдено несколько значений Тип отгрузки = <%>', inTypeCommercName;
     END IF;

     -- находим Тип отгрузки по наименованию
     vbTypeCommercId := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inTypeCommercName) AND Object.DescId = zc_Object_TypeCommerc());
     -- проверка
     IF COALESCE (vbTypeCommercId,0) = 0
     THEN
         --RAISE EXCEPTION 'Ошибка.Маршрут ТТ = <%> не найден', inTypeCommercName; 
         --сохраняем
         vbTypeCommercId := gpInsertUpdate_Object_TypeCommerc (ioId      := 0           ::Integer
                                                             , inCode    := 0           ::Integer
                                                             , inName    := TRIM (inTypeCommercName) ::TVarChar
                                                             , inComment := ''                       ::TVarChar
                                                             , inSession := inSession                ::TVarChar
                                                             );
     END IF;
     

     -- сохранили связь с <Тип отгрузки>
     PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_TypeCommerc(), vbPartnerId, vbTypeCommercId);
     
     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (vbPartnerId, vbUserId);
   
     if vbUserId = 9457 then  RAISE EXCEPTION 'Test admin.Ok'; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.06.26         *
*/

-- тест
--