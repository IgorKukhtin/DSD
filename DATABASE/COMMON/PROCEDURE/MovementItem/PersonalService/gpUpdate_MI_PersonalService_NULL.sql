-- Function: gpUpdate_MI_PersonalService_NULL()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_NULL (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_NULL(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �������� �� ��������';
     END IF;

     -- �������� - ������������� !!!���� ��� ��!!!
     IF NOT EXISTS (SELECT ObjectLink_PersonalServiceList_PaidKind.ChildObjectId
                FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
                     INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                           ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                          AND ObjectLink_PersonalServiceList_PaidKind.DescId = zc_ObjectLink_PersonalServiceList_PaidKind()
                                          AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()
                WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
                  AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
               )
     THEN
         RAISE EXCEPTION '������.���� <�������� �� (����)> � <������ - ��������� � �� (����)> ����������� ������ ��� ��������� ��.';
     END IF;


     -- �������� ��������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardRecalc(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecondRecalc(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAvCardSecondRecalc(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalogRecalc(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalogRetRecalc(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChildRecalc(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMinusExtRecalc(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAddOthRecalc(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummFineOthRecalc(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummHospOthRecalc(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCompensationRecalc(), MovementItem.Id, 0)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master();


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.01.18         *
 24.02.17         *
 20.02.17         * zc_MIFloat_SummCardSecondRecalc
 28.01.17                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_PersonalService_NULL(inMovementId :=0 , inINN := '2565555555', inSum1 := 15 ::TFloat, inSum2 := 45 ::TFloat , inSession :='3':: TVarChar)
