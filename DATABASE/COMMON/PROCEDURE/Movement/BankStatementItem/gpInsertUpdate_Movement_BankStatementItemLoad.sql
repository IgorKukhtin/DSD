-- Function: gpInsertUpdate_Movement_BankStatementItemLoad()

DROP FUNCTION IF EXISTS
   gpInsertUpdate_Movement_BankStatementItemLoad(TVarChar, TDateTime, TVarChar, TVarChar,
                                                 TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                 TVarChar, TVarChar, TFloat, TVarChar, TVarChar);

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
   DECLARE vbBankId Integer;
   DECLARE vbAmountCurrency TFloat;

   DECLARE vbCurrencyValue TFloat;
   DECLARE vbParValue TFloat;
   DECLARE vbCurrencyPartnerValue TFloat;
   DECLARE vbParPartnerValue TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankStatementItemLoad());
 
 
    -- 1. ����� ���� �� ���� � ���� � ����������� ������.
    vbMainBankAccountId:= (SELECT View_BankAccount.Id
                           FROM Object_BankAccount_View AS View_BankAccount
                           WHERE View_BankAccount.Name        = TRIM (inBankAccountMain)
                             AND View_BankAccount.isCorporate = TRUE
                           ORDER BY 1
                           LIMIT 1 -- ???���� �� ���������???
                          );
 
    -- 2. ���� ������ ����� ���, �� ������ ��������� �� ������ � �������� ���������� ��������
    IF COALESCE (vbMainBankAccountId, 0) = 0
    THEN
        RAISE EXCEPTION '���� "%" �� ������ � ����������� ������.% �������� �� ��������', TRIM (inBankAccountMain), chr(13);
    END IF;
 
 
    -- 3. ���� OKPO ������, ������ ��� ���������� �������� �� �����, � ����� ������ ���� ����� OKPO �� �������� ���������� �����
    IF COALESCE (inOKPO, '') = ''
    THEN
        --
        SELECT ObjectHistory_JuridicalDetails_ViewByDate.OKPO INTO inOKPO
          FROM Object_BankAccount_View
          JOIN ObjectLink AS ObjectLink_Bank_Juridical
                          ON ObjectLink_Bank_Juridical.ObjectId = Object_BankAccount_View.BankId
                         AND ObjectLink_Bank_Juridical.DescId = zc_ObjectLink_Bank_Juridical()
  
          JOIN ObjectHistory_JuridicalDetails_ViewByDate
            ON ObjectHistory_JuridicalDetails_ViewByDate.JuridicalId = ObjectLink_Bank_Juridical.ChildObjectId
           AND inOperDate >= ObjectHistory_JuridicalDetails_ViewByDate.StartDate AND inOperDate < ObjectHistory_JuridicalDetails_ViewByDate.EndDate
         WHERE Object_BankAccount_View.NAME = inBankAccountMain;
    END IF;
 
    -- �����
    vbCurrencyId:= (SELECT View_Currency.Id FROM Object_Currency_View AS View_Currency WHERE View_Currency.Code = zfConvert_StringToNumber (inCurrencyCode) OR View_Currency.InternalName = inCurrencyName);
    -- �����
    IF COALESCE(vbCurrencyId, 0) = 0 THEN
       vbCurrencyId:= (SELECT View_BankAccount.CurrencyId FROM Object_BankAccount_View AS View_BankAccount WHERE View_BankAccount.Id = vbMainBankAccountId);
    END IF;
 
 
    -- 4. ���� ����� ������ ���, �� ������ ��������� �� ������ � �������� ���������� ��������
    IF COALESCE(vbCurrencyId, 0) = 0  THEN
       RAISE EXCEPTION '������ "%" "%" �� ���������� � ����������� �����.% ���������� �������� �� ��������', inCurrencyCode, inCurrencyName, chr(13);
    END IF;
 
 
    --  5. ����� �������� zc_Movement_BankStatement �� ���� � ���������� �����.
    SELECT Movement.Id INTO vbMovementId
    FROM Movement
         JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                AND MovementLinkObject.ObjectId   = vbMainBankAccountId
                                AND MovementLinkObject.DescId     = zc_MovementLinkObject_BankAccount()
    WHERE Movement.OperDate = inOperDate AND Movement.DescId = zc_Movement_BankStatement() AND Movement.StatusId = zc_Enum_Status_UnComplete();
    --
    IF COALESCE (vbMovementId, 0) = 0 THEN
       -- ���� ������ ��������� ��� - ������� ���
       vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_BankStatement(), NEXTVAL ('Movement_BankStatement_seq') :: TVarChar, inOperDate, NULL);
       --
       PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_BankAccount(), vbMovementId, vbMainBankAccountId);
    END IF;


    -- 6. ����� �������� zc_Movement_BankStatementItem ������, �����������, ���� � �/c
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
         JOIN MovementFloat AS MovementFloat_Amount
                            ON MovementFloat_Amount.MovementId =  Movement.Id
                           AND MovementFloat_Amount.DescId     = zc_MovementFloat_Amount()
                           AND MovementFloat_Amount.ValueData  = inAmount
    WHERE Movement.ParentId                    = vbMovementId
      AND Movement.DescId                      = zc_Movement_BankStatementItem()
      AND Movement.InvNumber                   = inDocNumber
      AND MovementString_OKPO.ValueData        = inOKPO
      AND MovementString_BankAccount.ValueData = inBankAccount
      AND MovementString_Comment.ValueData     = inComment;
    --
    IF COALESCE(vbMovementItemId, 0) = 0 THEN
       -- ���� ������ ��������� ��� - ������� ���
       vbMovementItemId := lpInsertUpdate_Movement (0, zc_Movement_BankStatementItem(), inDocNumber, inOperDate, vbMovementId);
    END IF;

    -- ���� ������ ��������� �� �������, �� ������� ��� ��������
    IF vbCurrencyId <> zc_Enum_Currency_Basis() THEN
       SELECT Amount, ParValue, Amount, ParValue
              INTO vbCurrencyValue, vbParValue, vbCurrencyPartnerValue, vbParPartnerValue
       FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDate, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= vbCurrencyId,  inPaidKindId:= zc_Enum_PaidKind_FirstForm());
       --
       vbAmountCurrency:= inAmount;
       --
       inAmount := CAST (inAmount * vbCurrencyValue / vbParValue AS NUMERIC (16, 2));
    END IF;


    -- ��������� �������� <����� ��������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), vbMovementItemId, inAmount);
    -- ��������� �������� <����� ��������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCurrency(), vbMovementItemId, vbAmountCurrency);
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
    IF TRIM (COALESCE (inBankName, '')) = ''
    THEN
        vbBankId := lpInsertFind_Bank (inBankMFO, inBankName, vbUserId);
        inBankName:= COALESCE((SELECT Object.ValueData FROM Object WHERE Object.Id = vbBankId), '');
    END IF;
    --
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BankName (), vbMovementItemId, inBankName);
     -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Currency (), vbMovementItemId, vbCurrencyId);
     -- ��������� �������� <������ ��������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyPartner (), vbMovementItemId, vbCurrencyId);

     -- ���� ��� �������� � ������ �������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), vbMovementItemId, vbCurrencyValue);
     -- ������� ��� �������� � ������ �������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), vbMovementItemId, vbParValue);
     -- ���� ��� ������� ����� ��������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), vbMovementItemId, vbCurrencyPartnerValue);
     -- ������� ��� ������� ����� ��������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), vbMovementItemId, vbParPartnerValue);


    -- ����� �������� ��. ����
    vbJuridicalId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_Juridical() AND MLO.MovementId = vbMovementItemId);
    -- ������� ����� ������ ����� - ��������
    IF COALESCE(vbJuridicalId, 0) = 0
    THEN
        vbJuridicalId:= (WITH tmpCardChild_all AS (SELECT OS.ValueData, OS.ObjectId AS MemberId FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Member_CardChild() AND ValueData <> '')
                            , tmpCardChild AS (SELECT tmpCardChild_all.MemberId, zfCalc_Word_Split (inValue:= tmpCardChild_all.ValueData, inSep:= ',', inIndex:= 1) AS ValueData FROM tmpCardChild_all
                                             UNION
                                               SELECT tmpCardChild_all.MemberId, zfCalc_Word_Split (inValue:= tmpCardChild_all.ValueData, inSep:= ',', inIndex:= 2) AS ValueData FROM tmpCardChild_all
                                             UNION
                                               SELECT tmpCardChild_all.MemberId, zfCalc_Word_Split (inValue:= tmpCardChild_all.ValueData, inSep:= ',', inIndex:= 3) AS ValueData FROM tmpCardChild_all
                                             UNION
                                               SELECT tmpCardChild_all.MemberId, zfCalc_Word_Split (inValue:= tmpCardChild_all.ValueData, inSep:= ',', inIndex:= 4) AS ValueData FROM tmpCardChild_all
                                             UNION
                                               SELECT tmpCardChild_all.MemberId, zfCalc_Word_Split (inValue:= tmpCardChild_all.ValueData, inSep:= ',', inIndex:= 4) AS ValueData FROM tmpCardChild_all
                                              )
                            , tmpMember AS (SELECT tmpCardChild.MemberId
                                            FROM tmpCardChild
                                            WHERE tmpCardChild.ValueData <> '' AND inComment LIKE '%' || tmpCardChild.ValueData || '%'
                                            LIMIT 1 -- �� ������ ������
                                           )
                         SELECT tmpMember.MemberId FROM tmpMember
                         -- SELECT tmp.PersonalId FROM gpGet_Object_Member ((SELECT tmpMember.MemberId FROM tmpMember), inSession) AS tmp
                        );
        -- ���� �����, �� ������ ����� �����
        IF vbJuridicalId > 0
        THEN
            -- ���������� ����� + ��������
            vbInfoMoneyId:= zc_Enum_InfoMoney_60102();
            -- ��������� ����� � <���������> ���� � ���������� <��. ����>
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), vbMovementItemId, vbJuridicalId);
        END IF;
    END IF;

    -- ������ ����� ��� ����� ����
    IF COALESCE(vbJuridicalId, 0) = 0
    THEN
       -- �������� ����� ��������� ���� ������ �� ���������� ������!!!
       SELECT Object_BankAccount_View.JuridicalId INTO vbJuridicalId
       FROM Object_BankAccount_View
            JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                               ON ObjectBoolean_isCorporate.ObjectId  = Object_BankAccount_View.JuridicalId
                              AND ObjectBoolean_isCorporate.DescId    = zc_ObjectBoolean_Juridical_isCorporate()
                              AND ObjectBoolean_isCorporate.ValueData = TRUE
       WHERE Object_BankAccount_View.Name = inBankAccount AND TRIM (inBankAccount) <> '';

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


    -- ���� �� ���������� ����� + ��������
    IF COALESCE (vbInfoMoneyId, 0) <> zc_Enum_InfoMoney_60102()
    THEN

        CREATE TEMP TABLE _tmpContract_find ON COMMIT DROP AS (SELECT * FROM Object_Contract_View WHERE Object_Contract_View.JuridicalId = vbJuridicalId);
    

        -- 1. ���� ������
        IF inAmount > 0
        THEN
           IF TRIM (inBankAccount) <> ''
           THEN
               -- 1.0. ������� �������� <�������> ���� inBankAccount ��� inAmount > 0
               SELECT ObjectString_BankAccountPartner.ObjectId INTO vbContractId
               FROM ObjectString AS ObjectString_BankAccountPartner
                    INNER JOIN _tmpContract_find AS View_Contract
                                                 ON View_Contract.ContractId          = ObjectString_BankAccountPartner.ObjectId
                                                AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                AND View_Contract.isErased            = FALSE
               WHERE ObjectString_BankAccountPartner.ValueData = TRIM (inBankAccount)
                 AND ObjectString_BankAccountPartner.DescId    = zc_objectString_Contract_BankAccountPartner()
              ;  
           END IF;

           IF COALESCE (vbContractId, 0) = 0
           THEN
               -- 1.1. ������� �������� <�������> "�� ���������" ��� inAmount > 0
               SELECT MAX (View_Contract.ContractId) INTO vbContractId
               FROM _tmpContract_find AS View_Contract
                    INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = View_Contract.InfoMoneyId
                                                    AND InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_30000()) -- ������
                                                    -- AND inAmount > 0
                    INNER JOIN ObjectBoolean AS ObjectBoolean_Default
                                             ON ObjectBoolean_Default.ObjectId  = View_Contract.ContractId
                                            AND ObjectBoolean_Default.DescId    = zc_ObjectBoolean_Contract_Default()
                                            AND ObjectBoolean_Default.ValueData = TRUE
               WHERE View_Contract.JuridicalId = vbJuridicalId
                 AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                 AND View_Contract.isErased   = FALSE
                 AND View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm();
           END IF;

        END IF;
    

        -- 2. ���� ������
        IF inAmount < 0
        THEN
           -- 2.1. ������� �������� <�������> "�� ���������" ��� inAmount < 0
           SELECT MAX (View_Contract.ContractId) INTO vbContractId
           FROM _tmpContract_find AS View_Contract
                INNER JOIN ObjectBoolean AS ObjectBoolean_DefaultOut
                                         ON ObjectBoolean_DefaultOut.ObjectId  = View_Contract.ContractId
                                        AND ObjectBoolean_DefaultOut.DescId    = zc_ObjectBoolean_Contract_DefaultOut()
                                        AND ObjectBoolean_DefaultOut.ValueData = TRUE
           WHERE View_Contract.JuridicalId = vbJuridicalId
             AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
             AND View_Contract.isErased = FALSE
             AND View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm();

           -- 2.2. ������� �������� <�������> "�� ���������" ��� inAmount < 0
           IF COALESCE (vbContractId, 0) = 0
           THEN
               SELECT MAX (View_Contract.ContractId) INTO vbContractId
               FROM _tmpContract_find AS View_Contract
                    INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = View_Contract.InfoMoneyId
                                                    AND (InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_10000()) -- �������� �����
                                                      OR InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- ������������� + ���������
                                                        )
                    INNER JOIN ObjectBoolean AS ObjectBoolean_Default
                                             ON ObjectBoolean_Default.ObjectId  = View_Contract.ContractId
                                            AND ObjectBoolean_Default.DescId    = zc_ObjectBoolean_Contract_Default()
                                            AND ObjectBoolean_Default.ValueData = TRUE
               WHERE View_Contract.JuridicalId = vbJuridicalId
                 AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                 AND View_Contract.isErased = FALSE
                 AND View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm();
           END IF;

        END IF;
    
    
        -- 3.0. ���� �� ����� - ������� �������� <�������> "�� ���������" ��� ���������
        IF COALESCE (vbContractId, 0) = 0
        THEN
            SELECT MAX (View_Contract.ContractId) INTO vbContractId
            FROM _tmpContract_find AS View_Contract
                 INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = View_Contract.InfoMoneyId
                                                 AND InfoMoneyGroupId NOT IN (zc_Enum_InfoMoneyGroup_30000()) -- ������
                                                 AND InfoMoneyGroupId NOT IN (zc_Enum_InfoMoneyGroup_10000()) -- �������� �����
                                                 AND InfoMoneyDestinationId NOT IN (zc_Enum_InfoMoneyDestination_21500()) -- ������������� + ���������
                 INNER JOIN ObjectBoolean AS ObjectBoolean_Default
                                          ON ObjectBoolean_Default.ObjectId  = View_Contract.ContractId
                                         AND ObjectBoolean_Default.DescId    = zc_ObjectBoolean_Contract_Default()
                                         AND ObjectBoolean_Default.ValueData = TRUE
            WHERE View_Contract.JuridicalId = vbJuridicalId
              AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
              AND View_Contract.isErased = FALSE
              AND View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm();
        END IF;


        -- 1.4. ������� <�� ������ ����������> !!!������!!! � ��������
        IF vbContractId <> 0
        THEN
            SELECT InfoMoneyId INTO vbInfoMoneyId FROM Object_Contract_InvNumber_View WHERE ContractId = vbContractId;
        END IF;
    
    
        -- ���� �� �����, ����� ���������� �������� <�������>
        IF COALESCE (vbContractId, 0) = 0 AND COALESCE (vbJuridicalId, 0) <> 0
        THEN
            -- ������� <�������> � ��. ���� !!!� ���������� �� ...!!
            SELECT MAX (COALESCE (View_Contract.ContractId, View_Contract_next.ContractId)) INTO vbContractId
            FROM (SELECT zc_Enum_InfoMoney_30101()         AS InfoMoneyId -- ������ + ��������� + ������� ���������
                       , Object_InfoMoney_View.InfoMoneyId AS InfoMoneyId_Next
                  FROM Object_InfoMoney_View
                  WHERE InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_30000()) -- ������
                    AND inAmount > 0
                 UNION ALL
                  SELECT 0 AS InfoMoneyId
                       , Object_InfoMoney_View.InfoMoneyId AS InfoMoneyId_Next
                  FROM Object_InfoMoney_View
                  WHERE InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_10000()) -- �������� �����
                    AND inAmount < 0
                 UNION ALL
                  SELECT Object_InfoMoney_View.InfoMoneyId AS InfoMoneyId
                       , 0 AS InfoMoneyId_Next
                  FROM Object_InfoMoney_View
                  WHERE InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- ������������� + ���������
                    AND inAmount < 0
                 ) AS tmpInfoMoney
                 LEFT JOIN _tmpContract_find AS View_Contract
                                                ON View_Contract.JuridicalId = vbJuridicalId
                                               AND View_Contract.InfoMoneyId = tmpInfoMoney.InfoMoneyId
                                               AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                               AND View_Contract.isErased = FALSE
                                               AND View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm()
                 LEFT JOIN _tmpContract_find AS View_Contract_next
                                                ON View_Contract_next.JuridicalId = vbJuridicalId
                                               AND View_Contract_next.InfoMoneyId = tmpInfoMoney.InfoMoneyId_next
                                               AND View_Contract_next.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                               AND View_Contract_next.isErased = FALSE
                                               AND View_Contract_next.PaidKindId = zc_Enum_PaidKind_FirstForm()
                                               AND View_Contract.JuridicalId IS NULL
            ;
            -- ������� <�������> � ��. ���� !!!��� ���������� �� ...!!
            IF COALESCE (vbContractId, 0) = 0
            THEN
                SELECT MAX (View_Contract.ContractId) INTO vbContractId
                FROM _tmpContract_find AS View_Contract
                WHERE View_Contract.JuridicalId = vbJuridicalId
                  AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                  AND View_Contract.isErased = FALSE
                  AND View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm();
            END IF;
    
            -- ������� <�� ������ ����������> !!!������!!! � ��������
            SELECT InfoMoneyId INTO vbInfoMoneyId FROM Object_Contract_InvNumber_View WHERE ContractId = vbContractId;
            -- !!!�� ���� ��� ������ �����, ����� ������ <�� ������ ����������> �� "������ �� ���������"
            IF vbInfoMoneyId = zc_Enum_InfoMoney_30101() -- ������� ���������
               AND inAmount < 0
            THEN
                vbInfoMoneyId:= zc_Enum_InfoMoney_21501(); -- ������ �� ���������
            END IF;
    
        END IF; -- ���� �� �����, ����� ���������� �������� <�������>

    END IF; -- ���� �� ���������� ����� + ��������


    IF COALESCE (vbContractId, 0) <> 0 THEN
       -- ��������� ����� � <�������>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), vbMovementItemId, vbContractId);
    END IF;
    IF COALESCE (vbInfoMoneyId, 0) <> 0 THEN
       -- ��������� ����� � <�� ������ ����������>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), vbMovementItemId, vbInfoMoneyId);
    END IF;


    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (vbMovementItemId, vbUserId, TRUE);


/* if inSession = '5' 
 then
    RAISE EXCEPTION 'ok1 %   %    %    %',  lfGet_Object_ValueData (vbJuridicalId), vbContractId, lfGet_Object_ValueData (vbContractId), lfGet_Object_ValueData (vbInfoMoneyId);
 end if;*/


   RETURN 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 17.02.15                        * View_BankAccount.isCorporate = true
 17.12.14                        * ��������� ��������� �����
 19.07.14                                        * add Object_BankAccount_View
 17.06.14                        * ���� OKPO ������
 29.05.14                                        * add TRIM
 13.05.14                                        * other find vbContractId
 07.05.14                                        * error
 17.03.14                                        * ������� �������� <�������> "�� ���������"
 13.02.14                                        * ������� <�������> � <�� ������ ����������> !!!������!!! � ��������
 03.12.13                                        *
 13.11.13                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_BankStatementItemLoad (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFileName:= 'xxx', inBankAccountId:= 1, inSession:= '2')
-- select * from gpInsertUpdate_Movement_BankStatementItemLoad(inDocNumber := '123' , inOperDate := CURRENT_DATE, inBankAccountMain := 'UA173005280000026000301367079' , inBankMFOMain := '300528' , inOKPO := '37907261' , inJuridicalName := '37907261' , inBankAccount := '26005060875503' , inBankMFO := '304795' , inBankName := '' , inCurrencyCode := '980' , inCurrencyName := '' , inAmount := -123 , inComment := 'inComment' ,  inSession := '5');
-- select * from gpInsertUpdate_Movement_BankStatementItemLoad(inDocNumber := '123' , inOperDate := CURRENT_DATE, inBankAccountMain := 'UA173005280000026000301367079' , inBankMFOMain := '300528' , inOKPO := '32050382' , inJuridicalName := '32050382' , inBankAccount := '2600701586326' , inBankMFO := '304795' , inBankName := '' , inCurrencyCode := '980' , inCurrencyName := '' , inAmount := -123 , inComment := 'inComment' ,  inSession := '5');
