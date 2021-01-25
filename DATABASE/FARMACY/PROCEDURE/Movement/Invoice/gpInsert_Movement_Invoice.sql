-- Function: gpInsert_Movement_Invoice()

DROP FUNCTION IF EXISTS gpInsert_Movement_Invoice (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TFloat, Boolean, TFloat, TDateTime,  TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Invoice(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inJuridicalId      Integer  ,  -- Юр.лицо
    IN inUnitId           Integer  ,  -- Аптека
    IN inPartnerMedicalId Integer  ,  -- Больница
    IN inGroupMemberSPId  Integer  ,  -- Категория пациента
    IN inPercentSP        TFloat   ,  -- % скидки
    IN inisGroupMemberSP  Boolean  ,  -- кроме выбранной категории пациента
    IN inNDSKindId        Integer  ,  -- Ндс

    IN inDateInvoice      TDateTime  , -- дата счета
    IN inInvoice          TVarChar   , -- счет
    IN inisInsert         Boolean    , -- записать Счет (Да/Нет)

    IN inSession          TVarChar     -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMedicSPId Integer;
   DECLARE vbMemberSPId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
    vbUserId := inSession;

    IF COALESCE (inisInsert, FALSE) = FALSE
       THEN
           RETURN;
    END IF;

    CREATE TEMP TABLE tmpReport (MovementId_Sale Integer, JuridicalId Integer, PartnerMedicalId Integer,  ContractId Integer, SummaComp TFloat, CountSP TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpInvoice (MovementId Integer, InvNumber TVarChar, JuridicalId Integer, PartnerMedicalId Integer,  ContractId Integer) ON COMMIT DROP;

     -- выбираем данные из отчета
     INSERT INTO tmpReport (MovementId_Sale, JuridicalId, PartnerMedicalId, ContractId, SummaComp, CountSP)
       SELECT  tmp.MovementId
             , tmp.JuridicalId
             , tmp.HospitalId
             , tmp.ContractId
             , SUM (tmp.SummaComp) AS SummaComp
             , MAX (CountSP)       AS CountSP
       FROM gpReport_Sale_SP(inStartDate := inStartDate, inEndDate := inEndDate, inJuridicalId :=inJuridicalId, inUnitId := inUnitId, inHospitalId := inPartnerMedicalId
                           , inGroupMemberSPId := inGroupMemberSPId, inPercentSP := inPercentSP, inisGroupMemberSP := inisGroupMemberSP, inNDSKindId := inNDSKindId, inSession := inSession) AS tmp
       GROUP BY tmp.MovementId
              , tmp.JuridicalId
              , tmp.HospitalId
              , tmp.ContractId;

     -- ищем , вдруг уже создан счет
     INSERT INTO tmpInvoice (MovementId, InvNumber, JuridicalId, PartnerMedicalId, ContractId)
     SELECT Movement.Id AS MovementId
          , Movement.InvNumber 
          , COALESCE (MovementLinkObject_Juridical.ObjectId,0)      AS JuridicalId
          , COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) AS PartnerMedicalId 
          , COALESCE (MovementLinkObject_Contract.ObjectId,0)       AS ContractId
     FROM Movement 
        INNER JOIN MovementDate AS MovementDate_OperDateStart
                                ON MovementDate_OperDateStart.MovementId = Movement.Id
                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
                               AND MovementDate_OperDateStart.ValueData = inStartDate
        INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                ON MovementDate_OperDateEnd.MovementId = Movement.Id
                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
                               AND MovementDate_OperDateEnd.ValueData = inEndDate
        INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                      ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                     AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                     AND (COALESCE (MovementLinkObject_Juridical.ObjectId,0) = inJuridicalId OR inJuridicalId = 0)
        
        INNER JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                      ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                     AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                                     AND (COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) = inPartnerMedicalId OR inPartnerMedicalId = 0)

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                ON MovementFloat_ChangePercent.MovementId = Movement.Id
                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

    WHERE Movement.StatusId <> zc_Enum_Status_Erased()
      AND Movement.DescId = zc_Movement_Invoice()
      AND Movement.OperDate >= inDateInvoice AND Movement.OperDate <inDateInvoice + interval '1 day'
      AND COALESCE (Movement.InvNumber,'') = COALESCE (inInvoice,'')
      AND COALESCE (MovementFloat_ChangePercent.ValueData, 0) = inPercentSP
      ;

    -- сохранили <Документ>
    PERFORM lpInsertUpdate_Movement_Invoice (ioId              := COALESCE (tmpInvoice.MovementId, 0)
                                           , inInvNumber       := COALESCE (inInvoice,'')
                                           , inOperDate        := inDateInvoice
                                           , inJuridicalId     := tmpReport.JuridicalId
                                           , inPartnerMedicalId:= tmpReport.PartnerMedicalId
                                           , inContractId      := tmpReport.ContractId
                                           , inStartDate       := inStartDate
                                           , inEndDate         := inEndDate
                                           , inTotalSumm       := SUM (tmpReport.SummaComp):: Tfloat
                                           , inTotalCount      := MAX (tmpReport.CountSP)  :: Tfloat
                                           , inChangePercent   := COALESCE (inPercentSP, 0) :: TFloat
                                           , inValueSP         := 2 :: Tfloat
                                           , inUserId          := vbUserId
                                           )
     FROM tmpReport
        LEFT JOIN tmpInvoice ON tmpInvoice.JuridicalId = tmpReport.JuridicalId 
                             AND tmpInvoice.PartnerMedicalId = tmpReport.PartnerMedicalId 
                             AND COALESCE (tmpInvoice.ContractId, 0) = COALESCE (tmpReport.ContractId, 0)
     GROUP BY tmpReport.JuridicalId
            , tmpReport.PartnerMedicalId
            , tmpReport.ContractId
            , COALESCE (tmpInvoice.MovementId, 0);

     --выбираем док. счета, чтоб записать ссылки документам продаж 
     DELETE FROM tmpInvoice;
     INSERT INTO tmpInvoice (MovementId, InvNumber, JuridicalId, PartnerMedicalId, ContractId)
     SELECT Movement.Id AS MovementId
          , Movement.InvNumber 
          , COALESCE (MovementLinkObject_Juridical.ObjectId,0)      AS JuridicalId
          , COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) AS PartnerMedicalId 
          , COALESCE (MovementLinkObject_Contract.ObjectId,0)       AS ContractId
     FROM Movement 
        INNER JOIN MovementDate AS MovementDate_OperDateStart
                                ON MovementDate_OperDateStart.MovementId = Movement.Id
                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
                               AND MovementDate_OperDateStart.ValueData = inStartDate
        INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                ON MovementDate_OperDateEnd.MovementId = Movement.Id
                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
                               AND MovementDate_OperDateEnd.ValueData = inEndDate
        INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                      ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                     AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                     AND (COALESCE (MovementLinkObject_Juridical.ObjectId,0) = inJuridicalId OR inJuridicalId = 0)
        
        INNER JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                      ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                     AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                                     AND (COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) = inPartnerMedicalId OR inPartnerMedicalId = 0)

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
    WHERE Movement.StatusId <> zc_Enum_Status_Erased()
      AND Movement.DescId = zc_Movement_Invoice()
      AND Movement.OperDate >= inDateInvoice AND Movement.OperDate <inDateInvoice + interval '1 day'
      AND COALESCE (Movement.InvNumber,'') = COALESCE (inInvoice,'')
    ;

   -- ссылка на документ счет
   PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), tmpReport.MovementId_Sale, tmpInvoice.MovementId)
   FROM tmpReport
        INNER JOIN tmpInvoice ON tmpInvoice.JuridicalId = tmpReport.JuridicalId 
                             AND tmpInvoice.PartnerMedicalId = tmpReport.PartnerMedicalId 
                             AND COALESCE (tmpInvoice.ContractId, 0) = COALESCE (tmpReport.ContractId, 0);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.   Шаблий О.В.
 25.01.21                                                                                   *
 14.02.19         *
 13.05.17         * add inValueSP
 22.03.17         *
*/