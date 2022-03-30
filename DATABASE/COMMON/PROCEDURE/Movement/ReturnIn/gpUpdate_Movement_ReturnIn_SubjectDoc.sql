-- Function: gpUpdate_Movement_ReturnIn_SubjectDoc()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnIn_SubjectDoc (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnIn_SubjectDoc(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSubjectDocId      Integer               , --
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ReturnIn_SubjectDoc());

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SubjectDoc(), inMovementId, inSubjectDocId);

     -- ����������� ��������
     /*PERFORM gpReComplete_Movement_ReturnIn (inMovementId     := inMovementId
                                           , inStartDateSale  := NULL
                                           , inIsLastComplete := NULL
                                           , inUserId         := zc_Enum_Process_Auto_ReComplete());
     */

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.03.22         *
*/

-- ����
-- SELECT gpUpdate_Movement_ReturnIn_SubjectDoc (inMovementId:= Movement.Id, inSubjectDocId:=0, inUserId:= zfCalc_UserAdmin())

/*
WITH
tmpWeighingPartner AS (SELECT MovementLinkObject_To.ObjectId AS ToId
                              , MovementLinkObject_From.ObjectId AS FromId
                              , MovementLinkObject_SubjectDoc.ObjectId AS SubjectDocId
                              , Movement.OperDate
                              , Movement.ParentId
                         FROM Movement
                              JOIN MovementFloat AS MovementFloat_MovementDesc
                                                 ON MovementFloat_MovementDesc.MovementId = Movement.Id
                                                AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
                                                AND MovementFloat_MovementDesc.ValueData :: Integer = zc_Movement_ReturnIn()
                              JOIN Movement AS MovementRet ON MovementRet.Id = Movement.ParentId
                              JOIN MovementDesc ON MovementDesc.Id = MovementRet.DescId AND MovementDesc.Id = zc_Movement_ReturnIn()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                                            ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                                           AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()

                              JOIN MovementLinkObject AS MovementLinkObject_To
                                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                              JOIN MovementLinkObject AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         WHERE Movement.OperDate BETWEEN '01.01.2021' AND '01.03.2021'
                           AND Movement.DescId = zc_Movement_WeighingPartner()
                           AND Movement.StatusId <> zc_Enum_Status_Erased()
                         )

    SELECT *--, lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SubjectDoc(), tmpWeighingPartner.ParentId, tmpWeighingPartner.SubjectDocId)
    FROM tmpWeighingPartner

*/