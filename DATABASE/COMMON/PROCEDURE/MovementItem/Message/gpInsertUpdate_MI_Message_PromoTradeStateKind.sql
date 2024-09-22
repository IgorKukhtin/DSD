-- Function: gpInsertUpdate_MI_Message_PromoTradeStateKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Message_PromoTradeStateKind (Integer, Integer, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Message_PromoTradeStateKind(
 INOUT ioId                      Integer   , --
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inPromoTradeStateKindId   Integer   , -- ���������
    IN inIsQuickly               Boolean   , -- ��������� - ������
    IN inComment                 TVarChar  ,
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbIsInsert Boolean;
  DECLARE vbAmount_sign TFloat;
  DECLARE vbIsChange Boolean;
  DECLARE vbStrIdSignNo TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoTrade());

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- ��������
     IF COALESCE (inPromoTradeStateKindId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��������� �� ����� ���� ������.';
     END IF;


     -- ��� ��������� ����������
     vbAmount_sign:= COALESCE ((SELECT MAX (gpSelect.Ord) FROM gpSelect_MI_Sign (inMovementId, FALSE, inSession) AS gpSelect WHERE gpSelect.isSign = TRUE), 0);


     -- ��������
     IF 1=1 AND NOT EXISTS (SELECT 1 FROM lpSelect_Movement_PromoTradeSign (inMovementId) AS lpSelect WHERE lpSelect.UserId = vbUserId)
     THEN
         RAISE EXCEPTION '������.� ������������ <%> ��� ���� ��� ������������.', lfGet_Object_ValueData_sh (vbUserId);
     END IF;

     -- ��������
     IF 1=1 AND NOT EXISTS (SELECT 1 FROM lpSelect_Movement_PromoTradeSign (inMovementId) AS lpSelect WHERE lpSelect.UserId = vbUserId AND lpSelect.Num = vbAmount_sign + 1)
      -- ����� �������
      --AND inPromoTradeStateKindId <> zc_Enum_PromoTradeStateKind_Complete_1()
     THEN
         RAISE EXCEPTION '������.��� ���� ��� ������������ ������ ��� <%>.'
                       , (SELECT gpSelect.UserName FROM gpSelect_MI_Sign (inMovementId, FALSE, inSession) AS gpSelect WHERE gpSelect.Ord = vbAmount_sign + 1);
     END IF;


     -- ��������
     /*IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.ObjectId = zc_Enum_PromoTradeStateKind_Start())
        AND inPromoTradeStateKindId <> zc_Enum_PromoTradeStateKind_Start()
     THEN
         RAISE EXCEPTION '������.��������� <%> �� ����� ���� �������� �� <%>.', lfGet_Object_ValueData_sh (zc_Enum_PromoTradeStateKind_Start()), lfGet_Object_ValueData_sh (inPromoTradeStateKindId);
     END IF;

     -- �������� - ��� � ��������� ���������
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.ObjectId IN (zc_Enum_PromoTradeStateKind_Complete_1(), zc_Enum_PromoTradeStateKind_Complete_2(), zc_Enum_PromoTradeStateKind_Complete_3(), zc_Enum_PromoTradeStateKind_Complete_4(), zc_Enum_PromoTradeStateKind_Complete_5(), zc_Enum_PromoTradeStateKind_Complete_6(), zc_Enum_PromoTradeStateKind_Complete_7()))
        AND NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.ObjectId = inPromoTradeStateKindId)
     THEN
         RAISE EXCEPTION '������.��������� <%> �� ����� ���� �������� �� <%>.', lfGet_Object_ValueData_sh ((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = ioId)), lfGet_Object_ValueData_sh (inPromoTradeStateKindId);
     END IF;*/


     -- ����������
     -- vbIsChange:= inPromoTradeStateKindId <> COALESCE ((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = ioId), 0);

     -- ��������� <������� ���������>
     ioId:= lpInsertUpdate_MovementItem (ioId, zc_MI_Message(), inPromoTradeStateKindId, inMovementId
                                       , 0
                                       , NULL
                                       );

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     END IF;


     -- !!!����������� ��� ��������/������� + ��������� ������!!!
     PERFORM lpInsertUpdate_MI_Sign_all (inMovementId     := inMovementId
                                       , inSignInternalId := 11307029 -- �����-���������
                                       , inAmount         := vbAmount_sign + 1
                                       , inUserId         := vbUserId
                                        );


     -- ����� ��������� - � ��������� � �����
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoTradeStateKind(), inMovementId, tmp.ObjectId)
              -- ��������� �������� <���� ������������>
           , lpInsertUpdate_MovementDate (zc_MovementDate_Check(), inMovementId
                                        , CASE WHEN tmp.ObjectId = zc_Enum_PromoTradeStateKind_Complete_7() THEN CURRENT_DATE ELSE NULL END
                                         )
              -- ��������� �������� <�����������>
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), inMovementId
                                           , CASE WHEN tmp.ObjectId = zc_Enum_PromoTradeStateKind_Complete_7() THEN TRUE ELSE FALSE END
                                            )
     FROM (SELECT MI.ObjectId, MI.Amount
           FROM MovementItem AS MI
                JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoTradeStateKind()
           WHERE MI.MovementId = inMovementId
             AND MI.DescId     = zc_MI_Message()
             AND MI.isErased   = FALSE
           ORDER BY MI.Id DESC
           LIMIT 1
          ) AS tmp;

     --

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.  ���������� �.�.
 01.04.20         *
*/

-- ����
--