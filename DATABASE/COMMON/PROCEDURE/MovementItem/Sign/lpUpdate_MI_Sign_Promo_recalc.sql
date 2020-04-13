-- Function: lpUpdate_MI_Sign_Promo_recalc()

DROP FUNCTION IF EXISTS lpUpdate_MI_Sign_Promo_recalc (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_Sign_Promo_recalc(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPromoStateKindId    Integer   ,
    IN inUserId              Integer     -- ������������
)
RETURNS VOID AS
$BODY$
  DECLARE vbSignInternalId Integer;
  DECLARE vbStrMIIdSign    TVarChar;
  DECLARE vbStrIdSign      TVarChar;
  DECLARE vbStrIdSignNo    TVarChar;
  DECLARE vbIndex          Integer; -- � �/� � ������� - ��� ��� ��������
  DECLARE vbIndexNo        Integer; -- � �/� � ������� - ��� ������� ���������
BEGIN

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

      FROM lpSelect_MI_IncomeFuel_Sign (inMovementId:= inMovementId) AS tmp;



      -- �������� - ���� ��� ���������
      IF vbStrIdSign <> '' AND vbStrIdSignNo = ''
      THEN
          RAISE EXCEPTION '������.�������� � <%> �� <%> ��� <%>.'
                        , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                        , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                        , lfGet_Object_ValueData_sh (zc_Enum_PromoStateKind_Complete())
                         ;
      END IF;

      -- �������� - ���� ������ ������� <����������>
      IF inPromoStateKindId IN (zc_Enum_PromoStateKind_Main(), zc_Enum_PromoStateKind_Complete()) AND vbIndex = 0 AND vbIndexNo = 0
      THEN
          RAISE EXCEPTION '������.� ������������ <%> ��� ���� ������������� �������� <%> � ��������� � <%> �� <%>.'
                        , lfGet_Object_ValueData_sh (vbUserId)
                        , lfGet_Object_ValueData_sh (inPromoStateKindId)
                        , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                        , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                         ;
      END IF;


      -- ���� ���� ����� - ��� ������� ���������
      IF vbIndexNo > 0
      THEN
          -- � ������ �������������� �������� ��� ����������
          IF inPromoStateKindId IN (zc_Enum_PromoStateKind_Main(), zc_Enum_PromoStateKind_Complete())
          THEN
              -- ���� ��� ����� �� ���������� � ��/� = 1 � ����������
              IF vbStrIdSign = '' AND vbIndexNo = 1 AND inPromoStateKindId = zc_Enum_PromoStateKind_Complete()
              THEN
                  -- ���� �������� ������ - ������� � isMain = FALSE, ��� �� ���� ������ ���� ��������� = inUserId
                  PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal()
                                                           , inMovementId
                                                           , -- ����� ������
                                                             (SELECT gpSelect.Id
                                                              FROM gpSelect_Object_SignInternal (FALSE, inSession) AS gpSelect
                                                              WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                                                                AND gpSelect.isMain         = FALSE
                                                            ));
              ELSEIF inPromoStateKindId IN (zc_Enum_PromoStateKind_Main()
              THEN
                  -- ���� ������� ������
                  PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), inMovementId, NULL);
              END IF;

              -- ���������
              PERFORM gpInsertUpdate_MI_IncomeFuel_Sign (inMovementId, TRUE, inUserId :: TVarChar);

          END IF;
      END IF;

      -- ���� ���� ����� - ��� ��� ��������
      IF vbIndex > 0
      THEN
          -- �� � ������ �������������� �������� ��� ����������
          IF inPromoStateKindId NOT IN (zc_Enum_PromoStateKind_Main(), zc_Enum_PromoStateKind_Complete())
          THEN
              -- ������ �������
              PERFORM gpInsertUpdate_MI_IncomeFuel_Sign (inMovementId, FALSE, inUserId :: TVarChar);
          END IF;
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
