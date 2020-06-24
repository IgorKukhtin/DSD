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



      -- �������� - ���� ���������
      IF vbStrIdSign <> '' AND inPromoStateKindId = zc_Enum_PromoStateKind_Start()
      THEN
          -- ���� 2 ���� ���������
          IF zfCalc_Word_Split (vbStrIdSign, ',', 2) <> ''
          THEN
              -- ������ ������� - ��� ������������� � 2
              PERFORM gpInsertUpdate_MI_Sign (inMovementId, FALSE, zfCalc_Word_Split (vbStrIdSign, ',', 2));
          END IF;

          -- ���� 1 ���� ���������
          IF zfCalc_Word_Split (vbStrIdSign, ',', 1) <> ''
          THEN
              -- ������ ������� - ��� ������������� � 1
              PERFORM gpInsertUpdate_MI_Sign (inMovementId, FALSE, zfCalc_Word_Split (vbStrIdSign, ',', 1));
          END IF;
      END IF;


      -- �������� - ���� ���� �������
      IF vbStrIdSign <> '' AND inPromoStateKindId NOT IN (zc_Enum_PromoStateKind_Start(), zc_Enum_PromoStateKind_Main()) AND vbIndexNo <> 1
      THEN
          RAISE EXCEPTION '������.�������� � <%> �� <%> ��� <��������>.���������� ����������.<%><%>'
                        , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                        , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                        , vbIndex, vbIndexNo
                         ;
      END IF;


      -- ��������� ���: ����������
      IF inPromoStateKindId IN (zc_Enum_PromoStateKind_Complete())
      THEN
          -- ���� inUserId ��� �� ����������
          IF vbIndex = 0 OR 1=1
          THEN
              -- ���������
              PERFORM gpInsertUpdate_MI_Sign (inMovementId, TRUE, inUserId :: TVarChar);
          END IF;
          --
          -- ���� ���� 2 ���� ���������
          IF zfCalc_Word_Split (vbStrIdSignNo, ',', 2) <> ''
          THEN
              -- �������� ���������
              PERFORM gpInsertUpdate_MI_Message_PromoStateKind (ioId                  := 0
                                                              , inMovementId          := inMovementId
                                                              , inPromoStateKindId    := zc_Enum_PromoStateKind_Main()
                                                              , inIsQuickly           := TRUE
                                                              , inComment             := ''
                                                              , inSession             := inUserId :: TVarChar
                                                               );
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
