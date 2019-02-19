-- Function: lpInsertUpdate_Movement_Invoice()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Tfloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, Tfloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Invoice(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inJuridicalId           Integer    , -- Кому (покупатель)
    IN inPartnerMedicalId      Integer    , -- Медицинское учреждение(Соц. проект)
    IN inContractId            Integer    , -- Договор
    IN inStartDate             TDateTime  , -- дата нач.
    IN inEndDate               TDateTime  , -- дата кон.
    IN inTotalSumm             TFloat     , -- сумма
    IN inTotalCount            TFloat     , -- колво рецептов
    IN inChangePercent         TFloat     , -- % скидки
    IN inValueSP               Tfloat     , -- код соц. проекта
    IN inUserId                Integer      -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка
    inOperDate:= DATE_TRUNC ('DAY', inOperDate);
      
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Invoice(), inInvNumber, inOperDate, NULL, 0);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);

    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartnerMedical(), ioId, inPartnerMedicalId);
 
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inStartDate);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inEndDate);    

    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), ioId, inTotalSumm);
    -- Сохранили свойство <Итого колво рецептов>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), ioId, inTotalCount);
    -- Сохранили свойство <% скидки>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

    -- Сохранили свойство <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SP(), ioId, inValueSP);
  
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 18.02.19         * add inChangePercent
 14.02.19         *
 13.05.17         * add inValueSP
 22.03.17         *
*/