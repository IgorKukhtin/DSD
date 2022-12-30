-- Function: gpInsertUpdate_MI_PersonalService_SummService_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_SummService_Load (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_SummService_Load(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPersonalCode        Integer   , --Integer
    IN inFIO                 TVarChar  , -- ���
    IN inFineSubjectName     TVarChar  , -- ��� ���������
    IN inUnitFineSubjectName TVarChar  , -- ��� ���������� ���������
    IN inComment             TVarChar  , -- ����������
    IN inSummService         TFloat    , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbFineSubjectId Integer;
   DECLARE vbUnitFineSubjectId Integer; 
   DECLARE vbCodePersonal Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId := lpGetUserBySession (inSession);

     --RAISE EXCEPTION '��������� <%> �� ������ � ��� = <%> � ������ <%> .', inFIO, inINN, inSummMinusExtRecalc;

     IF COALESCE (inMovementId,0) = 0
     THEN
         RAISE EXCEPTION '������. �������� �� ��������';
     END IF;

     -- ��������
     IF COALESCE (inPersonalCode, 0) = 0 AND inFIO = '' AND COALESCE (inSummService, 0) = 0
     THEN
         RETURN;
     END IF;
     -- ��������
     IF COALESCE (inPersonalCode, 0) = 0 AND inFIO = '-' AND COALESCE (inSummService, 0) = 0
     THEN
         RETURN;
     END IF;

     -- ��������
     IF COALESCE (inPersonalCode, 0) = 0
     THEN
         RAISE EXCEPTION '������.� <%> �� ����������� ���� <���> � ����� Excel ��� ����� <%> <%>.', inFIO, inSummService, inFineSubjectName;
     END IF;


     -- ����� ���������� �� ����
     vbPersonalId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Personal() AND Object.ObjectCode = inPersonalCode);
     
     /*vbPersonalId:= (WITH tmpPersonal AS (SELECT ObjectLink_Personal_Member.ObjectId AS PersonalId
                                               , ROW_NUMBER() OVER (PARTITION BY ObjectString_INN.ValueData
                                                                    -- ����������� ������������ ��������� ��� ������, �.�. �������� � Ord = 1
                                                                    ORDER BY CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                                           , CASE WHEN ObjectLink_Personal_PersonalServiceList.ChildObjectId > 0 THEN 0 ELSE 1 END
                                                                           , CASE WHEN ObjectBoolean_Official.ValueData = TRUE THEN 0 ELSE 1 END
                                                                           , CASE WHEN ObjectBoolean_Main.ValueData = TRUE THEN 0 ELSE 1 END
                                                                           , ObjectLink_Personal_Member.ObjectId
                                                                   ) AS Ord
                                          FROM ObjectString AS ObjectString_INN
                                               INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                                     ON ObjectLink_Personal_Member.ChildObjectId = ObjectString_INN.ObjectId
                                                                    AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                               INNER JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ObjectId
                                                                                   AND Object_Personal.isErased = FALSE
                                               LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                                    ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                                                                   AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()          
                                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                                    ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                                   AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                                                       ON ObjectBoolean_Official.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                                      AND ObjectBoolean_Official.DescId   = zc_ObjectBoolean_Member_Official()
                                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                       ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                                      AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()
                                          WHERE TRIM (ObjectString_INN.ValueData) = inINN
                                            AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
                                         )
                     -- ��������
                     SELECT tmpPersonal.PersonalId FROM tmpPersonal WHERE tmpPersonal.Ord = 1
                    );
     */
     
     
     -- ��������
     IF COALESCE (vbPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��������� <%> �� ������ � ��� = <%> � ������ <%> .', inFIO, inPersonalCode, inSummService;
     END IF;

     --������� ��� ����������
     vbFineSubjectId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_FineSubject() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inFineSubjectName)) );
     IF COALESCE (vbFineSubjectId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��� ��������� <%> �� ������ ��� ���������� <%> � ��� <%> � ������ <%> .', inFineSubjectName, inFIO, inPersonalCode, inSummService;
     END IF;

     --������� 
     vbUnitFineSubjectId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inUnitFineSubjectName)) );
     IF COALESCE (vbUnitFineSubjectId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������������- ��� ���������� ��������� <%> �� ������� ��� ���������� <%> � ��� <%> � ������ <%> .', inUnitFineSubjectName, inFIO, inPersonalCode, inSummService;
     END IF;


     -- ���������
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                 := COALESCE (gpSelect.Id,0)
                                                        , inMovementId         := inMovementId
                                                        , inPersonalId         := tmpPersonal.PersonalId
                                                        , inIsMain             := COALESCE (gpSelect.IsMain, tmpPersonal.IsMain)
                                                        , inSummService        := inSummService
                                                        , inSummCardRecalc     := COALESCE (gpSelect.SummCardRecalc, 0)
                                                        , inSummCardSecondRecalc:= 0
                                                        , inSummCardSecondCash := COALESCE (gpSelect.SummCardSecondCash,0)
                                                        , inSummNalogRecalc    := COALESCE (gpSelect.SummNalogRecalc, 0)
                                                        , inSummNalogRetRecalc := 0
                                                        , inSummMinus          := COALESCE (gpSelect.SummMinus, 0)
                                                        , inSummAdd            := COALESCE (gpSelect.SummAdd, 0)
                                                        , inSummAddOthRecalc   := COALESCE (gpSelect.SummAddOthRecalc, 0)
                                                        , inSummHoliday        := COALESCE (gpSelect.SummHoliday, 0)
                                                        , inSummSocialIn       := COALESCE (gpSelect.SummSocialIn, 0)
                                                        , inSummSocialAdd      := COALESCE (gpSelect.SummSocialAdd, 0)
                                                        , inSummChildRecalc    := COALESCE (gpSelect.SummChildRecalc, 0)
                                                        , inSummMinusExtRecalc := COALESCE (gpSelect.SummMinusExtRecalc, 0)
                                                        , inSummFine           := COALESCE (gpSelect.SummFine, 0)
                                                        , inSummFineOthRecalc  := COALESCE (gpSelect.SummFineOthRecalc, 0)
                                                        , inSummHosp           := COALESCE (gpSelect.SummHosp, 0)
                                                        , inSummHospOthRecalc  := COALESCE (gpSelect.SummHospOthRecalc, 0)
                                                        , inSummCompensationRecalc := COALESCE (gpSelect.SummCompensationRecalc, 0)
                                                        , inSummAuditAdd       := COALESCE (gpSelect.SummAuditAdd,0)
                                                        , inSummHouseAdd       := COALESCE (gpSelect.SummHouseAdd,0)
                                                        , inNumber             := COALESCE (gpSelect.Number, '')
                                                        , inComment            := inComment ::TVarChar
                                                        , inInfoMoneyId        := COALESCE (gpSelect.InfoMoneyId, zc_Enum_InfoMoney_60101()) -- 60101 ���������� ����� + ���������� �����
                                                        , inUnitId             := tmpPersonal.UnitId
                                                        , inPositionId         := tmpPersonal.PositionId
                                                        , inMemberId               := gpSelect.MemberId                                     -- ��� ���� (���� ��������� ��������)
                                                        , inPersonalServiceListId  := gpSelect.PersonalServiceListId 
                                                        , inFineSubjectId          := vbFineSubjectId     ::Integer
                                                        , inUnitFineSubjectId      := vbUnitFineSubjectId ::Integer
                                                        , inUserId             := vbUserId
                                                         )
      FROM (SELECT View_Personal.PersonalId
                 , View_Personal.UnitId
                 , View_Personal.PositionId
                 , View_Personal.IsMain
            FROM Object_Personal_View AS View_Personal
            WHERE View_Personal.PersonalId = vbPersonalId
           ) AS tmpPersonal
           LEFT JOIN gpSelect_MovementItem_PersonalService (inMovementId, FALSE, FALSE, inSession) AS gpSelect ON gpSelect.PersonalId = tmpPersonal.PersonalId
      LIMIT 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.12.22         *
*/

-- ����
--