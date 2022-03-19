-- Function: gpInsert_Movement_Tax_isAutoPrepay()

DROP FUNCTION IF EXISTS gpInsert_Movement_Tax_isAutoPrepay (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Tax_isAutoPrepay (
    IN inStartDate           TDateTime , --
    IN inEndDate             TDateTime , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Insert_Movement_TaxPrepay());
     
     -- ��������� ������� ������ ������  ������� �� �� ����� �� �� �� ������
     CREATE TEMP TABLE tmpReport (JuridicalId Integer, ContractId Integer, Amount TFloat) ON COMMIT DROP;
     INSERT INTO tmpReport (JuridicalId, ContractId,  Amount)
       SELECT tmp.JuridicalId
            , 0 AS ContractId--, tmp.ContractId
            , (CASE WHEN tmp.EndAmount_A < 0 AND tmp.StartAmount_A >= 0 THEN (-1) * tmp.EndAmount_A
                    WHEN tmp.EndAmount_A < 0 AND tmp.StartAmount_A < 0 AND (-1) * tmp.EndAmount_A > (-1) * tmp.StartAmount_A THEN ((-1) * tmp.EndAmount_A - (-1) * tmp.StartAmount_A)
                    ELSE 0
               END) ::TFloat AS Amount
       FROM (SELECT tmp.JuridicalId
                  , SUM (COALESCE (tmp.StartAmount_A,0)) AS StartAmount_A
                  , SUM (COALESCE (tmp.EndAmount_A,0))   AS EndAmount_A
             FROM gpReport_JuridicalSold(inStartDate              := inStartDate ::TDateTime
                                       , inEndDate                := inEndDate   ::TDateTime
                                       , inAccountId              := 0
                                       , inInfoMoneyId            := zc_Enum_InfoMoney_30101()           --������� ��������� inInfoMoneyId := 8962
                                       , inInfoMoneyGroupId       := 0
                                       , inInfoMoneyDestinationId := 0
                                       , inPaidKindId             := zc_Enum_PaidKind_FirstForm()
                                       , inBranchId               := 0
                                       , inJuridicalGroupId       := 0
                                       , inCurrencyId             := 0
                                       , inIsPartionMovement      := 'False'
                                       , inSession                := inSession
                                         ) AS tmp
             WHERE tmp.AccountId IN (9128, 9121, 9130, 9136, 9129)
             GROUP BY tmp.JuridicalId
             ) AS tmp
       WHERE (tmp.EndAmount_A < 0 AND tmp.StartAmount_A >= 0)
          OR (tmp.EndAmount_A < 0 AND tmp.StartAmount_A < 0 AND (-1) * tmp.EndAmount_A > (-1) * tmp.StartAmount_A)
       /*
       HAVING SUM (CASE WHEN tmp.EndAmount_A < 0 AND tmp.StartAmount_A >= 0 THEN (-1) * tmp.EndAmount_A
                        WHEN tmp.EndAmount_A < 0 AND tmp.StartAmount_A < 0 AND (-1) * tmp.EndAmount_A > (-1) * tmp.StartAmount_A THEN ((-1) * tmp.EndAmount_A - (-1) * tmp.StartAmount_A)
                        ELSE 0
                   END) > 0.2
       */
    -- limit 1 -- ��� �����
      ; 

     -- ������� ��������� �� �� ����������
     PERFORM lpInsert_Movement_Tax_isAutoPrepay (inId                 := 0 ::Integer    -- ���� ������� <�������� ���������>
                                               , inInvNumber          := ''                    ::TVarChar   -- ����� ���������
                                               , inInvNumberPartner   := ''                    ::TVarChar   -- ����� ���������� ���������
                                               , inInvNumberBranch    := ''                    ::TVarChar   -- ����� �������
                                               , inOperDate           := inEndDate             ::TDateTime  -- ���� ���������
                                               , inisAuto             := TRUE                  ::Boolean    -- ������ �������������
                                               , inChecked            := FALSE                 ::Boolean    -- ��������
                                               , inDocument           := FALSE                 ::Boolean    -- ���� �� ����������� ��������
                                               , inPriceWithVAT       := FALSE                 ::Boolean    -- ���� � ��� (��/���)
                                               , inVATPercent         := CAST (TaxPercent_View.Percent as TFloat) ::TFloat     -- % ���
                                               , inAmount             := (1 / (1+TaxPercent_View.Percent/100) * tmpReport.Amount) ::TFloat -- ����� ���������� ��� ���
                                               , inFromId             := Object_Juridical_Basis.Id ::Integer    -- �� ���� (� ���������)  --����
                                               , inToId               := tmpReport.JuridicalId ::Integer    -- ���� (� ���������)
                                               , inPartnerId          := 0                     ::Integer    -- ����������
                                               , inContractId         := tmpReport.ContractId  ::Integer    -- ��������
                                               , inDocumentTaxKindId  := zc_Enum_DocumentTaxKind_Prepay() ::Integer    -- ��� ������������ ���������� ���������
                                               , inUserId             := vbUserId ::Integer     -- ������������ 
                                               )
    FROM tmpReport
         LEFT JOIN TaxPercent_View ON inEndDate BETWEEN TaxPercent_View.StartDate AND TaxPercent_View.EndDate
         LEFT JOIN Object AS Object_Juridical_Basis ON Object_Juridical_Basis.Id = zc_Juridical_Basis()
    WHERE COALESCE (tmpReport.Amount,0) > 0.2;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.12.21         * 
*/

-- ����
-- 1.���� �-�� ���. ������ 0, � �-�� ���. ������ 0, �� ����� �� �� ��= ������ �-�� ���.
-- 2.���� �-�� ���. ������ 0, � �-�� ���. ������ 0, � ������ �-�� ���. ������ ������ �-�� ���., �� ����� �� �� ��= ������ �-�� ���. ����� ������ �-�� ���.
--select * from gpReport_JuridicalSold(inStartDate := ('06.12.2021')::TDateTime , inEndDate := ('07.12.2021')::TDateTime , inAccountId := 0 , inInfoMoneyId := 0 , inInfoMoneyGroupId := 0 , inInfoMoneyDestinationId := 0 , inPaidKindId := 3 , inBranchId := 0 , inJuridicalGroupId := 0 , inCurrencyId := 0 , inIsPartionMovement := 'False' ,  inSession := '9457');