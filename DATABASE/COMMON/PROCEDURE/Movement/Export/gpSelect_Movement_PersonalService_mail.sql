 -- Function: gpSelect_Movement_PersonalService_mail

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_mail (Integer, TVarChar, TFloat, TDateTime, TVarChar);
---DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_mail (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_mail (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService_mail(
    IN inMovementId           Integer,
    IN inParam                Integer,    -- = 1  CardSecond, INN, SummCardSecondRecalc, PersonalName
                                          --CSV  = 2 ��� CardBankSecond, SummCardSecondRecalc

    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbKoeffSummCardSecond NUMERIC (16,10);
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Mail() AND MB.ValueData = TRUE)
        AND vbUserId <> 5
        AND inMovementId <> 27627805
     THEN
         RAISE EXCEPTION '������.<%> � <%> �� <%> ��� ���� ����������.%��� ��������� �������� ���������� ������������ ��������.'
                       , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList()))
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                       , CHR(13)
                        ;

     END IF;

     -- ��������
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
        AND vbUserId <> 5
     THEN
         RAISE EXCEPTION '������.<%> � <%> �� <%> % � ������� <%>.%��� �������� ���������� ���������� ������ ��������� � <%>.'
                       , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList()))
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                       , CHR(13)
                       , (SELECT lfGet_Object_ValueData_sh (Movement.StatusId) FROM Movement WHERE Movement.Id = inMovementId)
                       , CHR(13)
                       , (SELECT lfGet_Object_ValueData_sh (zc_Enum_Status_Complete()))
                        ;

     END IF;


     -- ���������� ������ �� ��������� ����������
     SELECT --ObjectFloat_KoeffSummCardSecond.ValueData AS KoeffSummCardSecond  --����� ��� �������� ��������� ���� 2�.
            CAST (ObjectFloat_KoeffSummCardSecond.ValueData/ 1000 AS NUMERIC (16,10)) AS KoeffSummCardSecond  --����� ��� �������� ��������� ���� 2�.
            INTO vbKoeffSummCardSecond
     FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
          LEFT JOIN ObjectFloat AS ObjectFloat_KoeffSummCardSecond
                                ON ObjectFloat_KoeffSummCardSecond.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                               AND ObjectFloat_KoeffSummCardSecond.DescId = zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond()
     WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
       AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList();

     -- ���� �� ������ ���. ����� �� ��������� = 1.00807
     IF COALESCE (vbKoeffSummCardSecond,0) = 0
     THEN
         vbKoeffSummCardSecond := 1.00807;
     END IF;

     -- ������� ��� ����������
     CREATE TEMP TABLE _Result (RowData TBlob) ON COMMIT DROP;
     -- !!!������ CSV - zc_Enum_ExportKind_PersonalService!!!

     -- CardSecond, INN, SummCardSecondRecalc, PersonalName
     IF inParam = 1
     THEN
         INSERT INTO _Result(RowData)
         WITH
         tmp AS (SELECT COALESCE (gpSelect.CardSecond, '') AS CardSecond
                      , COALESCE (gpSelect.INN, '')  AS INN
                      , SUM (FLOOR (100 * CAST ( ((COALESCE (gpSelect.SummCardSecondRecalc, 0) + COALESCE (gpSelect.SummAvCardSecondRecalc, 0)) * vbKoeffSummCardSecond) AS NUMERIC (16, 0)) ))  AS SummCardSecondRecalc -- �������� % � ��������� �� 2-� ������ + ��������� � �������
                      , UPPER (COALESCE (gpSelect.PersonalName, '') )  AS PersonalName
                 FROM gpSelect_MovementItem_PersonalService (inMovementId:= inMovementId  , inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
                 WHERE gpSelect.SummCardSecondRecalc <> 0 OR gpSelect.SummAvCardSecondRecalc <> 0
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
              || ';' || (SUM (tmp.SummCardSecondRecalc)) :: Integer
                 FROM tmp
                ;
     END IF;


     -- CardBankSecond, SummCardSecondRecalc
     IF inParam = 2
     THEN
      INSERT INTO _Result(RowData)
      WITH
  tmp_all AS (SELECT gpSelect.CardBankSecond
                     -- ���������
                   , SUM (COALESCE (gpSelect.SummCardSecondRecalc, 0) + COALESCE (gpSelect.SummAvCardSecondRecalc, 0))  AS SummCardSecondRecalc
              FROM gpSelect_MovementItem_PersonalService (inMovementId:= inMovementId  , inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
              WHERE (gpSelect.SummCardSecondRecalc <> 0 OR gpSelect.SummAvCardSecondRecalc <> 0)
                AND COALESCE (gpSelect.CardBankSecond,'') <> ''
	      GROUP BY gpSelect.CardBankSecond
	      )
    , tmp AS (SELECT tmp_all.CardBankSecond
                     -- % � ���������
                   , CAST (CASE WHEN tmp_all.SummCardSecondRecalc <= 29999
                                THEN tmp_all.SummCardSecondRecalc
                                ELSE tmp_all.SummCardSecondRecalc + (tmp_all.SummCardSecondRecalc - 29999) * 0.005
                           END AS NUMERIC (16, 0)) AS SummCardSecondRecalc
              FROM tmp_all
              WHERE 4000 <= tmp_all.SummCardSecondRecalc
	     )

	      SELECT tmp.CardBankSecond
           || ';' || tmp.SummCardSecondRecalc
              FROM tmp
             UNION ALL
              --������ ������
              SELECT ''
             UNION ALL
              --�����
              SELECT ''
           || ';' || (SUM (tmp.SummCardSecondRecalc)) :: TFloat
              FROM tmp
             ;
     END IF;


     -- !!!������ �����!!! - ��������� �������� <������������ �������� (��/���)>
     -- PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Mail(), inMovementId, TRUE);
     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

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
 08.02.24         *
 31.01.24         *
 17.11.21         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_PersonalService_mail (27194351, 2, zfCalc_UserAdmin());
