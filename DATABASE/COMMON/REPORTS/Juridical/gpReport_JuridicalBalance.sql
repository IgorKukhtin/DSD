-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpGetJuridicalCollation (TDateTime ,TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalBalance (TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalBalance (TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalBalance (TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalBalance (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalBalance (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalBalance(
    IN inOperDate         TDateTime , -- 
    IN inJuridicalId      Integer,    -- ����������� ����
    IN inPartnerId        Integer,    -- 
    IN inContractId       Integer,    -- �������
    IN inAccountId        Integer,    -- ���� 
    IN inPaidKindId       Integer   , --
    IN inInfoMoneyId      Integer,    -- �������������� ������  
    IN inCurrencyId       Integer   , -- ������ 
   OUT outStartBalance                TFloat,
   OUT outStartBalanceCurrency        TFloat,
   OUT outJuridicalName               TVarChar,
   OUT outJuridicalShortName          TVarChar,
   OUT outPartnerName                 TVarChar,
   OUT outCurrencyName                TVarChar,
   OUT outInternalCurrencyName        TVarChar,
   OUT outAccounterName               TVarChar,
   OUT outContracNumber               TVarChar,
   OUT outContractTagName             TVarChar,
   OUT outContractSigningDate         TDateTime,
   OUT outJuridicalName_Basis         TVarChar,
   OUT outJuridicalShortName_Basis    TVarChar,
   OUT outAccounterName_Basis         TVarChar,
    IN inSession                      TVarChar    -- ������ ������������
)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- ���� ������, ������� ������� �������
     WITH tmpContract AS (SELECT COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) AS ContractId
                          FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey
                               LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey_find ON View_Contract_ContractKey_find.ContractKeyId = View_Contract_ContractKey.ContractKeyId
                          WHERE View_Contract_ContractKey.ContractId = inContractId)
        , tmpContainer AS (SELECT CLO_Juridical.ContainerId               AS ContainerId
                                , Container_Currency.Id                   AS ContainerId_Currency
                                , Container.Amount                        AS Amount
                                , COALESCE (Container_Currency.Amount, 0) AS Amount_Currency
                           FROM ContainerLinkObject AS CLO_Juridical
                                INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId
                                                    AND Container.DescId = zc_Container_Summ()
                                LEFT JOIN ContainerLinkObject AS CLO_Partner
                                                              ON CLO_Partner.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                              ON CLO_InfoMoney.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                              ON CLO_Contract.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                                              ON CLO_PaidKind.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                LEFT JOIN tmpContract ON tmpContract.ContractId = CLO_Contract.ObjectId

                                LEFT JOIN ContainerLinkObject AS CLO_Currency ON CLO_Currency.ContainerId = CLO_Juridical.ContainerId AND CLO_Currency.DescId = zc_ContainerLinkObject_Currency()
                                LEFT JOIN Container AS Container_Currency ON Container_Currency.ParentId = CLO_Juridical.ContainerId AND Container_Currency.DescId = zc_Container_SummCurrency()

                           WHERE CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0
                             AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
                             AND (CLO_Partner.ObjectId = inPartnerId OR COALESCE (inPartnerId, 0) = 0)
                             AND (Container.ObjectId = inAccountId OR COALESCE (inAccountId, 0) = 0)
                             AND (CLO_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                             AND (CLO_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
                             AND (tmpContract.ContractId > 0 OR COALESCE (inContractId, 0) = 0)
                             AND (CLO_Currency.ObjectId = inCurrencyId OR COALESCE (inCurrencyId, 0) = 0 OR COALESCE (inCurrencyId, 0) = zc_Enum_Currency_Basis())
                          )
        , tmpSummContract_all AS (SELECT tmpContainer.ContainerId
                                       , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                                  FROM tmpContainer
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                      AND MIContainer.OperDate >= inOperDate
                                  GROUP BY tmpContainer.ContainerId, tmpContainer.Amount
                                 )
        , tmpSummContract AS (SELECT /*tmpSummContract_all.ContainerId,*/ SUM (tmpSummContract_all.Amount) AS Amount
                              FROM tmpSummContract_all
                              -- GROUP BY tmpSummContract_all.ContainerId
                             )
        , tmpSummContractCurrency_all AS (SELECT tmpContainer.ContainerId
                                               , tmpContainer.ContainerId_Currency
                                               , tmpContainer.Amount_Currency - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                                          FROM tmpContainer
                                               LEFT JOIN MovementItemContainer AS MIContainer
                                                                               ON MIContainer.Containerid = tmpContainer.ContainerId_Currency
                                                                              AND MIContainer.OperDate >= inOperDate
                                          GROUP BY tmpContainer.ContainerId, tmpContainer.ContainerId_Currency, tmpContainer.Amount_Currency
                                         )
        , tmpSummContractCurrency AS (SELECT /*tmpSummContractCurrency_all.ContainerId, */ SUM (tmpSummContractCurrency_all.Amount) AS Amount
                                      FROM tmpSummContractCurrency_all
                                      -- GROUP BY tmpSummContractCurrency_all.ContainerId
                                     )
        , tmpSumm AS (SELECT SUM (Amount) AS Amount FROM tmpSummContract)
        , tmpSummCurrency AS (SELECT SUM (Amount) AS Amount FROM tmpSummContractCurrency)

     SELECT COALESCE (tmpSumm.Amount, 0) :: TFloat         AS StartBalance
          , COALESCE (tmpSummCurrency.Amount, 0) :: TFloat AS StartBalanceCurrency
          , OHS_FullName.ValueData        AS JuridicalName
          , Object_Juridical.ValueData    AS JuridicalShortName
          , COALESCE (Object_Partner.ValueData, OHS_FullName.ValueData) AS PartnerName
          , Object_Currency_View.Name         AS CurrencyName
          , Object_Currency_View.InternalName AS InternalCurrencyName
          , OHS_AccounterName.ValueData   AS AccounterName
          , View_Contract.InvNumber       AS ContracNumber
          , View_Contract.ContractTagName AS ContractTagName
          , DATE (ObjectDate_Signing.ValueData)  AS ContractSigningDate
          , OHS_FullName_Basis.ValueData            AS JuridicalShortName_Basis
          , Object_Juridical_Basis.ValueData        AS JuridicalName_Basis
          , '���i� �.�.' /*OHS_AccounterName_Basis.ValueData*/   AS AccounterName_Basis
            INTO outStartBalance, outStartBalanceCurrency
               , outJuridicalName, outJuridicalShortName, outPartnerName, outCurrencyName, outInternalCurrencyName, outAccounterName
               , outContracNumber, outContractTagName, outContractSigningDate
               , outJuridicalName_Basis, outJuridicalShortName_Basis, outAccounterName_Basis
     FROM tmpSumm
          LEFT JOIN tmpSummCurrency ON 1 = 1 -- tmpSummCurrency.ContainerId = tmpSumm.ContainerId -- inCurrencyId <> 0
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = inJuridicalId
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = inPartnerId
          LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = inCurrencyId
          LEFT JOIN Object_Currency_View AS Object_Currency_View ON Object_Currency_View.Id = CASE WHEN inCurrencyId <> 0 THEN inCurrencyId ELSE 0 /*zc_Enum_Currency_Basis()*/ END
          LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = inContractId
          LEFT JOIN ObjectDate AS ObjectDate_Signing
                               ON ObjectDate_Signing.ObjectId = View_Contract.ContractId
                              AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()

          LEFT JOIN ObjectHistory_JuridicalDetails_View AS ViewHistory_JuridicalDetails ON ViewHistory_JuridicalDetails.JuridicalId = inJuridicalId
          LEFT JOIN ObjectHistoryString AS OHS_FullName
                                        ON OHS_FullName.ObjectHistoryId = ViewHistory_JuridicalDetails.ObjectHistoryId
                                       AND OHS_FullName.DescId = zc_ObjectHistoryString_JuridicalDetails_FullName()
          LEFT JOIN ObjectHistoryString AS OHS_AccounterName
                                        ON OHS_AccounterName.ObjectHistoryId = ViewHistory_JuridicalDetails.ObjectHistoryId
                                       AND OHS_AccounterName.DescId = zc_ObjectHistoryString_JuridicalDetails_AccounterName()

          LEFT JOIN Object AS Object_Juridical_Basis ON Object_Juridical_Basis.Id = COALESCE (View_Contract.JuridicalBasisId, zc_Juridical_Basis())
          LEFT JOIN ObjectHistory_JuridicalDetails_View AS ViewHistory_JuridicalDetails_Basis ON ViewHistory_JuridicalDetails_Basis.JuridicalId = Object_Juridical_Basis.Id
          LEFT JOIN ObjectHistoryString AS OHS_FullName_Basis
                                        ON OHS_FullName_Basis.ObjectHistoryId = ViewHistory_JuridicalDetails_Basis.ObjectHistoryId
                                       AND OHS_FullName_Basis.DescId = zc_ObjectHistoryString_JuridicalDetails_FullName()
          LEFT JOIN ObjectHistoryString AS OHS_AccounterName_Basis
                                        ON OHS_AccounterName_Basis.ObjectHistoryId = ViewHistory_JuridicalDetails_Basis.ObjectHistoryId
                                       AND OHS_AccounterName_Basis.DescId = zc_ObjectHistoryString_JuridicalDetails_AccounterName()
    ;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.11.14                                        * add RETURNS TABLE...
 10.05.14                                        * add inInfoMoneyId
 05.05.14                                        * add inPaidKindId
 05.05.14                                        * all
 26.03.14                        * 
 18.02.14                        * 
*/

-- ����
-- SELECT * FROM gpReport_JuridicalBalance (inOperDate:= '01.01.2013', inJuridicalId:= 0, inPartnerId:= 0, inContractId:= 0, inAccountId:= 0, inPaidKindId:= 0, inInfoMoneyId:= 0, inCurrencyId:=0, inSession:= zfCalc_UserAdmin()); 
