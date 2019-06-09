-- Function: gpComplete_Movement_Check_ver2()

-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, Integer, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Check_ver2(
    IN inMovementId        Integer              , -- ���� ���������
    IN inPaidType          Integer              , --��� ������ 0-������, 1-�����, 2-���������
    IN inCashRegister      TVarChar             , --� ��������� ��������
    IN inCashSessionId     TVarChar             , --������ ���������
    IN inUserSession	   TVarChar             , -- ������ ������������ ��� ������� ���������� ��� � ���������
--    IN inSession         TVarChar DEFAULT ''    -- ������ ������������
    IN inSession           TVarChar               -- ������ ������������
)
RETURNS TABLE (
    Id Integer,
    GoodsCode Integer,
    GoodsName TVarChar,
    Price TFloat,
    Remains TFloat,
    MCSValue TFloat,
    Reserved TFloat,
    MinExpirationDate TDateTime,
    PartionDateKindId  Integer,
    PartionDateKindName  TVarChar,
    NewRow Boolean,
    AccommodationId Integer,
    AccommodationName TVarChar,
    AmountMonth TFloat,
    PartionDateDiscount TFloat,
    Color_calc Integer)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPaidTypeId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbCashRegisterId Integer;
  DECLARE vbMessageText Text;
BEGIN
    if coalesce(inUserSession, '') <> '' then
     inSession := inUserSession;
    end if;
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Check());
    vbUserId:= lpGetUserBySession (inSession);


    -- ����
    IF EXISTS (SELECT 1 FROM Movement WHERE Movement.ID = inMovementId AND Movement.DescId = zc_Movement_Check() AND Movement.StatusId <> zc_Enum_Status_Complete())
    THEN
        -- �������� ���� ���������
        -- UPDATE Movement SET OperDate = CURRENT_TIMESTAMP WHERE Movement.Id = inMovementId; /*���� ���������� �������� � ��������� ���� � �� ������ ������������*/

        -- ����������
        vbUnitId:= (SELECT MLO_Unit.ObjectId FROM MovementLinkObject AS MLO_Unit WHERE MLO_Unit.MovementId = inMovementId AND MLO_Unit.DescId = zc_MovementLinkObject_Unit());

        -- ��������� ��� ������
        IF inPaidType = 0
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(), inMovementId, zc_Enum_PaidType_Cash());
        ELSEIF inPaidType = 1
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType() ,inMovementId, zc_Enum_PaidType_Card());
        ELSEIF inPaidType = 2
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType() ,inMovementId, zc_Enum_PaidType_CardAdd());
        ELSE
            RAISE EXCEPTION '������.�� ��������� ��� ������';
        END IF;

        -- ���������� �� ��������� ��������
        IF COALESCE(inCashRegister,'') <> ''
        THEN
            vbCashRegisterId := gpGet_Object_CashRegister_By_Serial(inSerial := inCashRegister -- �������� ����� ��������
                                                                  , inSession:= inSession);
        ELSE
            vbCashRegisterId := 0;
        END IF;
        -- ��������� ����� � �������� ���������
        IF vbCashRegisterId <> 0
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CashRegister(), inMovementId, vbCashRegisterId);
        END IF;

        -- ����������� �������� �����
        PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);


        -- ����������� ��������
        vbMessageText:= COALESCE (lpComplete_Movement_Check (inMovementId, vbUserId), '');


        -- ������� ������� �� �������� ��������� �� �������
        UPDATE CashSessionSnapShot
           SET Remains = CashSessionSnapShot.Remains - MovementItem.Amount
        FROM
             (SELECT MovementItem.ObjectId, SUM (MovementItem.Amount) AS Amount
              FROM MovementItem
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                ON MovementLinkObject_PartionDateKind.MovementId = MovementItem.MovementId
                                               AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE
                AND MovementItem.Amount > 0
                AND vbMessageText = ''
              GROUP BY MovementItem.ObjectId
             ) AS MovementItem
        WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
          AND CashSessionSnapShot.ObjectId = MovementItem.ObjectId
          AND COALESCE(PartionDateKindId, 0) = COALESCE(MovementLinkObject_PartionDateKind.ObjectId, 0)
       ;

        -- ���������� ������� � �������� �������� � ����������
        CREATE TEMP TABLE _DIFF (ObjectId  Integer
                           , GoodsCode Integer
                           , GoodsName TVarChar
                           , Price     TFloat
                           , Remains   TFloat
                           , MinExpirationDate TDateTime
                           , PartionDateKindId  Integer
                           , MCSValue  TFloat
                           , Reserved  TFloat
                           , NewRow    Boolean
                           , AccommodationId Integer
                           , Color_calc Integer) ON COMMIT DROP;

        -- �������� �������
        INSERT INTO _DIFF (ObjectId, GoodsCode, GoodsName, Price, Remains, MCSValue, Reserved, NewRow)
        SELECT ObjectId
             , GoodsCode
             , GoodsName
             , Price
             , Remains
             , MinExpirationDate
             , PartionDateKindId
             , MCSValue
             , Reserved
             , NewRow
             , AccommodationId
             , Color_calc FROM gpSelect_CashRemains_Diff_ver2 (TVarChar, TVarChar);

        -- ���������� ������� � �������
        RETURN QUERY
            SELECT
            _DIFF.ObjectId,
            _DIFF.GoodsCode,
            _DIFF.GoodsName,
            _DIFF.Price,
            _DIFF.Remains,
            _DIFF.MCSValue,
            _DIFF.Reserved,
            _DIFF.MinExpirationDate,
            NULLIF (_DIFF.PartionDateKindId, 0),
            Object_PartionDateKind.Name    AS PartionDateKindName,
            _DIFF.NewRow,
            _DIFF.AccommodationId,
            Object_Accommodation.ValueData AS AccommodationName,
            Object_PartionDateKind.AmountMonth                       AS AmountMonth,
            COALESCE(tmpPDChangePercentGoods.PartionDateDiscount,
                     tmpPDChangePercent.PartionDateDiscount)::TFloat AS PartionDateDiscount,
            _DIFF.Color_calc
        FROM _DIFF
            LEFT JOIN tmpPartionDateKind AS Object_PartionDateKind ON Object_PartionDateKind.Id = NULLIF (_DIFF.PartionDateKindId, 0)
            LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = _DIFF.AccommodationId
            LEFT JOIN tmpPDChangePercent ON tmpPDChangePercent.Id = NULLIF (_DIFF.PartionDateKindId, 0)
            LEFT JOIN tmpPDChangePercentGoods ON tmpPDChangePercentGoods.Id = NULLIF (_DIFF.PartionDateKindId, 0)
                                            AND tmpPDChangePercentGoods.GoodsId = _DIFF.ObjectId;
    ELSE
        RETURN QUERY
            SELECT
                Null::Integer  AS ObjectId,
                NULL::Integer  AS GoodsCode,
                NULL::TVarChar AS GoodsName,
                NULL::TFloat   AS Price,
                NULL::TFloat   AS Remains,
                NULL::TFloat   AS MCSValue,
                NULL::TFloat   AS Reserved,
                NULL::TDateTime   AS MinExpirationDate,
                NULL::Integer  AS PartionDateKindId,
                NULL::TVarChar AS PartionDateKindName,
                NULL::Boolean  AS NewRow,
                NULL::Integer  AS AccommodationId,
                NULL::TVarChar AS AccommodationName,
                NULL::Integer  AS AmountMonth,
                NULL::TFloat   AS PartionDateDiscount,
                NULL::Integer  AS Color_calc
            WHERE
                1 = 0;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�
 02.11.18                                                                                    * add TotalSummPayAdd
 10.09.15                                                                       *  CashSession
 06.07.15                                                                       *  �������� ��� ������
 05.02.15                         *

*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')