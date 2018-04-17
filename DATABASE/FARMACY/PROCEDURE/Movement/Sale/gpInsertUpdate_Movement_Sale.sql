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
   OUT outSPKindName           TVarChar   , -- вид соц.проекта
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMedicSPId Integer;
   DECLARE vbMemberSPId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
    vbUserId := inSession;

   IF COALESCE (inMemberSP, '') <> ''
      THEN
          inMemberSP:= TRIM (COALESCE (inMemberSP, ''));

          vbMemberSPId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_MemberSP() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inMemberSP) LIMIT 1);
          IF COALESCE (vbMemberSPId,0) = 0
             THEN 
                 -- не нашли Сохраняем
                 vbMemberSPId := gpInsertUpdate_Object_MemberSP (ioId               := 0
                                                               , inCode             := lfGet_ObjectCode(0, zc_Object_MemberSP()) 
                                                               , inName             := inMemberSP
                                                               , inPartnerMedicalId := inPartnerMedicalId    -- Мед. учрежд.
                                                               , inGroupMemberSPId  := inGroupMemberSPId     -- категория пац.
                                                               , inHappyDate        := '' ::  TVarChar       -- год рождения
                                                               , inSession := inSession
                                                                );
          END IF;
   END IF;

   IF COALESCE (inMedicSP, '') <> ''
      THEN
          inMedicSP:= TRIM (COALESCE (inMedicSP, ''));

          vbMedicSPId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_MedicSP() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inMedicSP) LIMIT 1);
          IF COALESCE (vbMedicSPId,0) = 0
             THEN 
                 -- не нашли Сохраняем
                 vbMedicSPId := gpInsertUpdate_Object_MedicSP (ioId      := 0
                                                             , inCode    := lfGet_ObjectCode(0, zc_Object_MedicSP()) 
                                                             , inName    := inMedicSP
                                                             , inPartnerMedicalId := inPartnerMedicalId
                                                             , inSession := inSession
                                                             );
          END IF;
   END IF;

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
                                        , inMedicSP         := COALESCE (vbMedicSPId,0)
                                        , inMemberSP        := COALESCE (vbMemberSPId,0)
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

    -- сохранили связь с <вид соц.проекта>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SPKind(), ioId, zc_Enum_SPKind_1303());
 
   END IF;


   outSPKindName := (SELECT Object.ValueData 
                     FROM MovementLinkObject AS MLO
                          LEFT JOIN Object ON Object.Id = MLO.ObjectId
                     WHERE MLO.DescId = zc_MovementLinkObject_SPKind() AND MLO.MovementId = ioId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 08.02.17         *
 13.10.15                                                                    *
*/