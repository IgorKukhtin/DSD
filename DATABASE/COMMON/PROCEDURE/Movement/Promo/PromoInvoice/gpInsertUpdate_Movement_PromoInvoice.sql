-- Function: gpInsertUpdate_Movement_Promo()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoInvoice (Integer, Integer, TVarChar, TVarChar, TDateTime, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoInvoice (Integer, Integer, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoInvoice(
 INOUT ioId                    Integer    , -- Ключ объекта <>
    IN inParentId              Integer    , -- Ключ родительского объекта <Документ акции>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inInvNumberPartner      TVarChar   ,
    IN inOperDate              TDateTime  , --
    IN inBonusKindId           Integer    , --
    IN inPaidKindId            Integer    , -- 
    IN inContractId            Integer    , -- 
    IN inTotalSumm             TFloat     , --
    IN inComment               TVarChar   , --
    IN inSession               TVarChar     -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoInvoice());
    --vbUserId := lpGetUserBySession (inSession);

    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    --проверили сохранен ли документ
    IF  COALESCE (inParentId, 0) = 0 
    THEN
        RAISE EXCEPTION 'Ошибка. Документ <Акция> не сохранен.';
    END IF;
    
    -- сохранили <Документ>
    ioId:= lpInsertUpdate_Movement (ioId, zc_Movement_PromoInvoice(), inInvNumber, inOperDate, inParentId, 0);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BonusKind(), ioId, inBonusKindId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
    
    --получаем юр.лицо из договора
    vbJuridicalId := (SELECT ObjectLink_Contract_Juridical.ChildObjectId
                      FROM ObjectLink AS ObjectLink_Contract_Juridical
                      WHERE ObjectLink_Contract_Juridical.ObjectId = inContractId 
                        AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                      );
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, vbJuridicalId);

        -- сохранили <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    -- сохранили <Торговая сеть доп.>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), ioId, inTotalSumm);
    
     IF vbIsInsert = True
     THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
     ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, vbUserId);
     END IF;


    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.21         *
 04.09.21         *
*/
