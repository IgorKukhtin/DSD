-- Function: gpInsertUpdate_Movement_BankStatementItemLoad()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankStatementItemLoad_2 (TVarChar, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar
                                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                                       , TVarChar, TVarChar, TFloat, TVarChar, TVarChar
                                                                        );

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankStatementItemLoad_2 (TVarChar, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar
                                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                                       , TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar, TVarChar
                                                                        );

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankStatementItemLoad_2(
    IN inStartDate           TDateTime ,
    IN inEndDate             TDateTime ,
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
    IN inAmountIn            TFloat    , -- ����� ��������
    IN inAmountOut           TFloat    , -- ����� ��������
    IN inComment             TVarChar  , -- �����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMainBankAccountId integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbContractId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbCurrencyId Integer;
   DECLARE vbBankId Integer;
   DECLARE vbAmountCurrency TFloat;

   DECLARE vbCurrencyValue TFloat;
   DECLARE vbParValue TFloat;
   DECLARE vbCurrencyPartnerValue TFloat;
   DECLARE vbParPartnerValue TFloat;
   DECLARE vbStr_tmp TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankStatementItemLoad());
 

    --IF vbUserId = '5' AND 1=1 THEN inOperDate:= inOperDate + INTERVAL '10 DAY'; END IF;

    IF inAmount <> 0 AND (inAmountIn <> 0 OR inAmountOut <> 0)
    THEN
        RAISE EXCEPTION '����� ������� ��������� ��� inAmount = <%> inAmountIn = <%> inAmountOut = <%>', inAmount, inAmountIn, inAmountOut;
    END IF;

    -- ���������
    IF inAmountIn > 0
    THEN 
        inAmount:= inAmountIn;
    END IF;
    
    -- ���������
    IF inAmountOut > 0
    THEN 
        inAmount:= -1 * inAmountOut;
    END IF;

    --�������� ���� ���� ��������� �������� � ����������� ������
    IF inOperDate > inEndDate OR inOperDate < inStartDate
    THEN
        RETURN 0;
    END IF;
    
    --
  --IF inBankMFOMain = '380805' THEN inAmount:= -1 * inAmount; END IF;

 
    -- 1. ����� ���� �� ���� � ���� � ����������� ������.
    vbMainBankAccountId:= (SELECT View_BankAccount.Id
                           FROM Object_BankAccount_View AS View_BankAccount
                           WHERE View_BankAccount.Name        = TRIM (inBankAccountMain)
                             AND View_BankAccount.isCorporate = TRUE
                           ORDER BY 1
                           LIMIT 1 -- ???���� �� ���������???
                          );
 
    /*IF COALESCE (vbMainBankAccountId, 0) = 0
    THEN
        vbStr_tmp        := inBankAccountMain;
        inBankAccountMain:= inBankAccount;
        inBankAccount    := vbStr_tmp;
        --
        vbStr_tmp    := inBankMFOMain;
        inBankMFOMain:= inBankMFO;
        inBankMFO    := vbStr_tmp;
        --
        --inBankName:= ???;

        -- 1. ����� ���� �� ���� � ���� � ����������� ������.
        vbMainBankAccountId:= (SELECT View_BankAccount.Id
                               FROM Object_BankAccount_View AS View_BankAccount
                               WHERE View_BankAccount.Name        = TRIM (inBankAccountMain)
                                 AND View_BankAccount.isCorporate = TRUE
                               ORDER BY 1
                               LIMIT 1 -- ???���� �� ���������???
                              );

    END IF;*/

    -- 2. ���� ������ ����� ���, �� ������ ��������� �� ������ � �������� ���������� ��������
    IF COALESCE (vbMainBankAccountId, 0) = 0
    THEN
        RAISE EXCEPTION '���� <%> �� ������ � ����������� ������.%�������� �� ��������.%���� �������� <%>', TRIM (inBankAccountMain), chr(13), chr(13), TRIM (inBankAccount);
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
    IF TRIM (inCurrencyCode) = '' THEN inCurrencyCode:= '980'; END IF;
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
       -- ��������� ��������
       PERFORM lpInsert_MovementProtocol (vbMovementId, vbUserId, TRUE);
    ELSE 
       -- ��������� ��������
       PERFORM lpInsert_MovementProtocol (vbMovementId, vbUserId, FALSE);
    END IF;


    -- 6. ����� �������� zc_Movement_BankStatementItem ������, �����������, ���� � �/c
    /*SELECT Movement.Id INTO vbMovementItemId
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
      AND MovementString_Comment.ValueData     = inComment;*/
    --

--    RAISE EXCEPTION 'ok1 %   %',  vbMovementItemId, vbMovementId;

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
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), vbMovementItemId
                                        , CASE WHEN 0 < (WITH tmpMember AS (SELECT ObjectLink_MemberMinus_From.ChildObjectId AS MemberId, ObjectString.ValueData
                                                                            FROM ObjectString
                                                                                 JOIN ObjectLink AS ObjectLink_MemberMinus_From
                                                                                                 ON ObjectLink_MemberMinus_From.ObjectId = ObjectString.ObjectId
                                                                                                AND ObjectLink_MemberMinus_From.DescId = zc_ObjectLink_MemberMinus_From()
                                                                                 JOIN Object AS Object_MemberMinus ON Object_MemberMinus.Id       = ObjectString.ObjectId
                                                                                                                  AND Object_MemberMinus.isErased = FALSE
                                                                            WHERE ObjectString.ValueData <> ''
                                                                              AND ObjectString.DescId = zc_ObjectString_MemberMinus_DetailPayment()
                                                                           )
                                                         SELECT tmpMember.MemberId FROM tmpMember WHERE TRIM (inComment) ILIKE TRIM (tmpMember.ValueData) LIMIT 1 -- �� ������ ������
                                                         -- SELECT tmp.PersonalId FROM gpGet_Object_Member ((SELECT tmpMember.MemberId FROM tmpMember), inSession) AS tmp
                                                        )
                                               THEN -1 * ABS (inAmount)

                                               WHEN 0 < (WITH tmpMember AS (SELECT ObjectString.ObjectId AS MemberId
                                                                            FROM ObjectString
                                                                                 JOIN Object AS Object_Member ON Object_Member.Id       = ObjectString.ObjectId
                                                                                                             AND Object_Member.isErased = FALSE
                                                                            WHERE ObjectString.ValueData ILIKE inOKPO AND inOKPO <> ''
                                                                              AND ObjectString.DescId = zc_ObjectString_Member_INN()
                                                                           )
                                                         SELECT tmpMember.MemberId FROM tmpMember LIMIT 1 -- �� ������ ������
                                                        )
                                                AND inComment ILIKE '%�������� ��%'
                                               THEN -1 * ABS (inAmount)
                                               
                                               ELSE inAmount
                                          END 
                                         );
    -- ��������� �������� <����� ��������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCurrency(), vbMovementItemId, vbAmountCurrency);
     -- ��������� �������� <����>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO (), vbMovementItemId, TRIM (inOKPO));
     -- ��������� �������� <����������� ����>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_JuridicalName (), vbMovementItemId, TRIM (inJuridicalName));
     -- ��������� �������� <�����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment (), vbMovementItemId, inComment);
     -- ��������� �������� <��������� ����>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BankAccount (), vbMovementItemId, TRIM (inBankAccount));
     -- ��������� �������� <���>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BankMFO (), vbMovementItemId, TRIM (inBankMFO));
    -- ��������� �������� <�������� �����>
    IF TRIM (COALESCE (inBankName, '')) = ''
    THEN
        vbBankId := lpInsertFind_Bank (inBankMFO, inBankName, vbUserId);
        inBankName:= COALESCE((SELECT Object.ValueData FROM Object WHERE Object.Id = vbBankId), '');
    END IF;
    --
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BankName (), vbMovementItemId, TRIM (inBankName));
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


/*
� zc_ObjectString_Partner_Terminal  ��������� 12345���
� ���� ������� � ���������� ����� ����� �����  ��������
������ ��� ���� ������ ����� ���� ����������

*/
    --������� �������� ����������
    vbPartnerId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_Partner() AND MLO.MovementId = vbMovementItemId);

    IF COALESCE (vbPartnerId,0) = 0
    THEN
        --������� ����� ���������� �� zc_ObjectString_Partner_Terminal  
        vbPartnerId := (SELECT ObjectString.ObjectId
                        FROM ObjectString
                        WHERE ObjectString.DescId = zc_ObjectString_Partner_Terminal()
                          AND inComment ILIKE ('%' || ObjectString.ValueData || '%')
                          AND ObjectString.ValueData <> ''
                        LIMIT 1
                        );
        IF COALESCE (vbPartnerId,0) <> 0
        THEN 
            vbJuridicalId := (SELECT ObjectLink_Partner_Juridical.ChildObjectId
                              FROM ObjectLink AS ObjectLink_Partner_Juridical
                              WHERE ObjectLink_Partner_Juridical.ObjectId = vbPartnerId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              );
            
            -- ��������� ����� � <���������> ���� � ���������� <��. ����>
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), vbMovementItemId, vbPartnerId);
            
            IF COALESCE(vbJuridicalId, 0) <> 0
            THEN
               -- ��������� ����� � <��. ����>
               PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), vbMovementItemId, vbJuridicalId);
            END IF;        
        END IF;
     END IF;


    IF COALESCE (vbJuridicalId,0) = 0
    THEN
        -- ����� �������� ��. ����
        vbJuridicalId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_Juridical() AND MLO.MovementId = vbMovementItemId);
    END IF;
    
    -- ������� ����� ����� ���������� ������� - ���������
    IF COALESCE(vbJuridicalId, 0) = 0 AND EXISTS (WITH tmpMember AS (SELECT ObjectString.ValueData
                                                                     FROM ObjectString
                                                                     WHERE ObjectString.ValueData <> ''
                                                                       AND ObjectString.DescId = zc_ObjectString_MemberMinus_DetailPayment()
                                                                    )
                                                  SELECT 1 FROM tmpMember WHERE TRIM (inComment) ILIKE TRIM (tmpMember.ValueData)
                                                 )
    THEN
        vbJuridicalId:= (WITH tmpMember AS (SELECT ObjectLink_MemberMinus_From.ChildObjectId AS MemberId, ObjectString.ValueData
                                            FROM ObjectString
                                                 JOIN ObjectLink AS ObjectLink_MemberMinus_From
                                                                 ON ObjectLink_MemberMinus_From.ObjectId = ObjectString.ObjectId
                                                                AND ObjectLink_MemberMinus_From.DescId = zc_ObjectLink_MemberMinus_From()
                                                 JOIN Object AS Object_MemberMinus ON Object_MemberMinus.Id       = ObjectString.ObjectId
                                                                                  AND Object_MemberMinus.isErased = FALSE
                                            WHERE ObjectString.ValueData <> ''
                                              AND ObjectString.DescId = zc_ObjectString_MemberMinus_DetailPayment()
                                           )
                         SELECT tmpMember.MemberId FROM tmpMember WHERE TRIM (inComment) ILIKE TRIM (tmpMember.ValueData) LIMIT 1 -- �� ������ ������
                         -- SELECT tmp.PersonalId FROM gpGet_Object_Member ((SELECT tmpMember.MemberId FROM tmpMember), inSession) AS tmp
                        );
                        
        -- ��� ��� ����� INN
        /*vbJuridicalId:= CASE WHEN vbJuridicalId > 0 THEN vbJuridicalId
                            ELSE (WITH tmpMember AS (SELECT ObjectString.ObjectId AS MemberId
                                                     FROM ObjectString
                                                          JOIN Object AS Object_Member ON Object_Member.Id       = ObjectString.ObjectId
                                                                                      AND Object_Member.isErased = FALSE
                                                     WHERE ObjectString.ValueData ILIKE inOKPO AND inOKPO <> ''
                                                       AND ObjectString.DescId = zc_ObjectString_Member_INN()
                                                    )
                                  SELECT tmpMember.MemberId FROM tmpMember LIMIT 1 -- �� ������ ������
                                 )
                        END;*/

        -- ���� �����, �� ������ ����� �����
        IF vbJuridicalId > 0
        THEN
            -- ���������� ����� + ��������� ������. ��.�.
            vbInfoMoneyId:= 979902;
            -- ��������� ����� � <���������> ���� � ���������� <��. ����>
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), vbMovementItemId, vbJuridicalId);
        END IF;
    END IF;

    -- ������ ����� ����� ����� - ��������
    IF COALESCE(vbJuridicalId, 0) = 0
    THEN
        vbJuridicalId:= (WITH tmpCardChild_all AS (SELECT OS.ValueData, OS.ObjectId AS MemberId FROM ObjectString AS OS JOIN Object ON Object.Id = OS.ObjectId AND Object.isErased = FALSE WHERE OS.DescId = zc_ObjectString_Member_CardChild() AND OS.ValueData <> '')
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
                                            WHERE tmpCardChild.ValueData <> '' AND inComment ILIKE ('%' || tmpCardChild.ValueData || '%')
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
            LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                    ON ObjectBoolean_isCorporate.ObjectId  = Object_BankAccount_View.JuridicalId
                                   AND ObjectBoolean_isCorporate.DescId    = zc_ObjectBoolean_Juridical_isCorporate()
       WHERE Object_BankAccount_View.Name = inBankAccount AND TRIM (inBankAccount) <> ''
         AND (ObjectBoolean_isCorporate.ValueData = TRUE /*OR Object_BankAccount_View.JuridicalId = 15505*/) -- ���� ��� 
         AND Object_BankAccount_View.JuridicalId IN
                           -- ���������� �����
                          (SELECT ObjectBoolean_isCorporate.ObjectId
                           FROM ObjectBoolean AS ObjectBoolean_isCorporate
                                JOIN ObjectHistory ON ObjectHistory.ObjectId = ObjectBoolean_isCorporate.ObjectId
                                                  AND inOperDate BETWEEN ObjectHistory.StartDate AND ObjectHistory.EndDate
                                JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                                         ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory.Id
                                                        AND ObjectHistoryString_JuridicalDetails_OKPO.ValueData = inOKPO
                                                        AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
                           WHERE ObjectBoolean_isCorporate.DescId    = zc_ObjectBoolean_Juridical_isCorporate()
                             AND ObjectBoolean_isCorporate.ValueData = TRUE
                          )
       ;

       IF COALESCE(vbJuridicalId, 0) = 0 THEN
         -- �������� ����� ��. ���� �� OKPO
         SELECT ObjectHistory.ObjectId INTO vbJuridicalId
         FROM ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
              JOIN ObjectHistory ON ObjectHistory.Id = ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId
                                AND inOperDate BETWEEN ObjectHistory.StartDate AND ObjectHistory.EndDate
         WHERE ObjectHistoryString_JuridicalDetails_OKPO.ValueData = inOKPO
           AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
           ;
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


    -- ���� �� ���������� ����� + �������� OR ���������� ����� + ��������� ������. ��.�.
    IF COALESCE (vbInfoMoneyId, 0) NOT IN (zc_Enum_InfoMoney_60102(), 979902)
    THEN

        CREATE TEMP TABLE _tmpContract_find ON COMMIT DROP AS -- (SELECT * FROM Object_Contract_View WHERE Object_Contract_View.JuridicalId = vbJuridicalId);
              (SELECT Object_Contract.Id                                  AS ContractId
                    , Object_Contract.isErased                            AS isErased
                    , COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, 0) AS ContractStateKindId
                    , ObjectLink_Contract_PaidKind.ChildObjectId          AS PaidKindId
                    , ObjectLink_Contract_InfoMoney.ChildObjectId         AS InfoMoneyId
                    , ObjectLink_Contract_Juridical.ChildObjectId         AS JuridicalId
               FROM ObjectLink AS ObjectLink_Contract_Juridical
                    INNER JOIN Object AS Object_Contract ON Object_Contract.Id       = ObjectLink_Contract_Juridical.ObjectId
                                                        AND Object_Contract.isErased = FALSE
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                         ON ObjectLink_Contract_ContractStateKind.ObjectId      = Object_Contract.Id
                                        AND ObjectLink_Contract_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind() 
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                         ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                                        AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                         ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                        AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
               WHERE ObjectLink_Contract_Juridical.ChildObjectId = vbJuridicalId
                 AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
                 AND COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, 0) <> zc_Enum_ContractStateKind_Close()
              );

    

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
                -- ���������� ������
                SELECT MAX (View_Contract.ContractId) INTO vbContractId
                FROM _tmpContract_find AS View_Contract
                WHERE View_Contract.JuridicalId = vbJuridicalId
                  AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                  AND View_Contract.isErased = FALSE
                  AND View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm()
                  AND View_Contract.InfoMoneyId = zc_Enum_InfoMoney_40801() --���������� ������
                 ;
            END IF;
            -- ������� <�������> � ��. ���� !!!��� ���������� �� ...!!
            IF COALESCE (vbContractId, 0) = 0
            THEN
                -- �� ���������� ������
                SELECT MAX (View_Contract.ContractId) INTO vbContractId
                FROM _tmpContract_find AS View_Contract
                WHERE View_Contract.JuridicalId = vbJuridicalId
                  AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                  AND View_Contract.isErased = FALSE
                  AND View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm()
                 ;
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


 if vbUserId = 5 AND 1=0 AND inBankAccountMain <> 'UA423808050000000026003707397'
 then
    RAISE EXCEPTION 'ok1 %   %    %    %  %',  lfGet_Object_ValueData (vbJuridicalId), vbContractId, lfGet_Object_ValueData (vbContractId), lfGet_Object_ValueData (vbInfoMoneyId), inComment;
 end if;


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
