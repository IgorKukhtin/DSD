-- Function: gpSelect_Movement_PersonalService_mail

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_mail (Integer, TVarChar, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService_mail(
    IN inMovementId           Integer,
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbKoeffSummCardSecond TFloat; 
BEGIN

     -- ��������
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Mail() AND MB.ValueData = TRUE)
     THEN
         RAISE EXCEPTION '������.<%> � <%> �� <%> ��� ���� ����������.%��� ��������� �������� ���������� ������������ ��������.'
                       , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList()))
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                       , CHR(13)
                        ;
                         
     END IF;

     -- ���������� ������ �� ��������� ����������
     SELECT ObjectFloat_KoeffSummCardSecond.ValueData AS KoeffSummCardSecond  --����� ��� �������� ��������� ���� 2�.
   INTO vbKoeffSummCardSecond
     FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
          LEFT JOIN ObjectFloat AS ObjectFloat_KoeffSummCardSecond
                                ON ObjectFloat_KoeffSummCardSecond.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                               AND ObjectFloat_KoeffSummCardSecond.DescId = zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond()
     WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
       AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList();

/*
     -- ���������� ������ �� ��������� ����������
     SELECT Object_Bank.Id                 AS BankId             -- ����
          , Object_Bank.ValueData          AS BankName           -- ����
          , ObjectString_MFO.ValueData     AS MFO                --
          , Object_BankAccount.Id          AS BankAccountId      -- �/����
          , Object_BankAccount.ValueData   AS BankAccountName    -- �/����
          , ObjectLink_PersonalServiceList_PSLExportKind.ChildObjectId AS PSLExportKindId    -- ��� �������� ��������� � ����
          , ObjectString_ContentType.ValueData ::TVarChar   AS ContentType  -- Content-Type
          , ObjectString_OnFlowType.ValueData  ::TVarChar   AS OnFlowType   -- ��� ���������� � �����
          , ObjectFloat_KoeffSummCardSecond.ValueData       AS KoeffSummCardSecond --����� ��� �������� ��������� ���� 2�.
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
*/
     --���� �� ������ ���. ����� �� ��������� = 1.00807
     IF COALESCE (vbKoeffSummCardSecond,0) = 0
     THEN
         vbKoeffSummCardSecond := 1.00807;
     END IF;

     -- ������� ��� ����������
     CREATE TEMP TABLE _Result (RowData TBlob) ON COMMIT DROP;
     -- !!!������ CSV - zc_Enum_ExportKind_PersonalService!!!

      INSERT INTO _Result(RowData)
      WITH
      tmp AS (SELECT COALESCE (gpSelect.CardSecond, '') AS CardSecond
                   , COALESCE (gpSelect.INN, '')  AS INN
                   , SUM (FLOOR (100 * CAST (COALESCE (gpSelect.SummCardSecondRecalc, 0) * vbKoeffSummCardSecond AS NUMERIC (16, 1)) ))  AS SummCardSecondRecalc -- �������� % � ��������� �� 2-� ������ + ��������� � �������
                   , UPPER (COALESCE (gpSelect.PersonalName, '') )  AS PersonalName
              FROM gpSelect_MovementItem_PersonalService (inMovementId:= inMovementId  , inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
           --   WHERE gpSelect.SummCardSecondRecalc <> 0
	      GROUP BY COALESCE (gpSelect.CardSecond, ''), UPPER (COALESCE (gpSelect.PersonalName, '')), COALESCE (gpSelect.INN, '')
	      )
	      
	      SELECT tmp.CardSecond
           || ';' || tmp.INN
           || ';' || tmp.SummCardSecondRecalc
           || ';' || REPLACE (tmp.PersonalName, ' ', ';' )
              FROM tmp
             UNION ALL
              --������ ������
              SELECT ''
             UNION ALL
              --����� 
              SELECT ''
           || ';' || ''
           || ';' || SUM (tmp.SummCardSecondRecalc)
              FROM tmp;
              


     -- ��������� �������� <������������ �������� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Mail(), inMovementId, TRUE);

     -- ���������
     RETURN QUERY
        SELECT _Result.RowData FROM _Result;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.11.21         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_PersonalService_mail (21011498, zfCalc_UserAdmin());

--SELECT lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Mail(), 21011498, FAlse);