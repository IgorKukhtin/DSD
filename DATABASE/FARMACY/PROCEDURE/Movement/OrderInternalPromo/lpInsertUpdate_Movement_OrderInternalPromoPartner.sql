-- Function: lpInsertUpdate_Movement_OrderInternalPromoPartner()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderInternalPromoPartner (Integer, Integer, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderInternalPromoPartner(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ>
    IN inParentId              Integer    , -- главый документ 
    IN inJuridicalId           Integer    , -- 
    IN inUserId                Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert  Boolean;
   DECLARE vbOperdate  Tdatetime;
   DECLARE vbInvnumber Tvarchar;   
BEGIN

    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    SELECT Movement.Operdate
         , Movement.Invnumber
         INTO vbOperdate, vbInvnumber
    FROM Movement
    WHERE Movement.Id = inParentId;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderInternalPromoPartner(), vbInvnumber, vbOperdate, inParentId);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
    
    -- сохранили протокол
--    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.04.19         *
*/