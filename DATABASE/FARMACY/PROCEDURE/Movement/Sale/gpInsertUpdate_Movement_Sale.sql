-- Function: gpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Sale(
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
    IN inMedicSP               TVarChar   , -- ФИО врача (Соц. проект)
    IN inMemberSP              TVarChar   , -- ФИО пациента (Соц. проект)
    IN inComment               TVarChar   , -- Примечание
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
    vbUserId := inSession;
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_Sale (ioId          := ioId
                                        , inInvNumber   := inInvNumber
                                        , inOperDate    := inOperDate
                                        , inUnitId      := inUnitId
                                        , inJuridicalId := inJuridicalId
                                        , inPaidKindId  := inPaidKindId
                                        , inPartnerMedicalId:= inPartnerMedicalId
                                        , inGroupMemberSPId := inGroupMemberSPId
                                        , inOperDateSP      := inOperDateSP
                                        , inInvNumberSP     := inInvNumberSP
                                        , inMedicSP         := inMedicSP
                                        , inMemberSP        := inMemberSP
                                        , inComment         := inComment
                                        , inUserId          := vbUserId
                                        );

   IF COALESCE (inPartnerMedicalId,0) <> 0 OR
      --COALESCE (inOperDateSP,Null) <> Null OR
      COALESCE (inInvNumberSP,'') <> '' OR
      COALESCE (inMedicSP,'') <> '' OR
      COALESCE (inMemberSP,'') <> '' THEN

     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SP(), MovementItem.Id, True)
     FROM MovementItem
     WHERE MovementItem.MovementId = ioId
       AND MovementItem.DescId = zc_MI_Master();
   END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 08.02.17         *
 13.10.15                                                                    *
*/