-- Function: gpUpdate_MI_Cash_Sign_isErased()

DROP FUNCTION IF EXISTS gpUpdate_MI_Cash_Sign_isErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Cash_Sign_isErased(
    IN inMovementId          Integer              , -- ���� ������� <������� ���������>
    IN inSession             TVarChar               -- ������� ������������
)
  RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId_mi Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- ����� ������ ���� ������������ ��� �������� �������������
     vbId_mi := (SELECT MovementItem.Id
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Sign()
                   AND MovementItem.ObjectId   = vbUserId
                   AND MovementItem.isErased   = FALSE
                );

     -- ��������
     IF COALESCE (vbId_mi, 0) = 0
     THEN
        RAISE EXCEPTION '������.������ �������� <���������� �������������>.������� �� ������.';
     END IF;


     -- ���� ������������� ������������
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Sign() AND MB.ValueData = TRUE)
     THEN
         -- ������� ��� �������
         PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Sign()
           AND MovementItem.isErased   = FALSE
          ;

         -- ������� �������� ��� <������������� ������, ������ ���������� �� ....>
         PERFORM lpInsertUpdate_MovementItemBoolean (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN zc_MIBoolean_Child() ELSE zc_MIBoolean_Master() END, MovementItem.Id, FALSE)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId IN (zc_MI_Master(), zc_MI_Child())
           AND MovementItem.isErased = FALSE
           ;

         -- ���������� ������� Child <-> Master
         UPDATE MovementItem SET DescId = CASE WHEN MovementItem.DescId = zc_MI_Master() THEN zc_MI_Child() ELSE zc_MI_Master() END
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId IN (zc_MI_Master(), zc_MI_Child())
           AND MovementItem.isErased = FALSE
           ;

         -- ������������� �� ������������
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Sign(), inMovementId, FALSE);


         -- ���� �������� ��������
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
         THEN
             -- ����������� ��������
             PERFORM lpUnComplete_Movement (inMovementId:= inMovementId, inUserId:= vbUserId);
         END IF;

         -- ��������
         PERFORM lpComplete_Movement_Cash (inMovementId:= inMovementId, inUserId:= vbUserId);

     ELSE
         -- ������� ���� �������
         PERFORM lpSetErased_MovementItem (inMovementItemId:= vbId_mi, inUserId:= vbUserId);
     END IF;

     -- ��������� �������� < ����/����� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_mi, CURRENT_TIMESTAMP);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.01.22         *
*/

-- ����