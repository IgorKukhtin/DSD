-- Function: gpSelect_Movement_Reestr()

DROP FUNCTION IF EXISTS gpSelect_Object_ReportCollation_PrintPack (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReportCollation_PrintPack(
    IN inId                  Integer   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId_User  Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
   DECLARE vbStartDate TDateTime;
          vbEndDate TDateTime;
          vbJuridicalId Integer; 
          vbPartnerId    Integer; 
          vbContractId   Integer; 
          vbPaidKindId   Integer; 
          vbInfoMoneyId  Integer;
          vbReportCollationCode Integer;
   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


SELECT ObjectDate_Start.ValueData::TDateTime
        , ObjectDate_End.ValueData::TDateTime
        , ObjectLink_ReportCollation_Juridical.ChildObjectId 
        , ObjectLink_ReportCollation_Partner.ChildObjectId
        , ObjectLink_ReportCollation_Contract.ChildObjectId
        , ObjectLink_ReportCollation_PaidKind.ChildObjectId
        , ObjectLink_ReportCollation_InfoMoney.ChildObjectId
        , Object_ReportCollation.ObjectCode

INTO vbStartDate
   , vbEndDate     
   , vbJuridicalId 
   , vbPartnerId   
   , vbContractId  
   , vbPaidKindId  
   , vbInfoMoneyId 
   , vbReportCollationCode
                                          
   FROM Object AS Object_ReportCollation
      LEFT JOIN ObjectDate AS ObjectDate_Start
                           ON ObjectDate_Start.ObjectId = Object_ReportCollation.Id
                          AND ObjectDate_Start.DescId = zc_ObjectDate_ReportCollation_Start()
      LEFT JOIN ObjectDate AS ObjectDate_End
                            ON ObjectDate_End.ObjectId = Object_ReportCollation.Id
                           AND ObjectDate_End.DescId = zc_ObjectDate_ReportCollation_End()
 
      LEFT JOIN ObjectBoolean AS ObjectBoolean_Buh
                              ON ObjectBoolean_Buh.ObjectId = Object_ReportCollation.Id
                             AND ObjectBoolean_Buh.DescId = zc_ObjectBoolean_ReportCollation_Buh()

      LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_PaidKind
                           ON ObjectLink_ReportCollation_PaidKind.ObjectId = Object_ReportCollation.Id
                          AND ObjectLink_ReportCollation_PaidKind.DescId = zc_ObjectLink_ReportCollation_PaidKind()
      
      LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Juridical
                           ON ObjectLink_ReportCollation_Juridical.ObjectId = Object_ReportCollation.Id
                          AND ObjectLink_ReportCollation_Juridical.DescId = zc_ObjectLink_ReportCollation_Juridical()
      
      LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Partner
                           ON ObjectLink_ReportCollation_Partner.ObjectId = Object_ReportCollation.Id
                          AND ObjectLink_ReportCollation_Partner.DescId = zc_ObjectLink_ReportCollation_Partner()

      LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Contract
                           ON ObjectLink_ReportCollation_Contract.ObjectId = Object_ReportCollation.Id
                          AND ObjectLink_ReportCollation_Contract.DescId = zc_ObjectLink_ReportCollation_Contract()

      LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_InfoMoney
                           ON ObjectLink_ReportCollation_InfoMoney.ObjectId = Object_ReportCollation.Id
                          AND ObjectLink_ReportCollation_InfoMoney.DescId = zc_ObjectLink_ReportCollation_InfoMoney()

   WHERE Object_ReportCollation.Id = inId;

     -- Результат
     OPEN Cursor1 FOR
    
 SELECT tmp.outjuridicalname_basis  AS juridicalname_basis
        , tmp.outJuridicalShortName_Basis AS JuridicalShortName_Basis
        , tmp.outpartnername          AS partnername
        , tmp.outAccounterName_Basis  AS AccounterName_Basis
        , tmp.outAccounterName        AS AccounterName
        , tmp.outContracNumber        AS ContracNumber
        , tmp.outContractSigningDate  AS ContractSigningDate
        , tmp.outStartBalance         AS StartBalance
        , vbReportCollationCode ::Integer AS ReportCollationCode  --, COALESCE (tmp.outReportCollationCode,vbReportCollationCode) ::Integer AS ReportCollationCode
        , vbStartDate AS StartDate
        , vbEndDate   AS EndDate
        --, (zfFormat_BarCode (zc_BarCodePref_Object(), inId) || '0') ::TVarChar AS BarCodeId
        , '' ::TVarChar AS BarCodeId
   FROM gpReport_JuridicalBalance(inOperDate   := vbStartDate
                                , inEndDate     := vbEndDate
                                , inJuridicalId := vbJuridicalId 
                                , inPartnerId   := vbPartnerId
                                , inContractId  := vbContractId
                                , inAccountId   := 0 
                                , inPaidKindId  := vbPaidKindId
                                , inInfoMoneyId := vbInfoMoneyId
                                , inCurrencyId  := 0
                                , inSession     := inSession) AS tmp;
   
    RETURN NEXT Cursor1;

     OPEN Cursor2 FOR

   SELECT vbStartDate AS StartDate
        , vbEndDate   AS EndDate
        , tmp1.OperationSort
        , tmp1.ItemName
        , tmp1.InvNumber
        , tmp1.invnumberpartner
        , tmp1.MovementSumm
        , tmp1.OperDate
        
   FROM gpReport_JuridicalCollation(inStartDate   := vbStartDate
                                  , inEndDate     := vbEndDate
                                  , inJuridicalId := vbJuridicalId 
                                  , inPartnerId   := vbPartnerId
                                  , inContractId  := vbContractId
                                  , inAccountId   := 0 
                                  , inPaidKindId  := vbPaidKindId
                                  , inInfoMoneyId := vbInfoMoneyId
                                  , inCurrencyId  := 0
                                  , inMovementId_Partion:= 0
                                  , inSession     := inSession) AS tmp1;


    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReportCollation_PrintPack (inId:= 7692051, inSession := '5');