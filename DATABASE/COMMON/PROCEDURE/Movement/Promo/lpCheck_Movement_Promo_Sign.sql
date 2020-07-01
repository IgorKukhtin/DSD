-- Function: lpCheck_Movement_Promo_Sign()

DROP FUNCTION IF EXISTS lpCheck_Movement_Promo_Sign (Integer, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpCheck_Movement_Promo_Sign(
    IN inMovementId          Integer   , -- ���� ���������
    IN inIsComplete          Boolean   , -- 
    IN inIsUpdate            Boolean   , -- 
    IN inUserId              Integer     -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbSignInternalId       Integer;
  DECLARE vbStrMIIdSign          TVarChar;
  DECLARE vbStrIdSign            TVarChar;
  DECLARE vbStrIdSignNo          TVarChar;
  DECLARE vbIndex                Integer; -- � �/� � ������� - ��� ��� ��������
  DECLARE vbIndexNo              Integer; -- � �/� � ������� - ��� ������� ���������
  DECLARE vbPromoStateKindId_old Integer;
BEGIN

     -- ���� ��� ��������
     -- IF zc_isPromo_Sign_check() = FALSE THEN RETURN; END IF;

     -- ������ - ��� ��������/�� ��������
     SELECT -- ������ ��� �������
            tmp.SignInternalId
            -- MovementItemId
          , tmp.StrMIIdSign
            -- Id ������������� - ��� ��� ��������
          , tmp.StrIdSign
            -- Id ������������� - ��� ������� ���������
          , tmp.StrIdSignNo
            -- � �/� � ������� - ��� ��� ��������
          , zfCalc_WordNumber_Split (tmp.strIdSign,   ',', inUserId :: TVarChar)
            -- � �/� � ������� - ��� ������� ���������
          , zfCalc_WordNumber_Split (tmp.strIdSignNo, ',', inUserId :: TVarChar)

            INTO vbSignInternalId, vbStrMIIdSign, vbStrIdSign, vbStrIdSignNo, vbIndex, vbIndexNo

     FROM lpSelect_MI_Sign (inMovementId:= inMovementId) AS tmp;
      
     -- ���� �������� - ����������, ������ ���� ��� ������� 
     IF inIsComplete = TRUE AND vbStrIdSignNo <> '' AND zc_isPromo_Sign_check() = TRUE
     THEN
         RAISE EXCEPTION '������.������ ���������� ������ <%>.��������� ���������� ��������� ������������� <%>.'
                        , lfGet_Object_ValueData_sh (zc_Enum_Status_Complete())
                        , lfGet_Object_ValueData_sh (zfConvert_StringToFloat (zfCalc_Word_Split (vbStrIdSignNo, ',', 1)) :: Integer)
                         ;
     END IF;
     
     -- ���� �������� - ��������� ����-����, �� ������ ���� �������� ������
     IF inIsUpdate = TRUE AND vbStrIdSign <> ''
     THEN
         RAISE EXCEPTION '������.�������� ��� �������� ������������� <%>.������������� �� ��������.'
                        , lfGet_Object_ValueData_sh (zfConvert_StringToFloat (zfCalc_Word_Split (vbStrIdSign, ',', 1)) :: Integer)
                         ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.05.16                                        *
*/

-- ����
-- SELECT * FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child() -- SELECT * FROM MovementItemFloat WHERE MovementItemId IN (SELECT Id FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child())
-- SELECT lpCheck_Movement_Promo_Sign (inMovementId:= Movement.Id, inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 3662505
-- SELECT lpCheck_Movement_Promo_Sign (inMovementId:= Movement.Id, inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 15265833
