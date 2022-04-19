-- Function: gpInsert_Movement_Invoice_Check()

DROP FUNCTION IF EXISTS gpInsert_Movement_Invoice_Check (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Invoice_Check(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inJuridicalId      Integer  ,  -- Юр.лицо
    IN inUnitId           Integer  ,  -- Аптека
    IN inPartnerMedicalId Integer  ,  -- Больница
    IN inJuridicalMedicId Integer  ,  -- юр.лицо плательщик с 01,04,2019
    IN inMedicalProgramSPId  Integer  ,  -- Медицинская программа соц. проектов
    IN inGroupMedicalProgramSPId Integer  ,  -- Группа медицинских программ соц. проектов
    
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
/* по просьбе Любы 23,04,2019 закоментила
    IF COALESCE (inPartnerMedicalId, 0) = 0
       THEN
           RAISE EXCEPTION 'Ошибка.Не выбран Заклад охорони здоров`я.';
    END IF;
*/
    CREATE TEMP TABLE tmpReport (MovementId_Check Integer, JuridicalId Integer, PartnerMedicalId Integer,  ContractId Integer, SummaComp TFloat, CountSP TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpInvoice (MovementId Integer, InvNumber TVarChar, JuridicalId Integer, PartnerMedicalId Integer,  ContractId Integer) ON COMMIT DROP;

     -- выбираем данные из отчета
     INSERT INTO tmpReport (MovementId_Check, JuridicalId, PartnerMedicalId, ContractId, SummaComp, CountSP)
       SELECT  tmp.MovementId
             , tmp.JuridicalId
             , CASE WHEN inJuridicalMedicId <> 0 AND inStartDate >= '01.04.2019'  THEN inJuridicalMedicId ELSE tmp.HospitalId END
             , tmp.ContractId
             , SUM (tmp.SummaComp)          AS SummaComp
             , SUM (tmp.CountSP)            AS CountSP
       FROM (SELECT  tmp.MovementId
                   , tmp.JuridicalId
                   , tmp.HospitalId
                   , CASE WHEN inJuridicalMedicId <> 0 AND inStartDate >= '01.04.2019'  THEN tmp.ContractId_Department ELSE tmp.ContractId END AS ContractId
                   , SUM (tmp.SummaSP)                AS SummaComp
                   , COUNT (DISTINCT tmp.InvNumberSP) AS CountSP
             FROM gpReport_Check_SP(inStartDate:=inStartDate, inEndDate:=inEndDate, inJuridicalId:=inJuridicalId
                                  , inUnitId:= inUnitId, inHospitalId:=inPartnerMedicalId, inJuridicalMedicId := inJuridicalMedicId
                                  , inMedicalProgramSPId := inMedicalProgramSPId, inGroupMedicalProgramSPId := inGroupMedicalProgramSPId
                                  , inSession:=inSession) AS tmp
             GROUP BY tmp.MovementId
                    , tmp.JuridicalId
                    , tmp.HospitalId
                    , CASE WHEN inJuridicalMedicId <> 0 AND inStartDate >= '01.04.2019'  THEN tmp.ContractId_Department ELSE tmp.ContractId END
                    , tmp.CountInvNumberSP
             ) AS tmp
             
       GROUP BY tmp.MovementId
              , tmp.JuridicalId
              , CASE WHEN inJuridicalMedicId <> 0 AND inStartDate >= '01.04.2019'  THEN inJuridicalMedicId ELSE tmp.HospitalId END
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
    WHERE Movement.StatusId <> zc_Enum_Status_Erased()
      AND Movement.DescId = zc_Movement_Invoice()
      AND Movement.OperDate >= inDateInvoice AND Movement.OperDate <inDateInvoice + interval '1 day'
      AND COALESCE (Movement.InvNumber,'') = COALESCE (inInvoice,'')
    LIMIT 1;


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
                                           , inChangePercent   := 0 :: TFloat
                                           , inValueSP         := 1 :: Tfloat
                                           , inUserId          := vbUserId
                                           )
     FROM tmpReport
        LEFT JOIN tmpInvoice ON tmpInvoice.JuridicalId = tmpReport.JuridicalId 
                             AND tmpInvoice.PartnerMedicalId = tmpReport.PartnerMedicalId 
                             AND COALESCE (tmpInvoice.ContractId,0) = COALESCE (tmpReport.ContractId,0)
     GROUP BY tmpReport.JuridicalId
            , tmpReport.PartnerMedicalId
            , tmpReport.ContractId
            , COALESCE (tmpInvoice.MovementId, 0);

     --выбираем док. счета, чтоб записать ссылки документам чеков 
     DELETE FROM tmpInvoice;
     INSERT INTO tmpInvoice (MovementId, InvNumber, JuridicalId, PartnerMedicalId, ContractId)
     SELECT MAX (Movement.Id) AS MovementId
          , MAX (Movement.Id)
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
     -- AND COALESCE (Movement.InvNumber,'') = COALESCE (inInvoice,'')
    GROUP BY COALESCE (MovementLinkObject_Juridical.ObjectId,0)  
           , COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) 
           , COALESCE (MovementLinkObject_Contract.ObjectId,0)  
    ;

   -- ссылка на документ счет
   PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), tmpReport.MovementId_Check, tmpInvoice.MovementId)
   FROM tmpReport
        INNER JOIN tmpInvoice ON tmpInvoice.JuridicalId = tmpReport.JuridicalId 
                             AND tmpInvoice.PartnerMedicalId = tmpReport.PartnerMedicalId 
                             AND COALESCE (tmpInvoice.ContractId,0) = COALESCE (tmpReport.ContractId,0);

    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%>', inSession;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 13.05.17         * add inValueSP
 18.04.17         *
*/


-- select * from gpInsert_Movement_Invoice_Check(inStartDate := ('01.10.2021')::TDateTime , inEndDate := ('01.10.2021')::TDateTime , inJuridicalId := 393038 , inUnitId := 0 , inPartnerMedicalId := 0 , inJuridicalMedicId := 10959824 , inMedicalProgramSPId := 0, inGroupMedicalProgramSPId := 0, inDateInvoice := ('02.11.2021')::TDateTime , inInvoice := '57500' , inisInsert := 'True' ,  inSession := '3');