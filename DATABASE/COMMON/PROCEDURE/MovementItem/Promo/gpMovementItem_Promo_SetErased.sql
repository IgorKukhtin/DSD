-- Function: gpMovementItem_Promo_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Promo_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Promo_SetErased(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId          Integer;
   DECLARE vbMovementId      Integer;
   DECLARE vbSignInternalId  Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_Promo());


     -- ���� ��� ��������� �����
     IF EXISTS (SELECT 1
                FROM MovementItem AS MI
                     JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
                WHERE MI.Id        = inMovementItemId
                  AND MI.DescId    = zc_MI_Message()
               )
     THEN
         -- �����
         vbMovementId:= (SELECT MI.MovementId FROM MovementItem AS MI WHERE MI.Id = inMovementItemId);

         -- ���� �� ���������
         IF inMovementItemId <> (SELECT MAX (MI.Id)
                                 FROM MovementItem AS MI
                                      JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
                                 WHERE MI.MovementId = vbMovementId
                                   AND MI.DescId     = zc_MI_Message()
                                   AND MI.isErased   = FALSE
                                )
         THEN
             RAISE EXCEPTION '������.������� ����� ������ ��������� ���������.';
         END IF;

         -- ��������
         IF inMovementItemId = (SELECT MI.Id
                                FROM MovementItem AS MI
                                     JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
                                WHERE MI.MovementId = vbMovementId
                                  AND MI.DescId     = zc_MI_Message()
                                  AND MI.isErased   = FALSE
                                ORDER BY MI.Id ASC
                                LIMIT 1
                               )
         THEN
             RAISE EXCEPTION '������.������ ��������� <%> �� ����� ���� �������.', lfGet_Object_ValueData_sh (zc_Enum_PromoStateKind_Start());
         END IF;


         -- ��������
         outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);


         -- ���� ���� ������ �������
         IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.Id = inMovementItemId AND MI.ObjectId IN (zc_Enum_PromoStateKind_Complete()))
         THEN
             -- ������ �������
             PERFORM gpInsertUpdate_MI_Sign (vbMovementId, FALSE, vbUserId :: TVarChar);
         END IF;

         -- ����� ��������� - � ��������� � �����
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoStateKind(), vbMovementId, tmp.ObjectId)
               , lpInsertUpdate_MovementFloat (zc_MovementFloat_PromoStateKind(), vbMovementId, tmp.Amount)
                  -- ��������� �������� <���� ������������>
               , lpInsertUpdate_MovementDate (zc_MovementDate_Check(), vbMovementId
                                            , CASE WHEN tmp.ObjectId = zc_Enum_PromoStateKind_Complete() THEN CURRENT_DATE ELSE NULL END
                                             )
                  -- ��������� �������� <�����������>
               , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), vbMovementId
                                               , CASE WHEN tmp.ObjectId = zc_Enum_PromoStateKind_Complete() THEN TRUE ELSE FALSE END
                                                )
                                                
         FROM (SELECT MI.ObjectId, MI.Amount
               FROM MovementItem AS MI
                    JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
               WHERE MI.MovementId = vbMovementId
                 AND MI.DescId     = zc_MI_Message()
                 AND MI.isErased   = FALSE
               ORDER BY MI.Id DESC
               LIMIT 1
              ) AS tmp;

         -- �������� ������ (���� ����)
         IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.Id = inMovementItemId AND MI.ObjectId IN (zc_Enum_PromoStateKind_Main()))
         THEN
             -- ����� ������ - "������" - � isMain = FALSE, ��� �� ���� ������ ���� ��������� ....
             vbSignInternalId:= (SELECT gpSelect.Id
                                 FROM gpSelect_Object_SignInternal (FALSE, vbUserId :: TVarChar) AS gpSelect
                                 WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                                   AND gpSelect.isMain         = FALSE
                                );
             -- ��������
             IF COALESCE (vbSignInternalId, 0) = 0
             THEN
                  RAISE EXCEPTION '������.�� ������� ���������� ��� ������������ ������ ����� ����������� ������� � ��������� � <%> �� <%>.', (SELECT InvNumber FROM Movement WHERE Id = vbMovementId), zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = vbMovementId));
             END IF;
   
             -- ���� �������� ������
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), vbMovementId, vbSignInternalId);
   
             -- ���� �������� - ������ ������ � ����� �������
             PERFORM lpInsertUpdate_MovementItem (MI.Id, MI.DescId, vbSignInternalId, MI.MovementId, MI.Amount, NULL)
             FROM MovementItem AS MI
             WHERE MI.MovementId = vbMovementId
               AND MI.DescId     = zc_MI_Sign()
               AND MI.isErased   = FALSE
              ;

         END IF;

     ELSE
         -- ��������
         outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.  ��������� �.�.
 13.10.15                                                                      *
*/