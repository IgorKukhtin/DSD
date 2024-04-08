-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalSaleDocument (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalSaleDocument (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalSaleDocument(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , -- 
    IN inJuridicalId      Integer   ,
    IN inAccountId        Integer   , --
    IN inContractId       Integer   , --
    IN inPaidKindId       Integer   , --
    IN inBranchId         Integer   , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, OperDate TDateTime, InvNumber TVarChar, TotalSumm TFloat, FromName TVarChar, ToName TVarChar, ContractNumber TVarChar, ContractTagName TVarChar, PaidKindName TVarChar)
AS
$BODY$
   DECLARE vbIsSale Boolean; 
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inStartDate, NULL, NULL, NULL, vbUserId);

     -- 
     vbIsSale:= EXISTS (SELECT AccountId FROM Object_Account_View WHERE AccountId = inAccountId AND AccountGroupId = zc_Enum_AccountGroup_30000()); -- Дебиторы

     -- !!!Отчет строим не по договору а по "ключу"!!!
     CREATE TEMP TABLE _tmpContract (ContractId Integer) ON COMMIT DROP; 
     INSERT INTO _tmpContract (ContractId)
         SELECT COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) AS ContractId
         FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey
              LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey_find ON View_Contract_ContractKey_find.ContractKeyId = View_Contract_ContractKey.ContractKeyId
         WHERE View_Contract_ContractKey.ContractId = inContractId;



    RETURN QUERY  
        SELECT 
              Movement.Id
            , Movement.OperDate
            , Movement.InvNumber
            , (CASE WHEN vbIsSale = TRUE AND Movement.DescId = zc_Movement_Income()
                         THEN (1 + COALESCE (MovementFloat_ChangePercentPartner.ValueData, 0) / 100)
                            * CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() OR COALESCE (MovementFloat_ChangePercent.ValueData, 0) = 0
                                        THEN MovementFloat_TotalSummPVAT.ValueData
                                   ELSE CASE WHEN MovementFloat_ChangePercent.ValueData = -1 * 100
                                                  THEN 0
                                             ELSE MovementFloat_TotalSummMVAT.ValueData / (1 + MovementFloat_ChangePercent.ValueData / 100)
                                                * (1 + COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100)
                                        END
                              END
                    ELSE MovementFloat_TotalSumm.ValueData
               END) :: TFloat AS TotalSumm
            , Object_From.ValueData AS FromName
            , (Object_To.ValueData /*|| ' (' || Object_To.Id :: TVarChar ||')'*/) :: TVarChar  AS ToName
            , View_Contract_InvNumber.InvNumber AS ContractNumber
            , View_Contract_InvNumber.ContractTagName
            , Object_PaidKind.ValueData  AS PaidKindName
         FROM Movement
              INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                            ON MovementLinkObject_Partner.MovementId = Movement.Id
                                           AND MovementLinkObject_Partner.DescId     = zc_MovementLinkObject_To()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner_TransferDebtOut
                                           ON MovementLinkObject_Partner_TransferDebtOut.MovementId = Movement.Id
                                          AND MovementLinkObject_Partner_TransferDebtOut.DescId = zc_MovementLinkObject_Partner()
              LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = COALESCE (MovementLinkObject_Partner_TransferDebtOut.ObjectId, MovementLinkObject_Partner.ObjectId)
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

              LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                           ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                          AND MovementLinkObject_PaidKind.DescId     = zc_MovementLinkObject_PaidKindTo()
              LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

              LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                           ON MovementLinkObject_Branch.MovementId = Movement.Id
                                          AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()

              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                          AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_ContractTo()
              -- !!!Группируем Договора!!!
              LEFT JOIN _tmpContract ON _tmpContract.ContractId = MovementLinkObject_Contract.ObjectId
              LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                           AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

              LEFT JOIN Object AS Object_To ON Object_To.Id = CASE WHEN vbIsSale = TRUE THEN COALESCE (MovementLinkObject_Partner_TransferDebtOut.ObjectId, MovementLinkObject_Partner.ObjectId) ELSE MovementLinkObject_From.ObjectId END
              LEFT JOIN Object AS Object_From  ON Object_From.Id = CASE WHEN vbIsSale = TRUE THEN MovementLinkObject_From.ObjectId ELSE MovementLinkObject_Partner.ObjectId END

              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                      ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                     AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()
              LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                      ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                     AND MovementFloat_ChangePercent.DescId     = zc_MovementFloat_ChangePercent()
              LEFT JOIN MovementFloat AS MovementFloat_ChangePercentPartner
                                      ON MovementFloat_ChangePercentPartner.MovementId = Movement.Id
                                     AND MovementFloat_ChangePercentPartner.DescId     = zc_MovementFloat_ChangePercentPartner()
              LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                      ON MovementFloat_TotalSummPVAT.MovementId = Movement.Id
                                     AND MovementFloat_TotalSummPVAT.DescId     = zc_MovementFloat_TotalSummPVAT()
              LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                      ON MovementFloat_TotalSummMVAT.MovementId = Movement.Id
                                     AND MovementFloat_TotalSummMVAT.DescId     = zc_MovementFloat_TotalSummMVAT()
              LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                      ON MovementFloat_VATPercent.MovementId = Movement.Id
                                     AND MovementFloat_VATPercent.DescId     = zc_MovementFloat_VATPercent()

        WHERE Movement.DescId   = zc_Movement_TransferDebtOut()
          AND Movement.StatusId = zc_Enum_Status_Complete()
          AND Movement.OperDate >= inStartDate 
          AND Movement.OperDate < inEndDate
          AND vbIsSale          = TRUE
          AND (_tmpContract.ContractId > 0 OR inContractId = 0)
          AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
          AND (MovementLinkObject_Branch.ObjectId = inBranchId OR inBranchId = 0)
          AND COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_Partner.ObjectId) = inJuridicalId 
        --and Object_To.Id <> 250535
        --and Object_To.Id = 250535

       UNION ALL 
        SELECT 
              Movement.Id
            , MovementDate_OperDatePartner.ValueData :: TDateTime AS OperDate
            , Movement.InvNumber
            , (CASE WHEN vbIsSale = TRUE AND Movement.DescId = zc_Movement_Income()
                         THEN (1 + COALESCE (MovementFloat_ChangePercentPartner.ValueData, 0) / 100)
                            * CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() OR COALESCE (MovementFloat_ChangePercent.ValueData, 0) = 0
                                        THEN MovementFloat_TotalSummPVAT.ValueData
                                   ELSE CASE WHEN MovementFloat_ChangePercent.ValueData = -1 * 100
                                                  THEN 0
                                             ELSE MovementFloat_TotalSummMVAT.ValueData / (1 + MovementFloat_ChangePercent.ValueData / 100)
                                                * (1 + COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100)
                                        END
                              END
                    ELSE MovementFloat_TotalSumm.ValueData
               END) :: TFloat AS TotalSumm
            , Object_From.ValueData AS FromName
            , (Object_To.ValueData /*|| ' (' || Object_To.Id :: TVarChar ||')'*/) :: TVarChar  AS ToName
            , View_Contract_InvNumber.InvNumber AS ContractNumber
            , View_Contract_InvNumber.ContractTagName
            , Object_PaidKind.ValueData  AS PaidKindName
         FROM (SELECT zc_Movement_Sale() AS DescId, zc_MovementLinkObject_Contract() AS DescId_Contract, zc_MovementLinkObject_PaidKind() AS DescId_PaidKind, zc_MovementLinkObject_To() AS DescId_Partner, zc_MovementLinkObject_From() AS DescId_Unit WHERE vbIsSale = TRUE
              UNION ALL
               SELECT zc_Movement_Income() AS DescId, zc_MovementLinkObject_ContractTo() AS DescId_Contract, zc_MovementLinkObject_PaidKind() AS DescId_PaidKind, zc_MovementLinkObject_To() AS DescId_Partner, zc_MovementLinkObject_From() AS DescId_Unit WHERE vbIsSale = TRUE
              UNION ALL
               SELECT zc_Movement_Income() AS DescId, zc_MovementLinkObject_Contract() AS DescId_Contract, zc_MovementLinkObject_PaidKind() AS DescId_PaidKind, zc_MovementLinkObject_From() AS DescId_Partner, zc_MovementLinkObject_To() AS DescId_Unit WHERE vbIsSale = FALSE
              ) AS tmpDesc
              INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.ValueData  >= inStartDate
                                     AND MovementDate_OperDatePartner.ValueData  < inEndDate
                                     AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
              INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                 AND Movement.DescId = tmpDesc.DescId
                                 AND Movement.StatusId = zc_Enum_Status_Complete()

              INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                            ON MovementLinkObject_Partner.MovementId = Movement.Id
                                           AND MovementLinkObject_Partner.DescId = tmpDesc.DescId_Partner
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner_TransferDebtOut
                                           ON MovementLinkObject_Partner_TransferDebtOut.MovementId = Movement.Id
                                          AND MovementLinkObject_Partner_TransferDebtOut.DescId = zc_MovementLinkObject_Partner()
              LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_Partner.ObjectId
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

              LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                           ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                          AND MovementLinkObject_PaidKind.DescId = tmpDesc.DescId_PaidKind
              LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

              LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                           ON MovementLinkObject_Branch.MovementId = Movement.Id
                                          AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()

              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                          AND MovementLinkObject_Contract.DescId = tmpDesc.DescId_Contract
              -- !!!Группируем Договора!!!
              LEFT JOIN _tmpContract ON _tmpContract.ContractId = MovementLinkObject_Contract.ObjectId
              LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                           AND MovementLinkObject_From.DescId = tmpDesc.DescId_Unit

              LEFT JOIN Object AS Object_To ON Object_To.Id = CASE WHEN vbIsSale = TRUE THEN COALESCE (MovementLinkObject_Partner_TransferDebtOut.ObjectId, MovementLinkObject_Partner.ObjectId) ELSE MovementLinkObject_From.ObjectId END
              LEFT JOIN Object AS Object_From  ON Object_From.Id = CASE WHEN vbIsSale = TRUE THEN MovementLinkObject_From.ObjectId ELSE MovementLinkObject_Partner.ObjectId END

              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                      ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                     AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()
              LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                      ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                     AND MovementFloat_ChangePercent.DescId     = zc_MovementFloat_ChangePercent()
              LEFT JOIN MovementFloat AS MovementFloat_ChangePercentPartner
                                      ON MovementFloat_ChangePercentPartner.MovementId = Movement.Id
                                     AND MovementFloat_ChangePercentPartner.DescId     = zc_MovementFloat_ChangePercentPartner()
              LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                      ON MovementFloat_TotalSummPVAT.MovementId = Movement.Id
                                     AND MovementFloat_TotalSummPVAT.DescId     = zc_MovementFloat_TotalSummPVAT()
              LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                      ON MovementFloat_TotalSummMVAT.MovementId = Movement.Id
                                     AND MovementFloat_TotalSummMVAT.DescId     = zc_MovementFloat_TotalSummMVAT()
              LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                      ON MovementFloat_VATPercent.MovementId = Movement.Id
                                     AND MovementFloat_VATPercent.DescId     = zc_MovementFloat_VATPercent()

        WHERE (_tmpContract.ContractId > 0 OR inContractId = 0)
          AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0
            OR (vbIsSale = TRUE AND inPaidKindId = zc_Enum_PaidKind_SecondForm() AND Movement.DescId = zc_Movement_Income())
              )
          AND (MovementLinkObject_Branch.ObjectId = inBranchId OR inBranchId = 0 OR vbIsSale = FALSE OR Movement.DescId = zc_Movement_Income())
          AND COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_Partner.ObjectId) = inJuridicalId 
        --and Object_To.Id <> 250535
        --and Object_To.Id = 250535
    ORDER BY 2 -- Movement.OperDate
           , 3 -- Movement.InvNumber
           , 4 -- CASE WHEN vbIsSale = TRUE AND Movement.DescId = zc_Movement_Income() THEN MovementFloat_TotalSummPVAT.ValueData * (1 + COALESCE (MovementFloat_ChangePercentPartner.ValueData, 0) / 100) ELSE MovementFloat_TotalSumm.ValueData END
            ;
          
          --, zc_Movement_ReturnIn()) 
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalSaleDocument (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.14                                        * add zc_Movement_TransferDebtOut
 05.05.14                                        * add inPaidKindId
 26.04.14                                        * add Object_Contract_ContractKey_View
 17.04.14                          * 
*/

-- тест
-- SELECT * FROM gpReport_JuridicalSaleDocument ('01.01.2014'::TDateTime, '01.02.2013'::TDateTime, 0, 0, 0, 0, inSession:= '2' :: TVarChar); 
