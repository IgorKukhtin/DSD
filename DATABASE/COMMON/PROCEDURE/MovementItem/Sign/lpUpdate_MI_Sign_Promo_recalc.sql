-- Function: lpUpdate_MI_Sign_Promo_recalc()

DROP FUNCTION IF EXISTS lpUpdate_MI_Sign_Promo_recalc (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_Sign_Promo_recalc(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPromoStateKindId    Integer   , -- ��������� �����
    IN inUserId              Integer     -- ������������
)
RETURNS VOID AS
$BODY$
  DECLARE vbId                   Integer;
  DECLARE vbSignInternalId       Integer;
  DECLARE vbStrMIIdSign          TVarChar;
  DECLARE vbStrIdSign            TVarChar;
  DECLARE vbStrIdSignNo          TVarChar;
  DECLARE vbIndex                Integer; -- � �/� � ������� - ��� ��� ��������
  DECLARE vbIndexNo              Integer; -- � �/� � ������� - ��� ������� ���������
  DECLARE vbPromoStateKindId_old Integer;
BEGIN

     -- ������ �� �����
     vbPromoStateKindId_old:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PromoStateKind());

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



      -- �������� - ���� ��� ���������
      IF vbStrIdSign <> '' AND vbIndex = 0 AND vbIndexNo = 0 AND inPromoStateKindId <> zc_Enum_PromoStateKind_Main()
      THEN
          RAISE EXCEPTION '������.�������� � <%> �� <%> ��� <��������>.���������� ����������.<%><%>'
                        , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                        , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                        , vbIndex, vbIndexNo
                         ;
      END IF;
/*
      -- �������� - ���� ������ ������� <����������>
      IF inPromoStateKindId IN (zc_Enum_PromoStateKind_Main(), zc_Enum_PromoStateKind_Complete()) AND vbIndex = 0 AND vbIndexNo = 0
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� ������������� �������� <%> � ��������� � <%> �� <%>.'
                        , lfGet_Object_ValueData_sh (inUserId)
                        , lfGet_Object_ValueData_sh (inPromoStateKindId)
                        , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                        , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                         ;
      END IF;*/


      -- �������� ������ (���� ����) + ��������� ���: ����������
      IF inPromoStateKindId IN (zc_Enum_PromoStateKind_Complete())
      THEN
          -- ���� ��� �� ����������� � ��/�=1 ��� ������ ��������� ��� �� ��� ��������
          IF (vbStrIdSign ='' AND vbIndexNo = 1) OR vbIndex = 1
          THEN
              -- ����� ������ - "������" - � isMain = FALSE, ��� �� ���� ������ ���� ��������� = inUserId
              vbSignInternalId:= (SELECT gpSelect.Id
                                  FROM gpSelect_Object_SignInternal (FALSE, inUserId :: TVarChar) AS gpSelect
                                  WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                                    AND gpSelect.isMain         = FALSE
                                 );
              -- ��������
              IF COALESCE (vbSignInternalId, 0) = 0
              THEN
                   RAISE EXCEPTION '������.�� ������� ���������� ��� ������������ ������ ����� ����������� ������� � ��������� � <%> �� <%>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
              END IF;

              -- ���� �������� ������
              PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), inMovementId, vbSignInternalId);

              -- ���� �������� - ������ ������ � ����� �������
              IF vbIndex = 1
              THEN
                  -- ��� ���������� Id ������
                  vbId:= CASE WHEN zfCalc_Word_Split (vbStrMIIdSign, ',', vbIndex) <> '' THEN zfCalc_Word_Split (vbStrMIIdSign, ',', vbIndex) :: Integer END;
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
          END IF;
              
          -- ���� inUserId ��� �� ����������
          IF vbIndex <> 1
          THEN
              -- ��������
              PERFORM gpInsertUpdate_MI_Sign (inMovementId, TRUE, inUserId :: TVarChar);
          END IF;


      -- ���� 1)� ������ �������������� ��������
      ELSEIF inPromoStateKindId = zc_Enum_PromoStateKind_Main()
      THEN
          -- ���� ������� ������
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), inMovementId, NULL);

          -- ���� �������� - ������ ������ � ������������ �������
          IF vbIndex = 1 OR (vbStrIdSign <> '' AND vbStrIdSignNo = '')
          THEN
              -- ����� ������
              vbSignInternalId:= (SELECT gpSelect.Id
                                   FROM gpSelect_Object_SignInternal (FALSE, inUserId :: TVarChar) AS gpSelect
                                   WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                                     AND gpSelect.isMain         = TRUE
                                 );
              -- ��������
              IF COALESCE (vbSignInternalId, 0) = 0
              THEN
                   RAISE EXCEPTION '������.�� ������� ���������� ��� ������������ ������ ����� ����������� ������� � ��������� � <%> �� <%>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
              END IF;

              -- ��� ���������� Id ������������ �������
              IF vbIndex = 0 AND vbIndexNo = 0
              THEN
                  -- ����� ������
                  vbId:= CASE WHEN zfCalc_Word_Split (vbStrMIIdSign, ',', 1) <> '' THEN zfCalc_Word_Split (vbStrMIIdSign, ',', 1) :: Integer END;
              ELSE
                  -- ����� ��� ����� inUserId
                  vbId:= CASE WHEN zfCalc_Word_Split (vbStrMIIdSign, ',', vbIndex) <> '' THEN zfCalc_Word_Split (vbStrMIIdSign, ',', vbIndex) :: Integer END;
              END IF;
              -- ��������
              IF COALESCE (vbId, 0) = 0
              THEN
                   RAISE EXCEPTION '������.�� ������� ������ ����� ������������ ������� � ��������� � <%> �� <%>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
              END IF;
              -- ��������
              PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, vbSignInternalId, MovementItem.MovementId, MovementItem.Amount, NULL)
              FROM MovementItem
              WHERE MovementItem.Id = vbId;

          END IF;

      END IF;


      -- ���� ���� ������ �������
      IF inPromoStateKindId NOT IN (zc_Enum_PromoStateKind_Complete(), zc_Enum_PromoStateKind_Main()) AND vbPromoStateKindId_old = zc_Enum_PromoStateKind_Complete()
      THEN
          -- ������ �������
          PERFORM gpInsertUpdate_MI_Sign (inMovementId, FALSE, inUserId :: TVarChar);
      END IF;
      
      
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.  ���������� �.�.
 03.08.17         *
 23.08.16         *
*/

-- ����
-- SELECT * FROM lpUpdate_MI_Sign_Promo_recalc (inMovementId:= 4136053, inIsSign:= TRUE, inSession:= '12894') -- ���������� �.�.
-- SELECT * FROM lpUpdate_MI_Sign_Promo_recalc (inMovementId:= 4136053, inIsSign:= FALSE, inSession:= '12894') -- ���������� �.�.

-- SELECT * FROM lpUpdate_MI_Sign_Promo_recalc (inMovementId:= 4136053, inIsSign:= TRUE, inSession:= '9463') -- ������ �.�.
-- SELECT * FROM lpUpdate_MI_Sign_Promo_recalc (inMovementId:= 4136053, inIsSign:= FALSE, inSession:= '9463') -- ������ �.�.
