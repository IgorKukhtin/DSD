-- Function: lpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, TVarChar, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, TVarChar, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Sale(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inUnitId                Integer    , -- От кого (подразделение)
    IN inJuridicalId           Integer    , -- Кому (покупатель)
    IN inPaidKindId            Integer    , -- Виды форм оплаты
    IN inPartnerMedicalId      Integer    , -- Медицинское учреждение(Соц. проект)
    IN inGroupMemberSPId       Integer    , -- Категория пациента(Соц. проект)
    IN inOperDateSP            TDateTime  , -- дата рецепта (Соц. проект)
    IN inInvNumberSP           TVarChar   , -- номер рецепта (Соц. проект)
    IN inMedicSP               Integer    , -- ФИО врача (Соц. проект)
    IN inMemberSP              Integer    , -- ФИО пациента (Соц. проект)
    IN inComment               TVarChar   , -- Примечание
    IN inUserId                Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка
    inOperDate:= DATE_TRUNC ('DAY', inOperDate);
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
    END IF;
    
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Sale(), inInvNumber, inOperDate, NULL, 0);
    
    -- сохранили связь с <От кого (подразделение)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    
    
    IF COALESCE(inJuridicalId,0) = 0
    THEN
        --Удалить связь с покупателем
        IF EXISTS(SELECT 1 FROM MovementLinkObject
                  WHERE MovementId = ioId
                    AND DescId = zc_MovementLinkObject_Juridical())
        THEN
            DELETE FROM MovementLinkObject
            WHERE MovementId = ioId
              AND DescId = zc_MovementLinkObject_Juridical();
        END IF;
    ELSE
        -- сохранили связь с <Кому (покупатель)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
    END IF;

    -- сохранили связь с <Виды форм оплаты>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
    
    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartnerMedical(), ioId, inPartnerMedicalId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GroupMemberSP(), ioId, inGroupMemberSPId);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberSP(), ioId, inInvNumberSP);
    -- сохранили <>
    --PERFORM lpInsertUpdate_MovementString (zc_MovementString_MemberSP(), ioId, inMemberSP);
    -- сохранили <>
    --PERFORM lpInsertUpdate_MovementString (zc_MovementString_MedicSP(), ioId, inMedicSP);
   
    IF COALESCE(inPartnerMedicalId,0) <> 0 OR COALESCE(inInvNumberSP,'') <> '' THEN
          IF inOperDateSP > inOperDate
             THEN
                 RAISE EXCEPTION 'Проверьте дату рецепта.';
          END IF;
       -- сохранили <>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateSP(), ioId, inOperDateSP);
    END IF;
    

    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MedicSP(), ioId, inMedicSP);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MemberSP(), ioId, inMemberSP);


    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 03.04.17         *
 14.02.17         *
 08.02.17         * add SP
 13.10.15                                                                       *
*/
