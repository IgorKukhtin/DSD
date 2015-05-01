-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpLoadMoneyFrom1C (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpLoadMoneyFrom1C(
    IN inId                  Integer    , 
    IN inBranchId            Integer    , -- ������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
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


     -- �������� ������ �� ������
     SELECT Money1C.InvNumber
          , Money1C.OperDate
          , Money1C.ClientCode
          , Money1C.SummaIn 
          , Money1C.SummaOut
            INTO vbInvNumber, vbOperDate, vbPartnerCode, vbSummaIn, vbSummaOut
     FROM Money1C WHERE Id = inId;


     -- ����� �����
     vbCashId:= (SELECT Object.Id
                 FROM Object
                      INNER JOIN ObjectLink AS Cash_Currency
                                            ON Cash_Currency.ObjectId = Object.Id
                                           AND Cash_Currency.DescId = zc_ObjectLink_Cash_Currency()
                      INNER JOIN ObjectLink AS Cash_Branch
                                            ON Cash_Branch.ObjectId = Object.Id
                                           AND Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
                                           AND Cash_Branch.ChildObjectId = inBranchId
                  WHERE Object.DescId = zc_Object_Cash() AND Cash_Currency.ChildObjectId = (lpGet_DefaultValue('zc_Object_Currency', 0) :: Integer)
                 );

     -- ����� ����� ��������
     SELECT ObjectLink_Partner1CLink_Contract.ChildObjectId AS ContractId 
          , ObjectLink_Partner1CLink_Partner.ChildObjectId AS PartnerId
          , View_Contract_InvNumber.InfoMoneyId
            INTO vbContractId, vbPartnerId, vbInfoMoneyId
     FROM Object AS Object_Partner1CLink
          INNER JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                               AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                               AND ObjectLink_Partner1CLink_Branch.ChildObjectId = zfGetBranchLinkFromBranchPaidKind (inBranchId, zc_Enum_PaidKind_SecondForm())
          INNER JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
          LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                               ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                              AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()
          LEFT JOIN Object_Contract_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = ObjectLink_Partner1CLink_Contract.ChildObjectId
     WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
       AND Object_Partner1CLink.ObjectCode = vbPartnerCode;
                    

     -- !!! ��� ������ �� ���������!!!
     IF vbPartnerId = zc_Enum_InfoMoney_40801() -- ���������� ������
     THEN RETURN;
     END IF;


     -- ����� ��������
     vbMovementId:= 0; /*(SELECT Movement.Id
                     FROM Movement
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                                                 AND MovementItem.ObjectId = vbCashId
                          INNER JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                            ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                                           AND MILinkObject_MoneyPlace.ObjectId = vbPartnerId
                     WHERE Movement.DescId = zc_Movement_Cash()
                       AND Movement.OperDate = vbOperDate
                       AND Movement.InvNumber = vbInvNumber
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                     );*/
         
     -- ���������� ��������� + ����������/�������������
     SELECT tmp.ioId INTO vbMovementId
     FROM gpInsertUpdate_Movement_Cash (ioId          := vbMovementId      -- ���� ������� <��������>
                                                , inInvNumber   := vbInvNumber       -- ����� ���������
                                                , inOperDate    := vbOperDate        -- ���� ���������
                                                , inServiceDate := NULL              -- ���� ����������
                                                , inAmountIn    := vbSummaIn         -- ����� �������
                                                , inAmountOut   := vbSummaOut        -- ����� �������
                                                , inAmountSumm  := NULL              -- C���� ���, �����
                                                , inComment     := ''                -- �����������
                                                , inCashId      := vbCashId          -- �����
                                                , inMoneyPlaceId:= vbPartnerId       -- ������� ������ � ��������
                                                , inPositionId  := NULL              -- ���������
                                                , inMemberId    := NULL              -- ��� ���� (����� ����)
                                                , inContractId  := vbContractId      -- ��������
                                                , inInfoMoneyId := vbInfoMoneyId     -- �������������� ������
                                                , inUnitId      := NULL              -- �������������
                                                , inCurrencyId           := NULL     -- ������ 
                                                , inCurrencyPartnerValue := NULL     -- ���� ��� ������� ����� ��������
                                                , inParPartnerValue      := NULL     -- ������� ��� ������� ����� ��������
                                                , inMovementId_Partion   := 0
                                                , inSession     := inSession         -- ������ ������������
                                                 ) AS tmp;
   
     -- ��������� �������� <�������� �� 1�>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), vbMovementId, TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.01.15                                        * all
 08.09.14                                        * 
 02.09.14                         * 
*/

-- ����
-- SELECT * FROM gpLoadMoneyFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
