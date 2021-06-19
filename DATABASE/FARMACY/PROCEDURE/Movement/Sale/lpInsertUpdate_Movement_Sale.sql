-- Function: lpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, TVarChar, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, TVarChar, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, Boolean, Integer);


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
    IN inisNP                  Boolean    , -- Доставка "Новой почтой"
    IN inUserId                Integer      -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId Integer;
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

                      
    IF COALESCE(inInvNumberSP, '') <> ''  
       THEN
           vbMovementId := (SELECT Movement.Id
                            FROM Movement 
                              INNER JOIN MovementString AS MovementString_InvNumberSP
                                                        ON MovementString_InvNumberSP.MovementId = Movement.Id
                                                       AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                                                       AND MovementString_InvNumberSP.ValueData = inInvNumberSP
                              INNER JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                                            ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                                           AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                                                           AND MovementLinkObject_PartnerMedical.ObjectId = inPartnerMedicalId
                              INNER JOIN MovementLinkObject AS MovementLinkObject_MedicSP
                                                            ON MovementLinkObject_MedicSP.MovementId = Movement.Id
                                                           AND MovementLinkObject_MedicSP.DescId = zc_MovementLinkObject_MedicSP()
                                                           AND MovementLinkObject_MedicSP.ObjectId = inMedicSP
                              INNER JOIN MovementDate AS MovementDate_OperDateSP
                                                      ON MovementDate_OperDateSP.MovementId = Movement.Id
                                                     AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()
                                                     AND MovementDate_OperDateSP.ValueData = inOperDateSP
                            WHERE Movement.DescId = zc_Movement_Sale()
                              AND Movement.StatusId <> zc_Enum_Status_Erased()
                              AND Movement.Id <> ioId
                            LIMIT 1);
                            
           IF vbMovementId <> 0
              THEN
                  RAISE EXCEPTION 'Ошибка.По рецепту <%> найдена другая <Продажа> № <%> от <%>. Дублирование запрещено.'
                                                                                         --, CHR (13)
                                                                                         , inInvNumberSP
                                                                                         , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId)
                                                                                         , DATE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId))
                                                                                        -- , lfGet_Object_ValueData ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId AND MLO.DescId = zc_MovementLinkObject_From()))
                                                                                        -- , COALESCE (' на <' || lfGet_Object_ValueData ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId AND MLO.DescId = zc_MovementLinkObject_To())) || '>', '')
                                                                                       --  , CHR (13)
                                                                                        ;
                                                                                                       
              END IF;
    END IF;
    
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberSP(), ioId, inInvNumberSP);
    
    -- сохранили <>
    --PERFORM lpInsertUpdate_MovementString (zc_MovementString_MemberSP(), ioId, inMemberSP);
    -- сохранили <>
    --PERFORM lpInsertUpdate_MovementString (zc_MovementString_MedicSP(), ioId, inMedicSP);
   
    IF COALESCE(inPartnerMedicalId,0) <> 0 OR COALESCE(inInvNumberSP,'') <> '' THEN
          -- такая проверка при проведении
          --IF inOperDateSP > inOperDate
          --   THEN
          --       RAISE EXCEPTION 'Ошибка. Дата рецепта позже даты документа.';
          --END IF;
       -- сохранили <>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateSP(), ioId, inOperDateSP);
    END IF;
    

    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MedicSP(), ioId, inMedicSP);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MemberSP(), ioId, inMemberSP);

    -- сохранили признак
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NP(), ioId, inisNP);

    -- !!!протокол через свойства конкретного объекта!!!
     IF vbIsInsert = FALSE
     THEN
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (корректировка)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;
     
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 18.01.18         *
 03.04.17         *
 14.02.17         *
 08.02.17         * add SP
 13.10.15                                                                       *
*/
--select * from gpInsertUpdate_Movement_Sale(ioId := 3959860 , inInvNumber := '5853' , inOperDate := ('18.01.2018')::TDateTime , inUnitId := 183292 , inJuridicalId := 0 , inPaidKindId := 6 , inPartnerMedicalId := 3690583 , inGroupMemberSPId := 3690580 , inOperDateSP := ('18.01.2018')::TDateTime , inInvNumberSP := '77' , inMedicSP := 'Кукушкин Сергей Иванович' , inMemberSP := 'Зорин' , inComment := '' ,  inSession := '3');