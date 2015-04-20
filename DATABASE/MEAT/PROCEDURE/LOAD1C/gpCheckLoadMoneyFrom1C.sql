-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpCheckLoadMoneyFrom1C (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLoadMoneyFrom1C(
    IN inStartDate           TDateTime  , -- ��������� ���� ��������
    IN inEndDate             TDateTime  , -- �������� ���� ��������
    IN inBranchId            Integer    , -- ������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMoneyCount Integer;
   DECLARE vbCount Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadMoneyFrom1C());
     vbUserId := lpGetUserBySession (inSession);


     -- ���������� ����� ������� (��� �������� ��� ��� ��� �������� �����������)
     SELECT COUNT(*) INTO vbMoneyCount 
       FROM Money1C 
      WHERE Money1C.OperDate BETWEEN inStartDate AND inEndDate
        AND inBranchId = zfGetBranchFromUnitId (Money1C.UnitId);

     -- ���������� ����� ��������� ������� (��� �������� ��� ��� ��� �������� �����������)
     SELECT COUNT(*) INTO vbCount
      FROM Money1C
           JOIN (SELECT Object_Partner1CLink.ObjectCode
                      , ObjectLink_Partner1CLink_Branch.ChildObjectId  AS BranchId
                 FROM Object AS Object_Partner1CLink
                      LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                           ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                          AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                      LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                                           ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                                          AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()                                 
                      LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                           ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                          AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
                      LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_Partner1CLink_Partner.ChildObjectId
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner1CLink_Partner.ChildObjectId
                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                      LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = ObjectLink_Partner1CLink_Contract.ChildObjectId
                                                    AND Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                 WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                   AND Object_Partner1CLink.ObjectCode <> 0
                   AND (Object_Contract_View.ContractId <> 0 OR Object_To.DescId <> zc_Object_Partner()) -- �������� ������� ������ ��� �����������
                   AND ObjectLink_Partner1CLink_Partner.ChildObjectId <> 0 -- ��� �������� ��� ���� ������
                ) AS tmpPartner1CLink ON tmpPartner1CLink.ObjectCode = Money1C.ClientCode
                                     AND tmpPartner1CLink.BranchId = zfGetBranchLinkFromBranchPaidKind (zfGetBranchFromUnitId (Money1C.UnitId), zc_Enum_PaidKind_SecondForm())
     WHERE Money1C.OperDate BETWEEN inStartDate AND inEndDate AND inBranchId = zfGetBranchFromUnitId (Money1C.UnitId);


     -- ��������
     IF vbMoneyCount <> vbCount THEN 
        RAISE EXCEPTION '������. �� ��� ������ ������������������. ������� �� ��������.'; --  <%> <%> <%>, inBranchId, vbMoneyCount, vbCount; 
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 08.09.14                                        * add �������� ������� ������ ��� �����������
 26.08.14                                        * add ��� �������� ��� ���� ������
 14.08.14                        * ����� ����� � ���������
 22.05.14                                        * add ObjectCode <> 0
 24.04.14                         * 
*/

-- ����
-- SELECT * FROM gpCheckLoadMoneyFrom1C ('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, 8379, zfCalc_UserAdmin())
