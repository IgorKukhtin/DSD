-- Function: gpUpdate_Object_PartnerRouteTT_Load()

DROP FUNCTION IF EXISTS gpUpdate_Object_PartnerRouteTT_Load (Integer, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_PartnerRouteTT_Load(
    IN inPartnerCode     Integer   , --
    IN inPartnerName     TVarChar  ,
    IN inRouteTTName     TVarChar  ,
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
           vbPartnerId   Integer;
           vbRouteTTId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_RouteTT());

     IF COALESCE (inPartnerCode,0) = 0
     THEN
         RETURN;
     END IF;

     -- проверка
     IF COALESCE (inRouteTTName,'') = ''
     THEN
         RETURN;
     END IF;

     -- находим контрагента
     vbPartnerId := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inPartnerCode AND Object.DescId = zc_Object_Partner() Limit 1);
     
     IF COALESCE (vbPartnerId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Контрагент <(%) %> не найден', inPartnerCode, inPartnerName;
     END IF;

     -- находим маршрут TT по наименованию
     vbRouteTTId := (SELECT Object.Id FROM Object WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inRouteTTName)) AND Object.DescId = zc_Object_RouteTT() Limit 1);
     IF COALESCE (vbRouteTTId,0) = 0
     THEN
         --сохраняем новый элемент
         vbRouteTTId := gpInsertUpdate_Object_RouteTT (ioId      := 0
                                                     , inCode    := 0
                                                     , inName    := TRIM (inRouteTTName) ::TVarChar
                                                     , inComment := ''        ::TVarChar
                                                     , inSession := inSession ::TVarChar
                                                      );
     END IF;
     
     -- сохранили связь с <Маршруты ТТ>
     PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_RouteTT(), vbPartnerId, vbRouteTTId);
     
     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (vbPartnerId, vbUserId);
   
     if vbUserId = 9457 then  RAISE EXCEPTION 'Test admin.Ok'; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.05.26         *
*/

-- тест
--