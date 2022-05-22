-- Function: gpInsertUpdate_MI_Cash_Sign()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Cash_Sign (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Cash_Sign(
    IN inMovementId           Integer   , -- ������������� ��������
    IN inAmount               TFloat    , -- ���� <> 0, ����� ���������� ���������� �������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
   DECLARE vbId_mi Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������� ����� ������ ���� ������������ ��� �������� �������������
     vbId_mi := (SELECT MovementItem.Id
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Sign()
                   AND MovementItem.ObjectId   = vbUserId
                 --AND MovementItem.isErased   = FALSE
                );

     -- �������� - ���� ������������� ������������
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Sign() AND MB.ValueData = TRUE)
     THEN
        RAISE EXCEPTION '������.������������� ������������.��������� ����������.';
     END IF;

     -- ��������
     IF NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbUserId AND OB.DescId = zc_ObjectBoolean_User_Sign() AND OB.ValueData = TRUE)
     THEN
        RAISE EXCEPTION '������.� ������������ <%> ��� ���� <���������� �������������>.', lfGet_Object_ValueData_sh (vbUserId);
     END IF;
     -- ��������
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = vbId_mi AND MovementItem.isErased = FALSE)
     THEN
        RAISE EXCEPTION '������.<���������� �������������> ��� ����������.������������ ���������.';
     END IF;
     -- �������� - �����
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.isErased = FALSE AND MI.DescId IN (zc_MI_Master(), zc_MI_Child())
                HAVING SUM (CASE WHEN MI.DescId = zc_MI_Master() THEN MI.Amount ELSE 0 END) <> SUM (CASE WHEN MI.DescId = zc_MI_Master() THEN MI.Amount ELSE 0 END)
               )
     THEN
        RAISE EXCEPTION '������.�� ������������� ����� ������������� 1.<%> � 2.<%>.'
                      , zfConvert_FloatToString ((SELECT ABS (SUM (MI.Amount)) FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.isErased = FALSE AND MI.DescId = zc_MI_Master()))
                      , zfConvert_FloatToString ((SELECT SUM (CASE WHEN MI_master.Amount > 0 THEN 1 ELSE -1 END * MI.Amount)
                                                  FROM MovementItem AS MI
                                                       JOIN MovementItem AS MI_master ON MI_master.MovementId = inMovementId AND MI_master.isErased = FALSE AND MI_master.DescId = zc_MI_Master()
                                                  WHERE MI.MovementId = inMovementId AND MI.isErased = FALSE AND MI.DescId = zc_MI_Child()
                                                ))
                        ;
     END IF;


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbId_mi, 0) = 0;

     -- ��������� <������� ���������>
     vbId_mi := lpInsertUpdate_MovementItem (vbId_mi, zc_MI_Sign(), vbUserId, inMovementId, 1, NULL);

     -- ��������� �������� < ����/����� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_mi, CURRENT_TIMESTAMP);


     -- ���� ������������� ��������� ���������, ������ ������ Master <-> Child
     IF (SELECT COUNT(DISTINCT MovementItem.ObjectId) FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Sign() AND MI.isErased = FALSE)
         =
        (SELECT COUNT(*)
         FROM Object
              INNER JOIN ObjectBoolean AS ObjectBoolean_Sign
                                       ON ObjectBoolean_Sign.ObjectId  = Object.Id
                                      AND ObjectBoolean_Sign.DescId    = zc_ObjectBoolean_User_Sign()
                                      AND ObjectBoolean_Sign.ValueData = TRUE
         WHERE Object.DescId = zc_Object_User()
         )
     THEN
         -- ������  Master <-> Child
         UPDATE MovementItem SET DescId = CASE WHEN MovementItem.DescId = zc_MI_Master() THEN zc_MI_Child() ELSE zc_MI_Master() END
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId IN (zc_MI_Master(), zc_MI_Child())
           AND MovementItem.isErased = FALSE
           ;

         -- ������ ����� ������������� ��� <������������� ������, ������ ���������� �� ....>
         PERFORM lpInsertUpdate_MovementItemBoolean (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN zc_MIBoolean_Child() ELSE zc_MIBoolean_Master() END, MovementItem.Id, TRUE)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId IN (zc_MI_Master(), zc_MI_Child())
           AND MovementItem.isErased = FALSE
           ;

         -- ������������� ������������
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Sign(), inMovementId, TRUE);
         

         -- ���� �������� ��������
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
         THEN
             -- ����������� ��������
             PERFORM lpUnComplete_Movement (inMovementId:= inMovementId, inUserId:= vbUserId);
         END IF;

         -- ��������
         PERFORM lpComplete_Movement_Cash (inMovementId:= inMovementId, inUserId:= vbUserId);


     ELSE
         -- ������������� �� ������������
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Sign(), inMovementId, FALSE);

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.01.22         *
 */

-- ����
--