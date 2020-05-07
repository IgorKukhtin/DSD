-- Function: gpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ���� �����. �����.
    IN inPriceUnitFrom       TFloat    , -- ���� �����������
 INOUT ioPriceUnitTo         TFloat    , -- ���� ����������
   OUT outSumma              TFloat    , -- �����
   OUT outSummaUnitTo        TFloat    , -- ����� � ����� ����������
    IN inAmountManual        TFloat    , -- ���-�� ������
    IN inAmountStorage       TFloat    , -- ���� ���-�� �����-�����������
   OUT outAmountDiff         TFloat    , -- ����������� ���-��  �����  ���� ���-�� �����-����������
   OUT outAmountStorageDiff  TFloat    , -- ����������� ���-��  �����  ���� ���-�� �����-�����������
    IN inReasonDifferencesId Integer   , -- ������� �����������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbUnitId Integer;
   DECLARE vbFromId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;

   DECLARE vbAmount        TFloat;
   DECLARE vbAmountManual  TFloat;
   DECLARE vbAmountStorage TFloat;
   DECLARE vbIsSUN         Boolean;
   DECLARE vbIsSUN_v2      Boolean;
   DECLARE vbIsSUN_v3      Boolean;
   DECLARE vbIsDefSUN      Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;

    --���������� ������������� ����������
    SELECT MovementLinkObject_To.ObjectId                               AS UnitId
         , COALESCE (MovementBoolean_SUN.ValueData, FALSE)::Boolean     AS isSUN
         , COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE)::Boolean  AS isSUN_v2
         , COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE)::Boolean  AS isSUN_v3
         , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)::Boolean  AS isDefSUN
    INTO vbUnitId, vbIsSUN, vbIsSUN_v2, vbIsSUN_v3, vbIsDefSUN
    FROM Movement 
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
    
          LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                   
          LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                    ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                   AND MovementBoolean_SUN_v2.DescId = zc_MovementBoolean_SUN_v2()
          LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                    ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                   AND MovementBoolean_SUN_v3.DescId = zc_MovementBoolean_SUN_v3()

          LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                    ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                   AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
    WHERE Movement.Id = inMovementId;
    
    IF COALESCE (ioId, 0) = 0 AND (vbIsSUN = TRUE OR vbIsSUN_v2 = TRUE OR vbIsSUN_v3 = TRUE) AND
      NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION '������. � ����������� �� ��� ���������� ������ ���������.';    
    END IF;

    -- �������� ���������� �������� ���������
    SELECT
           SUM (MovementItem.Amount)                         AS Amount
         , SUM (COALESCE(MIFloat_AmountManual.ValueData,0))  AS AmountManual
         , SUM (COALESCE(MIFloat_AmountStorage.ValueData,0)) AS AmountStorage
    INTO vbAmount, vbAmountManual, vbAmountStorage
    FROM MovementItem
               LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                           ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
               LEFT JOIN MovementItemFloat AS MIFloat_AmountStorage
                                           ON MIFloat_AmountStorage.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountStorage.DescId = zc_MIFloat_AmountStorage()
    WHERE MovementItem.Id = ioId;


    -- ��� ���� "������" ��������� ��������
    IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_Cashless())
    THEN
      -- ��� ���� "������ ������"
      IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
      THEN
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;

        IF COALESCE (vbUserUnitId, 0) = 0
        THEN
          RAISE EXCEPTION '������. �� ������� ������������� ����������.';
        END IF;
        
        IF vbisDefSUN = TRUE
        THEN
          RAISE EXCEPTION '������. �������, �� �� ������ ������������� ������ �����������! ��������� ������ �� ����������� �� ���.';
        END IF;
        
        IF vbIsSUN = TRUE AND EXISTS(SELECT 1
                                     FROM Object AS Object_CashSettings
                                          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_BanSUN
                                                                  ON ObjectBoolean_CashSettings_BanSUN.ObjectId = Object_CashSettings.Id 
                                                                 AND ObjectBoolean_CashSettings_BanSUN.DescId = zc_ObjectBoolean_CashSettings_BanSUN()
                                     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
                                       AND COALESCE(ObjectBoolean_CashSettings_BanSUN.ValueData, FALSE) = TRUE)
        THEN
          RAISE EXCEPTION '������. ������ ��� ���� ����������, �������� ��������� IT.';
        END IF;                                

        --���������� ������������� �����������
        SELECT MovementLinkObject_From.ObjectId AS vbFromId
               INTO vbFromId
        FROM MovementLinkObject AS MovementLinkObject_From
        WHERE MovementLinkObject_From.MovementId = inMovementId
          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();

        IF COALESCE (vbFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0)
        THEN
          RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);
        END IF;
        
        IF vbUnitId <> 11299914 OR (DATE_TRUNC ('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH' - ('' ||
            CASE WHEN date_part('isodow', DATE_TRUNC ('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH') = 1
                 THEN 6 - date_part('isodow', DATE_TRUNC ('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH')
                 ELSE date_part('isodow', DATE_TRUNC ('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH') - 2 END|| 'DAY ')::INTERVAL) <= CURRENT_DATE
        THEN
          IF COALESCE (vbFromId, 0) = COALESCE (vbUserUnitId, 0)
          THEN
            IF COALESCE (vbAmountManual, 0) <> COALESCE (inAmountManual, 0)
            THEN
              RAISE EXCEPTION '������. �������� <���� ���-�� �����-����������> ��� ���������.';
            END IF;
          END IF;

          IF COALESCE (vbUnitId, 0) = COALESCE (vbUserUnitId, 0)
          THEN
            IF COALESCE (vbAmount, 0) <> COALESCE (inAmount, 0) OR
             COALESCE (vbAmountStorage, 0) <> COALESCE (vbAmountStorage, 0)
            THEN
              RAISE EXCEPTION '������. �������� <���-��, ����������� � �����-����������> � <���� ���-�� �����-�����������> ��� ���������.';
            END IF;
          END IF;

          IF COALESCE (ioId, 0) <> 0 AND vbIsSUN = TRUE AND ceil(vbAmount) < inAmount
          THEN
            RAISE EXCEPTION '������. ����������� ���������� � ������������ �� ��� ��� ���������.';
          END IF;
        END IF;
        
/*        IF EXISTS(SELECT 1 FROM MovementBoolean
                  WHERE MovementBoolean.MovementId = inMovementId
                    AND MovementBoolean.DescId = zc_MovementBoolean_isAuto()
                    AND MovementBoolean.ValueData = TRUE)
        THEN

          IF COALESCE (ioId, 0) = 0 OR EXISTS(SELECT 1 FROM MovementItem
                                              WHERE MovementItem.ID = ioId
                                                AND MovementItem.Amount < inAmount)
          THEN
            RAISE EXCEPTION '������. ����������� ���������� � ������������� �������������� ������������ ��� ���������.';
          END IF;
        END IF;
*/
      END IF;

      -- ��� ����������
      IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId in (zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
         AND vbUserId NOT IN (183242 )
      THEN

        IF COALESCE (vbAmountManual, 0) <> COALESCE (inAmountManual, 0) OR
         COALESCE (vbAmountStorage, 0) <> COALESCE (inAmountStorage, 0)
        THEN
          RAISE EXCEPTION '������. �������� <���� ���-�� �����-����������> � <���� ���-�� �����-�����������> ��� ���������.';
        END IF;
      END IF;
    END IF;

    --���� ���� ���������� = 0 �������� �� �� ���� ����������� � ���������� � �����
    IF COALESCE (ioPriceUnitTo, 0) = 0 AND COALESCE (inPriceUnitFrom, 0) <> 0
    THEN
        ioPriceUnitTo := inPriceUnitFrom;

        --����������� �����
        PERFORM lpInsertUpdate_Object_Price(inGoodsId := inGoodsId,
                                            inUnitId  := vbUnitId,
                                            inPrice   := ioPriceUnitTo,
                                            inDate    := CURRENT_DATE::TDateTime,
                                            inUserId  := vbUserId);
    END IF;

    --��������� �����
    outSumma := ROUND(inAmount * inPrice, 2);
    outAmountDiff := COALESCE (inAmountManual,0) - COALESCE (inAmount,0);
    outAmountStorageDiff := COALESCE (inAmountStorage,0) - COALESCE (inAmount,0);

    outSummaUnitTo := ROUND(inAmount * ioPriceUnitTo, 2);


    IF outAmountDiff = 0
    THEN
        inReasonDifferencesId := 0;
    END IF;

     -- ���������
    ioId := lpInsertUpdate_MovementItem_Send (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inAmountManual       := inAmountManual
                                            , inAmountStorage      := inAmountStorage
                                            , inReasonDifferencesId:= inReasonDifferencesId
                                            , inUserId             := vbUserId
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 21.12.19                                                                      * ������ ���������� � ����������� �� ���
 01.04.19                                                                      *
 05.02.19         * add inAmountStorage
 19.12.18                                                                      *
 07.09.17         *
 28.06.16         *
 29.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Send (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
