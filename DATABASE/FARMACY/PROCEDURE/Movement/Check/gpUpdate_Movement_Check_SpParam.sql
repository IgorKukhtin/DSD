-- Function: gpInsertUpdate_Movement_Check()

-- DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SpParam (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SpParam (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SpParam (Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SpParam (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SpParam (Integer, Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SpParam(
    IN inId                  Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inSPKindId            Integer   , -- Вид соц.проекта
    IN inPartnerMedicalId    Integer   , -- Медицинское учреждение(Соц. проект)
    IN inOperDateSP          TDateTime , -- дата рецепта (Соц. проект)
    IN inAmbulance           TVarChar  , --
    IN inMedicSP             TVarChar  , -- ФИО врача (Соц. проект)
    IN inInvNumberSP         TVarChar  , -- номер рецепта (Соц. проект)
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMedicSPId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inId);

    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SPKind(), inId, inSPKindId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartnerMedical(), inId, inPartnerMedicalId);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Ambulance(), inId, inAmbulance);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_MedicSP(), inId, inMedicSP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberSP(), inId, inInvNumberSP);
    -- сохранили <>
    IF inInvNumberSP <> ''
    THEN
          IF inOperDateSP > vbOperDate
             THEN
                 RAISE EXCEPTION 'Проверьте дату рецепта.';
          END IF;
       -- сохранили <>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateSP(), inId, inOperDateSP);
    ELSE   
       -- сохранили <>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateSP(), inId, NULL);
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 23.05.17         * add inSPKindId
 26.04.17         * add inPartnerMedicalId
 21.04.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Check_SpParam (ioId := 0, inUnitId := 183293, inDate := NULL::TDateTime, inBayer := 'Test Bayer'::TVarChar, inSession:= zfCalc_UserAdmin());
