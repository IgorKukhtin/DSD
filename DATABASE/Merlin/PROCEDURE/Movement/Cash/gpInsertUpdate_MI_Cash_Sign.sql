-- Function: gpInsertUpdate_MI_Cash_Sign()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Cash_Sign (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Cash_Sign(
    IN inMovementId           Integer   , -- ������������� ��������
    IN inAmount               TFloat    , -- ���� <> 0, ����� ���������� ���������� �������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
   DECLARE vbMI_Id Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     --������� ����� ������ ���� ������������ ��� ���������� �������������
     vbMI_Id := (SELECT MovementItem.Id FROM MovementItem 
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId = zc_MI_Sign()
                   AND MovementItem.ObjectId = vbUserId
                   AND MovementItem.isErased = FALSE);

     --
   RAISE EXCEPTION '������. <%>  -  <%> .', vbMI_Id, vbMI_Id;
     IF COALESCE (vbMI_Id, 0) <> 0 
     THEN
        -- RETURN;
            RAISE EXCEPTION '������. <%>  -  <%> .', vbMI_Id, vbMI_Id;
     END IF;
     
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMI_Id, 0) = 0;

     -- ��������� <������� ���������>
     vbMI_Id := lpInsertUpdate_MovementItem (vbMI_Id, zc_MI_Sign(), vbUserId, inMovementId, inAmount, NULL);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <���� ��������>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbMI_Id, CURRENT_TIMESTAMP);
     END IF;
     
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMI_Id, vbUserId, vbIsInsert);

     -- �������� , ���� ������������� ��������� ��������� ��������� �� � ������ � ������ � �����
     IF (SELECT COUNT(*) FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Sign() AND MI.isErased = FALSE)
         = 
        (SELECT COUNT(*) 
         FROM Object
              INNER JOIN ObjectBoolean AS ObjectBoolean_Sign
                                       ON ObjectBoolean_Sign.DescId = zc_ObjectBoolean_User_Sign() 
                                      AND ObjectBoolean_Sign.ObjectId = Object.Id
                                      AND COALESCE (ObjectBoolean_Sign.ValueData,FALSE) = TRUE
         WHERE Object.DescId = zc_Object_User()
         )
     THEN
         UPDATE MovementItem SET DescId = CASE WHEN DescId = zc_MI_Master() THEN zc_MI_Child() ELSE zc_MI_Master() END
         WHERE MovementItem.MovementId = inMovementId AND DescId IN (zc_MI_Master(), zc_MI_Child());

         -- �.�. ��������� ��� ������ ��� ��� Child ��� Master
         -- ��������� , �.�. ����� ����� ������� ��� �������, � ����� ��� ���� �������������
         PERFORM lpInsertUpdate_MovementItemBoolean (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN zc_MIBoolean_Child() ELSE zc_MIBoolean_Child() END, MovementItem.Id, TRUE)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId IN (zc_MI_Master(), zc_MI_Child());
         
         --
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Sign(), inMovementId, TRUE);
         
         /*
         UPDATE zc_MIBoolean_Child SET ValueData = TRUE
         WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() --  �.�. ��������� ��� ������ ��� ��� Child
         
         -- 
         UPDATE zc_MIBoolean_Master SET ValueData = TRUE
         WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() --  �.�. ��������� ��� ������ ��� ��� Master
         */     
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