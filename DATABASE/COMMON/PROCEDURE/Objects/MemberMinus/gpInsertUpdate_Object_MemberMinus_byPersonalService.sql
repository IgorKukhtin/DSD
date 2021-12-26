-- Function: gpInsertUpdate_Object_MemberMinus_byPersonalService()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus_byPersonalService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberMinus_byPersonalService(
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
   DECLARE vbNumber TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MemberMinus());
     vbUserId:= lpGetUserBySession (inSession);

     CREATE TEMP TABLE tmpMemberMinus ON COMMIT DROP AS 
     WITH
          tmpPersonal AS (SELECT lfSelect.MemberId
                               , lfSelect.PersonalId
                               , lfSelect.PositionId
                               , lfSelect.isMain
                               , lfSelect.UnitId
                          FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                          WHERE lfSelect.Ord = 1
                         )
         -- �������� ������ �� ����������� MemberMinus
        SELECT tmp.Id
             , tmp.FromId  AS MemberId
             , tmpPersonal.PersonalId
             , tmpPersonal.PositionId
             , CASE WHEN COALESCE (tmp.Tax,0) = 0 THEN 100 ELSE tmp.Tax END AS Tax
             , tmp.Number
             , tmp.isChild
             , (tmp.Summ) AS Summ
        FROM gpSelect_Object_MemberMinus (FALSE, FALSE, inSession) AS tmp
             LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = tmp.FromId
        WHERE tmp.isErased = FALSE
        ;


     CREATE TEMP TABLE tmpData ON COMMIT DROP AS
        WITH
          --������ �� ���. �� ������� ��������� � ��.���������
          tmpMI_All AS (SELECT tmp.*
                             , CASE WHEN COALESCE (tmp.SummChildRecalc,0) <> 0 THEN TRUE ELSE FALSE END isChild 
                        FROM gpSelect_MovementItem_PersonalService(21646761 , FALSE, FALSE, inSession) AS tmp
                        WHERE COALESCE (tmp.SummChildRecalc,0) <> 0
                           OR COALESCE (tmp.SummMinusExtRecalc,0) <> 0
                       )

            --������������ ������ ��������� �� % �� �������������� ������
            SELECT tmpMemberMinus.MemberId
                 , tmpMI_All.Number
                 , tmpMemberMinus.Tax
                 , tmpMI_All.isChild 
                 , SUM (CASE WHEN COALESCE (tmpMemberMinus.isChild,TRUE) = TRUE THEN COALESCE (tmpMI_All.SummChildRecalc,0) ELSE COALESCE (tmpMI_All.SummMinusExtRecalc,0) END) AS TotalSummMinus
                 , SUM ((CASE WHEN COALESCE (tmpMemberMinus.isChild,TRUE) = TRUE THEN COALESCE (tmpMI_All.SummChildRecalc,0) ELSE COALESCE (tmpMI_All.SummMinusExtRecalc,0) END) * COALESCE (tmpMemberMinus.Tax,100) / 100) AS SummMinus
            FROM tmpMI_All
                 LEFT JOIN tmpMemberMinus ON tmpMemberMinus.PersonalId = tmpMI_All.PersonalId
                                         AND tmpMemberMinus.Number = tmpMI_All.Number
            GROUP BY tmpMemberMinus.MemberId
                   , tmpMI_All.Number
                   , tmpMemberMinus.Tax
                   , tmpMI_All.isChild
            HAVING SUM (CASE WHEN COALESCE (tmpMemberMinus.isChild,TRUE) = TRUE THEN COALESCE (tmpMI_All.SummChildRecalc,0) ELSE COALESCE (tmpMI_All.SummMinusExtRecalc,0) END) <> 0
         ;

     --�������� ���� ������������ �� 100 % / �� ��� �����
     SELECT tmp.MemberId, tmp.Number
        INTO vbMemberId, vbNumber
     FROM (SELECT tmpData.Number
                , tmpData.MemberId
                , tmpData.TotalSummMinus
                , SUM (tmpData.Tax)       AS Tax
                , SUM (tmpData.SummMinus) AS SummMinus
           FROM tmpData
           GROUP BY tmpData.MemberId
                  , tmpData.TotalSummMinus
                  , tmpData.Number
           HAVING SUM (tmpData.Tax) <> 100
               OR SUM (tmpData.SummMinus) <> tmpData.TotalSummMinus
           LIMIT 1
           ) AS tmp;

     IF COALESCE (vbMemberId,0) <> 0
     THEN
          RAISE EXCEPTION '������.�� ���������� <%> ���.���� � <%> ������������ �� 100%', lfGet_Object_ValueData (vbMemberId), vbNumber;
     END IF;
     
     
     -- ��������� � �����������
     PERFORM  lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_Summ(), tmpMemberMinus.Id, tmpData.SummMinus)
     FROM tmpData
          INNER JOIN tmpMemberMinus ON tmpMemberMinus.MemberId = tmpData.MemberId
                                   AND tmpMemberMinus.Number = tmpData.Number
     WHERE COALESCE (tmpData.SummMinus,0) <> 0
     ;
     
     --��������� ������� ����������� ���� ������ ����������������  ����� ���
     PERFORM gpInsertUpdate_Object_MemberMinus(ioId                   := 0   ::Integer       -- ���� ������� < >
                                             , inName                 := '' ::TVarChar      -- ���������� 
                                             , inBankAccountTo        := '' ::TVarChar      -- � ����� ���������� �������
                                             , inDetailPayment        := '' ::TVarChar      -- ���������� �������
                                             , inINN_to               := '' ::TVarChar      -- ����/��� ����������
                                             , inToShort              := '' ::TVarChar      -- ��. ���� (����������� ��������) 
                                             , inNumber               := tmpData.Number   ::TVarChar      -- 
                                             , inFromId               := tmpData.MemberId ::Integer       -- ���������� ����
                                             , inToId                 := NULL ::Integer       -- ���������� ����(���������) / ����������� ����
                                             , ioBankAccountFromId    := NULL  ::Integer       -- IBAN ����������� �������
                                             , inBankAccountToId      := NULL  ::Integer       -- IBAN ���������� �������
                                             , inBankAccountId_main   := NULL  ::Integer       --� ��������������� �����
                                             , inTotalSumm            := tmpData.SummMinus::TFloat         -- ����� �����
                                             , inSumm                 := tmpData.SummMinus::TFloat         -- ����� � ��������� ����������
                                             , inTax                  := 100             ::TFloat         -- % ���������
                                             , inisChild              := tmpData.isChild ::Boolean        -- �������� (��/���)
                                             , inSession              := inSession       ::TVarChar        -- ������ ������������
                                             )
     FROM tmpData
          LEFT JOIN tmpMemberMinus ON tmpMemberMinus.MemberId = tmpData.MemberId
                                   AND tmpMemberMinus.Number = tmpData.Number
     WHERE COALESCE (tmpData.SummMinus,0) <> 0 
       AND tmpMemberMinus.MemberId IS NULL
       AND COALESCE (tmpData.Number,'') <> ''
     ;

    IF (vbUserId = '5') OR (vbUserId = '9457')
    THEN
        RAISE EXCEPTION '��������� ������ :)';
    END IF;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.12.21         *
*/
