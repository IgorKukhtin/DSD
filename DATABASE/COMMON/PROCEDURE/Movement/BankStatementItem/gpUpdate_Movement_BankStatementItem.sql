-- Function: gpInsertUpdate_Movement_BankStatementItem()

DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem(Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem(Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem(Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem(Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_BankStatementItem(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inJuridicalId         Integer   , -- ���  
    IN inPartnerId           Integer   , -- ����������  
    IN inInfoMoneyId         Integer   , -- �������������� ������ 
    IN inContractId          Integer   , -- �������  
    IN inUnitId              Integer   , -- �������������
    IN inMovementId_Invoice  Integer   , -- �������� ����
    IN inServiceDate         TDateTime , --
   OUT outServiceDate        TDateTime , --
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_BankStatementItem());

      
     IF inJuridicalId = 0 THEN
        inJuridicalId := NULL;
     END IF; 
     IF inInfoMoneyId = 0 THEN
        inInfoMoneyId := NULL;
     END IF; 
     IF inContractId = 0 THEN
        inContractId := NULL;
     END IF; 
     IF inUnitId = 0 THEN
        inUnitId := NULL;
     END IF; 

     IF inInfoMoneyId IN (zc_Enum_InfoMoney_60101() -- ���������� ����� + ���������� �����
                        , zc_Enum_InfoMoney_60102() -- ���������� ����� + ��������
                         )
     THEN
         -- ������ 1-�� ����� ������
         outServiceDate := DATE_TRUNC ('MONTH', inServiceDate);
     ELSE
         outServiceDate := NULL;
     END IF;

     
     -- ��������� ������
     PERFORM lpInsertUpdate_Movement (ioId:= Id, inDescId:= DescId, inInvNumber:= InvNumber, inOperDate:= OperDate, inParentId:= ParentId, inAccessKeyId:= AccessKeyId)
     FROM Movement WHERE Id = ioId -- AND inSession <> '5'
    ;

     -- �������� ��������� ��������
     IF NOT EXISTS (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyId = inInfoMoneyId AND (InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500() -- ���������

                                                                                                                                 , zc_Enum_InfoMoneyDestination_30500() -- ������ ������

                                                                                                                                 , zc_Enum_InfoMoneyDestination_40100() -- ������� ������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40200() -- ������ �������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40300() -- ���������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40400() -- �������� �� ��������
                                                                                                                                 -- , zc_Enum_InfoMoneyDestination_40500() -- �����
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40600() -- ��������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40700() -- ����
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40800() -- ���������� ������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40900() -- ���������� ������

                                                                                                                                 , zc_Enum_InfoMoneyDestination_50100() -- ��������� ������� �� ��
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50200() -- ��������� �������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50300() -- ��������� ������� (������)
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50400() -- ������ � ������

                                                                                                                                 , zc_Enum_InfoMoneyDestination_41000() -- �������/������� ������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_41100() -- ���������� ��������
                                                                                                                                 )
                                                                                                         OR InfoMoneyId = zc_Enum_InfoMoney_21419() -- ������ �� �������
                                                                                                        )
                    )
        -- AND EXISTS (SELECT Id FROM gpGet_Movement_BankStatementItem (inMovementId:= ioId, inSession:= inSession) WHERE ContractId = inContractId)
        AND NOT EXISTS (SELECT ContractId FROM Object_Contract_View WHERE ContractId = inContractId AND InfoMoneyId = inInfoMoneyId)
        AND NOT EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inJuridicalId AND DescId = zc_ObjectLink_Juridical_InfoMoney() AND ChildObjectId IN (zc_Enum_InfoMoney_20801(), zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_21001(), zc_Enum_InfoMoney_21101())) -- ���� + ���� + ����� + �������
        AND inContractId > 0
     THEN
         RAISE EXCEPTION '������.�������� �������� ��� <�� ������ ����������>.';
     END IF;
     -- ��������
     IF COALESCE (inMovementId_Invoice, 0) = 0 AND EXISTS (SELECT 1 FROM Object_InfoMoney_View AS View_InfoMoney WHERE View_InfoMoney.InfoMoneyId = inInfoMoneyId AND View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()) -- ����������
     THEN
        RAISE EXCEPTION '������.��� �� ������ <%> ���������� ��������� �������� <� ���. ����>.', lfGet_Object_ValueData (inInfoMoneyId);
     END IF;


     -- ��������� ����� � <��. ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
     -- ��������� ����� � <�������������� ������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);     
     -- ��������� ����� � <�������������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);

     -- ��������� ����� � ���������� <����>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);

     -- ����������� �������� <����� ����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), ioId, outServiceDate);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.07.24         *
 12.09.18         * add ServiceDate
 21.07.16         * zc_MovementLinkMovement_Invoice
 07.03.14                                        * add zc_Enum_InfoMoney_21419
 18.03.14                                        * lpInsertUpdate_Movement
 13.03.14                                        * add �������� ��������� ��������
 03.12.13                        *
 13.08.13          *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_BankStatementItem (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFileName:= 'xxx', inBankAccountId:= 1, inSession:= '2')

