-- Function: gpInsertUpdate_Movement_BankStatementItemLoad()

DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_BankStatementItemLoad(TVarChar, TDateTime, TVarChar, TVarChar,  
                                                 TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, 
                                                 TVarChar, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_BankStatementItemLoad(TVarChar, TDateTime, TVarChar, TVarChar,  
                                                 TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, 
                                                 TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_BankStatementItemLoad(TVarChar, TDateTime, TVarChar, TVarChar,  
                                                 TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, 
                                                 TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankStatementItemLoad(
    IN inDocNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inBankAccountMain     TVarChar  , -- ��������� ����
    IN inBankMFOMain         TVarChar  , -- ��� 
    IN inOKPO                TVarChar  , -- ����
    IN inJuridicalName       TVarChar  , -- ��. ����
    IN inBankAccount         TVarChar  , -- ��������� ����
    IN inBankMFO             TVarChar  , -- ��� 
    IN inBankName            TVarChar  , -- �������� ����� 
    IN inCurrencyCode        TVarChar  , -- ��� ������ 
    IN inCurrencyName        TVarChar  , -- �������� ������ 
    IN inAmount              TFloat    , -- ����� �������� 
    IN inComment             TVarChar  , -- �����������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMainBankAccountId integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbContractId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbCurrencyId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankStatementItemLoad());


   -- 1. ����� ���� �� ���� � ���� � ����������� ������. 
   SELECT Object_BankAccount.Id INTO vbMainBankAccountId
     FROM Object AS Object_BankAccount 
    WHERE Object_BankAccount.DescId = zc_Object_BankAccount() AND Object_BankAccount.ValueData = inBankAccountMain;

   -- 2. ���� ������ ����� ���, �� ������ ��������� �� ������ � �������� ���������� ��������
   IF COALESCE(vbMainBankAccountId, 0) = 0  THEN
--      RETURN 0;
      RAISE EXCEPTION '���� "%" �� ������ � ����������� ������.% �������� �� ��������', inBankAccountMain, chr(13);
   END IF;

   SELECT Object_Currency_View.Id INTO vbCurrencyId
     FROM Object_Currency_View 
    WHERE Object_Currency_View.Code = zfConvert_StringToNumber(inCurrencyCode) OR InternalName = inCurrencyName;

   IF COALESCE(vbCurrencyId, 0) = 0 THEN
      SELECT Object_BankAccount_View.CurrencyId INTO vbCurrencyId 
      FROM Object_BankAccount_View WHERE Object_BankAccount_View.Id = vbMainBankAccountId;
   END IF;

   -- 2. ���� ����� ������ ���, �� ������ ��������� �� ������ � �������� ���������� ��������
   IF COALESCE(vbCurrencyId, 0) = 0  THEN
      RAISE EXCEPTION '������ "%" "%" �� ���������� � ����������� �����.% ���������� �������� �� ��������', inCurrencyCode, inCurrencyName, chr(13);
   END IF;

--  4. ����� �������� zc_Movement_BankStatement �� ���� � ���������� �����. 
   SELECT Movement.Id INTO vbMovementId 
     FROM Movement
     JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id AND MovementLinkObject.ObjectId = vbMainBankAccountId
      AND MovementLinkObject.DescId = zc_MovementLinkObject_BankAccount()
    WHERE Movement.OperDate = inOperDate AND Movement.DescId = zc_Movement_BankStatement() AND Movement.StatusId = zc_Enum_Status_UnComplete();


    IF COALESCE(vbMovementId, 0) = 0 THEN
       -- 5. ���� ������ ��������� ��� - ������� ���
       -- ��������� <��������>
       vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_BankStatement(), NEXTVAL ('Movement_BankStatement_seq') :: TVarChar, inOperDate, NULL);              
       PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_BankAccount(), vbMovementId, vbMainBankAccountId);
    END IF;

    --6. ����� �������� zc_Movement_BankStatementItem ������, �����������, ���� � �/c
    
    SELECT Movement.Id INTO vbMovementItemId 
     FROM Movement
     JOIN MovementString AS MovementString_OKPO
       ON MovementString_OKPO.MovementId =  Movement.Id
      AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
     JOIN MovementString AS MovementString_BankAccount
       ON MovementString_BankAccount.MovementId =  Movement.Id
      AND MovementString_BankAccount.DescId = zc_MovementString_BankAccount()
     JOIN MovementString AS MovementString_Comment
       ON MovementString_Comment.MovementId =  Movement.Id
      AND MovementString_Comment.DescId = zc_MovementString_Comment()
    WHERE Movement.ParentId = vbMovementId 
      AND Movement.DescId = zc_Movement_BankStatementItem() 
      AND Movement.InvNumber = inDocNumber
      AND MovementString_OKPO.ValueData = inOKPO
      AND MovementString_BankAccount.ValueData = inBankAccount
      AND MovementString_Comment.ValueData = inComment;

    IF COALESCE(vbMovementItemId, 0) = 0 THEN
       -- 7. ���� ������ ��������� ��� - ������� ���
       -- ��������� <��������>
       vbMovementItemId := lpInsertUpdate_Movement (0, zc_Movement_BankStatementItem(), inDocNumber, inOperDate, vbMovementId);              
    END IF;

    -- ��������� �������� <����� ��������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), vbMovementItemId, inAmount);
     -- ��������� �������� <����>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO (), vbMovementItemId, inOKPO);
     -- ��������� �������� <����������� ����>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_JuridicalName (), vbMovementItemId, inJuridicalName);
     -- ��������� �������� <�����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment (), vbMovementItemId, inComment);
     -- ��������� �������� <��������� ����>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BankAccount (), vbMovementItemId, inBankAccount);
     -- ��������� �������� <���>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BankMFO (), vbMovementItemId, inBankMFO);
     -- ��������� �������� <�������� �����>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BankName (), vbMovementItemId, inBankName);
     -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Currency (), vbMovementItemId, vbCurrencyId);


    -- ���������� �������� ��. ����
    SELECT ObjectId INTO vbJuridicalId FROM MovementLinkObject  
     WHERE DescId = zc_MovementLinkObject_Juridical() AND MovementId = vbMovementItemId;



    IF COALESCE(vbJuridicalId, 0) = 0 THEN
       -- �������� ����� ��������� ����
       SELECT Object_BankAccount.Id INTO vbJuridicalId
         FROM Object AS Object_BankAccount 
        WHERE Object_BankAccount.DescId = zc_Object_BankAccount() AND Object_BankAccount.ValueData = inBankAccount;

       IF COALESCE(vbJuridicalId, 0) = 0 THEN
         -- �������� ����� ��. ���� �� OKPO
         SELECT ObjectHistory.ObjectId INTO vbJuridicalId
           FROM ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
           JOIN ObjectHistory ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory.Id
          WHERE ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
            AND ObjectHistoryString_JuridicalDetails_OKPO.ValueData = inOKPO
            AND inOperDate BETWEEN ObjectHistory.StartDate AND ObjectHistory.EndDate;
        END IF;
    
        IF COALESCE(vbJuridicalId, 0) <> 0 THEN
           -- ��������� ����� � <��. ����>
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), vbMovementItemId, vbJuridicalId);
        END IF;
    END IF;


    -- ������� �������� <�������>
    -- SELECT ObjectId INTO vbContractId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_Contract() AND MovementId = vbMovementItemId;
    -- ������� �������� <�� ������ ����������>
    -- SELECT ObjectId INTO vbInfoMoneyId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_InfoMoney() AND MovementId = vbMovementItemId;

    -- ������� �������� <�������> "�� ���������"
    SELECT MAX (View_Contract.ContractId) INTO vbContractId
    FROM Object_Contract_View AS View_Contract
         JOIN ObjectBoolean AS ObjectBoolean_Default
                            ON ObjectBoolean_Default.ObjectId = Object_Contract_View.ContractId
                           AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_Contract_Default()
                           AND ObjectBoolean_Default.ValueData = TRUE
    WHERE View_Contract.JuridicalId = vbJuridicalId
      AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
      AND View_Contract.isErased = FALSE;

    IF vbContractId <> 0
    THEN
        -- ������� <�� ������ ����������> !!!������!!! � ��������
        SELECT InfoMoneyId INTO vbInfoMoneyId FROM Object_Contract_InvNumber_View WHERE ContractId = vbContractId;
    END IF;

    -- ���� �� �����, ����� ���������� �������� <�������>
    IF COALESCE (vbContractId, 0) = 0 AND COALESCE (vbJuridicalId, 0) <> 0
    THEN 
        -- ������� <�������> � ��. ���� !!!� ���������� �� ...!!
        SELECT MAX (View_Contract.ContractId) INTO vbContractId
        FROM (SELECT zc_Enum_InfoMoney_30101()         AS InfoMoneyId -- ������ + ��������� + ������� ���������
                   , Object_InfoMoney_View.InfoMoneyId AS InfoMoneyId_Next
              FROM Object_InfoMoney_View
              WHERE InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_30000()) -- ������
                AND inAmount > 0
             UNION ALL
              SELECT Object_InfoMoney_View.InfoMoneyId AS InfoMoneyId
                   , 0 AS InfoMoneyId_Next
              FROM Object_InfoMoney_View
              WHERE InfoMoneyGroupId IN (zc_Enum_InfoMoneyDestination_21500()) -- ������������� + ���������
                AND inAmount < 0
             UNION ALL
              SELECT 0 AS InfoMoneyId
                   , Object_InfoMoney_View.InfoMoneyId AS InfoMoneyId_Next
              FROM Object_InfoMoney_View
              WHERE InfoMoneyGroupId IN (zc_Enum_InfoMoneyDestination_21500()) -- �������� �����
                AND inAmount < 0
             ) AS tmpInfoMoney
             LEFT JOIN Object_Contract_View AS View_Contract
                                            ON View_Contract.JuridicalId = vbJuridicalId
                                           AND View_Contract.InfoMoneyId = tmpInfoMoney.InfoMoneyId
                                           AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                           AND View_Contract.isErased = FALSE
             LEFT JOIN Object_Contract_View AS View_Contract_next
                                            ON View_Contract_next.JuridicalId = vbJuridicalId
                                           AND View_Contract_next.InfoMoneyId = tmpInfoMoney.InfoMoneyId_next
                                           AND View_Contract_next.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                           AND View_Contract_next.isErased = FALSE
                                           AND View_Contract.JuridicalId IS NULL
        ;
        -- ������� <�������> � ��. ���� !!!��� ���������� �� ...!!
        IF COALESCE (vbContractId, 0) = 0
        THEN 
            SELECT MAX (View_Contract.ContractId) INTO vbContractId
            FROM Object_Contract_View AS View_Contract
            WHERE View_Contract.JuridicalId = vbJuridicalId
              AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
              AND View_Contract.isErased = FALSE;
        END IF;

        -- ������� <�� ������ ����������> !!!������!!! � ��������
        SELECT InfoMoneyId INTO vbInfoMoneyId FROM Object_Contract_InvNumber_View WHERE ContractId = vbContractId;
        -- !!!�� ���� ��� ������ �����, ����� ������ <�� ������ ����������> �� "������ �� ���������"
        IF vbInfoMoneyId = zc_Enum_InfoMoney_30101() -- ������� ���������
           AND inAmount < 0
        THEN
            vbInfoMoneyId:= zc_Enum_InfoMoney_21501(); -- ������ �� ���������
        END IF;


        IF COALESCE (vbContractId, 0) <> 0 THEN
           -- ��������� ����� � <�������>
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), vbMovementItemId, vbContractId);     
        END IF;
        IF COALESCE (vbInfoMoneyId, 0) <> 0 THEN
           -- ��������� ����� � <�� ������ ����������>
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), vbMovementItemId, vbInfoMoneyId);
        END IF;

    END IF;  
   
/*
    IF (COALESCE(vbInfoMoneyId, 0) = 0) AND (COALESCE(vbJuridicalId, 0) <> 0) THEN 
       -- ������� <�������������� ������> � ��. ����
       SELECT ChildObjectId INTO vbInfoMoneyId 
       FROM ObjectLink 
       WHERE ObjectId = vbJuridicalId AND DescId = zc_ObjectLink_Juridical_InfoMoney();
       IF COALESCE(vbInfoMoneyId, 0) <> 0 THEN
          -- ��������� ����� � <�������������� ������>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), vbMovementItemId, vbInfoMoneyId);
       END IF;
    END IF;*/

/*   -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);
  */

   RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 17.03.14                                        * ������� �������� <�������> "�� ���������"
 13.02.14                                        * ������� <�������> � <�� ������ ����������> !!!������!!! � ��������
 03.12.13                                        *
 13.11.13                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_BankStatementItemLoad (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFileName:= 'xxx', inBankAccountId:= 1, inSession:= '2')
