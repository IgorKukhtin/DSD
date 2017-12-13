-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoPartner (Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoPartner(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ>
    IN inParentId              Integer    , -- главый документ маркетинга
    IN inJuridicalId           Integer    , -- Поставщик
    IN inComment               TVarChar   , -- Примечание
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbIsInsert  Boolean;
   DECLARE vbOperdate  Tdatetime;
   DECLARE vbInvnumber Tvarchar;   
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
       
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    SELECT Movement.Operdate
         , Movement.Invnumber
         INTO vbOperdate, vbInvnumber
    FROM Movement
    WHERE Movement.Id = inParentId;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PromoPartner(), vbInvnumber, vbOperdate, inParentId);
    
    -- сохранили связь с <Поставщик>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
    
    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 12.10.17         *
*/