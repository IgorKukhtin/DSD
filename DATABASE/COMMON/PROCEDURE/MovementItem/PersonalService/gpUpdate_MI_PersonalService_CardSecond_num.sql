-- Function: gpUpdate_MI_PersonalService_CardSecond_num()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_CardSecond_num (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_CardSecond_num(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbServiceDateId Integer;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbMemberId_check Integer;

   DECLARE vbBankId_num_1  Integer;
   DECLARE vbBankId_num_2  Integer;
   DECLARE vbBankId_num_3  Integer;
   DECLARE vbSummMax_1     TFloat;
   DECLARE vbSummMax_2     TFloat;
   DECLARE vbSummMax_3     TFloat;

   DECLARE vbBankId_const_1  Integer;
   DECLARE vbBankId_const_2  Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �������� �� ��������';
     END IF;

-- !!!����
IF vbUserId = 5 AND 1=0
THEN
    PERFORM gpUnComplete_Movement_PersonalService (inMovementId:= inMovementId, inSession:= inSession);
END IF;

     -- ������� ��� �������
     PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     IN (zc_MI_Master())
       AND MovementItem.isErased   = FALSE
      --AND 1=0
     ;


     -- ����������
     vbBankId_const_1:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Bank() AND Object.isErased = FALSE AND Object.ValueData ILIKE '%���� ������%' ORDER BY Object.Id DESC LIMIT 1);
     vbBankId_const_2:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Bank() AND Object.isErased = FALSE AND Object.ValueData ILIKE '%��� ����%' ORDER BY Object.Id DESC LIMIT 1);

     -- ����������
     SELECT
             -- ����� ���� ���� ������
             CASE WHEN MovementFloat_BankSecond_num.ValueData = 1
                       THEN 1 -- MovementLinkObject_BankSecond_num.ObjectId

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 1
                       THEN 2 -- MovementLinkObject_BankSecondTwo_num.ObjectId

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 1
                       THEN 3 -- -1 -- MovementLinkObject_BankSecondDiff_num.ObjectId

             END AS BankId_num_1

             -- ����� ���� ���� ������
           , CASE WHEN MovementFloat_BankSecond_num.ValueData = 2
                       THEN 1 -- MovementLinkObject_BankSecond_num.ObjectId

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 2
                       THEN 2 -- MovementLinkObject_BankSecondTwo_num.ObjectId

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 2
                       THEN 3 -- -1 -- MovementLinkObject_BankSecondDiff_num.ObjectId

             END AS BankId_num_2

             -- ����� ���� ���� ������
           , CASE WHEN MovementFloat_BankSecond_num.ValueData = 3
                       THEN 1 -- MovementLinkObject_BankSecond_num.ObjectId

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 3
                       THEN 2 -- MovementLinkObject_BankSecondTwo_num.ObjectId

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 3
                       THEN 3 -- -1 -- MovementLinkObject_BankSecondDiff_num.ObjectId

             END AS BankId_num_3

             -- ����������� - 1
           , CASE WHEN MovementFloat_BankSecond_num.ValueData = 1
                       THEN 0 -- ObjectFloat_BankSecond_SummMax.ValueData

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 1
                       THEN 39999 -- ObjectFloat_BankSecondTwo_SummMax.ValueData

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 1
                       THEN 0 -- ObjectFloat_BankSecondDiff_SummMax.ValueData

             END AS SummMax_1


             -- ����������� - 2
           , CASE WHEN MovementFloat_BankSecond_num.ValueData = 2
                       THEN 0 -- ObjectFloat_BankSecond_SummMax.ValueData

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 2
                       THEN 39999 -- ObjectFloat_BankSecondTwo_SummMax.ValueData

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 2
                       THEN 0 -- ObjectFloat_BankSecondDiff_SummMax.ValueData

             END AS SummMax_2

             -- ����������� - 3
           , CASE WHEN MovementFloat_BankSecond_num.ValueData = 3
                       THEN 0 -- ObjectFloat_BankSecond_SummMax.ValueData

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 3
                       THEN 39999 -- ObjectFloat_BankSecondTwo_SummMax.ValueData

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 3
                       THEN 0 -- ObjectFloat_BankSecondDiff_SummMax.ValueData

             END AS SummMax_3


             INTO vbBankId_num_1, vbBankId_num_2, vbBankId_num_3
                , vbSummMax_1, vbSummMax_2, vbSummMax_3

       FROM MovementLinkMovement AS MLM_BankSecondNum

            LEFT JOIN MovementFloat AS MovementFloat_BankSecond_num
                                    ON MovementFloat_BankSecond_num.MovementId =  MLM_BankSecondNum.MovementChildId
                                   AND MovementFloat_BankSecond_num.DescId = zc_MovementFloat_BankSecond_num()

            LEFT JOIN MovementFloat AS MovementFloat_BankSecondTwo_num
                                    ON MovementFloat_BankSecondTwo_num.MovementId =  MLM_BankSecondNum.MovementChildId
                                   AND MovementFloat_BankSecondTwo_num.DescId = zc_MovementFloat_BankSecondTwo_num()

            LEFT JOIN MovementFloat AS MovementFloat_BankSecondDiff_num
                                    ON MovementFloat_BankSecondDiff_num.MovementId =  MLM_BankSecondNum.MovementChildId
                                   AND MovementFloat_BankSecondDiff_num.DescId = zc_MovementFloat_BankSecondDiff_num()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankSecond_num
                                         ON MovementLinkObject_BankSecond_num.MovementId = MLM_BankSecondNum.MovementChildId
                                        AND MovementLinkObject_BankSecond_num.DescId = zc_MovementLinkObject_BankSecond_num()
            LEFT JOIN ObjectFloat AS ObjectFloat_BankSecond_SummMax
                                  ON ObjectFloat_BankSecond_SummMax.ObjectId = MovementLinkObject_BankSecond_num.ObjectId
                                 AND ObjectFloat_BankSecond_SummMax.DescId   = zc_ObjectFloat_Bank_SummMax()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankSecondTwo_num
                                         ON MovementLinkObject_BankSecondTwo_num.MovementId = MLM_BankSecondNum.MovementChildId
                                        AND MovementLinkObject_BankSecondTwo_num.DescId = zc_MovementLinkObject_BankSecondTwo_num()
            LEFT JOIN ObjectFloat AS ObjectFloat_BankSecondTwo_SummMax
                                  ON ObjectFloat_BankSecondTwo_SummMax.ObjectId = MovementLinkObject_BankSecondTwo_num.ObjectId
                                 AND ObjectFloat_BankSecondTwo_SummMax.DescId   = zc_ObjectFloat_Bank_SummMax()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankSecondDiff_num
                                         ON MovementLinkObject_BankSecondDiff_num.MovementId = MLM_BankSecondNum.MovementChildId
                                        AND MovementLinkObject_BankSecondDiff_num.DescId = zc_MovementLinkObject_BankSecondDiff_num()
            LEFT JOIN ObjectFloat AS ObjectFloat_BankSecondDiff_SummMax
                                  ON ObjectFloat_BankSecondDiff_SummMax.ObjectId = MovementLinkObject_BankSecondDiff_num.ObjectId
                                 AND ObjectFloat_BankSecondDiff_SummMax.DescId   = zc_ObjectFloat_Bank_SummMax()
       WHERE MLM_BankSecondNum.MovementId =  inMovementId
         AND MLM_BankSecondNum.DescId     =  zc_MovementLinkMovement_BankSecondNum()
      ;


      IF COALESCE (vbBankId_num_1, 0) = 0 AND COALESCE (vbBankId_num_2, 0) = 0 AND COALESCE (vbBankId_num_3, 0) = 0
      THEN
          RAISE EXCEPTION '������.���������� �� ������ �� ���������';
      END IF;


     -- ���������� <����� ����������>
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MIDate_ServiceDate()));

     -- ���������� <���������> - ��� � ������� ������ ���� �����������
     vbPersonalServiceListId := (SELECT MLO_PersonalServiceList.ObjectId
                                 FROM MovementLinkObject AS MLO_PersonalServiceList
                                 WHERE MLO_PersonalServiceList.MovementId = inMovementId
                                   AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                );



     -- ��������, � ������� ���������� � zc_ObjectLink_Personal_PersonalServiceListCardSecond ������ ���� isMain
     vbMemberId_check:=
          (WITH -- ���������� ���
                tmpPersonal_all AS (SELECT Object_Personal.Id                                         AS PersonalId
                                         , ObjectLink_Personal_Unit.ChildObjectId                     AS UnitId
                                         , ObjectLink_Personal_Member.ChildObjectId                   AS MemberId
                                         , ObjectLink_Personal_Position.ChildObjectId                 AS PositionId
                                         , zc_Enum_InfoMoney_60101()                                  AS InfoMoneyId  -- 60101 ���������� �����
                                         , ObjectLink_Personal_PersonalServiceList.ChildObjectId      AS PersonalServiceListId
                                         , ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId AS PersonalServiceListId_CardSecond
                                         , ObjectBoolean_isMain.ValueData                             AS isMain

                                    FROM ObjectLink AS ObjectLink_Personal_PersonalServiceList

                                         INNER JOIN Object AS Object_Personal ON Object_Personal.Id       = ObjectLink_Personal_PersonalServiceList.ObjectId
                                                                             AND Object_Personal.isErased = FALSE
                                         INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                               ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                                              AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                         INNER JOIN Object AS Object_Member ON Object_Member.Id       = ObjectLink_Personal_Member.ChildObjectId
                                                                           AND Object_Member.isErased = FALSE
                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_isMain
                                                                 ON ObjectBoolean_isMain.ObjectId = Object_Personal.Id
                                                                AND ObjectBoolean_isMain.DescId   = zc_ObjectBoolean_Personal_Main()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                              ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                             AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                              ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                             AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()

                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                                              ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId = ObjectLink_Personal_PersonalServiceList.ObjectId
                                                             AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId   = zc_ObjectLink_Personal_PersonalServiceListCardSecond()

                                         --  ������ ������, ������� �������� � ����� "� ����. �� (�2)" ������� "UA".

                                         -- 1- � ���������� ����� �� - �2(������)
                                         LEFT JOIN ObjectString AS ObjectString_CardSecond
                                                                ON ObjectString_CardSecond.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                             --AND ObjectString_CardSecond.DescId    = zc_ObjectString_Member_CardSecond()
                                                               AND ObjectString_CardSecond.DescId    = zc_ObjectString_Member_CardIBANSecond()
                                         -- 1- ����� ���������� �������� �� - �2(������)
                                         LEFT JOIN ObjectString AS ObjectString_Member_CardBankSecond
                                                                ON ObjectString_Member_CardBankSecond.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectString_Member_CardBankSecond.DescId    = zc_ObjectString_Member_CardBankSecond()
                                         -- 1- Bank - �2(������)
                                         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecond
                                                              ON ObjectLink_Member_BankSecond.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                             AND ObjectLink_Member_BankSecond.DescId   = zc_ObjectLink_Member_BankSecond()
                                         -- 2 - � ���������� ����� �� - �2(���)
                                         LEFT JOIN ObjectString AS ObjectString_CardSecondTwo
                                                                ON ObjectString_CardSecondTwo.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                            --AND ObjectString_CardSecondTwo.DescId    = zc_ObjectString_Member_CardSecondTwo()
                                                               AND ObjectString_CardSecondTwo.DescId    = zc_ObjectString_Member_CardIBANSecondTwo()
                                         -- 2 - ����� ���������� �������� �� - �2(���)
                                         LEFT JOIN ObjectString AS ObjectString_Member_CardBankSecondTwo
                                                                ON ObjectString_Member_CardBankSecondTwo.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectString_Member_CardBankSecondTwo.DescId    = zc_ObjectString_Member_CardBankSecondTwo()
                                         -- 2- Bank - �2(���)
                                         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondTwo
                                                              ON ObjectLink_Member_BankSecondTwo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                             AND ObjectLink_Member_BankSecondTwo.DescId   = zc_ObjectLink_Member_BankSecondTwo()
                                         -- 3 - � ���������� ����� �� - �2(���)
                                         LEFT JOIN ObjectString AS ObjectString_CardSecondDiff
                                                                ON ObjectString_CardSecondDiff.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                             --AND ObjectString_CardSecondDiff.DescId    = zc_ObjectString_Member_CardSecondDiff()
                                                               AND ObjectString_CardSecondDiff.DescId    = zc_ObjectString_Member_CardIBANSecondDiff()
                                         -- 3 - ����� ���������� �������� �� - �2(���)
                                         LEFT JOIN ObjectString AS ObjectString_Member_CardBankSecondDiff
                                                                ON ObjectString_Member_CardBankSecondDiff.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectString_Member_CardBankSecondDiff.DescId    = zc_ObjectString_Member_CardBankSecondDiff()
                                         -- 3- Bank - �2(���)
                                         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondDiff
                                                              ON ObjectLink_Member_BankSecondDiff.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                             AND ObjectLink_Member_BankSecondDiff.DescId   = zc_ObjectLink_Member_BankSecondDiff()


                                    WHERE ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                      AND ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId > 0
                                      AND (-- 1 - ������
                                           (/*ObjectString_CardSecond.ValueData ILIKE '%UA%' AND*/  zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecond.ValueData, 8)) > 0
                                        --AND ObjectLink_Member_BankSecond.ChildObjectId > 0
                                           )
                                           -- 2 - ���
                                        OR (/*ObjectString_CardSecondTwo.ValueData ILIKE '%UA%' AND*/ zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecondTwo.ValueData, 8)) > 0
                                        --AND ObjectLink_Member_BankSecondTwo.ChildObjectId > 0
                                           )
                                           -- 3 - ���
                                        OR (/*ObjectString_CardSecondDiff.ValueData ILIKE '%UA%' AND*/ zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecondDiff.ValueData, 8)) > 0
                                        --AND ObjectLink_Member_BankSecondDiff.ChildObjectId > 0
                                           )
                                          )
                                   )
           SELECT tmp.MemberId
           FROM (SELECT DISTINCT tmpPersonal_all.MemberId FROM tmpPersonal_all WHERE tmpPersonal_all.PersonalServiceListId_CardSecond = vbPersonalServiceListId) AS tmp
                LEFT JOIN (SELECT DISTINCT tmpPersonal_all.MemberId FROM tmpPersonal_all WHERE tmpPersonal_all.isMain = TRUE
                          ) AS tmp_check ON tmp_check.MemberId = tmp.MemberId
           WHERE tmp_check.MemberId IS NULL
           LIMIT 1
          );
     IF vbMemberId_check > 0
        AND vbUserId <> 5
     THEN
       RAISE EXCEPTION '������.��� ����������� <%> � ��������� <�������� ����� ������ = ��> �� ��������� <��������� ����������(����� �2)>.', lfGet_Object_ValueData (vbMemberId_check);
     END IF;




     -- ����� ������ - MovementItem
     CREATE TEMP TABLE _tmpMI (MovementItemId Integer, MemberId Integer, PersonalId Integer, UnitId Integer, PositionId Integer, InfoMoneyId Integer, PersonalServiceListId Integer, FineSubjectId Integer, UnitId_FineSubject Integer
                             , SummCardSecondRecalc TFloat
                             , BankId_1 Integer, BankId_2 Integer, BankId_3 Integer
                             , Num_1 Integer, Num_2 Integer, Num_3 Integer
                             , Sum_max_1 TFloat, Sum_max_2 TFloat, Sum_max_3 TFloat
                             , SummCard_1 TFloat, SummCard_2 TFloat, SummCard_3 TFloat
                              ) ON COMMIT DROP;
     --
     INSERT INTO _tmpMI (MovementItemId, MemberId, PersonalId, UnitId, PositionId, InfoMoneyId, PersonalServiceListId, FineSubjectId, UnitId_FineSubject, SummCardSecondRecalc
                       , BankId_1, BankId_2, BankId_3
                       , Num_1, Num_2, Num_3
                       , Sum_max_1, Sum_max_2, Sum_max_3
                       , SummCard_1, SummCard_2, SummCard_3
                        )
           WITH -- ���������� ���
                tmpPersonal_all AS (SELECT Object_Personal.Id                                         AS PersonalId
                                         , ObjectLink_Personal_Unit.ChildObjectId                     AS UnitId
                                         , ObjectLink_Personal_Member.ChildObjectId                   AS MemberId
                                         , ObjectLink_Personal_Position.ChildObjectId                 AS PositionId
                                         , zc_Enum_InfoMoney_60101()                                  AS InfoMoneyId  -- 60101 ���������� �����
                                         , ObjectLink_Personal_PersonalServiceList.ChildObjectId      AS PersonalServiceListId
                                         , ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId AS PersonalServiceListId_CardSecond
                                         , ObjectBoolean_isMain.ValueData                             AS isMain
                                           -- 1 - ��������� - ������
                                         , CASE WHEN zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecond.ValueData, 8)) > 0
                                                -- >0 - ����� �����������
                                                THEN COALESCE (ObjectLink_Member_BankSecond.ChildObjectId, 1)
                                           END AS BankId_1
                                           -- 2 - ��������� - ���
                                         , CASE WHEN zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecondTwo.ValueData, 8)) > 0
                                                -- >0 - ����� �����������
                                                THEN COALESCE (ObjectLink_Member_BankSecondTwo.ChildObjectId, 1)
                                           END AS BankId_2
                                           -- 3 - ��������� - ������
                                         , CASE WHEN zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecondDiff.ValueData, 8)) > 0
                                                -- >0 - ����� �����������
                                                THEN COALESCE (ObjectLink_Member_BankSecondDiff.ChildObjectId, 1)
                                           END AS BankId_3


                                    FROM ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                         INNER JOIN Object AS Object_Personal ON Object_Personal.Id       = ObjectLink_Personal_PersonalServiceList.ObjectId
                                                                             AND Object_Personal.isErased = FALSE
                                         INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                               ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                                              AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                         INNER JOIN Object AS Object_Member ON Object_Member.Id       = ObjectLink_Personal_Member.ChildObjectId
                                                                           AND Object_Member.isErased = FALSE
                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_isMain
                                                                 ON ObjectBoolean_isMain.ObjectId = Object_Personal.Id
                                                                AND ObjectBoolean_isMain.DescId   = zc_ObjectBoolean_Personal_Main()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                              ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                             AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                              ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                             AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()

                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                                              ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId = ObjectLink_Personal_PersonalServiceList.ObjectId
                                                             AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId   = zc_ObjectLink_Personal_PersonalServiceListCardSecond()

                                         --  ������ ������, ������� �������� � ����� "� ����. �� (�2)" ������� "UA".
                                         -- 1- � ���������� ����� �� - �2(������)
                                         LEFT JOIN ObjectString AS ObjectString_CardSecond
                                                                ON ObjectString_CardSecond.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                             --AND ObjectString_CardSecond.DescId    = zc_ObjectString_Member_CardSecond()
                                                               AND ObjectString_CardSecond.DescId    = zc_ObjectString_Member_CardIBANSecond()
                                         -- 1- ����� ���������� �������� �� - �2(������)
                                         LEFT JOIN ObjectString AS ObjectString_Member_CardBankSecond
                                                                ON ObjectString_Member_CardBankSecond.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectString_Member_CardBankSecond.DescId    = zc_ObjectString_Member_CardBankSecond()
                                         -- 1- Bank - �2(������)
                                         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecond
                                                              ON ObjectLink_Member_BankSecond.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                             AND ObjectLink_Member_BankSecond.DescId   = zc_ObjectLink_Member_BankSecond()
                                         -- 2 - � ���������� ����� �� - �2(���)
                                         LEFT JOIN ObjectString AS ObjectString_CardSecondTwo
                                                                ON ObjectString_CardSecondTwo.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                             --AND ObjectString_CardSecondTwo.DescId    = zc_ObjectString_Member_CardSecondTwo()
                                                               AND ObjectString_CardSecondTwo.DescId    = zc_ObjectString_Member_CardIBANSecondTwo()
                                         -- 2 - ����� ���������� �������� �� - �2(���)
                                         LEFT JOIN ObjectString AS ObjectString_Member_CardBankSecondTwo
                                                                ON ObjectString_Member_CardBankSecondTwo.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectString_Member_CardBankSecondTwo.DescId    = zc_ObjectString_Member_CardBankSecondTwo()
                                         -- 2- Bank - �2(���)
                                         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondTwo
                                                              ON ObjectLink_Member_BankSecondTwo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                             AND ObjectLink_Member_BankSecondTwo.DescId   = zc_ObjectLink_Member_BankSecondTwo()
                                         -- 3 - � ���������� ����� �� - �2(������)
                                         LEFT JOIN ObjectString AS ObjectString_CardSecondDiff
                                                                ON ObjectString_CardSecondDiff.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                             --AND ObjectString_CardSecondDiff.DescId    = zc_ObjectString_Member_CardSecondDiff()
                                                               AND ObjectString_CardSecondDiff.DescId    = zc_ObjectString_Member_CardIBANSecondDiff()
                                         -- 3 - ����� ���������� �������� �� - �2(������)
                                         LEFT JOIN ObjectString AS ObjectString_Member_CardBankSecondDiff
                                                                ON ObjectString_Member_CardBankSecondDiff.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectString_Member_CardBankSecondDiff.DescId    = zc_ObjectString_Member_CardBankSecondDiff()
                                         -- 3- Bank - �2(������)
                                         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondDiff
                                                              ON ObjectLink_Member_BankSecondDiff.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                             AND ObjectLink_Member_BankSecondDiff.DescId   = zc_ObjectLink_Member_BankSecondDiff()

                                    WHERE ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                      AND ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId > 0
                                      AND (-- 1 - ������
                                           (/*ObjectString_CardSecond.ValueData ILIKE '%UA%' AND*/ zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecond.ValueData, 8)) > 0
                                        --AND ObjectLink_Member_BankSecond.ChildObjectId > 0
                                           )
                                           -- 2 - ���
                                        OR (/*ObjectString_CardSecondTwo.ValueData ILIKE '%UA%' AND*/ zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecondTwo.ValueData, 8)) > 0
                                        --AND ObjectLink_Member_BankSecondTwo.ChildObjectId > 0
                                           )
                                           -- 3 - ������
                                        OR (/*ObjectString_CardSecondDiff.ValueData ILIKE '%UA%' AND*/ zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecondDiff.ValueData, 8)) > 0
                                        --AND ObjectLink_Member_BankSecondDiff.ChildObjectId > 0
                                           )
                                          )
                                   )
                -- ��� ��� ���� - �� ��� ��� �������� Personal ������� �� Container
              , tmpMember AS (SELECT DISTINCT tmpPersonal_all.MemberId, tmpPersonal_all.InfoMoneyId, tmpPersonal_all.PersonalServiceListId
                                              -- 1 - ��������� - ������
                                            , tmpPersonal_all.BankId_1
                                              -- 2 - ��������� - ���
                                            , tmpPersonal_all.BankId_2
                                              -- 3 - ��������� - ������
                                            , tmpPersonal_all.BankId_3
                              FROM tmpPersonal_all
                              WHERE tmpPersonal_all.PersonalServiceListId_CardSecond = vbPersonalServiceListId
                                AND tmpPersonal_all.isMain                = TRUE
                             )
                -- ���������� - ����� �������� Personal - ������ �� Container, �.�. ��� ����� � ������ PersonalServiceListId
              , tmpPersonal_not AS (SELECT tmpPersonal_all.*
                                     FROM tmpPersonal_all
                                          INNER JOIN tmpMember ON tmpMember.MemberId = tmpPersonal_all.MemberId
                                     WHERE tmpPersonal_all.PersonalServiceListId_CardSecond <> vbPersonalServiceListId
                                    )
                -- ���������� �� vbPersonalServiceListId - �� ��� �������� Personal - ������ �� ��� � �����������
              , tmpPersonal_only AS (SELECT tmpPersonal_all.*
                                     FROM tmpPersonal_all
                                          LEFT JOIN tmpMember ON tmpMember.MemberId = tmpPersonal_all.MemberId
                                     WHERE tmpPersonal_all.PersonalServiceListId_CardSecond = vbPersonalServiceListId
                                       AND tmpMember.MemberId                    IS NULL
                                    )
         , tmpContainer_all AS (SELECT CLO_ServiceDate.ContainerId              AS ContainerId
                                     , CLO_Personal.ObjectId                    AS PersonalId
                                     , CLO_Unit.ObjectId                        AS UnitId
                                     , CLO_Position.ObjectId                    AS PositionId
                                     , CLO_InfoMoney.ObjectId                   AS InfoMoneyId           -- 60101 ���������� �����
                                     , CLO_PersonalServiceList.ObjectId         AS PersonalServiceListId
                                     , ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                FROM ContainerLinkObject AS CLO_ServiceDate
                                     INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                    ON CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                     INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                    ON CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_Personal.DescId      = zc_ContainerLinkObject_Personal()
                                     INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                    ON CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                     INNER JOIN ContainerLinkObject AS CLO_Position
                                                                    ON CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_Position.DescId      = zc_ContainerLinkObject_Position()
                                     INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                                    ON CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_PersonalServiceList.DescId      = zc_ContainerLinkObject_PersonalServiceList()
                                     LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = CLO_PersonalServiceList.ObjectId

                                     INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                           ON ObjectLink_Personal_Member.ObjectId      = CLO_Personal.ObjectId
                                                          AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                     LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                                          ON ObjectLink_PersonalServiceList_PaidKind.ObjectId      = CLO_PersonalServiceList.ObjectId
                                                         AND ObjectLink_PersonalServiceList_PaidKind.DescId        = zc_ObjectLink_PersonalServiceList_PaidKind()
                                                         AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm() -- !!!��� �� ��!!!
                                     -- !!!���������!!!
                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_BankNot
                                                             ON ObjectBoolean_BankNot.ObjectId  = CLO_PersonalServiceList.ObjectId
                                                            AND ObjectBoolean_BankNot.DescId    = zc_ObjectBoolean_PersonalServiceList_BankNot()
                                                            AND ObjectBoolean_BankNot.ValueData = TRUE
                                WHERE CLO_ServiceDate.ObjectId    = vbServiceDateId
                                  AND CLO_ServiceDate.DescId      = zc_ContainerLinkObject_ServiceDate()
                                  AND ObjectLink_PersonalServiceList_PaidKind.ObjectId IS NULL
                                  -- !!!���������!!!
                                  AND ObjectBoolean_BankNot.ObjectId IS NULL
                                  -- ���� ��� �� �����
                                  -- AND COALESCE (vbPersonalServiceListId_avance, 0) = 0
                               )
             , tmpPersonal AS (SELECT DISTINCT
                                      tmpContainer_all.PersonalId
                                    , tmpContainer_all.UnitId
                                    , tmpContainer_all.PositionId
                                    , tmpContainer_all.InfoMoneyId           -- 60101 ���������� �����
                                    , tmpContainer_all.PersonalServiceListId
                                    , tmpContainer_all.MemberId
                                      -- 1 - ��������� - ������
                                    , tmpMember.BankId_1
                                      -- 2 - ��������� - ���
                                    , tmpMember.BankId_2
                                      -- 3 - ��������� - ������
                                    , tmpMember.BankId_3
                               FROM tmpMember
                                    INNER JOIN tmpContainer_all ON tmpContainer_all.MemberId    = tmpMember.MemberId
                                                               AND tmpContainer_all.InfoMoneyId = tmpMember.InfoMoneyId
                                    LEFT JOIN tmpPersonal_not ON tmpPersonal_not.PersonalId            = tmpContainer_all.PersonalId
                                                             AND tmpPersonal_not.UnitId                = tmpContainer_all.UnitId
                                                             AND tmpPersonal_not.PositionId            = tmpContainer_all.PositionId
                                                             AND tmpPersonal_not.InfoMoneyId           = tmpContainer_all.InfoMoneyId
                                                             AND tmpPersonal_not.PersonalServiceListId = tmpContainer_all.PersonalServiceListId
                               WHERE tmpPersonal_not.PersonalId IS NULL
                              UNION
                               SELECT tmpPersonal_only.PersonalId
                                    , tmpPersonal_only.UnitId
                                    , tmpPersonal_only.PositionId
                                    , tmpPersonal_only.InfoMoneyId           -- 60101 ���������� �����
                                    , tmpPersonal_only.PersonalServiceListId
                                    , tmpPersonal_only.MemberId
                                      -- 1 - ��������� - ������
                                    , tmpPersonal_only.BankId_1
                                      -- 2 - ��������� - ���
                                    , tmpPersonal_only.BankId_2
                                      -- 3 - ��������� - ������
                                    , tmpPersonal_only.BankId_3
                               FROM tmpPersonal_only
                               -- ���� ��� �� �����
                               -- WHERE COALESCE (vbPersonalServiceListId_avance, 0) = 0
                              )
                -- ������� ��������
              , tmpMI AS (SELECT MovementItem.Id                                        AS MovementItemId
                               , MovementItem.ObjectId                                  AS PersonalId
                               , MILinkObject_Unit.ObjectId                             AS UnitId
                               , MILinkObject_Position.ObjectId                         AS PositionId
                               , MILinkObject_PersonalServiceList.ObjectId              AS PersonalServiceListId
                               , COALESCE (MILinkObject_FineSubject.ObjectId, 0)        AS FineSubjectId
                               , COALESCE (MILinkObject_UnitFineSubject.ObjectId, 0)    AS UnitId_FineSubject
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_Unit.ObjectId, MILinkObject_Position.ObjectId ORDER BY MovementItem.Id ASC) AS Ord
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                                ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_FineSubject
                                                                ON MILinkObject_FineSubject.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_FineSubject.DescId = zc_MILinkObject_FineSubject()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_UnitFineSubject
                                                                ON MILinkObject_UnitFineSubject.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_UnitFineSubject.DescId = zc_MILinkObject_UnitFineSubject()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                            -- ���� ��� �� �����
                            -- AND COALESCE (vbPersonalServiceListId_avance, 0) = 0
                         )
         -- ����� ����������� - ������������ MovementItemId, ������ ������ ����
       , tmpListPersonal AS (SELECT tmpMI.MovementItemId                                  AS MovementItemId
                                  , COALESCE (tmpPersonal.PersonalId,  tmpMI.PersonalId)  AS PersonalId
                                  , COALESCE (tmpPersonal.UnitId,      tmpMI.UnitId)      AS UnitId
                                  , COALESCE (tmpPersonal.PositionId,  tmpMI.PositionId)  AS PositionId
                                    -- ���� ����� ����� - ������ ��� ������ �������
                                  , tmpPersonal.InfoMoneyId                               AS InfoMoneyId
                                    -- ���� ����� ����� - ������ ��� ������ �������
                                  , tmpPersonal.PersonalServiceListId                     AS PersonalServiceListId
                                  , tmpPersonal.MemberId                                  AS MemberId
                                  , COALESCE (tmpMI.FineSubjectId, 0)                     AS FineSubjectId
                                  , COALESCE (tmpMI.UnitId_FineSubject, 0)                AS UnitId_FineSubject
                                    -- 1 - ��������� - ������
                                  , tmpPersonal.BankId_1
                                    -- 2 - ��������� - ���
                                  , tmpPersonal.BankId_2
                                    -- 3 - ��������� - ������
                                  , tmpPersonal.BankId_3
                             FROM tmpMI
                                  FULL JOIN tmpPersonal ON tmpPersonal.PersonalId            = tmpMI.PersonalId
                                                       AND tmpPersonal.PositionId            = tmpMI.PositionId
                                                       AND tmpPersonal.UnitId                = tmpMI.UnitId
                                                       AND tmpPersonal.PersonalServiceListId = tmpMI.PersonalServiceListId
                                                       AND tmpMI.Ord              = 1

                            )
         -- ������ Container - ��� ������ � ��������� - ������� ��� ���������
       , tmpContainer AS (SELECT tmpContainer_all.ContainerId
                               , tmpMI.PersonalId
                               , tmpMI.UnitId
                               , tmpMI.PositionId
                               , tmpMI.InfoMoneyId
                               , tmpMI.PersonalServiceListId
                               , tmpMI.FineSubjectId
                               , tmpMI.UnitId_FineSubject
                          FROM tmpListPersonal AS tmpMI
                               INNER JOIN tmpContainer_all ON tmpContainer_all.PersonalId            = tmpMI.PersonalId
                                                          AND tmpContainer_all.UnitId                = tmpMI.UnitId
                                                          AND tmpContainer_all.PositionId            = tmpMI.PositionId
                                                          AND tmpContainer_all.InfoMoneyId           = tmpMI.InfoMoneyId
                                                          AND tmpContainer_all.PersonalServiceListId = tmpMI.PersonalServiceListId
                         )
   -- ������ �������� - ������� ��� ��������� (�������)
 , tmpMIContainer_all AS (SELECT MIContainer.*
                               , tmpContainer.PersonalId
                               , tmpContainer.UnitId
                               , tmpContainer.PositionId
                               , tmpContainer.InfoMoneyId
                               , tmpContainer.PersonalServiceListId
                               , tmpContainer.FineSubjectId
                               , tmpContainer.UnitId_FineSubject
                          FROM tmpContainer
                               INNER JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                               AND MIContainer.DescId      = zc_MIContainer_Summ()
                         )
       -- ������
     , tmpSummCard AS (SELECT SUM (COALESCE (MIFloat_SummCard.ValueData, 0) + COALESCE (MIFloat_SummAvCardSecond.ValueData, 0))  AS Amount
                               , tmp.PersonalId
                               , tmp.UnitId
                               , tmp.PositionId
                               , tmp.InfoMoneyId
                               , tmp.PersonalServiceListId
                               , tmp.FineSubjectId
                               , tmp.UnitId_FineSubject
                          FROM (SELECT DISTINCT
                                       tmpMIContainer_all.MovementItemId
                                     , tmpMIContainer_all.PersonalId
                                     , tmpMIContainer_all.UnitId
                                     , tmpMIContainer_all.PositionId
                                     , tmpMIContainer_all.InfoMoneyId
                                     , tmpMIContainer_all.PersonalServiceListId
                                     , tmpMIContainer_all.FineSubjectId
                                     , tmpMIContainer_all.UnitId_FineSubject
                                FROM tmpMIContainer_all
                                WHERE tmpMIContainer_all.MovementDescId = zc_Movement_PersonalService()
                               ) AS tmp
                               LEFT JOIN MovementItemFloat AS MIFloat_SummCard
                                                           ON MIFloat_SummCard.MovementItemId = tmp.MovementItemId
                                                          AND MIFloat_SummCard.DescId         = zc_MIFloat_SummCard()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecond
                                                           ON MIFloat_SummAvCardSecond.MovementItemId = tmp.MovementItemId
                                                          AND MIFloat_SummAvCardSecond.DescId         = zc_MIFloat_SummAvCardSecond()
                          WHERE MIFloat_SummCard.ValueData         <> 0
                             OR MIFloat_SummAvCardSecond.ValueData <> 0
                          GROUP BY tmp.PersonalId
                                 , tmp.UnitId
                                 , tmp.PositionId
                                 , tmp.InfoMoneyId
                                 , tmp.PersonalServiceListId
                                 , tmp.FineSubjectId
                                 , tmp.UnitId_FineSubject
                         )
       -- ������ �������� - ������� ��� ��������� (�������)
     , tmpMIContainer AS (SELECT SUM (COALESCE (CASE WHEN tmpMIContainer_all.MovementDescId = zc_Movement_BankAccount()
                                                       OR tmpMIContainer_all.AnalyzerId     = zc_Enum_AnalyzerId_Cash_PersonalCardSecond()
                                                     THEN 0
                                                     ELSE tmpMIContainer_all.Amount
                                                END, 0))  AS Amount
                               , tmpMIContainer_all.PersonalId
                               , tmpMIContainer_all.UnitId
                               , tmpMIContainer_all.PositionId
                               , tmpMIContainer_all.InfoMoneyId
                               , tmpMIContainer_all.PersonalServiceListId
                               , tmpMIContainer_all.FineSubjectId
                               , tmpMIContainer_all.UnitId_FineSubject
                          FROM tmpMIContainer_all
                          GROUP BY tmpMIContainer_all.PersonalId
                                 , tmpMIContainer_all.UnitId
                                 , tmpMIContainer_all.PositionId
                                 , tmpMIContainer_all.InfoMoneyId
                                 , tmpMIContainer_all.PersonalServiceListId
                                 , tmpMIContainer_all.FineSubjectId
                                 , tmpMIContainer_all.UnitId_FineSubject
                         )
            -- ���������
            SELECT tmpData.MovementItemId
                 , tmpData.MemberId
                 , tmpData.PersonalId
                 , tmpData.UnitId
                 , tmpData.PositionId
                 , tmpData.InfoMoneyId
                 , tmpData.PersonalServiceListId
                 , tmpData.FineSubjectId
                 , tmpData.UnitId_FineSubject
                 , tmpData.SummCardSecondRecalc

                   -- ���� �� ������ ����� + ������� �����
                 , CASE WHEN tmpData.BankId_1 > 1 THEN tmpData.BankId_1 ELSE NULL END AS BankId_1
                   -- ���� �� ������ ����� + ������� �����
                 , CASE WHEN tmpData.BankId_2 > 1 THEN tmpData.BankId_2 ELSE NULL END AS BankId_1
                   -- ���� �� ������� ����� + ������� �����
                 , CASE WHEN tmpData.BankId_3 > 1 THEN tmpData.BankId_3 ELSE NULL END AS BankId_1

                   -- ��� �� 1,2,3 �� ������ �����
                 , tmpData.Num_1
                   -- ��� �� 1,2,3 �� ������ �����
                 , tmpData.Num_2
                   -- ��� �� 1,2,3 �� ������� �����
                 , tmpData.Num_3

                 , tmpData.SummMax_1
                 , tmpData.SummMax_2
                 , tmpData.SummMax_3

                   -- ����� ��� ������� �����
                 , tmpData.SummCard_1
                   -- ����� ��� ������� �����
                 , tmpData.SummCard_2
                   -- ����� ��� �������� �����
                 , CASE WHEN tmpData.BankId_3 > 0 AND tmpData.SummMax_3 > 0
                        THEN CASE WHEN ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1 - tmpData.SummCard_2 > tmpData.SummMax_3 THEN tmpData.SummMax_3 ELSE ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1 - tmpData.SummCard_2 END
                        WHEN tmpData.BankId_3 > 0
                        THEN ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1 - tmpData.SummCard_2
                        ELSE 0
                   END AS SummCard_3


            FROM
           (SELECT tmpData.*

                   -- ����� ��� ������� �����
                 , CASE WHEN tmpData.BankId_2 > 0 AND tmpData.SummMax_2 > 0
                        THEN CASE WHEN ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1 > tmpData.SummMax_2 THEN tmpData.SummMax_2 ELSE ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1 END
                        WHEN tmpData.BankId_2 > 0
                        THEN ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1
                        ELSE 0
                   END AS SummCard_2


            FROM
           (SELECT tmpData.*

                   -- ����� ��� ������� �����
                 , CASE WHEN tmpData.BankId_1 > 0 AND tmpData.SummMax_1 > 0
                        THEN CASE WHEN ROUND (tmpData.SummCardSecondRecalc, 1) > tmpData.SummMax_1 THEN tmpData.SummMax_1 ELSE ROUND (tmpData.SummCardSecondRecalc, 1) END
                        WHEN tmpData.BankId_1 > 0
                        THEN ROUND (tmpData.SummCardSecondRecalc, 1)
                        ELSE 0
                   END AS SummCard_1


            FROM
           (SELECT tmpListPersonal.MovementItemId
                 , tmpListPersonal.MemberId
                 , tmpListPersonal.PersonalId
                 , tmpListPersonal.UnitId
                 , tmpListPersonal.PositionId
                 , tmpListPersonal.InfoMoneyId
                 , tmpListPersonal.PersonalServiceListId
                 , tmpListPersonal.FineSubjectId
                 , tmpListPersonal.UnitId_FineSubject
                 , CASE WHEN -1 * COALESCE (tmpMIContainer.Amount, 0) - COALESCE (tmpSummCard.Amount, 0) > 0
                                  -- �.�. � ��������� ���� � �������
                             THEN -1 * COALESCE (tmpMIContainer.Amount, 0) - COALESCE (tmpSummCard.Amount, 0)
                        ELSE 0
                   END AS SummCardSecondRecalc

                   -- ���������� �� ������ �����
                 , CASE WHEN vbBankId_num_1 = 1 THEN tmpListPersonal.BankId_1
                        WHEN vbBankId_num_2 = 1 THEN tmpListPersonal.BankId_2
                        WHEN vbBankId_num_3 = 1 THEN tmpListPersonal.BankId_3
                   END AS BankId_1

                   -- ���������� �� ������ �����
                 , CASE WHEN vbBankId_num_1 = 2 THEN tmpListPersonal.BankId_1
                        WHEN vbBankId_num_2 = 2 THEN tmpListPersonal.BankId_2
                        WHEN vbBankId_num_3 = 2 THEN tmpListPersonal.BankId_3
                   END AS BankId_2

                   -- ���������� �� ������ �����
                 , CASE WHEN vbBankId_num_1 = 3 THEN tmpListPersonal.BankId_1
                        WHEN vbBankId_num_2 = 3 THEN tmpListPersonal.BankId_2
                        WHEN vbBankId_num_3 = 3 THEN tmpListPersonal.BankId_3
                   END AS BankId_3

                   -- ��� �� 1,2,3 �� ������ �����
                 , vbBankId_num_1 AS Num_1
                   -- ��� �� 1,2,3 �� ������ �����
                 , vbBankId_num_2 AS Num_2
                   -- ��� �� 1,2,3 �� ������� �����
                 , vbBankId_num_3 AS Num_3

                   -- ����������� - ��� 1
                 , vbSummMax_1 AS SummMax_1
                   -- ����������� - ��� 2
                 , vbSummMax_2 AS SummMax_2
                   -- ����������� - ��� 3
                 , vbSummMax_3 AS SummMax_3

            FROM tmpListPersonal
                 LEFT JOIN tmpMIContainer ON tmpMIContainer.PersonalId            = tmpListPersonal.PersonalId
                                         AND tmpMIContainer.UnitId                = tmpListPersonal.UnitId
                                         AND tmpMIContainer.PositionId            = tmpListPersonal.PositionId
                                         AND tmpMIContainer.InfoMoneyId           = tmpListPersonal.InfoMoneyId
                                         AND tmpMIContainer.PersonalServiceListId = tmpListPersonal.PersonalServiceListId
                 LEFT JOIN tmpSummCard ON tmpSummCard.PersonalId            = tmpListPersonal.PersonalId
                                      AND tmpSummCard.UnitId                = tmpListPersonal.UnitId
                                      AND tmpSummCard.PositionId            = tmpListPersonal.PositionId
                                      AND tmpSummCard.InfoMoneyId           = tmpListPersonal.InfoMoneyId
                                      AND tmpSummCard.PersonalServiceListId = tmpListPersonal.PersonalServiceListId
                                      AND tmpSummCard.FineSubjectId         = tmpListPersonal.FineSubjectId
                                      AND tmpSummCard.UnitId_FineSubject     = tmpListPersonal.UnitId_FineSubject
            WHERE tmpListPersonal.MovementItemId > 0
               OR -1 * COALESCE (tmpMIContainer.Amount, 0) - COALESCE (tmpSummCard.Amount, 0) > 0 -- !!! �.�. ���� ���� ���� �� ��
           ) AS tmpData
           ) AS tmpData
           ) AS tmpData
          ;

--  RAISE EXCEPTION '<%>', (select count(*) from _tmpMI where _tmpMI.PersonalId = 7412781);


     IF vbUserId = 5 AND 1=0
     THEN
         RAISE EXCEPTION '������.Admin <%>  <%>  <%>  <%>.'
                       , (SELECT SUM (_tmpMI.SummCardSecondRecalc) FROM _tmpMI)
                       , (SELECT SUM (_tmpMI.SummCard_1) FROM _tmpMI)
                       , (SELECT SUM (_tmpMI.SummCard_2) FROM _tmpMI)
                       , (SELECT SUM (_tmpMI.SummCard_3) FROM _tmpMI)
                        ;
     END IF;

     -- ��������� ��������
     PERFORM -- ����� ������ ������
             lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankSecond_num(), _tmpMI.MovementItemId
                                                  , CASE WHEN 0 = CASE WHEN _tmpMI.Num_1 = 1 THEN COALESCE (_tmpMI.SummCard_1, 0)
                                                                       WHEN _tmpMI.Num_2 = 1 THEN COALESCE (_tmpMI.SummCard_2, 0)
                                                                       WHEN _tmpMI.Num_3 = 1 THEN COALESCE (_tmpMI.SummCard_3, 0)
                                                                  END
                                                              THEN NULL
                                                         WHEN _tmpMI.Num_1 = 1 THEN COALESCE (_tmpMI.BankId_1, vbBankId_const_1)
                                                         WHEN _tmpMI.Num_2 = 1 THEN COALESCE (_tmpMI.BankId_2, vbBankId_const_2)
                                                         WHEN _tmpMI.Num_3 = 1 THEN _tmpMI.BankId_3
                                                    END
                                                   )
             -- ����� ������ ���
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankSecondTwo_num(), _tmpMI.MovementItemId
                                                  , CASE WHEN 0 = CASE WHEN _tmpMI.Num_1 = 2 THEN COALESCE (_tmpMI.SummCard_1, 0)
                                                                       WHEN _tmpMI.Num_2 = 2 THEN COALESCE (_tmpMI.SummCard_2, 0)
                                                                       WHEN _tmpMI.Num_3 = 2 THEN COALESCE (_tmpMI.SummCard_3, 0)
                                                                  END
                                                              THEN NULL
                                                         WHEN _tmpMI.Num_1 = 2 THEN COALESCE (_tmpMI.BankId_1, vbBankId_const_1)
                                                         WHEN _tmpMI.Num_2 = 2 THEN COALESCE (_tmpMI.BankId_2, vbBankId_const_2)
                                                         WHEN _tmpMI.Num_3 = 2 THEN _tmpMI.BankId_3
                                                    END
                                                   )
             -- ����� ������ ������
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankSecondDiff_num(), _tmpMI.MovementItemId
                                                  , CASE WHEN 0 = CASE WHEN _tmpMI.Num_1 = 3 THEN COALESCE (_tmpMI.SummCard_1, 0)
                                                                       WHEN _tmpMI.Num_2 = 3 THEN COALESCE (_tmpMI.SummCard_2, 0)
                                                                       WHEN _tmpMI.Num_3 = 3 THEN COALESCE (_tmpMI.SummCard_3, 0)
                                                                  END
                                                              THEN NULL
                                                         WHEN _tmpMI.Num_1 = 3 THEN COALESCE (_tmpMI.BankId_1, vbBankId_const_1)
                                                         WHEN _tmpMI.Num_2 = 3 THEN COALESCE (_tmpMI.BankId_2, vbBankId_const_2)
                                                         WHEN _tmpMI.Num_3 = 3 THEN _tmpMI.BankId_3
                                                    END
                                                   )
             -- ����� ������ ������
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ_BankSecond_num(), _tmpMI.MovementItemId
                                             , CASE WHEN _tmpMI.Num_1 = 1 THEN _tmpMI.SummCard_1
                                                    WHEN _tmpMI.Num_2 = 1 THEN _tmpMI.SummCard_2
                                                    WHEN _tmpMI.Num_3 = 1 THEN _tmpMI.SummCard_3
                                                    ELSE 0
                                               END
                                              )
             -- ����� ������ ���
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ_BankSecondTwo_num(), _tmpMI.MovementItemId
                                             , CASE WHEN _tmpMI.Num_1 = 2 THEN _tmpMI.SummCard_1
                                                    WHEN _tmpMI.Num_2 = 2 THEN _tmpMI.SummCard_2
                                                    WHEN _tmpMI.Num_3 = 2 THEN _tmpMI.SummCard_3
                                                    ELSE 0
                                               END
                                              )
             -- ����� ������ ������
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ_BankSecondDiff_num(), _tmpMI.MovementItemId
                                             , CASE WHEN _tmpMI.Num_1 = 3 THEN _tmpMI.SummCard_1
                                                    WHEN _tmpMI.Num_2 = 3 THEN _tmpMI.SummCard_2
                                                    WHEN _tmpMI.Num_3 = 3 THEN _tmpMI.SummCard_3
                                                    ELSE 0
                                               END
                                              )
     FROM
    (SELECT lpInsertUpdate_MovementItem_PersonalService_item (ioId                 := _tmpMI.MovementItemId
                                                            , inMovementId         := inMovementId
                                                            , inPersonalId         := _tmpMI.PersonalId
                                                            , inIsMain             := COALESCE (ObjectBoolean_Main.ValueData, FALSE)
                                                            , inSummService        := 0
                                                            , inSummCardRecalc     := 0
                                                            , inSummCardSecondRecalc:= _tmpMI.SummCardSecondRecalc -- CASE WHEN vbPersonalServiceListId_avance > 0 THEN 0 ELSE _tmpMI.SummCardSecondRecalc END
                                                            , inSummCardSecondCash := 0
                                                            , inSummAvCardSecondRecalc:= 0 -- CASE WHEN vbPersonalServiceListId_avance > 0 THEN _tmpMI.SummCardSecondRecalc ELSE 0 END
                                                            , inSummNalogRecalc    := 0
                                                            , inSummNalogRetRecalc := 0
                                                            , inSummMinus          := 0
                                                            , inSummAdd            := 0
                                                            , inSummAddOthRecalc   := 0
                                                            , inSummHoliday        := 0
                                                            , inSummSocialIn       := 0
                                                            , inSummSocialAdd      := 0
                                                            , inSummChildRecalc    := 0
                                                            , inSummMinusExtRecalc := 0
                                                            , inSummFine           := 0
                                                            , inSummFineOthRecalc  := 0
                                                            , inSummHosp           := 0
                                                            , inSummHospOthRecalc  := 0
                                                            , inSummCompensationRecalc := 0
                                                            , inSummAuditAdd           := 0
                                                            , inSummHouseAdd           := 0
                                                            , inSummAvanceRecalc   := 0
                                                            , inNumber             := ''
                                                            , inComment            := ''
                                                            , inInfoMoneyId        := _tmpMI.InfoMoneyId
                                                            , inUnitId             := _tmpMI.UnitId
                                                            , inPositionId         := _tmpMI.PositionId
                                                            , inMemberId           := NULL
                                                            , inPersonalServiceListId := _tmpMI.PersonalServiceListId
                                                            , inFineSubjectId      := _tmpMI.FineSubjectId
                                                            , inUnitFineSubjectId  := _tmpMI.UnitId_FineSubject
                                                            , inUserId             := vbUserId
                                                             ) AS MovementItemId
            -- ���� �� ������ �����
          , _tmpMI.BankId_1
            -- ���� �� ������ �����
          , _tmpMI.BankId_2
            -- ���� �� ������� �����
          , _tmpMI.BankId_3

            -- ��� �� 1,2,3 �� ������ �����
          , _tmpMI.Num_1
            -- ��� �� 1,2,3 �� ������ �����
          , _tmpMI.Num_2
            -- ��� �� 1,2,3 �� ������� �����
          , _tmpMI.Num_3

            -- ����� ��� ������� �����
          , _tmpMI.SummCard_1
            -- ����� ��� ������� �����
          , _tmpMI.SummCard_2
            -- ����� ��� �������� �����
          , _tmpMI.SummCard_3

     FROM _tmpMI
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = _tmpMI.PersonalId
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()
    ) AS _tmpMI
     ;
     

     -- ��������
     IF EXISTS (SELECT 1
                FROM MovementItem
                     JOIN MovementItemLinkObject AS MILO_PersonalServiceList
                                                 ON MILO_PersonalServiceList.MovementItemId = MovementItem.Id
                                                AND MILO_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()
                     INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                           ON ObjectLink_PersonalServiceList_PaidKind.ObjectId      = MILO_PersonalServiceList.ObjectId
                                          AND ObjectLink_PersonalServiceList_PaidKind.DescId        = zc_ObjectLink_PersonalServiceList_PaidKind()
                                          AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm() -- !!!��� �� ��!!!
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                --AND MovementItem.Amount     > 0
               )
     THEN
         RAISE EXCEPTION '������. � ������������� �� ������� ��������� <%>.'
                       , lfGet_Object_ValueData_sh ((SELECT MILO_PersonalServiceList.ObjectId
                                                     FROM MovementItem
                                                          JOIN MovementItemLinkObject AS MILO_PersonalServiceList
                                                                                      ON MILO_PersonalServiceList.MovementItemId = MovementItem.Id
                                                                                     AND MILO_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()
                                                          INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                                                                ON ObjectLink_PersonalServiceList_PaidKind.ObjectId      = MILO_PersonalServiceList.ObjectId
                                                                               AND ObjectLink_PersonalServiceList_PaidKind.DescId        = zc_ObjectLink_PersonalServiceList_PaidKind()
                                                                               AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm() -- !!!��� �� ��!!!
                                                     WHERE MovementItem.MovementId = inMovementId
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                                     --AND MovementItem.Amount     > 0
                                                     LIMIT 1
                                                    ));
     END IF;

     --��� ��������� ���� �������� ����� ������ ������ ���� ����� 4000 = �� �������  = ���
     -- ��������� �������� <��������>
     -- PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_4000(), inMovementId, FALSE);
     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

/*
RAISE EXCEPTION '<%  >  %', (select count(*)
from _tmpMI where _tmpMI.MemberId = 239655)
, ( select count(*)  FROM MovementItem
                                         INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                               ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                              AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                                              AND ObjectLink_Personal_Member.ChildObjectId   = 239655
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
);
*/

-- !!!����
-- PERFORM gpComplete_Movement_PersonalService (inMovementId:= inMovementId, inSession:= inSession);
-- RAISE EXCEPTION '��' ;
IF /*vbUserId = 5 and*/ 1=0
THEN
    RAISE EXCEPTION '������.test=ok   %'
  , (            SELECT sum (coalesce (MIF_SummCardSecondRecalc.ValueData, 0))

            FROM MovementItem
                 LEFT JOIN MovementItemFloat AS MIF_SummCardSecondRecalc
                                             ON MIF_SummCardSecondRecalc.MovementItemId = MovementItem.Id
                                            AND MIF_SummCardSecondRecalc.DescId         = zc_MIFloat_SummCardSecondRecalc()
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.isErased   = FALSE
              AND MovementItem.DescId     = zc_MI_Master()
)
;
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.06.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond_num (inMovementId:= 12977959, inSession:= zfCalc_UserAdmin())
