-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoPartner (
    Integer    , -- Ключ объекта <партнер для документа акции>
    Integer    , -- Ключ родительского объекта <Документ акции>
    Integer    , -- партнер
    TVarChar     -- сессия пользователя

);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoPartner (
    Integer    , -- Ключ объекта <партнер для документа акции>
    Integer    , -- Ключ родительского объекта <Документ акции>
    Integer    , -- партнер
    Integer    , -- Контракт
    TVarChar     -- сессия пользователя

);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoPartner(
 INOUT ioId                    Integer    , -- Ключ объекта <партнер для документа акции>
    IN inParentId              Integer    , -- Ключ родительского объекта <Документ акции>
    IN inPartnerId             Integer    , -- Ключ объекта <Контрагент / Юр лицо / Торговая Сеть>
    IN inContractId            Integer    , -- Ключ объекта <Контракт>
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPartnerDescId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := inSession;
    -- сохранили <Документ>
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    --проверили сохранен ли документ
    IF NOT EXISTS(SELECT 1 FROM Movement 
                  WHERE Movement.Id = inParentId
                    AND Movement.StatusId = zc_Enum_Status_UnComplete())
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен или не находится в состоянии <Не проведен>.';
    END IF;
    
    -- сохранили <Документ>
    SELECT
        lpInsertUpdate_Movement (ioId, zc_Movement_Promo(), Movement_Promo.InvNumber, Movement_Promo.OperDate, inParentId, 0)
    INTO
        ioId
    FROM
        Movement AS Movement_Promo
    WHERE
        Movement_Promo.Id = inParentId;
    
    --проверить соответствие контракта клиенту
    IF COALESCE(inContractId,0) <> 0
    THEN
        vbPartnerDescId = (Select DescId from Object Where Id = inPartnerId);
        IF vbPartnerDescId = zc_Object_Juridical()
        THEN
            IF NOT EXISTS(Select 1 from Object_Contract_View 
                          Where Object_Contract_View.ContractId = inContractId 
                            AND Object_Contract_View.JuridicalId = inPartnerId)
            THEN
                RAISE EXCEPTION 'Ошибка. Несоответствие контракта и партнера.';
            END IF;
        END IF;
        IF vbPartnerDescId = zc_Object_Partner()
        THEN
            IF NOT EXISTS(Select 1 from Object_Contract_View
                              Inner Join ObjectLink ON ObjectLink.ChildObjectId = Object_Contract_View.JuridicalId
                                                   AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()
                          Where Object_Contract_View.ContractId = inContractId 
                            AND ObjectLink.ObjectId = inPartnerId)
            THEN
                RAISE EXCEPTION 'Ошибка. Несоответствие контракта и партнера.';
            END IF;
        END IF;
        IF vbPartnerDescId = zc_Object_Retail()
        THEN
            IF NOT EXISTS(Select 1 from Object_Contract_View
                              Inner Join ObjectLink ON ObjectLink.ObjectId = Object_Contract_View.JuridicalId
                                                   AND ObjectLink.DescId = zc_ObjectLink_Juridical_Retail()
                          Where Object_Contract_View.ContractId = inContractId 
                            AND ObjectLink.ChildObjectId = inPartnerId)
            THEN
                RAISE EXCEPTION 'Ошибка. Несоответствие контракта и партнера.';
            END IF;
        END IF;
    END IF;
    -- сохранили связь с <Контрагент / Юр лицо / Торговая Сеть>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);
    -- сохранили связь с <Контракт>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 17.11.15                                                                    *inContractId
 31.10.15                                                                    *
*/