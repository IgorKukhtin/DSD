-- Function: gpSelect_Movement_PersonalServiceNum_mail_xls

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalServiceNum_mail_xls (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalServiceNum_mail_xls(
    IN inMovementId           Integer,
    IN inParam                Integer,    --XLS  = 4 ��� ������������� �� ����������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (FIO               TVarChar
             , Name              TVarChar
             , Name_two          TVarChar
             , INN               TVarChar
             , Phone             TVarChar
               -- � ���������� IBAN����� �� - �2
             , CardIBANSecond    TVarChar
               -- ����� ���������� �������� �� - �2
             , CardBankSecond    TVarChar
               -- �����
             , BankSecond_num    NUMERIC (16,2)
               -- 
             , PersonalName      TVarChar
               -- � ���������� ����� �� - �2
             , CardSecond        TVarChar
               -- ����
             , BankSecondName    TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Mail() AND MB.ValueData = TRUE)
        AND vbUserId NOT IN (5, 9457)
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
        AND vbUserId NOT IN (5, 9457)
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



     -- ���������
     IF inParam = 4
     THEN
      -- ���������
      RETURN QUERY
      WITH
            tmpMI AS (SELECT *
                      FROM MovementItem
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.isErased = FALSE
                        AND MovementItem.DescId = zc_MI_Master()
                      )

          , tmpMember AS (SELECT tmp.ObjectId                                 AS PersonalId
                                , Object_Personal.ValueData                   AS PersonalName
                                , ObjectString_Member_INN.ValueData           AS INN
                                , ObjectString_Member_Phone.ValueData         AS Phone
                                  -- ����� ���������� �������� �� - �2
                                , ObjectString_CardBankSecond.ValueData       AS CardBankSecond
                                , ObjectString_CardBankSecondTwo.ValueData    AS CardBankSecondTwo
                                , ObjectString_CardBankSecondDiff.ValueData   AS CardBankSecondDiff
                                  -- � ���������� IBAN����� �� - �2
                                , ObjectString_CardIBANSecond.ValueData       AS CardIBANSecond
                                , ObjectString_CardIBANSecondTwo.ValueData    AS CardIBANSecondTwo
                                , ObjectString_CardIBANSecondDiff.ValueData   AS CardIBANSecondDiff
                                  -- � ���������� ����� �� - �2
                                , ObjectString_CardSecond.ValueData           AS CardSecond
                                , ObjectString_CardSecondTwo.ValueData        AS CardSecondTwo
                                , ObjectString_CardSecondDiff.ValueData       AS CardSecondDiff

                          FROM (SELECT DISTINCT tmpMI.ObjectId FROM tmpMI) AS tmp
                               LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmp.ObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                    ON ObjectLink_Personal_Member.ObjectId = tmp.ObjectId
                                                   AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                               LEFT JOIN ObjectString AS ObjectString_Member_INN
                                                      ON ObjectString_Member_INN.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_Member_INN.DescId = zc_ObjectString_member_INN()
                               LEFT JOIN ObjectString AS ObjectString_Member_Phone
                                                      ON ObjectString_Member_Phone.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_Member_Phone.DescId = zc_ObjectString_Member_Phone()

                               -- ����� ���������� �������� �� - �2
                               LEFT JOIN ObjectString AS ObjectString_CardBankSecond
                                                      ON ObjectString_CardBankSecond.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_CardBankSecond.DescId = zc_ObjectString_Member_CardBankSecond()
                               LEFT JOIN ObjectString AS ObjectString_CardBankSecondTwo
                                                      ON ObjectString_CardBankSecondTwo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_CardBankSecondTwo.DescId = zc_ObjectString_Member_CardBankSecondTwo()
                               LEFT JOIN ObjectString AS ObjectString_CardBankSecondDiff
                                                      ON ObjectString_CardBankSecondDiff.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_CardBankSecondDiff.DescId = zc_ObjectString_Member_CardBankSecondDiff()
                               -- � ���������� IBAN����� �� - �2
                               LEFT JOIN ObjectString AS ObjectString_CardIBANSecond
                                                      ON ObjectString_CardIBANSecond.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_CardIBANSecond.DescId = zc_ObjectString_Member_CardIBANSecond()
                               LEFT JOIN ObjectString AS ObjectString_CardIBANSecondTwo
                                                      ON ObjectString_CardIBANSecondTwo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_CardIBANSecondTwo.DescId = zc_ObjectString_Member_CardIBANSecondTwo()
                               LEFT JOIN ObjectString AS ObjectString_CardIBANSecondDiff
                                                      ON ObjectString_CardIBANSecondDiff.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_CardIBANSecondDiff.DescId = zc_ObjectString_Member_CardIBANSecondDiff()
                               -- � ���������� ����� �� - �2
                               LEFT JOIN ObjectString AS ObjectString_CardSecond
                                                      ON ObjectString_CardSecond.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_CardSecond.DescId = zc_ObjectString_Member_CardSecond()
                               LEFT JOIN ObjectString AS ObjectString_CardSecondTwo
                                                      ON ObjectString_CardSecondTwo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_CardSecondTwo.DescId = zc_ObjectString_Member_CardSecondTwo()
                               LEFT JOIN ObjectString AS ObjectString_CardSecondDiff
                                                      ON ObjectString_CardSecondDiff.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_CardSecondDiff.DescId = zc_ObjectString_Member_CardSecondDiff()

                          )
           --������ ���������� �� ����������
          , tmpAll AS (SELECT tmpMember.PersonalName
                            , tmpMember.INN                    AS INN
                            , tmpMember.Phone                  AS Phone
                              -- ����� ���������� �������� �� - �2
                            , tmpMember.CardBankSecond         AS CardBankSecond
                              -- � ���������� IBAN����� �� - �2
                            , tmpMember.CardIBANSecond         AS CardIBANSecond
                              -- � ���������� ����� �� - �2
                            , tmpMember.CardSecond             AS CardSecond
                              -- ����
                            , Object_BankSecond_num.ValueData  AS BankSecondName
                              -- �����
                            , SUM (COALESCE (MIFloat_Summ_BankSecond_num.ValueData,0)) AS BankSecond_num

                       FROM tmpMI AS MovementItem
                            LEFT JOIN tmpMember ON tmpMember.PersonalId = MovementItem.ObjectId

                            INNER JOIN MovementItemFloat AS MIFloat_Summ_BankSecond_num
                                                         ON MIFloat_Summ_BankSecond_num.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Summ_BankSecond_num.DescId = zc_MIFloat_Summ_BankSecond_num()
                                                        AND COALESCE (MIFloat_Summ_BankSecond_num.ValueData,0) <> 0

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_BankSecond_num
                                                             ON MILinkObject_BankSecond_num.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_BankSecond_num.DescId = zc_MILinkObject_BankSecond_num()
                            LEFT JOIN Object AS Object_BankSecond_num ON Object_BankSecond_num.Id = MILinkObject_BankSecond_num.ObjectId

                       GROUP BY tmpMember.PersonalName
                              , tmpMember.INN
                              , tmpMember.Phone
                              , tmpMember.CardBankSecond
                              , tmpMember.CardIBANSecond
                              , tmpMember.CardSecond
                              , Object_BankSecond_num.ValueData

                   UNION
                     SELECT tmpMember.PersonalName             AS PersonalName
                          , tmpMember.INN                      AS INN
                          , tmpMember.Phone                    AS Phone
                            -- ����� ���������� �������� �� - �2
                          , tmpMember.CardBankSecondTwo        AS CardBankSecond
                            -- � ���������� IBAN����� �� - �2
                          , tmpMember.CardIBANSecondTwo        AS CardIBANSecond
                            -- � ���������� ����� �� - �2
                          , tmpMember.CardSecondTwo            AS CardSecond
                            -- ����
                          , Object_BankSecondTwo_num.ValueData AS BankSecondName
                            -- �����
                          , SUM (COALESCE (MIFloat_Summ_BankSecondTwo_num.ValueData,0)) AS BankSecond_num

                     FROM tmpMI AS MovementItem
                          LEFT JOIN tmpMember ON tmpMember.PersonalId = MovementItem.ObjectId

                          INNER JOIN MovementItemFloat AS MIFloat_Summ_BankSecondTwo_num
                                                       ON MIFloat_Summ_BankSecondTwo_num.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Summ_BankSecondTwo_num.DescId = zc_MIFloat_Summ_BankSecondTwo_num()
                                                      AND COALESCE (MIFloat_Summ_BankSecondTwo_num.ValueData,0) <> 0

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_BankSecondTwo_num
                                             ON MILinkObject_BankSecondTwo_num.MovementItemId = MovementItem.Id
                                            AND MILinkObject_BankSecondTwo_num.DescId = zc_MILinkObject_BankSecondTwo_num()
                          LEFT JOIN Object AS Object_BankSecondTwo_num ON Object_BankSecondTwo_num.Id = MILinkObject_BankSecondTwo_num.ObjectId

                      GROUP BY tmpMember.PersonalName
                             , tmpMember.INN
                             , tmpMember.Phone
                             , tmpMember.CardBankSecondTwo
                             , tmpMember.CardIBANSecondTwo
                             , tmpMember.CardSecondTwo
                             , Object_BankSecondTwo_num.ValueData

                   UNION
                     SELECT tmpMember.PersonalName              AS PersonalName
                          , tmpMember.INN                       AS INN
                          , tmpMember.Phone                     AS Phone
                            -- ����� ���������� �������� �� - �2
                          , tmpMember.CardBankSecondDiff        AS CardBankSecond
                            -- � ���������� IBAN����� �� - �2
                          , tmpMember.CardIBANSecondDiff        AS CardIBANSecond
                            -- � ���������� ����� �� - �2
                          , tmpMember.CardSecondDiff            AS CardSecond
                            -- ����
                          , Object_BankSecondDiff_num.ValueData AS BankSecondName
                            -- �����
                          , SUM (COALESCE (MIFloat_Summ_BankSecondDiff_num.ValueData,0)) AS BankSecond_num

                     FROM tmpMI AS MovementItem
                          LEFT JOIN tmpMember ON tmpMember.PersonalId = MovementItem.ObjectId

                          INNER JOIN MovementItemFloat AS MIFloat_Summ_BankSecondDiff_num
                                                       ON MIFloat_Summ_BankSecondDiff_num.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Summ_BankSecondDiff_num.DescId = zc_MIFloat_Summ_BankSecondDiff_num()
                                                      AND COALESCE (MIFloat_Summ_BankSecondDiff_num.ValueData,0) <> 0

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_BankSecondDiff_num
                                             ON MILinkObject_BankSecondDiff_num.MovementItemId = MovementItem.Id
                                            AND MILinkObject_BankSecondDiff_num.DescId = zc_MILinkObject_BankSecondDiff_num()
                          LEFT JOIN Object AS Object_BankSecondDiff_num ON Object_BankSecondDiff_num.Id = MILinkObject_BankSecondDiff_num.ObjectId

                      GROUP BY tmpMember.PersonalName
                             , tmpMember.INN
                             , tmpMember.Phone
                             , tmpMember.CardBankSecondDiff
                             , tmpMember.CardIBANSecondDiff
                             , tmpMember.CardSecondDiff
                             , Object_BankSecondDiff_num.ValueData
                   )


              SELECT
                    -- ������� ���������� - ������� �����������
                    zfCalc_Word_Split (inValue:= tmpAll.PersonalName, inSep:= ' ', inIndex:= 1)  AS FIO
                     -- ��� ���������� - ��� �����������
                   , zfCalc_Word_Split (inValue:= tmpAll.PersonalName, inSep:= ' ', inIndex:= 2) AS Name
                     -- �������� ���������� - �� ������� �����������
                   , zfCalc_Word_Split (inValue:= tmpAll.PersonalName, inSep:= ' ', inIndex:= 3) AS Name_two
                   , tmpAll.INN              ::TVarChar
                   , tmpAll.Phone            ::TVarChar
                     -- � ���������� IBAN����� �� - �2
                   , tmpAll.CardIBANSecond   ::TVarChar
                     -- ����� ���������� �������� �� - �2
                   , tmpAll.CardBankSecond   ::TVarChar
                     -- �����
                   , CAST (tmpAll.BankSecond_num AS NUMERIC (16, 0))   ::NUMERIC (16,2)
                     --
                   , tmpAll.PersonalName     ::TVarChar
                     -- � ���������� ����� �� - �2
                   , tmpAll.CardSecond       ::TVarChar
                     -- ����
                   , tmpAll.BankSecondName   ::TVarChar
              FROM tmpAll

             UNION ALL
              -- �����
              SELECT ''  ::TVarChar
                   , ''  ::TVarChar
                   , ''  ::TVarChar
                   , ''  ::TVarChar
                   , ''  ::TVarChar
                   , ''  ::TVarChar
                   , ''  ::TVarChar
                   , (SUM (CAST (tmpAll.BankSecond_num AS NUMERIC (16, 0)))) :: NUMERIC (16,2)
                   , ''  ::TVarChar
                   , ''  ::TVarChar
                   , ''  ::TVarChar
              FROM tmpAll
             ;

     END IF;
     

     /*IF vbUserId <> 5
     THEN
         -- !!!������ �����!!! - ��������� �������� <������������ �������� (��/���)>
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Mail(), inMovementId, TRUE);
         -- ��������� ��������
         PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
     END IF;*/


    -- ���������
    -- RETURN QUERY
     --   SELECT _Result.RowData FROM _Result;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.02.24         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_PersonalServiceNum_mail_xls (27680979, 4, '9457');
