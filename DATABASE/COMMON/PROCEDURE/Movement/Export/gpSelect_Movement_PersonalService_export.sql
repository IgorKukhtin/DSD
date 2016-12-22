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
RETURNS TABLE (RowData TVarChar)
AS
$BODY$
   DECLARE vbBankId Integer;

   DECLARE r RECORD;
   DECLARE i Integer; -- �������������
   DECLARE e Text;
   DECLARE er Text;
BEGIN
	-- *** ��������� ������� ��� ����� ����������
	CREATE TEMP TABLE _tmpResult (RowData TVarChar, errStr TVarChar) ON COMMIT DROP;


        -- ���������� ����
        vbBankId:= (SELECT ObjectLink_PersonalServiceList_Bank.ChildObjectId
                    FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
                          LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Bank
                                               ON ObjectLink_PersonalServiceList_Bank.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId 
                                              AND ObjectLink_PersonalServiceList_Bank.DescId = zc_ObjectLink_PersonalServiceList_Bank()
                    WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
                      AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                   );

     -- ��� "���� ������"
     IF vbBankId = 76968
     THEN
	-- *** ����� �����
	-- ��� ��������� (�� ��)
	INSERT INTO _tmpResult (RowData) VALUES ('Content-Type=doc/pay_sheet');
	-- ������ ������
	INSERT INTO _tmpResult (RowData) VALUES ('');
	-- ���� ���������
	INSERT INTO _tmpResult (RowData) VALUES ('DATE_DOC='||TO_CHAR(NOW(), 'dd.mm.yyyy'));
	-- ���� �������������
	INSERT INTO _tmpResult (RowData) VALUES ('VALUE_DATE='||TO_CHAR(NOW(), 'dd.mm.yyyy'));
	-- ����� ���������
	INSERT INTO _tmpResult (RowData) VALUES ('NUM_DOC='||inInvNumber);
	-- ��� ����� ����������
	INSERT INTO _tmpResult (RowData) VALUES ('PAYER_BANK_MFO=307123');
	-- ���� ��������
	INSERT INTO _tmpResult (RowData) VALUES ('PAYER_ACCOUNT=26007010192834');
	-- ����� ����������	
	INSERT INTO _tmpResult (RowData) VALUES ('AMOUNT='||ROUND(inAmount::numeric, 2));
	-- ���� ����� �����������
	INSERT INTO _tmpResult (RowData) VALUES ('PAYER_BANK_ACCOUNT=29244006');
	-- ��� ��������� �������
	INSERT INTO _tmpResult (RowData) VALUES ('ONFLOW_TYPE=������� �������� �����');
	-- ������������ �������
	INSERT INTO _tmpResult (RowData) VALUES ('CLN_NAME=��� "����"');
	-- ��� ������ �������
	INSERT INTO _tmpResult (RowData) VALUES ('CLN_OKPO=24447183');
	-- ������ ����������
	INSERT INTO _tmpResult (RowData) VALUES ('PERIOD='||TO_CHAR(NOW(), 'TMMonth yyyy'));

	-- *** �������� �����
	i := 0; -- �������� �������������
	FOR r IN (select card, personalname, inn, SummCardRecalc from gpSelect_MovementItem_PersonalService(inMovementId := inMovementId, inShowAll := 'False', inIsErased := 'False',  inSession := inSession))
	LOOP
		IF (char_length(r.card)<>14) 
		   OR (NOT ISNUMERIC(r.card))
		   --OR (NOT ISNUMERIC(r.inn)) 
		   --OR (char_length(r.inn)<>10) 
		   OR (char_length(r.personalname)=0) THEN
		   BEGIN
			e := '��������/�������� ������: ����� - ' || r.card || ', ��� - ' || r.personalname || ', ��� - ' || r.inn || ', ����� - ' || r.SummCardRecalc || CHR(13) || CHR(10);
			er := concat(er, e);
		   END;
		ELSE
		BEGIN
			-- ����� ���������� �����
			INSERT INTO _tmpResult (RowData) VALUES ('CARD_HOLDERS.'||i::TVarChar||'.CARD_NUM='||r.card);
			-- ��� ��������� �����
			INSERT INTO _tmpResult (RowData) VALUES ('CARD_HOLDERS.'||i::TVarChar||'.CARD_HOLDER='||LEFT(REPLACE(r.personalname, chr(39), ''), 80));
			-- ��� ��������� �����
			INSERT INTO _tmpResult (RowData) VALUES ('CARD_HOLDERS.'||i::TVarChar||'.CARD_HOLDER_INN='||r.inn);
			-- ����� ����������
			INSERT INTO _tmpResult (RowData) VALUES ('CARD_HOLDERS.'||i::TVarChar||'.AMOUNT='||ROUND(r.SummCardRecalc::numeric, 2));
			i := i + 1; -- ����������� �������� �������������
		END;
		END IF;

        END LOOP;

     END IF; -- if vbBankId = 76968 -- ��� "���� ������"


     -- ��� "��� ����"
     IF vbBankId = 76970
     THEN

         -- ������ ������� XML
         INSERT INTO _tmpResult (RowData) VALUES ('<?xml version="1.0" encoding="windows-1251"?>');
         INSERT INTO _tmpResult (RowData) VALUES ('<DATAPACKET Version="2.0">');

         -- �����
         INSERT INTO _tmpResult(RowData)
            SELECT '<SCHEDULEINFO SHEDULE_DATE="' || TO_CHAR (NOW(), 'dd/mm/yyyy') || '"'   -- ���� ���������� ��������� � ������� ��/��/����
                     ||       ' SHEDULE_NUMBER="' || inInvNumber || '"'                     -- ����� ���������� ���������
                     ||  ' PAYER_BANK_BRANCHID="' || '300528' || '"'                        -- ��� �����, � ������� ������ ���� �����������
                  -- || ' PAYER_BANK_ACCOUNTNO="' || '00002' || '"'                         -- ���� ����������� � ����� (����������). ����������. ���� ������������� �������� ��������� ������� ����� �������, ��� ���������� ���� ����� ������������ �������������, �� ������ ���� ����� �������������� ��� ����������
                     ||      ' PAYER_ACCOUNTNO="' || '26000301367079' || '"'                -- ���� ��� �������� �������
                     || ' TOTAL_SHEDULE_AMOUNT="' || REPLACE (CAST (inAmount AS NUMERIC (16, 2)) :: TVarChar, '.', ',') || '"' -- ����� ����� ���������� ��������� � ������� ���,���
                     ||   ' CONTRAGENT_CODEZKP="' || '1011442' || '"'                       -- ��� ����������� �������. ����������� ����������� ������ ��� ������, ������������ ���
                     || '>'
                    ;


           -- �������� �����
           INSERT INTO _tmpResult(RowData) VALUES ('<EMPLOYEES>');
           --
           INSERT INTO _tmpResult (RowData)
                   SELECT '<EMPLOYEE IDENTIFYCODE="' || gpSelect.inn || '"'                              -- ����������������� ��� ����������
                               || ' CARDACCOUNTNO="' || gpSelect.card || '"'                             -- ����� ���������� (��� �������) �����
                               ||        ' AMOUNT="' || REPLACE (CAST (inAmount AS NUMERIC (16, 2)) :: TVarChar, '.', ',') || '"' -- ����� ��� ���������� �� ���� ���������� � ������� ���,���
                               || '/>'
                   FROM gpSelect_MovementItem_PersonalService (inMovementId := inMovementId
                                                             , inShowAll    := FALSE
                                                             , inIsErased   := FALSE
                                                             , inSession    := inSession
                                                              ) AS gpSelect
                   WHERE gpSelect.SummCardRecalc <> 0
                  ;

           -- ��������� ������� XML
           INSERT INTO _tmpResult(RowData) VALUES ('</EMPLOYEES>');
           INSERT INTO _tmpResult(RowData) VALUES ('</SCHEDULEINFO>');
           INSERT INTO _tmpResult(RowData) VALUES ('</DATAPACKET>');

     END IF; -- if vbBankId = 76970 -- ��� "��� ����"


     -- �������� ������
     IF er <> ''
     THEN
         RAISE EXCEPTION '%', er;
     END IF;


     -- ���������
     RETURN QUERY
        SELECT _tmpResult.RowData FROM _tmpResult;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.12.16                                        *
 01.07.16                                        
*/

-- ����
-- SELECT * FROM gpSelect_Movement_PersonalService_export (4989071, '1959', 50000.01, '15.06.2016', zfCalc_UserAdmin());
