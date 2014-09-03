-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpLoadMoneyFrom1C (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpLoadMoneyFrom1C(
    IN inId                  Integer    , 
    IN inBranchId            Integer    , -- ������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbCashId Integer;
   DECLARE vbOperDate TDateTime;  
   DECLARE vbMovementId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbPartnerCode Integer;
   DECLARE vbContractId Integer;
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbSummaIn TFloat;
   DECLARE vbSummaOut TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadMoneyFrom1C());
     vbUserId := lpGetUserBySession (inSession);

     -- �������� ����������                                   

     -- �������� ������ �� ������
     SELECT 
         Money1C.InvNumber
       , Money1C.OperDate
       , Money1C.ClientCode
       , Money1C.SummaIn 
       , Money1C.SummaOut INTO vbInvNumber, vbOperDate, vbPartnerCode, vbSummaIn, vbSummaOut
    FROM Money1C WHERE Id = inId;

     -- ����� �����
     SELECT  
          Object.Id INTO vbCashId
       FROM Object
           JOIN ObjectLink AS Cash_Currency
                           ON Cash_Currency.ObjectId = Object.Id
                          AND Cash_Currency.DescId = zc_ObjectLink_Cash_Currency()
           JOIN ObjectLink AS Cash_Branch
                           ON Cash_Branch.ObjectId = Object.Id
                          AND Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
       WHERE (Cash_Branch.ChildObjectId = inBranchId) AND (Cash_Currency.ChildObjectId = lpGet_DefaultValue('zc_Object_Currency', 0)::integer);

     -- ����� ����� ��������
     SELECT ObjectLink_Partner1CLink_Contract.ChildObjectId AS ContractId 
          , ObjectLink_Partner1CLink_Partner.ChildObjectId AS PartnerId 
          , ocv.infomoneyid INTO vbContractId, vbPartnerId, vbInfoMoneyId
       FROM Object AS Object_Partner1CLink
            JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                            ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                           AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
                           
            JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                            ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                           AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
            JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                            ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                           AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()                                 
                           
       LEFT JOIN Object_Contract_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = ObjectLink_Partner1CLink_Contract.ChildObjectId, Object_Contract_View AS ocv   

           WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                           AND Object_Partner1CLink.ObjectCode = vbPartnerCode
                           AND ObjectLink_Partner1CLink_Branch.ChildObjectId = zfGetBranchLinkFromBranchPaidKind(inBranchId, zc_Enum_PaidKind_SecondForm());
                    
    SELECT Movement.Id INTO vbMovementId FROM 

       Movement
            JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                        ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                       AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            
       WHERE Movement.DescId = zc_Movement_Cash()
         AND Movement.OperDate = vbOperDate
         AND MovementItem.objectid = vbCashId
         AND MILinkObject_MoneyPlace.ObjectId = vbPartnerId
         AND InvNumber = vbInvNumber
         AND statusid = zc_enum_status_complete();
         

        PERFORM gpInsertUpdate_Movement_Cash(
              ioId := vbMovementId                , -- ���� ������� <��������>
       inInvNumber := vbInvNumber      , -- ����� ���������
        inOperDate := vbOperDate       , -- ���� ���������
     inServiceDate := NULL             , -- ���� ����������
        inAmountIn := vbSummaIn        , -- ����� �������
       inAmountOut := vbSummaOut       , -- ����� �������
         inComment := ''               , -- �����������
          inCashId := vbCashId         , -- �����
    inMoneyPlaceId := vbPartnerId      , -- ������� ������ � ��������
      inPositionId := NULL             , -- ���������
        inMemberId := NULL             , -- ��� ���� (����� ����)
      inContractId := vbContractId     , -- ��������
     inInfoMoneyId := vbInfoMoneyId    , -- �������������� ������
          inUnitId := NULL             , -- �������������
         inSession := inSession);          -- ������ ������������
   
     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 02.09.14                         * 
*/

-- ����
-- SELECT * FROM gpLoadMoneyFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
