-- Function: gpInsertUpdateMobile_Movement_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_Cash (TVarChar, TVarChar, TDateTime, Integer, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_Cash (
    IN inGUID       TVarChar  , -- ���������� ���������� ������������� ��� ������������� � ���������� ������������
    IN inInvNumber  TVarChar  , -- ����� ���������
    IN inOperDate   TDateTime , -- ���� ���������
    IN inStatusId   Integer   , -- ���� ��������
    IN inInsertDate TDateTime , -- ����/����� �������� ���������
    IN inAmount     TFloat    , -- ����� �����
    IN inPaidKindId Integer   , -- ��� ����� ������
    IN inPartnerId  Integer   , -- ���������� - �� ����
    IN inCashId     Integer   , -- � ����� ����� ����� ������
    IN inMemberId   Integer   , -- �������� �����
    IN inContractId Integer   , -- �������
    IN inComment    TVarChar  , -- ����������
    IN inSession    TVarChar    -- ������ ������������
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbisInsert Boolean;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- �������� Id ��������� �� GUID
      SELECT MovementString_GUID.MovementId 
           , Movement_Cash.StatusId
      INTO vbId 
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_Cash
                         ON Movement_Cash.Id = MovementString_GUID.MovementId
                        AND Movement_Cash.DescId = zc_Movement_Cash()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;

      vbisInsert:= (COALESCE (vbId, 0) = 0);

      IF (vbisInsert = false) AND (vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased()))
      THEN -- ���� ������ ����� ��������, �� �����������    
           PERFORM lpUnComplete_Movement (inMovementId:= vbId, inUserId:= vbUserId);
      END IF;

      vbId:= lpInsertUpdate_Movement_Cash (ioId                   := vbId
                                         , inParentId             := NULL
                                         , inInvNumber            := inInvNumber
                                         , inOperDate             := inOperDate
                                         , inServiceDate          := DATE_TRUNC ('MONTH', inOperDate)
                                         , inAmountIn             := inAmount
                                         , inAmountOut            := 0.0
                                         , inAmountSumm           := inAmount
                                         , inAmountCurrency       := inAmount
                                         , inComment              := inComment
                                         , inCashId               := inCashId
                                         , inMoneyPlaceId         := inPartnerId
                                         , inPositionId           := 0
                                         , inContractId           := inContractId
                                         , inInfoMoneyId          := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inContractId AND DescId = zc_ObjectLink_Contract_InfoMoney())
                                         , inMemberId             := inMemberId
                                         , inUnitId               := 0
                                         , inCurrencyId           := zc_Enum_Currency_Basis()
                                         , inCurrencyValue        := 1.0
                                         , inParValue             := 1.0
                                         , inCurrencyPartnerValue := 1.0
                                         , inParPartnerValue      := 1.0
                                         , inMovementId_Partion   := 0
                                         , inUserId               := vbUserId
                                          );

      -- ��������� �������� <����/����� �������� �� ��������� ����������>
      PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_InsertMobile(), vbId, inInsertDate);

      -- ��������� �������� <���������� ���������� �������������>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);

      -- !!! ��������� ������� ��������
      PERFORM lpSetErased_Movement (inMovementId:= vbId, inUserId:= vbUserId);

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 16.02.17                                                        *                                          
*/

-- ����
/* 
  SELECT * FROM gpInsertUpdateMobile_Movement_Cash (inGUID       := '{88E07827-BCC3-41E7-A574-E0837AD2E17A}'
                                                  , inInvNumber  := '-30'
                                                  , inOperDate   := CURRENT_DATE
                                                  , inStatusId   := zc_Enum_Status_UnComplete()
                                                  , inInsertDate := CURRENT_TIMESTAMP
                                                  , inAmount     := 6456.45
                                                  , inPaidKindId := zc_Enum_PaidKind_SecondForm()
                                                  , inPartnerId  := 17819
                                                  , inCashId     := 280296
                                                  , inMemberId   := 274610
                                                  , inContractId := 16687
                                                  , inComment    := '������ ����������'
                                                  , inSession    := zfCalc_UserAdmin()
                                                   );
*/