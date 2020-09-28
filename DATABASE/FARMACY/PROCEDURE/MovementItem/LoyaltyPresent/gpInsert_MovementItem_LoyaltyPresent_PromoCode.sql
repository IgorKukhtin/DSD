-- Function: gpInsert_MovementItem_LoyaltyPresent_PromoCode()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_LoyaltyPresent_PromoCode (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_LoyaltyPresent_PromoCode(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inCount               Integer   , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbGUID TVarChar;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbIndex Integer;
BEGIN

      -- �������� ���� ������������ �� ����� ���������
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION '��������� �������� ��� ���������, ���������� � ���������� ��������������';
    END IF;

    IF COALESCE (inCount, 0) > 100
    THEN
      RAISE EXCEPTION '�� ��� ����� ������������ �� ����� 100 �����.';
    END IF;

    vbIndex := 0;

    -- ������ ������� ��� ������
    WHILE (vbIndex < inCount) LOOP
      vbIndex := vbIndex + 1;


        -- ��������� <������� ���������>
        vbId := lpInsertUpdate_MovementItem (0, zc_MI_Sign(), 0, inMovementId, 1, NULL, zc_Enum_Process_Auto_PartionClose());

        -- ������������ ��������
        vbGUID := TO_CHAR(CURRENT_DATE, 'MMYY')||'-';

        vbUnitKey := (random() * 9999)::Integer::TVarChar;
        WHILE LENGTH(vbUnitKey) < 4
        LOOP
          vbUnitKey := '0'||vbUnitKey;
        END LOOP;
        vbGUID := vbGUID||vbUnitKey||'-';

        vbUnitKey := (random() * 9999)::Integer::TVarChar;
        WHILE LENGTH(vbUnitKey) < 4
        LOOP
          vbUnitKey := '0'||vbUnitKey;
        END LOOP;
        vbGUID := vbGUID||vbUnitKey||'-';

        vbUnitKey := (random() * 9999)::Integer::TVarChar;
        WHILE LENGTH(vbUnitKey) < 4
        LOOP
          vbUnitKey := '0'||vbUnitKey;
        END LOOP;
        vbGUID := upper(vbGUID||vbUnitKey);

        -- ��������� �������� <>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, vbGUID);
        PERFORM lpInsertUpdate_MovementItem_Loyalty_GUID (vbId, vbGUID, vbUserId);

        -- ��������� �������� <>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), vbId, CURRENT_DATE);

        -- ��������� ����� � <>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), vbId, vbUserId);
        -- ��������� �������� <>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId, CURRENT_TIMESTAMP);

    END LOOP;

/*    IF inSession = '3'
    THEN
      RAISE EXCEPTION '������. ������ % % ...', inAmount, vbGUID;
    END IF;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.07.20                                                       *
 */

-- SELECT * FROM gpInsert_MovementItem_LoyaltyPresent_PromoCode (19620044 , 1, '3');