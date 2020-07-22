-- Function: gpInsert_MovementItem_Loyalty_PromoCode()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Loyalty_PromoCode (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_Loyalty_PromoCode(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inCount               Integer   , -- ����������
    IN inAmount              TFloat    , -- �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbId Integer;
   DECLARE vbisElectron Boolean;
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

    SELECT COALESCE(MovementBoolean_Electron.ValueData, FALSE) ::Boolean
    INTO vbisElectron
    FROM Movement
         LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                   ON MovementBoolean_Electron.MovementId =  Movement.Id
                                  AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()
    WHERE Movement.ID = inMovementId;

    -- ���� �������� �� ��� ����� �� �����������
    IF vbisElectron <> TRUE
    THEN
      RAISE EXCEPTION '��������� �������� ��������� ������ � ���������� ���������� ��� �����';
    END IF;

    vbIndex := 0;

    -- ������ ������� ��� ������
    WHILE (vbIndex < inCount) LOOP
      vbIndex := vbIndex + 1;


        -- ��������� <������� ���������>
        vbId := lpInsertUpdate_MovementItem (0, zc_MI_Sign(), 0, inMovementId, inAmount, NULL, zc_Enum_Process_Auto_PartionClose());

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

-- SELECT * FROM gpInsert_MovementItem_Loyalty_PromoCode (19620044 , 1, 20, '3');