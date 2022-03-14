-- Function: gpInsertUpdate_Movement_SendOnPrice_Branch()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPrice_Branch (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPrice_Branch (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPrice_Branch (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPrice_Branch (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPrice_Branch (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendOnPrice_Branch(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� (������)
    IN inOperDatePartner     TDateTime , -- ���� (������)
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inSubjectDocId        Integer   , -- ��������� ��� �����������
 INOUT ioPriceListId         Integer   , -- ����� ����
   OUT outPriceListName      TVarChar  , -- ����� ����
    IN inMovementId_Order    Integer    , -- ���� ���������
    IN inComment             TVarChar   , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsProcess_BranchIn Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch());


     -- ������ �������� - ������ �� ������� ��� ������ � ������� (� ������ ����� �������� ������ "���� (������)")
     vbIsProcess_BranchIn:= EXISTS (SELECT Id FROM Object_Unit_View WHERE Id = inToId AND BranchId = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId))
                         OR EXISTS (SELECT Id FROM Object_Unit_View WHERE Id = (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_To()) AND BranchId = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId))
                           ;
     -- ��������
     IF COALESCE (ioId, 0) = 0 AND vbIsProcess_BranchIn = TRUE
     THEN
         RAISE EXCEPTION '������.��� ���� ��� �������� ��������� <������ �� ������>.';
     END IF;

     -- ��������, �.�. ��� ��������� ������ ������
     IF ioId <> 0 AND vbIsProcess_BranchIn = TRUE
     THEN
         IF NOT EXISTS (SELECT Movement.Id
                        FROM Movement
                             JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                  ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                                 AND MovementBoolean_PriceWithVAT.ValueData = inPriceWithVAT
                             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                     ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                                    AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                             LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                     ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                             JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                    AND MovementLinkObject_From.ObjectId = inFromId
                             JOIN MovementLinkObject AS MovementLinkObject_To
                                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                    AND MovementLinkObject_To.ObjectId = inToId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                                          ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                                         AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
                        WHERE Movement.Id = ioId
                          AND Movement.OperDate = inOperDate
                          AND Movement.InvNumber = inInvNumber
                          AND COALESCE (MovementFloat_VATPercent.ValueData, 0) = COALESCE (inVATPercent, 0)
                          AND COALESCE (MovementFloat_ChangePercent.ValueData, 0) = COALESCE (inChangePercent, 0)
                          AND COALESCE (MovementLinkObject_PriceList.ObjectId, 0) = COALESCE (ioPriceListId, 0)
                       )
         THEN
             RAISE EXCEPTION '������.��������������� <��������> ����� ������ � ��������� ������.';
         END IF;
     END IF;

     -- ��������� <��������>
     SELECT tmp.ioId, tmp.ioPriceListId, tmp.outPriceListName
            INTO ioId, ioPriceListId, outPriceListName
     FROM lpInsertUpdate_Movement_SendOnPrice
                                       (ioId               := ioId
                                      , inInvNumber        := inInvNumber
                                      , inOperDate         := CASE WHEN vbIsProcess_BranchIn = FALSE THEN inOperDate ELSE (SELECT OperDate FROM Movement WHERE Id = ioId) END
                                      , inOperDatePartner  := CASE WHEN vbIsProcess_BranchIn = TRUE OR COALESCE (ioId, 0) = 0 THEN inOperDatePartner ELSE (SELECT ValueData FROM MovementDate WHERE MovementId = ioId AND DescId = zc_MovementDate_OperDatePartner()) END
                                      , inPriceWithVAT     := CASE WHEN vbIsProcess_BranchIn = FALSE THEN inPriceWithVAT ELSE (SELECT ValueData FROM MovementBoolean WHERE MovementId = ioId AND DescId = zc_MovementBoolean_PriceWithVAT()) END
                                      , inVATPercent       := CASE WHEN vbIsProcess_BranchIn = FALSE THEN inVATPercent ELSE (SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_VATPercent()) END
                                      , inChangePercent    := CASE WHEN vbIsProcess_BranchIn = FALSE THEN inChangePercent ELSE (SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_ChangePercent()) END
                                      , inFromId           := CASE WHEN vbIsProcess_BranchIn = FALSE THEN inFromId ELSE (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_From()) END
                                      , inToId             := CASE WHEN vbIsProcess_BranchIn = FALSE THEN inToId ELSE (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_To()) END
                                      , inRouteSortingId   := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_RouteSorting())
                                      , inSubjectDocId     := CASE WHEN vbIsProcess_BranchIn = FALSE THEN inSubjectDocId ELSE (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_SubjectDoc()) END
                                      , inMovementId_Order := inMovementId_Order
                                      , ioPriceListId      := CASE WHEN vbIsProcess_BranchIn = FALSE THEN ioPriceListId ELSE (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_PriceList()) END
                                      , inProcessId        := CASE WHEN EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = inUserId AND ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin())
                                                                        THEN zc_Enum_Process_InsertUpdate_Movement_SendOnPrice()
                                                                        ELSE zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                                                              END
                                      , inUserId           := vbUserId
                                       ) AS tmp;

    -- �����������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.02.20         * inSubjectDocId
 04.11.14                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_SendOnPrice_Branch (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
