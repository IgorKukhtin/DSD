-- Function: gpUpdate_Movement_Promo_SignInternal()

--DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_SignInternal(Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_SignInternal(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_SignInternal(
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inCountNum               Integer   , -- ������� ������ - ����� ���������� ��-��������� � �� ����, ���� - ������ ����
   OUT outSignInternalId        Integer   ,
   OUT outSignInternalName      TVarChar  ,
   OUT outStrSign               TVarChar  , -- ��� �������������. - ���� ��. �������
   OUT outStrSignNo             TVarChar  , -- ��� �������������. - ��������� ��. �������
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbId             Integer;
   DECLARE vbStrMIIdSign    TVarChar;
   DECLARE vbSignInternalId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());

          
     -- ������ - ��� ��������/�� �������� - MovementItemId
     vbStrMIIdSign:= (SELECT tmp.StrMIIdSign FROM lpSelect_MI_Sign (inMovementId:= inMovementId) AS tmp);

     -- �����
     IF inCountNum = 3
     THEN
         -- ����� ������ - � isMain = TRUE, ��� 3 ����������
         vbSignInternalId:= (SELECT gpSelect.Id
                             FROM gpSelect_Object_SignInternal (FALSE, inSession) AS gpSelect
                             WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                               AND gpSelect.isMain         = TRUE
                               AND gpSelect.Count_member   = inCountNum
                               AND gpSelect.Id <> 1127098
                            );
     ELSEIF inCountNum IN (1, 2)
     THEN
         -- ����� ������ - "������" - � isMain = FALSE, ��� �� ���� ������ ����/��� ����������
         vbSignInternalId:= (SELECT gpSelect.Id
                             FROM gpSelect_Object_SignInternal (FALSE, inSession) AS gpSelect
                             WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                               AND gpSelect.isMain         = FALSE
                               AND gpSelect.Count_member   = inCountNum
                               AND gpSelect.Id <> 1127098
                            );
         -- �������� - ������ ������� ���� �� ������
         IF zfCalc_Word_Split (vbStrMIIdSign, ',', 2) <> ''
         THEN
             RAISE EXCEPTION '������.�������� ��� ��������.��������� ������ ���������.';
         END IF;

     END IF;

     -- ��������
     IF COALESCE (vbSignInternalId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������� ������ ��� ������� <%> ����������.', inCountNum;
     END IF;

     -- ���� �������� ������
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), inMovementId, vbSignInternalId);
     

     -- ���� ������ ���� ������� - ������ ������ � ����� �������
     IF vbStrMIIdSign <> ''
     THEN
         -- ��� ���������� Id ������
         vbId:= CASE WHEN zfCalc_Word_Split (vbStrMIIdSign, ',', 1) <> '' THEN zfCalc_Word_Split (vbStrMIIdSign, ',', 1) :: Integer END;
         -- ��������
         IF COALESCE (vbId, 0) = 0
         THEN
              RAISE EXCEPTION '������.�� ������� ������ ����� ����������� ������� � ��������� � <%> �� <%>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
         END IF;
         -- ��������
         PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, vbSignInternalId, MovementItem.MovementId, MovementItem.Amount, NULL)
         FROM MovementItem
         WHERE MovementItem.Id = vbId;

     -- ������ ������ ������� - ����������
     -- ELSE
    
     END IF;


     -- ���� ��������� - � ������ ����� ����������
     IF zc_Enum_PromoStateKind_Start() = (SELECT MI.ObjectId
                                          FROM MovementItem AS MI
                                               JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
                                          WHERE MI.MovementId = inMovementId
                                            AND MI.DescId     = zc_MI_Message()
                                            AND MI.isErased   = FALSE
                                          ORDER BY MI.Id DESC
                                          LIMIT 1
                                         )
     THEN
         -- �������� ���������
         PERFORM gpInsertUpdate_MI_Message_PromoStateKind (ioId                  := 0
                                                         , inMovementId          := inMovementId
                                                         , inPromoStateKindId    := zc_Enum_PromoStateKind_StartSign() -- zc_Enum_PromoStateKind_Head()
                                                         , inIsQuickly           := TRUE
                                                         , inComment             := ''
                                                         , inSession             := inSession
                                                          );
     ELSE
         RAISE EXCEPTION '������.��������� ���-�� ����������� �������� ������ ��� ��������� <%>.', lfGet_Object_ValueData_sh (zc_Enum_PromoStateKind_Start());
     END IF;


     -- ������� ���������� � �������
     SELECT tmpRes.SignInternalId
          , tmpRes.SignInternalName
          , tmpRes.strSign
          , tmpRes.strSignNo
            INTO outSignInternalId
               , outSignInternalName
               , outStrSign
               , outStrSignNo
     FROM (WITH tmpSign AS (SELECT * FROM lpSelect_MI_Sign (inMovementId:= inMovementId))
           SELECT Object_SignInternal.Id        AS SignInternalId
                , Object_SignInternal.ValueData AS SignInternalName
                , tmpSign.strSign               AS strSign
                , tmpSign.strSignNo             AS strSignNo
           FROM tmpSign
                LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = tmpSign.SignInternalId
          ) AS tmpRes;
          

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.04.20         *
*/

-- ����
--