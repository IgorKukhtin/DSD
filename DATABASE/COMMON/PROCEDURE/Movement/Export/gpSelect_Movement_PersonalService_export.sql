-- Function: gpSelect_Movement_PersonalService_export

-- DROP FUNCTION IF EXISTS gpexport_txtbankvostokpayroll (Integer, TVarChar, TFloat, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_export (Integer, TVarChar, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService_export(
    IN inMovementId           Integer,
    IN inInvNumber            TVarChar,
    IN inAmount               TFloat,
    IN inOperDate             TDateTime,
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (RowData Text)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbBankId    Integer;
   DECLARE vbTotalSumm TFloat;

   DECLARE r RECORD;
   DECLARE i Integer; -- �������������
   DECLARE e Text;
   DECLARE er Text;

   DECLARE vbOperDate TDateTime;

   DECLARE vbPSLExportKindId Integer;
   DECLARE vbBankName TVarChar;
   DECLARE vbMFO TVarChar;
   DECLARE vbBankAccountId Integer;
   DECLARE vbBankAccountName TVarChar;
   DECLARE vbContentType TVarChar;
   DECLARE vbOnFlowType TVarChar; 
   DECLARE vbKoeffSummCardSecond NUMERIC (16,10); 
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ������������
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- *** ��������� ������� ��� ����� ����������
     CREATE TEMP TABLE _tmpResult (NPP Integer, RowData Text, errStr TVarChar, INN TVarChar, CardIBAN TVarChar, LASTNAME TVarChar, FIRSTNAME TVarChar, MIDDLENAME TVarChar, AMOUNT TFloat) ON COMMIT DROP;
     /*
     -- ��������
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Export() AND MB.ValueData = TRUE) AND vbUserId <> 5
     THEN
         RAISE EXCEPTION '������.<%> � <%> �� <%> ��� ���� ���������.%��� ��������� �������� ���������� ������������ ��������.'
                       , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList()))
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                       , CHR(13)
                        ;
                         
     END IF;
    */

     -- ���������� ������ �� ��������� ����������
     SELECT Object_Bank.Id                 AS BankId             -- ����
          , Object_Bank.ValueData          AS BankName           -- ����
          , ObjectString_MFO.ValueData     AS MFO                --
          , Object_BankAccount.Id          AS BankAccountId      -- �/����
          , Object_BankAccount.ValueData   AS BankAccountName    -- �/����
          , ObjectLink_PersonalServiceList_PSLExportKind.ChildObjectId AS PSLExportKindId    -- ��� �������� ��������� � ����
          , ObjectString_ContentType.ValueData ::TVarChar   AS ContentType  -- Content-Type
          , ObjectString_OnFlowType.ValueData  ::TVarChar   AS OnFlowType   -- ��� ���������� � �����
          , CAST ((ObjectFloat_KoeffSummCardSecond.ValueData/ 1000) AS NUMERIC (16,10))  AS KoeffSummCardSecond --����� ��� �������� ��������� ���� 2�.
   INTO vbBankId, vbBankName, vbMFO
      , vbBankAccountId, vbBankAccountName
      , vbPSLExportKindId, vbContentType, vbOnFlowType
      , vbKoeffSummCardSecond
     FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Bank
                                ON ObjectLink_PersonalServiceList_Bank.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                               AND ObjectLink_PersonalServiceList_Bank.DescId = zc_ObjectLink_PersonalServiceList_Bank()
           LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_PersonalServiceList_Bank.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PSLExportKind
                                ON ObjectLink_PersonalServiceList_PSLExportKind.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                               AND ObjectLink_PersonalServiceList_PSLExportKind.DescId = zc_ObjectLink_PersonalServiceList_PSLExportKind()

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_BankAccount
                                ON ObjectLink_PersonalServiceList_BankAccount.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId 
                               AND ObjectLink_PersonalServiceList_BankAccount.DescId = zc_ObjectLink_PersonalServiceList_BankAccount()
           LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_PersonalServiceList_BankAccount.ChildObjectId

           LEFT JOIN ObjectString AS ObjectString_ContentType 
                                  ON ObjectString_ContentType.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                 AND ObjectString_ContentType.DescId = zc_ObjectString_PersonalServiceList_ContentType()
           LEFT JOIN ObjectString AS ObjectString_OnFlowType 
                                  ON ObjectString_OnFlowType.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                 AND ObjectString_OnFlowType.DescId = zc_ObjectString_PersonalServiceList_OnFlowType()

           LEFT JOIN ObjectString AS ObjectString_MFO
                                  ON ObjectString_MFO.ObjectId = Object_Bank.Id
                                 AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()

           LEFT JOIN ObjectFloat AS ObjectFloat_KoeffSummCardSecond
                                 ON ObjectFloat_KoeffSummCardSecond.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                AND ObjectFloat_KoeffSummCardSecond.DescId = zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond()

     WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
       AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList();

     --���� �� ������ ���. ����� �� ��������� = 1.00807
     IF COALESCE (vbKoeffSummCardSecond,0) = 0
     THEN
         vbKoeffSummCardSecond := 1.00807;
     END IF;


     -- ������� ����� �� (����) - 2�.
     IF EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN MovementItemFloat AS MIFloat_SummCardSecondRecalc
                                                  ON MIFloat_SummCardSecondRecalc.MovementItemId = MovementItem.Id
                                                 AND MIFloat_SummCardSecondRecalc.DescId         IN (zc_MIFloat_SummCardSecondRecalc(), zc_MIFloat_SummAvCardSecondRecalc())
                                                 AND MIFloat_SummCardSecondRecalc.ValueData      <> 0
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
               )
     THEN
	-- ����� �����
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-1, '����;���;����� � ��������;�������;���;��������');

	-- �������� �����
	i           := 0; -- �������� �������������
        vbTotalSumm := 0; -- ��������

	FOR r IN (SELECT COALESCE (gpSelect.CardSecond, '') AS CardSecond, UPPER (COALESCE (gpSelect.PersonalName, '')) AS PersonalName, COALESCE (TRIM (gpSelect.INN), '') AS INN
	                 -- �������� % � ��������� �� 2-� ������ + ��������� � �������
	             --, SUM (FLOOR (100 * CAST (COALESCE (gpSelect.SummCardSecondRecalc, 0) * 1.00705 AS NUMERIC (16, 2)))) AS SummCardSecondRecalc
	             --, SUM (FLOOR (100 * CAST (COALESCE (gpSelect.SummCardSecondRecalc, 0) * 1.00705 AS NUMERIC (16, 1)))) AS SummCardSecondRecalc
	               , SUM (FLOOR (100 * CAST ((COALESCE (gpSelect.SummCardSecondRecalc, 0) * vbKoeffSummCardSecond
                                               + COALESCE (gpSelect.SummAvCardSecondRecalc, 0) * vbKoeffSummCardSecond
                                                 ) AS NUMERIC (16, 0)))) AS SummCardSecondRecalc
	          FROM gpSelect_MovementItem_PersonalService (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
	          WHERE gpSelect.SummCardSecondRecalc <> 0 OR gpSelect.SummAvCardSecondRecalc <> 0
	          GROUP BY COALESCE (gpSelect.CardSecond, ''), UPPER (COALESCE (gpSelect.PersonalName, '')), COALESCE (TRIM (gpSelect.INN), '')
	         )
	LOOP
            -- ����� ����� -
            vbTotalSumm:= vbTotalSumm + r.SummCardSecondRecalc;
            --
            IF   CHAR_LENGTH (r.personalname) = 0
              -- OR CHAR_LENGTH (r.CardSecond)   <> 14
              -- OR ISNUMERIC (r.CardSecond)     = FALSE
            THEN
                e := '��������/�������� ������: ����� - ' || r.CardSecond || ', ��� - ' || r.personalname || ', ��� - ' || r.inn || ', ����� - ' || r.SummCardSecondRecalc || CHR(13) || CHR(10);
                er := concat(er, e);
            ELSE
                -- ����� ���������� ����� �2; ���; ����� - ��������� � �������; �������; ���; ��������
                INSERT INTO _tmpResult (NPP, RowData) VALUES (i, ''||r.CardSecond||';'||r.inn||';'|| r.SummCardSecondRecalc || ';' || LEFT(REPLACE(REPLACE(r.personalname, ' ', ';'), chr(39), ''), 80) );
                i := i + 1; -- ����������� �������� �������������
            END IF;

        END LOOP;

	-- ������ ������
	INSERT INTO _tmpResult (NPP, RowData) VALUES (i + 1, '');
        -- ����� ����������
	INSERT INTO _tmpResult (NPP, RowData) VALUES (i + 2, ';;' || vbTotalSumm);

     ELSE
         -- �������� ������
         IF COALESCE (vbBankId, 0) = 0
         THEN
              RAISE EXCEPTION '������.��� ��������� <%> �� ����������� �������� <����>.'
                            , lfGet_Object_ValueData_sh ((SELECT MLO_PersonalServiceList.ObjectId
                                                          FROM MovementLinkObject AS MLO_PersonalServiceList
                                                          WHERE MLO_PersonalServiceList.MovementId = inMovementId
                                                            AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                         ));
         END IF;

     END IF;


     -- ��� "���� ������"
     --IF vbBankId = 76968
     IF vbPSLExportKindId = zc_Enum_PSLExportKind_iBank()
     THEN
	-- *** ����� �����
	-- ��� ��������� (�� ��)
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-100, 'Content-Type='||vbContentType);                --(-100, 'Content-Type=doc/pay_sheet');
	-- ������ ������
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-95, '');
	-- ���� ���������
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-90, 'DATE_DOC='||TO_CHAR(NOW(), 'dd.mm.yyyy'));
	-- ����� ���������
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-85, 'NUM_DOC='||inInvNumber);
	-- ������������ �������
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-80, 'CLN_NAME=��� "����"');
	-- ��� ������ �������
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-75, 'CLN_OKPO=24447183');
	-- ���� ��������
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-70, 'PAYER_ACCOUNT='||vbBankAccountName);            --(-70, 'PAYER_ACCOUNT=UA823071230000026007010192834'); -- 26007010192834
	-- ��� ����� ����������
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-68, 'PAYER_BANK_MFO='||vbMFO);                       --(-68, 'PAYER_BANK_MFO=307123');
	-- ������������ �������������� �����
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-60, 'PAYER_BANK_NAME='||vbBankName);                 --(-60, 'PAYER_BANK_NAME=��� "���� ������"')

        -- ����� ������� ��i���� ��� �������� ���i�i� �� ���
      --INSERT INTO _tmpResult (NPP, RowData) VALUES (-46, 'PAYER_COMMISSION_ACCOUNT=UA823071230000026007010192834');
	-- ��� ��� �������������� �����, � ����� �i������ ���������� � ���i PAYER_COMMISSION_ACCOUNT �������
      --INSERT INTO _tmpResult (NPP, RowData) VALUES (-45, 'PAYER_COMMISSION_BANK_MFO=307123');
	-- ������������ �������������� �����, � ����� �i������ ���������� � ���i PAYER_COMMISSION_ACCOUNT �������
      --INSERT INTO _tmpResult (NPP, RowData) VALUES (-44, 'PAYER_COMMISSION_BANK_NAME=��� "���� ������"');

	-- ��� ��������� �������
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-41, 'ONFLOW_TYPE='||vbOnFlowType);                   --(-41, 'ONFLOW_TYPE=������� �������� �����');

	-- ����� ����������
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-35, 'AMOUNT='||ROUND(inAmount::numeric, 2));
	-- ���� �������������
	INSERT INTO _tmpResult (NPP, RowData) VALUES (-25, 'VALUE_DATE='||TO_CHAR(NOW(), 'dd.mm.yyyy'));
	-- ���� ����� �����������
	-- INSERT INTO _tmpResult (NPP, RowData) VALUES (-60, 'PAYER_BANK_ACCOUNT=29244006');

	-- ������ ����������
        IF vbBankId IN (76968, 6314382) -- ��� "���� ������"
        THEN
            -- INSERT INTO _tmpResult (NPP, RowData) VALUES (-10, 'PERIOD='||TO_CHAR(NOW(), 'TMMonth yyyy'));
            INSERT INTO _tmpResult (NPP, RowData) VALUES (-10, 'PERIOD=0' || EXTRACT (MONTH FROM CURRENT_DATE) :: TVarChar || ',' || EXTRACT (YEAR FROM CURRENT_DATE) :: TVarChar);
        END IF;


	-- *** �������� �����
	i := 0; -- �������� �������������
	FOR r IN (-- SELECT gpSelect.card
	          SELECT CASE WHEN vbBankId IN (76968, 6314382) THEN SUBSTRING (gpSelect.card FROM char_length(gpSelect.card) - 13 for 14 ) ELSE gpSelect.card END AS card
	               , gpSelect.personalname
	               , TRIM (gpSelect.INN) AS INN
	               , COALESCE (gpSelect.SummCardRecalc, 0) + COALESCE (gpSelect.SummHosp, 0) AS SummCardRecalc
	          FROM gpSelect_MovementItem_PersonalService (inMovementId := inMovementId, inShowAll := 'False', inIsErased := 'False',  inSession := inSession) AS gpSelect
	         )
	LOOP
		IF (char_length (r.card) < 14)
		   -- OR (NOT ISNUMERIC(r.card))
		   -- OR (NOT ISNUMERIC(r.inn))
		   -- OR (char_length(r.inn)<>10)
		   OR (char_length(r.personalname)=0) THEN
		   BEGIN
			IF char_length (r.card) < 14
			THEN
                            e := '� ������ ����� ������ ���� �� ����� 14 �������� (' || lfGet_Object_ValueData_sh (vbBankId) || ')(' || COALESCE(vbBankId, 0) || ') - ' || r.card || ', ��� - ' || r.personalname || ', ��� - ' || r.inn || ', ����� - ' || r.SummCardRecalc || CHR(13) || CHR(10);
                        ELSE
                            e := '��������/�������� ������: ����� - ' || r.card || ', ��� - ' || r.personalname || ', ��� - ' || r.inn || ', ����� - ' || r.SummCardRecalc || CHR(13) || CHR(10);
                        END IF;
                        --
			IF COALESCE (er, '') = ''
			THEN
			    er := concat(er, e);
			END IF;
		   END;
		ELSE
		BEGIN
			-- ����� ���������� �����
			INSERT INTO _tmpResult (NPP, RowData) VALUES (i * 10 + 1, 'CARD_HOLDERS.'||i::TVarChar||'.CARD_NUM='||r.card);
			-- ��� ��������� �����
			INSERT INTO _tmpResult (NPP, RowData) VALUES (i * 10 + 2, 'CARD_HOLDERS.'||i::TVarChar||'.CARD_HOLDER='||LEFT(REPLACE(r.personalname, chr(39), ''), 80));
			-- ��� ��������� �����
			INSERT INTO _tmpResult (NPP, RowData) VALUES (i * 10 + 3, 'CARD_HOLDERS.'||i::TVarChar||'.CARD_HOLDER_INN='||r.inn);
			-- ����� ����������
			INSERT INTO _tmpResult (NPP, RowData) VALUES (i * 10 + 4, 'CARD_HOLDERS.'||i::TVarChar||'.AMOUNT='||ROUND(r.SummCardRecalc::numeric, 2));
                        -- ���������
			i := i + 1;
		END;
		END IF;

        END LOOP;

     END IF; -- if vbBankId = 76968 -- ��� "���� ������"


     -- ��� "��� ����"
     IF vbBankId = 76970
     THEN

         -- ������ ������� XML
         INSERT INTO _tmpResult (NPP, RowData) VALUES (-40, '<?xml version="1.0" encoding="windows-1251"?>');
         INSERT INTO _tmpResult (NPP, RowData) VALUES (-30, '<DATAPACKET Version="2.0">');

         -- �����
         INSERT INTO _tmpResult(NPP, RowData)
            SELECT -20
                 , '<SCHEDULEINFO'
                     -- ���� ���������� ��������� � ������� ��/��/����
                     ||       ' SHEDULE_DATE="' || TO_CHAR (NOW(), 'dd/mm/yyyy') || '"'   
                     -- ����� ���������� ���������
                     ||       ' SHEDULE_NUMBER="' || inInvNumber || '"'                     
                     -- �������� ����������� �����������
                     ||          ' CLIENT_NAME="' || '��� ����' || '"'
                     -- ��� �����, � ������� ������ ���� �����������
                     ||  ' PAYER_BANK_BRANCHID="' || '300528' || '"'                        
       
                     -- ���������� ���� �����������. ������������ �� ��� ��������� �� ���. ��������� �������� ��� � �����������; ���� ��� �������� ���������� ��������� ������, �� ���� ���������� ���� � ����������� ID; ���� ��� �������� �� ���������� �� ������ �����, �� ��� ������� ������� ������ ������
                        -- 1) ���� PAYER_BANK_ACCOUNTNO �� ������� ���������
                     || ' PAYER_BANK_ACCOUNTNO="' || /*'29241009900000' ||*/ '"'                         
                   --|| ' PAYER_BANK_ACCOUNTNO="' || 'UA293005280000029241009900000' || '"'                         
                     -- IBAN ����������� ����� �����������.
                     || ' PAYER_BANK_ACCOUNTIBAN="' || 'UA293005280000029241009900000' || '"'            
                     -- ���� ��� �������� �������
                              -- 1) ���� PAYER_ACCOUNTNO �� ������� ���������
                     ||      ' PAYER_ACCOUNTNO="' || /*'26000301367079' ||*/ '"'                
                   --||      ' PAYER_ACCOUNTNO="' || 'UA173005280000026000301367079' || '"'                
                     -- IBAN c���� ��� �������� �������
                     || ' PAYER_ACCOUNTIBAN ="' || 'UA173005280000026000301367079' || '"'                         

                     -- ����� ����� ���������� ��������� � ������� ���,���
                     || ' TOTAL_SHEDULE_AMOUNT="' || REPLACE (CAST (inAmount AS NUMERIC (16, 2)) :: TVarChar, '.', ',') || '"' 
                     -- ��� ����������� �������. ����������� ����������� ������ ��� ������, ������������ ���
                     ||   ' CONTRAGENT_CODEZKP="' || '1011442' || '"'                       

                               -- COMMENTS
                     ||    ' COMMENTS="�������� ����� �� 1 ��������' 
                     ||' ' || zfCalc_MonthNameUkr_export (vbOperDate)
                     ||' ' || EXTRACT (YEAR FROM vbOperDate) :: TVarChar
                     ||' ' ||'����. ���,����,�� �������� ' || zfConvert_DateToString (vbOperDate) || '"'

                     || '>'
                    ;


           -- �������� �����
           INSERT INTO _tmpResult(NPP, RowData) VALUES (-10, '<EMPLOYEES>');
           --
           INSERT INTO _tmpResult (NPP, RowData, INN, CardIBAN, LASTNAME, FIRSTNAME, MIDDLENAME, AMOUNT)
                   SELECT ROW_NUMBER() OVER (ORDER BY gpSelect.card) AS NPP
                        , '<EMPLOYEE'
                               -- ��� ����������
                               ||  ' IDENTIFYCODE="' || TRIM (gpSelect.INN) || '"'

                               -- ��������� ����� ����������
                               -- ||         ' TABNO="' || gpSelect.MemberId || '"'

                               -- ����� ���������� (��� �������) �����
                                   -- 1) ���� CARDACCOUNTNO �� ������� ���������
                               || ' CARDACCOUNTNO="' || /*TRIM (gpSelect.card)||*/  '"'

                               -- IBAN ���������� ����� �� - ������ ����� 
                               || ' CARDIBAN="' || TRIM (gpSelect.CardIBAN) || '"'
                               
                               -- ������� ���������� - ������� �����������
                               ||      ' LASTNAME="' || zfCalc_Word_Split (inValue:= gpSelect.PersonalName, inSep:= ' ', inIndex:= 1) || '"'
                               -- ��� ���������� - ��� �����������
                               ||     ' FIRSTNAME="' || zfCalc_Word_Split (inValue:= gpSelect.PersonalName, inSep:= ' ', inIndex:= 2) || '"'
                               -- �������� ���������� - �� ������� �����������
                               ||    ' MIDDLENAME="' || zfCalc_Word_Split (inValue:= gpSelect.PersonalName, inSep:= ' ', inIndex:= 3) || '"'
                               -- ����� ��� ���������� �� ���� ���������� � ������� ���,���
                               ||        ' AMOUNT="' || REPLACE (CAST (COALESCE (gpSelect.SummCardRecalc, 0)  + COALESCE (gpSelect.SummHosp, 0) AS NUMERIC (16, 2)) :: TVarChar, '.', ',') || '"'

                               -- COMMENTS
                               --||    ' COMMENTS="�������� ����� �� 1 ��������' 
                               --||' ' || zfCalc_MonthNameUkr_export (vbOperDate)
                               --||' ' || EXTRACT (YEAR FROM vbOperDate) :: TVarChar
                               --||' ' ||'����"'

                               || '/>'

                         -- ��� �������� - ��� ����������
                       , TRIM (COALESCE (gpSelect.INN, '')) AS INN
                         -- ��� �������� - 1.1.IBAN ����. ����� �� - ������ ����� 
                       , TRIM (COALESCE (gpSelect.CardIBAN, '')) AS CardIBAN
                         -- ������� ���������� - ������� �����������
                       , zfCalc_Word_Split (inValue:= gpSelect.PersonalName, inSep:= ' ', inIndex:= 1) AS LASTNAME
                         -- ��� ���������� - ��� �����������
                       , zfCalc_Word_Split (inValue:= gpSelect.PersonalName, inSep:= ' ', inIndex:= 2) AS FIRSTNAME
                         -- �������� ���������� - �� ������� �����������
                       , zfCalc_Word_Split (inValue:= gpSelect.PersonalName, inSep:= ' ', inIndex:= 3) AS MIDDLENAME
                         -- ����� ��� ���������� �� ���� ���������� � ������� ���,���
                       , CAST (COALESCE (gpSelect.SummCardRecalc, 0)  + COALESCE (gpSelect.SummHosp, 0) AS NUMERIC (16, 2)) AS AMOUNT

                   FROM gpSelect_MovementItem_PersonalService (inMovementId := inMovementId
                                                             , inShowAll    := FALSE
                                                             , inIsErased   := FALSE
                                                             , inSession    := inSession
                                                              ) AS gpSelect
                   WHERE gpSelect.SummCardRecalc <> 0
                  ;

           -- �������� - �������� �����
           IF EXISTS (SELECT 1 FROM _tmpResult WHERE _tmpResult.NPP > 0 AND _tmpResult.CardIBAN = '')
           THEN
                RAISE EXCEPTION '������.��� ���������� %<%> %<%> %<%> %����� = <%> %�� ����������� �������� <1.1.IBAN ���������� ����� �� - ������ �����>.'
                              , CHR (13)
                              , (SELECT _tmpResult.LASTNAME FROM _tmpResult WHERE _tmpResult.NPP > 0 AND _tmpResult.CardIBAN = '' ORDER BY _tmpResult.NPP LIMIT 1)
                              , CHR (13)
                              , (SELECT _tmpResult.FIRSTNAME FROM _tmpResult WHERE _tmpResult.NPP > 0 AND _tmpResult.CardIBAN = '' ORDER BY _tmpResult.NPP LIMIT 1)
                              , CHR (13)
                              , (SELECT _tmpResult.MIDDLENAME FROM _tmpResult WHERE _tmpResult.NPP > 0 AND _tmpResult.CardIBAN = '' ORDER BY _tmpResult.NPP LIMIT 1)
                              , CHR (13)
                              , (SELECT zfConvert_FloatToString (_tmpResult.AMOUNT) FROM _tmpResult WHERE _tmpResult.NPP > 0 AND _tmpResult.CardIBAN = '' ORDER BY _tmpResult.NPP LIMIT 1)
                              , CHR (13)
                               ;
           END IF;
           -- �������� - �������� �����
           IF EXISTS (SELECT 1 FROM _tmpResult WHERE _tmpResult.NPP > 0 AND _tmpResult.INN = '')
           THEN
                RAISE EXCEPTION '������.��� ���������� %<%> %<%> %<%> %����� = <%> %�� ����������� �������� <���>.'
                              , CHR (13)
                              , (SELECT _tmpResult.LASTNAME FROM _tmpResult WHERE _tmpResult.NPP > 0 AND _tmpResult.INN = '' ORDER BY _tmpResult.NPP LIMIT 1)
                              , CHR (13)
                              , (SELECT _tmpResult.FIRSTNAME FROM _tmpResult WHERE _tmpResult.NPP > 0 AND _tmpResult.INN = '' ORDER BY _tmpResult.NPP LIMIT 1)
                              , CHR (13)
                              , (SELECT _tmpResult.MIDDLENAME FROM _tmpResult WHERE _tmpResult.NPP > 0 AND _tmpResult.INN = '' ORDER BY _tmpResult.NPP LIMIT 1)
                              , CHR (13)
                              , (SELECT zfConvert_FloatToString (_tmpResult.AMOUNT) FROM _tmpResult WHERE _tmpResult.NPP > 0 AND _tmpResult.INN = '' ORDER BY _tmpResult.NPP LIMIT 1)
                              , CHR (13)
                               ;
           END IF;


           -- ��������� ������� XML
           INSERT INTO _tmpResult (NPP, RowData) VALUES ((SELECT COUNT(*) FROM _tmpResult) + 1, '</EMPLOYEES>');
           INSERT INTO _tmpResult (NPP, RowData) VALUES ((SELECT COUNT(*) FROM _tmpResult) + 1, '</SCHEDULEINFO>');
           INSERT INTO _tmpResult (NPP, RowData) VALUES ((SELECT COUNT(*) FROM _tmpResult) + 1, '</DATAPACKET>');

     END IF; -- if vbBankId = 76970 -- ��� "��� ����"


     -- �������� ������
     IF er <> ''
     THEN
         RAISE EXCEPTION '%', er;
     END IF;

     -- ��������� �������� <������������ �������� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Export(), inMovementId, TRUE);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

     -- ���������
     RETURN QUERY
        SELECT _tmpResult.RowData FROM _tmpResult ORDER BY NPP;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.07.17         *
 20.12.16                                        *
 01.07.16
*/

-- ����
-- SELECT * FROM gpSelect_Movement_PersonalService_export (15240373, '1959', 50000.01, '15.06.2016', zfCalc_UserAdmin());
