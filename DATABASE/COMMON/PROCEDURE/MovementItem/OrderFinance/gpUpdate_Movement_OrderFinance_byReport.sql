-- Function: gpUpdate_Movement_OrderFinance_byReport()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderFinance_byReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderFinance_byReport(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());

    CREATE TEMP TABLE _tmpReport (JuridicalId Integer, PaidKindId Integer, ContractId Integer
                                , DebetRemains TFloat, KreditRemains TFloat
                                , DefermentPaymentRemains TFloat   --���� � ���������
                                , Remains TFloat) ON COMMIT DROP;
    INSERT INTO _tmpReport (JuridicalId, PaidKindId, ContractId
                          , DebetRemains, KreditRemains
                          , DefermentPaymentRemains   --���� � ���������
                          , Remains)
	    SELECT JuridicalId, PaidKindId, ContractId
                 , DebetRemains, KreditRemains
                 , DefermentPaymentRemains   --���� � ���������
                 , Remains 
            FROM gpReport_JuridicalDefermentIncome(inOperDate      := vbOperDate 
                                                 , inEmptyParam    := vbOperDate
                                                 , inAccountId     := 0
                                                 , inPaidKindId    := vbPaidKindId
                                                 , inBranchId      := 0
                                                 , inJuridicalGroupId := 0
                                                 , inSession       := inSession);

SELECT *
            FROM gpReport_JuridicalDefermentIncome(inOperDate      := '30.07.2019' 
                                                 , inEmptyParam    := '30.07.2019'
                                                 , inAccountId     := 0
                                                 , inPaidKindId    := 3
                                                 , inBranchId      := 0
                                                 , inJuridicalGroupId := 0
                                                 , inSession       := '5'::TVarchar);
                                                 
                                                 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.07.19         *
*/

-- ����
--