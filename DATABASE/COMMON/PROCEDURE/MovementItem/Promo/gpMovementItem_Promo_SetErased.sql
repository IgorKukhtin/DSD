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
   DECLARE vbUserId     Integer;
   DECLARE vbMovementId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_Promo());

     -- �����
     vbMovementId:= (SELECT MI.MovementId FROM MovementItem AS MI WHERE MI.Id = inMovementItemId);

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

     -- ������������� ����� ��������
     outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);


     IF EXISTS (SELECT 1
                FROM MovementItem AS MI
                     JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
                WHERE MI.Id        = inMovementItemId
                  AND MI.DescId    = zc_MI_Message()
               )
     THEN
         -- ����� ��������� - � ��������� � �����
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoStateKind(), vbMovementId, tmp.ObjectId)
               , lpInsertUpdate_MovementFloat (zc_MovementFloat_PromoStateKind(), vbMovementId, tmp.Amount)
         FROM (SELECT MI.ObjectId, MI.Amount
               FROM MovementItem AS MI
                    JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
               WHERE MI.MovementId = vbMovementId
                 AND MI.DescId     = zc_MI_Message()
                 AND MI.isErased   = FALSE
               ORDER BY MI.Id DESC
               LIMIT 1
              ) AS tmp;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_Promo_SetErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.  ��������� �.�.
 13.10.15                                                                      *
*/