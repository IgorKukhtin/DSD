-- Function: gpUpdate_Movement_Promo_SignInternal()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_SignInternal(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_SignInternal(
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inIsNull                 Boolean   , -- ������� ������ - ����� ���������� ��-��������� � �� ����, ���� - ������ ����
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
     IF inIsNull = TRUE
     THEN
         -- ����� ������ - � isMain = TRUE, ��� ��� ����������
         vbSignInternalId:= (SELECT gpSelect.Id
                             FROM gpSelect_Object_SignInternal (FALSE, inSession) AS gpSelect
                             WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                               AND gpSelect.isMain         = TRUE
                            );
     ELSE
         -- ����� ������ - "������" - � isMain = FALSE, ��� �� ���� ������ ���� ���������
         vbSignInternalId:= (SELECT gpSelect.Id
                             FROM gpSelect_Object_SignInternal (FALSE, inSession) AS gpSelect
                             WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                               AND gpSelect.isMain         = FALSE
                            );
         -- �������� - ������ ������� ���� �� ������
         IF zfCalc_Word_Split (vbStrMIIdSign, ',', 2) <> ''
         THEN
             RAISE EXCEPTION '������.�������� ��� ��������.��������� ������ ���������.';
         END IF;

     END IF;

     -- ���� �������� ������
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), inMovementId, vbSignInternalId);
     

     -- ���� �������� - ������ ������ � ����� �������
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